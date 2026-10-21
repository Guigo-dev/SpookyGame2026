extends Area2D

@export var speed : float
@export var target: Node2D
@export var attic_mode: bool = false

var player_touching: CharacterBody2D = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attic_mode:
		global_position.x -= speed * delta
		$AnimatedSprite2D.flip_h = true
		return

	if target == null:
		return

	var direction: Vector2 = global_position.direction_to(target.global_position)
	global_position += direction * speed * delta

	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif direction.x > 0:
		$AnimatedSprite2D.flip_h = false



func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if attic_mode:
		player_touching = body
		body.spider_entered(self)
	else:
		body.updateFearAmount(25)
		queue_free()


func _on_body_exited(body: Node2D) -> void:
	if not attic_mode:
		return

	if body == player_touching:
		player_touching.spider_exited(self)
		player_touching = null

func _on_tree_exited() -> void:
	if attic_mode and is_instance_valid(player_touching):
		player_touching.spider_exited(self)
		player_touching = null
