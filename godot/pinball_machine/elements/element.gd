class_name Element
extends Node2D

signal trigger(id)
signal score(id, amount)
signal excite(value)

@export var active = true:
	set = set_active

@export var points = 0:
	set = set_points

var id := 0


func set_active(_active=true) -> void:
	active = _active

func set_points(_points) -> void:
	points = _points

func set_id(id) -> void:
	self.id = id

func on_bump(ball) -> void:
	pass
