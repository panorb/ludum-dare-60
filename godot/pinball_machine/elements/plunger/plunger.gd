extends Element

@export var maximum := 50.0
@export var force := 1250.0

@onready var plunger = $PlungerPart
@onready var area = $Area2D

var target_pos := 0.0
const UP_SPEED := 700.0
const DOWN_SPEED := -50.0

var pressed := false

var sim_speed_factor := 1.0
func set_sim_speed(factor: float) -> void:
	sim_speed_factor = factor

func press() -> void:
	pressed = true
func release() -> void:
	pressed = false
	print("released")
	for body in area.get_overlapping_bodies():
		print(body)
		if body is RigidBody2D:
			print("applying force!")
			print(((plunger.position.y/maximum)*force))
			body.apply_central_impulse(Vector2.from_angle(rotation-PI/2) * body.mass * ((plunger.position.y/maximum)*force))

func _init():
	pass

func _physics_process(_delta: float) -> void:
	if pressed and active:
		target_pos = maximum
	else:
		target_pos = 0.0
	if target_pos < (plunger.position).y:
		plunger.position.y = max(0, plunger.position.y-UP_SPEED*_delta*sim_speed_factor)
	if target_pos > (plunger.position).y:
		plunger.position.y = min(target_pos, plunger.position.y-DOWN_SPEED*_delta*sim_speed_factor)
