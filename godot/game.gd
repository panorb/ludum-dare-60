extends Node

@onready var playfield = $PinballPlayfield

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		playfield.start()
	if event.is_action_pressed("ui_left"):
		playfield.flip_left_press()
	if event.is_action_released("ui_left"):
		playfield.flip_left_release()
	if event.is_action_pressed("ui_right"):
		playfield.flip_right_press()
	if event.is_action_released("ui_right"):
		playfield.flip_right_release()
