extends Area2D

@export var label : RichTextLabel
@export var control: Control

func interact():
	Global.animationIsPlaying = true
	label.text = "Enfrente seus medos!"
	label.visible_characters = 0
	control.visible = true
# Animação de aparecimento do texto
	$"../../TextBoxSound".play()
	while label.visible_characters < label.get_total_character_count():
		if $"../../TextBoxSound".playing == false:
			$"../../TextBoxSound".play()
		label.visible_characters += 1
		await get_tree().create_timer(0.05).timeout
	$"../../TextBoxSound".stop()
# Espera o jogador pressionar interact novamente
	while not Input.is_action_just_pressed("interact"):
		await get_tree().process_frame
	control.visible = false
	Global.animationIsPlaying = false
