
extends Area2D

@export var player: CharacterBody2D
@export var camera_2d: Camera2D
@export var fall_destiny: Marker2D
@export var fade: ColorRect

@export var destination_room: String = "LivingRoom"

@export var fall_duration: float = 1.3
@export var reveal_duration: float = 1.2
@export var zoom_multiplier: float = 1.7
@export var close_duration: float = 0.65

var falling := false
var normal_zoom: Vector2
var transicao: ShaderMaterial

var transition_radius := 2000.0:
	set(value):
		transition_radius = value

		if transicao != null:
			transicao.set_shader_parameter("radius", value)


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if player == null or camera_2d == null or fall_destiny == null:
		push_error("Fall transition nodes are not assigned!")
		return

	if fade == null or not fade.material is ShaderMaterial:
		push_error("FadeRect needs a ShaderMaterial!")
		return

	normal_zoom = camera_2d.zoom

	transicao = fade.material.duplicate() as ShaderMaterial
	fade.material = transicao

	fade.color = Color.WHITE
	fade.visible = false

	transition_radius = get_full_radius()


func _process(_delta: float) -> void:
	if falling and transicao != null and fade.visible:
		update_transition_center()


func _on_body_entered(body: Node2D) -> void:
	if body != player or falling or transicao == null:
		return

	falling = true
	await start_fall()


func start_fall() -> void:
	player.controls_locked = true
	player.velocity = Vector2.ZERO

	fade.visible = true
	fade.color = Color.WHITE

	update_transition_center()
	transition_radius = get_full_radius()

	var fall_tween = create_tween()
	fall_tween.set_parallel(true)

	# Camera zoom
	fall_tween.tween_property(
		camera_2d,
		"zoom",
		normal_zoom * zoom_multiplier,
		fall_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Close the circle faster than the zoom
	fall_tween.tween_property(
		self,
		"transition_radius",
		0.0,
		close_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	await fall_tween.finished

	transition_radius = 0.0

	player.global_position = fall_destiny.global_position
	Global.actualRoom = destination_room

	camera_2d.zoom = normal_zoom

	if Global.mapsCamLimits.has(destination_room):
		var limits = Global.mapsCamLimits[destination_room]

		camera_2d.limit_left = limits[0]
		camera_2d.limit_right = limits[1]
		camera_2d.limit_top = limits[2]
		camera_2d.limit_bottom = limits[3]

	camera_2d.reset_smoothing()

	transition_radius = 0.0

	await get_tree().process_frame

	update_transition_center()

	transition_radius = 18.0

	await get_tree().create_timer(0.25).timeout

	var reveal_tween = create_tween()

	reveal_tween.tween_property(
		self,
		"transition_radius",
		get_full_radius(),
		1.8
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	await reveal_tween.finished

	fade.visible = false
	player.controls_locked = false
	falling = false



func update_transition_center() -> void:
	if transicao == null:
		return

	var screen_position = player.get_global_transform_with_canvas().origin
	var screen_size = get_viewport().get_visible_rect().size

	if screen_size.x <= 0.0 or screen_size.y <= 0.0:
		return

	var normalized_position = screen_position / screen_size

	transicao.set_shader_parameter(
		"center",
		normalized_position
	)


func get_full_radius() -> float:
	var screen_size = get_viewport().get_visible_rect().size
	return screen_size.length() + 100.0
