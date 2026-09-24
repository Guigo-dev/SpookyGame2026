extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		visible = false
		body.get_node("Camera2D").limit_left = -1024
		body.get_node("Camera2D").limit_top = -512
		body.get_node("Camera2D").limit_bottom = 512
		
