extends CharacterBody2D

@onready var flashlight: PointLight2D = $Flashlight
var flashlight_timer = 0
var test_1 = false
var test_2 = false
var test_3 = false 
var inside_room = false

const SPEED = 150.0
@export var sprite_2d: AnimatedSprite2D
var direction_looking := Vector2.DOWN

func _ready() -> void:
	add_to_group("player")
	
func _input(event):
	if event.is_action_pressed("flashlight"):
		flashlight.enabled = !flashlight.enabled 

func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x < 0:
		sprite_2d.flip_h = true
	elif direction.x > 0:
		sprite_2d.flip_h = false
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		
		
	
	if velocity != Vector2.ZERO:
		sprite_2d.play("walk")
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
	if inside_room and not flashlight.enabled and not test_1:
		flashlight_timer += delta

		if flashlight_timer >= 10:
			test_1 = true
			$"../Living_room/LivingRoomLight".enabled = true
			
	elif inside_room and flashlight.enabled and not test_1:
		flashlight_timer = 0


func _on_living_room_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		inside_room = true


func _on_living_room_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		inside_room = false
		flashlight_timer = 0
		
		
