extends Node

@onready var playfield = %PinballMachine
@onready var ai_controller = %AIController

var active := true

func _ready() -> void:
	ai_controller.sim_end.connect(_on_sim_end)

func _on_sim_end(coins):
	active = true

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
	if event.is_action_pressed("debug_ai_toggle"): #TODO trigger this with the start day button instead!
		if ai_controller.active:
			ai_controller.active = false
			Engine.time_scale = 1.0
			active = true
		else:
			ai_controller.active = true
			Engine.time_scale = 1.5
			active = false
			ai_controller.start()
