extends Node2D

@export var camera : Camera2D


#setar a camera para a living room
func _on_living_room_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		camera.limit_left = Global.mapsCamLimits["LivingRoom"][0]
		camera.limit_top = Global.mapsCamLimits["LivingRoom"][1]
		camera.limit_right = Global.mapsCamLimits["LivingRoom"][2]
		camera.limit_bottom = Global.mapsCamLimits["LivingRoom"][3]

#setar a camera para a dining room
func _on_dining_room_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		camera.limit_left = Global.mapsCamLimits["DiningRoom"][0]
		camera.limit_top = Global.mapsCamLimits["DiningRoom"][1]
		camera.limit_right = Global.mapsCamLimits["DiningRoom"][2]
		camera.limit_bottom = Global.mapsCamLimits["DiningRoom"][3]
