class_name RandomSoundPlayer
extends Node

var sounds_to_play : Array[AudioStreamPlayer] = []

var playing: bool:
	set(new_playing): sounds_to_play.map(func(sound: AudioStreamPlayer): sound.playing = new_playing)
	get: return sounds_to_play.any(func(sound: AudioStreamPlayer): sound.playing)

func _ready():
	pass

func fill_array():
	for child in get_children():
		if child is AudioStreamPlayer:
			sounds_to_play.append(child)

func play():
	if not sounds_to_play:
		fill_array()
	sounds_to_play.pick_random().play()
