extends PointLight2D
@onready var player: CharacterBody2D = $".."


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _physics_process(delta: float) -> void:
	
	var rotation_speed = 2
	var mouse_position = get_global_mouse_position()
	var target_angle = global_position.angle_to_point(mouse_position)
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
