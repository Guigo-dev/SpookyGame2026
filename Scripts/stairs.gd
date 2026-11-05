extends StaticBody2D

@export var player: CharacterBody2D
@export var stairs_goal: Marker2D
@export var attic_goal: Marker2D


func interact():
	if Global.actualRoom == "LivingRoom":
		player.global_position = stairs_goal.global_position
	else:
		player.global_position = attic_goal.global_position
	
