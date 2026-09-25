extends Node2D

@export var camera : Camera2D
@export var LivingRoom: Node2D
@export var DiningRoom: Node2D

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
