extends Node2D

@onready var heartbeat = $CanvasLayer/TextureRect
var heartbeat_timer := 0.0

@export var player: CharacterBody2D
@export var camera : Camera2D
@export var LivingRoom: Node2D
@export var DiningRoom: Node2D
@export var ghostSpawner: PathFollow2D
var ghostCD: float
var ghostScene = preload("res://Scenes/Fantasma.tscn")

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if ghostCD >= randi_range(10,30) and Global.ghostsQtd < 6: #spawn dos fantasmas
		spawnGhost()
		ghostCD = 0
	ghostCD += delta
	ghostSpawner.progress += 20 * delta
	heartbeat_timer += delta

	if heartbeat_timer >= 5.0:
		heartbeat_timer = 0.0
		heartbeat_pulse()

func spawnGhost() -> void:
	var ghostInstance = ghostScene.instantiate()
	add_child(ghostInstance)
	ghostInstance.global_position = $Path2D/PathFollow2D.global_position
	ghostInstance.target = get_node("Player")
	ghostInstance.set_collision_layer_value(3,true)
	
func heartbeat_pulse():
	var tween = create_tween()

	heartbeat.modulate.a = 0.0

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
			LivingRoom.get_node("LivingRoomLight").enable = true
		

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


func _on_living_room_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		LivingRoom.get_node("LivingRoomLight").enabled = false


func _on_dining_room_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		DiningRoom.get_node("DiningRoomLight").enabled = false
