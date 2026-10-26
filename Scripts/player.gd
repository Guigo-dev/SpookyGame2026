extends CharacterBody2D

@onready var flashlight: PointLight2D = $Flashlight
@onready var interaction_area: Area2D = $InteractionArea
@export var collectible: PackedScene
@export var audioStream: AudioStreamPlayer
@export var sprite_2d: AnimatedSprite2D
@export var spider_push_force: float = 30.0
@export var interact_hint: Label
@export var spider_fear_per_spider: int = 2
@export var spider_fear_max: int = 10
@export var spider_fear_interval: float = 1.0


var spider_fear_timer: float = 0.0

var touching_spiders: Array[Node2D] = []

var fearAmount := 0
var collectible_counter = 0
var flashlight_timer = 0
var fearDecay_cd = 0.0
var fear_cd = 0.0

var controls_locked = false
var was_in_attic: bool = false
var is_dead: bool = false

const SPEED = 75.0
var direction_looking := Vector2.DOWN

func _ready() -> void:
	add_to_group("player")
	
func _input(event):
	if controls_locked or Global.animationIsPlaying:
		return
	if event.is_action_pressed("flashlight"):
		flashlight.enabled = !flashlight.enabled
		flashlight.playSound()
	if event.is_action_pressed("interact"): 
		interaction_area.interact()
		
	
func spawn_collectible(posicao: Vector2):
	var item = collectible.instantiate()
	item.position = posicao
	$"../Collectibles".add_child(item)

func _physics_process(delta: float) -> void:
	if Global.animationIsPlaying:
		return
	
	var is_in_attic: bool = Global.actualRoom == "Attic"
	if was_in_attic and not is_in_attic:
		if fearAmount >= 120:
			updateFearAmount(100 - fearAmount)
	was_in_attic = is_in_attic
	
	interact_hint.scale.x = 1.0 if scale.x > 0 else -1.0
	if controls_locked:
		velocity = Vector2.ZERO
		sprite_2d.play("idle")
		move_and_slide()
		return

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x < 0:
		sprite_2d.flip_h = true
	elif direction.x > 0:
		sprite_2d.flip_h = false
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		
	#Aranha reduz velocidade
	if touching_spiders.size() > 0:
		var total_push := Vector2.ZERO

		for spider in touching_spiders.duplicate():
			if not is_instance_valid(spider):
				touching_spiders.erase(spider)
				continue

			if spider.is_queued_for_deletion():
				touching_spiders.erase(spider)
				continue

			var push_direction: Vector2 = spider.global_position.direction_to(
				spider.hole_target
			)

			total_push += push_direction * spider_push_force

		velocity += total_push.limit_length(70.0)
		#medo aranha
		if touching_spiders.size() > 0:
			spider_fear_timer += delta

			if spider_fear_timer >= spider_fear_interval:
				spider_fear_timer = 0.0

				var fear_increase = min(
					touching_spiders.size() * spider_fear_per_spider,
					spider_fear_max
				)

				updateFearAmount(fear_increase)
		else:
			spider_fear_timer = 0.0
		
	
	if velocity != Vector2.ZERO:
		sprite_2d.play("walk")
		if !audioStream.is_playing():
			audioStream.play()
	else:
		sprite_2d.play("idle")
		
		
	#Hitbox da interação
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			direction_looking = Vector2(sign(direction.x), 0)
		else:
			direction_looking = Vector2(0, sign(direction.y))
	$InteractionArea.position = direction_looking * 20 
	
	
	move_and_slide()

	#lanterna dentro da sala
	if Global.actualRoom == "LivingRoom" and not flashlight.enabled:
		flashlight_timer += delta

		if flashlight_timer >= 10 and !Global.mapsLightStatus["LivingRoom"]:
			$"../LivingRoom/LivingRoomLight".enabled = true
			Global.mapsLightStatus["LivingRoom"] = true
			$"../LightsOnSound".play()
			Global.ChanllengsCounter += 1
			spawn_collectible(Vector2(0, 150))
			
	elif (Global.actualRoom == "LivingRoom" and flashlight.enabled) or Global.actualRoom != "LivingRoom":
		flashlight_timer = 0
	
	#medo constante
	fear_cd += delta
	if fear_cd >= 2.0:
		fear_cd = 0.0
		updateFearAmount(1)
	
	#Diminui medo na luz da sala
	fearDecay_cd += delta
	if Global.mapsLightStatus.get(Global.actualRoom,false) and fearDecay_cd >= 2.0:
		fearDecay_cd = 0.0
		updateFearAmount(-10)


func _on_living_room_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$"../LivingRoom/LivingRoomLight".enabled = false
		flashlight_timer = 0

func updateFearAmount(amount : int) -> void:
	fearAmount += amount
	if fearAmount >= 150:
		fearAmount = 150
		Global.heartbeatInterval = 0.5
		Global.currentCanvasModulateColor = Color.BLACK
	elif fearAmount >= 100:
		Global.fearLevel = 3
		Global.heartbeatInterval = 1.0
		Global.currentCanvasModulateColor =Color(0.157, 0.157, 0.157)
	elif fearAmount >= 50:
		Global.fearLevel = 2
		Global.heartbeatInterval = 2.5
		Global.currentCanvasModulateColor =Color(0.22, 0.22, 0.22)
	elif fearAmount >= 25:
		Global.heartbeatInterval = 3.5
		Global.currentCanvasModulateColor =Color(0.255, 0.255, 0.255)
	else:
		Global.currentCanvasModulateColor =Color(0.349, 0.349, 0.349)
		Global.heartbeatInterval = 5.0
		Global.fearLevel = 1
	if fearAmount < 0:
		fearAmount = 0
	print(fearAmount)
	if fearAmount >= 150 and Global.actualRoom != "Attic":
		die()

	
func playAnimation(anim: String):
	sprite_2d.play(anim)
	if anim == "walk":
		audioStream.play()

func spider_entered(spider: Node2D) -> void:
	if not touching_spiders.has(spider):
		touching_spiders.append(spider)


func spider_exited(spider: Node2D) -> void:
	touching_spiders.erase(spider)


func clear_spiders() -> void:
	touching_spiders.clear()

func die() -> void:
	is_dead = true
	controls_locked = true
	velocity = Vector2.ZERO

	sprite_2d.play("idle")
