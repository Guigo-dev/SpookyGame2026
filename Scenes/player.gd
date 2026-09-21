extends CharacterBody2D


const SPEED = 150.0
@export var sprite_2d: AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x < 0:
		sprite_2d.flip_h = true
	elif direction.x > 0:
		sprite_2d.flip_h = false
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	if velocity != Vector2.ZERO:
		sprite_2d.play("walk")
	else:
		sprite_2d.play("idle")

	move_and_slide()
