extends StaticBody2D

var collected := false

func interact() -> void:
	if collected:
		return

	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	collected = true

	Global.ChanllengsCounter += 1

	get_tree().current_scene.finish_spider_challenge()
	$"../../LightsOnSound".play()

	queue_free()
