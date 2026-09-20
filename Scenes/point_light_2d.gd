extends PointLight2D
@onready var player: CharacterBody2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:

	var mouse = get_global_mouse_position()
	look_at(mouse)
