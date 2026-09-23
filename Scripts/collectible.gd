extends StaticBody2D

func interact():
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.collectible_counter += 1
	queue_free()
