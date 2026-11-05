extends Node

@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer
var stopped := false

func _process(delta: float) -> void:
	if music_player.playing == false and !stopped:
		music_player.play()

func stop():
	music_player.stop()
	stopped = true

func start():
	stopped = false
