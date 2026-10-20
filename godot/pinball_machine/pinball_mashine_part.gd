# Main class off all Parts of a pinball maschine
# -> sub classes: Element, Set

class_name PinballMashinePart
extends Node2D

# Categories of exciting events. Repeated events of the same category are
# less exciting to the audience.
enum Category {
	MISC,
	BUMPER,
	SLINGSHOT,
	TARGET,
	SPINNER,
	CAPTURE,
	GUIDE,
	CONTROL,
	HIGHSCORE,
}

signal score(category: Category, score: int)
signal excite(category: Category, excitement: float)
signal trigger_ball()
signal summon_ball(position: Vector2, velocity: Vector2)

@export var active = true:
	set = set_active;

@export var points = 0:
	set = set_points;

@export var category := Category.MISC

func set_active(_active=true) -> void:
	active = _active

func set_points(_points) -> void:
	points = _points
