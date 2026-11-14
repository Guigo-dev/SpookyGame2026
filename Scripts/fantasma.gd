extends Area2D

@export var speed : float
@export var target: Node2D

@export var invMaterial : Material
@export var strangeMaterial : Material
@export var dmgSound: AudioStream
@export var deathSound: AudioStream

var soundPosition := 0.0
var flashlighTime := 0.0
var isInFlashlight := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null:
		return
	
	var direction = global_position.direction_to(target.global_position)
	global_position += direction * speed * delta
	
	update_material()
	
	if isInFlashlight:
		flashlighTime += delta
	if flashlighTime >= 2.4:
		die()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.updateFearAmount(25)
		body.playHurtSound()
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("flashlight"):
		playSound("damage")
		isInFlashlight = true


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("flashlight"):
		isInFlashlight = false
		playSound("stop")

func update_material():
	if Global.fearLevel == 1:
		$Sprite2D.material.set_shader_parameter("chromatic_aberration",0)
		$Sprite2D.material.set_shader_parameter("color_levels",14.0)
		$Sprite2D.material.set_shader_parameter("brightness",1.0)
		$Sprite2D.material.set_shader_parameter("saturation",1.0)
		$Sprite2D.material.set_shader_parameter("collor_offset_multiplier",0.0)
	if Global.fearLevel == 2:
		$Sprite2D.material.set_shader_parameter("chromatic_aberration",0.1)
		$Sprite2D.material.set_shader_parameter("color_levels",10.0)
		$Sprite2D.material.set_shader_parameter("brightness",1.0)
		$Sprite2D.material.set_shader_parameter("saturation",2.0)
		$Sprite2D.material.set_shader_parameter("collor_offset_multiplier",0.1)
	if Global.fearLevel == 3:
		$Sprite2D.material.set_shader_parameter("chromatic_aberration",0.18)
		$Sprite2D.material.set_shader_parameter("color_levels",2.0)
		$Sprite2D.material.set_shader_parameter("brightness",1.2)
		$Sprite2D.material.set_shader_parameter("saturation",3.5)
		$Sprite2D.material.set_shader_parameter("collor_offset_multiplier",0.2)

func playSound(type:String):
	if type == "damage":
		if $HurtSound.is_playing():
			return
		$HurtSound.set_stream(dmgSound)
		$HurtSound.play(soundPosition)
	elif type == "stop":
		soundPosition = $HurtSound.get_playback_position()
		$HurtSound.stop()

func die():
	if $DeathSound.playing == true:
		return
	
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	$DeathSound.play()
	await $DeathSound.finished
	queue_free()
