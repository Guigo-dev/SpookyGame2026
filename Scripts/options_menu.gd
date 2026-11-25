extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("options_menu")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Global.onMainMenu == true:
		$CenterContainer/ButtonsContainer/ContinueButton.visible = false
	get_tree().paused = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("options"):
		get_tree().paused = false
		queue_free()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_sound_button_pressed() -> void:
	pass # Replace with function body.


func _on_back_menu_button_pressed() -> void:
	print("Botão voltar ao menu pressionado")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main_menu.tscn")
