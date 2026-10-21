extends Area2D

var player
var isInside := false
var healingCD := 0.0

func _process(delta: float) -> void:
	healingCD += delta
	
	if isInside and healingCD >= 2.0:
		healingCD = 0.0
		player.updateFearAmount(-5)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		isInside = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		isInside = false
