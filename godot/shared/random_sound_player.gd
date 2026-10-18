class_name RandomSoundPlayer
extends Node

var sounds_to_play : Array[AudioStreamPlayer] = []

func _ready():
	pass

func fill_array():
	for child in get_children():
		if child is AudioStreamPlayer:
			sounds_to_play.append(child)

func play():
	if not sounds_to_play:
		fill_array()
	sounds_to_play[randi() % len(sounds_to_play)].play()
