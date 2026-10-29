extends StaticBody2D

var was_eaten = false

func _process(delta: float) -> void:
	if $FoodSound.playing == false and !was_eaten:
		$FoodSound.play()

func interact():
	
	if was_eaten:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		was_eaten = true
		player.controls_locked = true
		player.flashlight.enabled = false
		$AnimatedSprite2D.play("eat")
		for i in range(3):
			$EatSound.play()
			await $EatSound.finished
		await get_tree().create_timer(1.0).timeout
		player.controls_locked = false
		Global.mapsLightStatus["Kitchen"] = true
		$"../KitchenLight".enabled = true
		$"../../LightsOnSound".play()
		Global.ChanllengsCounter += 1
