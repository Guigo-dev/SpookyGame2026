extends Area2D

@export var speed : float
@export var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null:
		return
	
	var direction = global_position.direction_to(target.global_position)
	global_position += direction * speed * delta
