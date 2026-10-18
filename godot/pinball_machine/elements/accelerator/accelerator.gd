extends Element

@onready var area = $Area2D

@export var force := 300.0

func _physics_process(_delta: float) -> void:
	if not active:
		return
	for body in area.get_overlapping_bodies():
		if body is RigidBody2D:
			body.apply_central_impulse(Vector2.from_angle(rotation-PI/2) * body.mass * force)
