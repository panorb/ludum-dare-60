class_name Element
extends Node2D

signal trigger(id)
signal score(id, amount)

@export var active = true
@export var points = 0
var id := 0

func set_active(active=true) -> void:
	self.active = active

func set_id(id) -> void:
	self.id = id

func on_bump(ball) -> void:
	pass
