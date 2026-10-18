class_name Game
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%BackgroundMusicStartAudioStreamPlayer.play()
	%BackgroundMusicStartAudioStreamPlayer.finished.connect(
		func():
			%BackgroundMusicMainLoopAudioStreamPlayer.play()
			%BackgroundMusicMainLoopAudioStreamPlayer.finished.connect(
				func():
					%BackgroundMusicMainLoopAudioStreamPlayer.play()
					var background_music_main_loop_tween = get_tree().create_tween();
					background_music_main_loop_tween.tween_property(%BackgroundMusicMainLoopAudioStreamPlayer, 'volume_db', 0, 6).from(-80.0)
			)
	);
	#var background_music_main_loop_tween = get_tree().create_tween().parallel()
	#background_music_main_loop_tween.tween_property(%BackgroundMusicMainLoopAudioStreamPlayer, 'volume_db', 0.0, 3)
	#background_music_main_loop_tween.tween_property(%BackgroundMusicMainLoopAudioStreamPlayer, 'playing', true, 0)
	
	#var background_music_tween = get_tree().create_tween();
	#background_music_tween.tween_property(%BackgroundMusicStartAudioStreamPlayer, 'playing', true, 0)
	#background_music_tween.tween_property(%BackgroundMusicMainLoopAudioStreamPlayer, 'playing', true, 0)
	
	#background_music_tween.set_loops().tween_subtween(background_music_main_loop_tween)

func _input(event: InputEvent) -> void:
	if event.is_action("ui_page_up"):
		%BackgroundMusicMainLoopAudioStreamPlayer.seek(210)
