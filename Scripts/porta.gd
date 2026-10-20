extends StaticBody2D

@export var Area1 : Area2D
@export var Area2: Area2D
@onready var open_audio: AudioStreamPlayer2D = $OpenAudio
@onready var close_audio: AudioStreamPlayer2D = $CloseAudio

var tween: Tween

func interact():
	if tween and tween.is_running():
		return

	tween = create_tween()

	open_audio.play()
	tween.tween_property(self, "rotation", deg_to_rad(-90), 2)

	await tween.finished

	await get_tree().create_timer(3).timeout

	close_audio.play()
	tween = create_tween()
	tween.tween_property(self, "rotation", 0.0, 2)
