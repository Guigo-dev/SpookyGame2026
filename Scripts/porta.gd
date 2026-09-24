extends Area2D

@export var Area1 : Area2D;
@export var Area2: Area2D;

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		visible = false
