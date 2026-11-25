extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false

	modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)


func _on_continue_button_pressed() -> void:
	Global.onMainMenu = false
	get_tree().change_scene_to_file("res://Scenes/fase.tscn")


func _on_back_menu_button_pressed() -> void:
	print("Botão voltar ao menu pressionado")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main_menu.tscn")
