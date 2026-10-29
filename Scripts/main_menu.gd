extends Control

@export var character_rect : TextureRect
@export var background : TextureRect

func _ready() -> void:
	MusicManager.start()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_play_button_pressed() -> void:
	MusicManager.stop()
	background.texture = load("res://Sprites/Images/Menu_porta_aberta.png")
	$DoorSound.play()
	await $DoorSound.finished
	var mainScene = load("res://Scenes/fase.tscn")
	get_tree().change_scene_to_packed(mainScene)

func _on_credits_button_pressed() -> void:
	var creditsScene = load("res://Scenes/final_menu.tscn")
	get_tree().change_scene_to_packed(creditsScene)

func _on_play_button_mouse_entered() -> void:
	character_rect.position.x = -720
	$FlashlightSound.play()

func _on_options_button_mouse_entered() -> void:
	character_rect.position.x = 0
	$FlashlightSound.play()

func _on_credits_button_mouse_entered() -> void:
	character_rect.position.x = -1440
	$FlashlightSound.play()
