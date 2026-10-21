extends Control

@export var playButton : Button

func _on_play_button_pressed() -> void:
	var mainScene = load("res://Scenes/fase.tscn")
	get_tree().change_scene_to_packed(mainScene)
