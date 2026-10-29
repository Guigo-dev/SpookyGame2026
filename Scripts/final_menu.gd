extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_play_button_pressed() -> void:
	var mainMenu = load("res://Scenes/Main_menu.tscn")
	get_tree().change_scene_to_packed(mainMenu)
