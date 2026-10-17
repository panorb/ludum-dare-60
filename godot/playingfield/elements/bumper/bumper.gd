extends Node2D

@onready var bump_shape = $StaticBody2D

func on_bump(body: Node2D) -> void:
	#body.velocity = body.velocity * 5.0
	print("bump!")
	var direction := (body.global_position - global_position).normalized()
	body.apply_central_impulse(direction * body.mass * 500.0)
