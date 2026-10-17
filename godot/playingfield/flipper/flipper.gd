extends Element

@export var maximum := 1.0

@onready var flipper = $Flipper

var target_rot := 0.0
const UP_SPEED := 15.0
const DOWN_SPEED := -5.0

var pressed := false

var sim_speed_factor := 1.0
func set_sim_speed(factor: float) -> void:
	sim_speed_factor = factor

func press() -> void:
	pressed = true
func release() -> void:
	pressed = false

func _init():
	pass

func _physics_process(_delta: float) -> void:
	if pressed and active:
		target_rot = maximum
	else:
		target_rot = 0.0
	if maximum > 0:
		if target_rot < flipper.rotation:
			flipper.rotation = max(0, flipper.rotation+DOWN_SPEED*_delta*sim_speed_factor)
		if target_rot > flipper.rotation:
			flipper.rotation = min(target_rot, flipper.rotation+UP_SPEED*_delta*sim_speed_factor)
	else:
		if target_rot < flipper.rotation:
			flipper.rotation = max(target_rot, flipper.rotation-UP_SPEED*_delta*sim_speed_factor)
		if target_rot > flipper.rotation:
			flipper.rotation = min(0, flipper.rotation-DOWN_SPEED*_delta*sim_speed_factor)
