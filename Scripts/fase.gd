extends Node2D

@onready var heartbeat = $CanvasLayer/TextureRect
@onready var spider_spawn_point: Marker2D = $SpiderSpawnPoint
@onready var spider_spawn_point_2: Marker2D = $SpiderSpawnPoint2
@onready var spider_spawn_point_3: Marker2D = $SpiderSpawnPoint3
@onready var spider_hole: Area2D = $HoleTrigger
var heartbeat_timer := 0.0
const SPIDER_SCENE = preload("res://Scenes/Spider.tscn")

@export var canvasModulate: CanvasModulate
@export var player: CharacterBody2D
@export var camera : Camera2D
@export var LivingRoom: Node2D
@export var DiningRoom: Node2D
@export var Kitchen: Node2D
@export var ghostSpawner: PathFollow2D
@export var attic: Area2D
@export var spider_spawn_interval: float = 0.075
@export var spider_speed: float = 140.0
@export var spider_max_count: int = 100



var ghostCD: float
var ghostScene = preload("res://Scenes/Fantasma.tscn")
var spider_spawn_timer := 0.0
var spider_challenge_active := false
var spider_challenge_completed := false
var attic_spiders: Array[Node2D] = []

func _ready() -> void:
	#$AnimationPlayer/CameraCutscene.enabled = true
	#$Player/Camera2D.enabled = false
	#$AnimationPlayer/CameraCutscene.make_current()
	#$AnimationPlayer.play("initialCutscene")
	#await $AnimationPlayer.animation_finished
	#$Player/Camera2D.enabled = true
	#$AnimationPlayer/CameraCutscene.enabled = false
	#$Player/Camera2D.make_current()
	randomize()

func _process(delta: float) -> void:
	if Global.animationIsPlaying:
		return
	update_spiders(delta)
	if !Global.mapsLightStatus["LivingRoom"]:
		if ghostCD >= randi_range(7,20) and Global.ghostsQtd < 5: #spawn dos fantasmas
			spawnGhost()
			ghostCD = 0
		ghostCD += delta
		ghostSpawner.progress += 20 * delta
	heartbeat_timer += delta
	if canvasModulate.color != Global.currentCanvasModulateColor:
		canvasModulate.color = canvasModulate.color.lerp(Global.currentCanvasModulateColor,2.0*delta)
	if heartbeat_timer >= Global.heartbeatInterval:
		heartbeat_timer = 0.0
		heartbeat_pulse()
	
	if Global.ChanllengsCounter == 3:
		$DiningRoom/DiningRoomLight.enabled = true
		await $LightsOnSound.finished
		Global.ChanllengsCounter = 4
		$AnimationPlayer/CameraCutscene.global_position = $Player/Camera2D.global_position
		$AnimationPlayer/CameraCutscene.enabled = true
		$Player/Camera2D.enabled = false
		$AnimationPlayer/CameraCutscene.make_current()
		$AnimationPlayer.play("door_opening_cutscene")
		await $AnimationPlayer.animation_finished
		$Player/Camera2D.enabled = true
		$AnimationPlayer/CameraCutscene.enabled = false
		$Player/Camera2D.make_current()
	

func spawnGhost() -> void:
	var ghostInstance = ghostScene.instantiate()
	add_child(ghostInstance)
	ghostInstance.global_position = $Path2D/PathFollow2D.global_position
	ghostInstance.target = get_node("Player")
	ghostInstance.set_collision_layer_value(3,true)
	
func heartbeat_pulse():
	var tween = create_tween()

	heartbeat.modulate.a = 0.0
	$HeartbeatSound.play()
	# primeira batida
	tween.tween_property(heartbeat, "modulate:a", 0.7, 0.08)
	tween.tween_property(heartbeat, "modulate:a", 0.0, 0.08)

	tween.tween_interval(0.08)

	# segunda batida
	tween.tween_property(heartbeat, "modulate:a", 0.9, 0.08)
	tween.tween_property(heartbeat, "modulate:a", 0.0, 0.2)

#setar a camera para a living room
func _on_living_room_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.actualRoom = "LivingRoom"
		camera.limit_left = Global.mapsCamLimits["LivingRoom"][0]
		camera.limit_top = Global.mapsCamLimits["LivingRoom"][1]
		camera.limit_right = Global.mapsCamLimits["LivingRoom"][2]
		camera.limit_bottom = Global.mapsCamLimits["LivingRoom"][3]
		if Global.mapsLightStatus[Global.actualRoom] == true:
			LivingRoom.get_node("LivingRoomLight").enabled = true
		

#setar a camera para a dining room
func _on_dining_room_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.actualRoom = "DiningRoom"
		camera.limit_left = Global.mapsCamLimits["DiningRoom"][0]
		camera.limit_top = Global.mapsCamLimits["DiningRoom"][1]
		camera.limit_right = Global.mapsCamLimits["DiningRoom"][2]
		camera.limit_bottom = Global.mapsCamLimits["DiningRoom"][3]
		if Global.mapsLightStatus[Global.actualRoom] == true:
			DiningRoom.get_node("DiningRoomLight").enabled = true

func _on_kitchen_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.actualRoom = "Kitchen"
		camera.limit_left = Global.mapsCamLimits["Kitchen"][0]
		camera.limit_top = Global.mapsCamLimits["Kitchen"][1]
		camera.limit_right = Global.mapsCamLimits["Kitchen"][2]
		camera.limit_bottom = Global.mapsCamLimits["Kitchen"][3]
		if Global.mapsLightStatus[Global.actualRoom] == true:
			Kitchen.get_node("KitchenLight").enabled = true

func _on_attic_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.actualRoom = "Attic"
		camera.limit_left = Global.mapsCamLimits["Attic"][0]
		camera.limit_top = Global.mapsCamLimits["Attic"][1]
		camera.limit_right = Global.mapsCamLimits["Attic"][2]
		camera.limit_bottom = Global.mapsCamLimits["Attic"][3]
		if Global.mapsLightStatus[Global.actualRoom] == true:
			attic.get_node("AtticLight").enabled = true

func _on_living_room_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		LivingRoom.get_node("LivingRoomLight").enabled = false

func _on_dining_room_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		DiningRoom.get_node("DiningRoomLight").enabled = false

func _on_kitchen_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		Kitchen.get_node("KitchenLight").enabled = false

func _on_attic_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		attic.get_node("AtticLight").enabled = false
		reset_spider_challenge()


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	Global.animationIsPlaying = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.animationIsPlaying = false



func _on_end_game_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player" and Global.ChanllengsCounter >= 3:
		var finalMenu = load("res://Scenes/final_menu.tscn")
		get_tree().change_scene_to_packed(finalMenu)

func _on_spider_trigger_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if spider_challenge_active or spider_challenge_completed:
		return

	spider_challenge_active = true
	spider_spawn_timer = 0.0

func spawn_spider() -> void:
	if attic_spiders.size() >= spider_max_count:
		return

	var spider = SPIDER_SCENE.instantiate()

	spider.attic_mode = true
	spider.speed = spider_speed
	spider.hole_target = spider_hole.global_position

	add_child(spider)
	
	var spawn_index = randi_range(0, 9)
	
	if spawn_index >= 0 and spawn_index <= 5:
		spider.global_position = spider_spawn_point.global_position
		spider.global_position.y += randf_range(-120.0, 120.0)
	elif spawn_index >=6 and spawn_index <= 7:
		spider.global_position = spider_spawn_point_2.global_position
		spider.global_position.x += randf_range(-120.0, 120.0)
	else:
		spider.global_position = spider_spawn_point_3.global_position
		spider.global_position.x += randf_range(-120.0, 120.0)
	if $SpidersSound.playing == false:
		$SpidersSound.play()
	
	attic_spiders.append(spider)

func update_spiders(delta: float) -> void:
	if not spider_challenge_active:
		return

	var left_limit = Global.mapsCamLimits["Attic"][0]

	for spider in attic_spiders.duplicate():
		if not is_instance_valid(spider):
			attic_spiders.erase(spider)
			continue

		if spider.is_queued_for_deletion():
			attic_spiders.erase(spider)
			continue

		if spider.global_position.distance_to(spider_hole.global_position) < 12.0:
			remove_spider(spider)

	spider_spawn_timer += delta

	if spider_spawn_timer >= spider_spawn_interval:
		spider_spawn_timer = 0.0
		spawn_spider()
	if not spider_challenge_active:
		return

	left_limit = Global.mapsCamLimits["Attic"][0]

	for i in range(attic_spiders.size() - 1, -1, -1):
		var spider = attic_spiders[i]

		if not is_instance_valid(spider):
			attic_spiders.remove_at(i)
			continue

		if spider.is_queued_for_deletion():
			attic_spiders.remove_at(i)
			continue

		if spider.global_position.x < left_limit + 100.0:
			attic_spiders.remove_at(i)
			spider.queue_free()

	spider_spawn_timer += delta

	if spider_spawn_timer >= spider_spawn_interval:
		spider_spawn_timer = 0.0
		spawn_spider()
	if not spider_challenge_active:
		return

	left_limit = Global.mapsCamLimits["Attic"][0]

	for i in range(attic_spiders.size() - 1, -1, -1):
		var spider = attic_spiders[i]

		if not is_instance_valid(spider):
			attic_spiders.remove_at(i)
			continue

		if spider.global_position.x < left_limit:
			attic_spiders.remove_at(i)
			spider.queue_free()

	spider_spawn_timer += delta

	if spider_spawn_timer >= spider_spawn_interval:
		spider_spawn_timer = 0.0
		spawn_spider()
		
func finish_spider_challenge() -> void:
	if spider_challenge_completed:
		return

	spider_challenge_active = false
	spider_challenge_completed = true
	spider_spawn_timer = 0.0

	player.clear_spiders()

	for spider in attic_spiders.duplicate():
		remove_spider(spider)

	attic_spiders.clear()

	for spider in attic_spiders:
		if is_instance_valid(spider):
			spider.set_process(false)
			spider.set_physics_process(false)
			spider.set_deferred("monitoring", false)
			spider.queue_free()

	attic_spiders.clear()

	Global.mapsLightStatus["Attic"] = true

	if is_instance_valid(attic):
		var light = attic.get_node_or_null("AtticLight")
		if light:
			light.enabled = true
	$SpidersSound.stop()
	await get_tree().process_frame

func remove_spider(spider: Node2D) -> void:
	if not is_instance_valid(spider):
		return

	if spider.is_queued_for_deletion():
		return

	attic_spiders.erase(spider)
	spider.queue_free()
	
func reset_spider_challenge() -> void:
	spider_challenge_active = false
	spider_spawn_timer = 0.0

	player.clear_spiders()

	for spider in attic_spiders.duplicate():
		remove_spider(spider)
	$SpidersSound.stop()
	attic_spiders.clear()


func _on_pintura_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
