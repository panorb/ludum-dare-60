# Main class off all Parts of a pinball maschine
# -> sub classes: Element, Set

class_name PinballMashinePart
extends Node2D

signal hit(score: int, excitement: float)

@export var active = true:
	set = set_active;

@export var points = 0:
	set = set_points;

func set_active(_active=true) -> void:
	active = _active

func set_points(_points) -> void:
	points = _points
