extends StaticBody2D

var was_eaten = false

func interact():
	
	if was_eaten:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.controls_locked = true
		player.flashlight.enabled = false
		player.controls_locked = false
		was_eaten = true
		$AnimatedSprite2D.play("eat")
		var comidas = 0
		while comidas < 3:
			if $EatSound.playing == false:
				$EatSound.play()
				comidas += 1
		Global.mapsLightStatus["Kitchen"] = true
		$"../KitchenLight".enabled = true
		$"../../LightsOnSound".play()
		Global.ChanllengsCounter += 1
