extends StaticBody2D


@onready var open_audio: AudioStreamPlayer2D = $OpenAudio
@onready var close_audio: AudioStreamPlayer2D = $CloseAudio

var tween: Tween

func interact():
	if tween and tween.is_running():
		return

	tween = create_tween()

	open_audio.play()
	tween.tween_property(self, "rotation", deg_to_rad(-90), 2.0)

	# Espera a porta terminar de abrir e aguarda 3 segundos
	tween.tween_interval(3.0)

	# Fecha a porta após a espera
	tween.tween_callback(func(): close_audio.play())
	tween.tween_property(self, "rotation", 0.0, 2.0)

	await tween.finished
