extends Node

@onready var playfield = $PinballPlayfield

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("flipper_charge"):
		playfield.start()
	if event.is_action_pressed("flipper_left"):
		playfield.flip_left_press()
	if event.is_action_released("flipper_left"):
		playfield.flip_left_release()
	if event.is_action_pressed("flipper_right"):
		playfield.flip_right_press()
	if event.is_action_released("flipper_right"):
		playfield.flip_right_release()
