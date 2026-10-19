extends Node

@onready var playfield = %PinballMachine
@onready var ai_controller = %AIController

var active := true

func _unhandled_input(event: InputEvent) -> void:
	if active:
		if event.is_action_pressed("insert_coin"):
			playfield.start()
		if event.is_action_pressed("flipper_charge"):
			playfield.plunger_charge()
		if event.is_action_released("flipper_charge"):
			playfield.plunger_release()
		if event.is_action_pressed("flipper_left"):
			playfield.flip_left_press()
		if event.is_action_released("flipper_left"):
			playfield.flip_left_release()
		if event.is_action_pressed("flipper_right"):
			playfield.flip_right_press()
		if event.is_action_released("flipper_right"):
			playfield.flip_right_release() 
