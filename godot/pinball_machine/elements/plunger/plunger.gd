extends Element

@export var maximum := 50.0

@onready var plunger = $PlungerPart

var target_pos := 0.0
const UP_SPEED := 1000.0
const DOWN_SPEED := -50.0

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
	print(target_pos)
	if pressed and active:
		target_pos = maximum
	else:
		target_pos = 0.0
	print(plunger.position)
	if target_pos < (plunger.position).y:
		print("lowering")
		plunger.position.y = max(0, plunger.position.y-UP_SPEED*_delta*sim_speed_factor)
	if target_pos > (plunger.position).y:
		print("raising")
		plunger.position.y = min(target_pos, plunger.position.y-DOWN_SPEED*_delta*sim_speed_factor)
