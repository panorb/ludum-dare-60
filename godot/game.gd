class_name Game
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Play start of background music
	%BackgroundMusicStartAudioStreamPlayer.play()
	# After start music start loop
	%BackgroundMusicStartAudioStreamPlayer.finished.connect(
		func():
			# start loop 
			%BackgroundMusicMainLoopAudioStreamPlayer.play()
			# if loop finisched start loop again and fade-in
			%BackgroundMusicMainLoopAudioStreamPlayer.finished.connect(
				func():
					%BackgroundMusicMainLoopAudioStreamPlayer.play()
					var background_music_main_loop_tween = get_tree().create_tween();
					background_music_main_loop_tween.tween_property(%BackgroundMusicMainLoopAudioStreamPlayer, 'volume_db', 0, 6).from(-80.0)
			)
	);
