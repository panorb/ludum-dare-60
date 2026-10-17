extends Node2D

func on_bump(body: Node2D) -> void:
	print("bump!")
	var direction := (body.global_position - global_position).normalized()
	body.apply_central_impulse(direction * body.mass * 500.0)
