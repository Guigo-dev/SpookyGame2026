extends StaticBody2D

var was_eaten = false

func interact():
	
	if was_eaten:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.controls_locked = true
		player.flashlight.enabled = false

		await get_tree().create_timer(5.0).timeout

		player.controls_locked = false
		was_eaten = true
		player.test_2 = true
		Global.mapsLightStatus["Kitchen"] = true
		$"../KitchenLight".enabled = true
		$"../../LightsOnSound".play()
		Global.ChanllengsCounter += 1
