extends PointLight2D
@onready var player: CharacterBody2D = $".."
@onready var flashlightArea: Area2D = $Area2D
var ghosts: Dictionary[Area2D,Dictionary] = {} #


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _physics_process(delta: float) -> void:
	
	var rotation_speed = 2
	var mouse_position = get_global_mouse_position()
	var target_angle = global_position.angle_to_point(mouse_position)
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	if ghosts.size() > 0 and self.enabled == true:
		for ghost in ghosts:
			if ghosts[ghost]["isInFlashlight"]:
				ghosts[ghost]["time"] += delta #calcula o tempo que o fantasma está colidindo com a lanterna
			if ghosts[ghost]["time"] > 3:
				ghosts.erase(ghost)
				ghost.queue_free()
				Global.ghostsQtd -= 1
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if ghosts.has(area):
		ghosts[area]["isInFlashlight"] = true
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	if ghosts.has(area):
		ghosts[area]["isInFlashlight"] = false

func _on_fase_child_entered_tree(node: Node) -> void:
	call_deferred("add_ghost", node)

func add_ghost(node: Node):
	if node.is_in_group("enemy"):
		Global.ghostsQtd += 1
		var area = node as Area2D
		ghosts[area] = {
			"time": 0.0,
			"isInFlashlight": false
		}
