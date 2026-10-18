extends Node2D

@onready var right_flipper_trigger := $RightFlipperTrigger
@onready var left_flipper_trigger := $LeftFlipperTrigger
@onready var plunger_trigger := $PlungerTrigger
@onready var playfield = %PinballMachine

@export var active := false

func _ready() -> void:
	right_flipper_trigger.body_entered.connect(_flipper_right_press)
	right_flipper_trigger.body_exited.connect(_flipper_right_release)
	left_flipper_trigger.body_entered.connect(_flipper_left_press)
	left_flipper_trigger.body_exited.connect(_flipper_left_release)
	plunger_trigger.body_entered.connect(_flipper_charge_press)
	plunger_trigger.body_exited.connect(_flipper_charge_release)

func _flipper_right_press(body) -> void:
		if not active:
			return
		playfield.flip_right_press()

func _flipper_right_release(body) -> void:
		if not active:
			return
		playfield.flip_right_release()

func _flipper_left_press(body) -> void:
		if not active:
			return
		playfield.flip_left_press()

func _flipper_left_release(body) -> void:
		if not active:
			return
		playfield.flip_left_release()

func _flipper_charge_press(body) -> void:
		if not active:
			return
		print("entered")
		playfield.plunger_charge()

func _flipper_charge_release(body) -> void:
		if not active:
			return
		playfield.plunger_release()
