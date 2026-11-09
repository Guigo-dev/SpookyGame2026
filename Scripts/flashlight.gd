extends PointLight2D
@onready var player: CharacterBody2D = $".."
@onready var flashlightArea: Area2D = $Area2D
@export var onSound: AudioStream
@export var offSound: AudioStream

@export var mouse_center_deadzone: float = 16.0



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	flashlightArea.add_to_group("flashlight")
	
func _process(_delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var mouse_direction: Vector2 = mouse_position - global_position

	if mouse_direction.length_squared() > mouse_center_deadzone * mouse_center_deadzone:
		global_rotation = mouse_direction.angle()



func _physics_process(delta: float) -> void:
	
	var rotation_speed = 2
	var mouse_position = get_global_mouse_position()
	var target_angle = global_position.angle_to_point(mouse_position)
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func playSound():
	if enabled:
		$AudioStreamPlayer.set_stream(onSound)
	else:
		$AudioStreamPlayer.set_stream(offSound)
	$AudioStreamPlayer.play()
