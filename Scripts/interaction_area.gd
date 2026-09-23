extends Area2D

var interactables: Array = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.has_method("interact"):
		interactables.append(body)

func _on_body_exited(body):
	interactables.erase(body)

#Interage com o mais proximo
func interact():
	if interactables.is_empty():
		return null
	var near_interactable = null
	var min_dist = INF
	for obj in interactables:
		var d = global_position.distance_to(obj.global_position)
		if d < min_dist:
			min_dist = d
			near_interactable = obj
	if near_interactable:
		near_interactable.interact()
