class_name MusicPlayer extends AudioStreamPlayer

static var ins: MusicPlayer

func _init():
	ins = self

@export var music: Array[AudioStream]

func ChangeMusic(index: int):
	stream = music[index]
	play()

func MuffleMusic(on: bool):
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, on)
