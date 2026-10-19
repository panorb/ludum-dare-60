class_name Element
extends PinballMashinePart

signal trigger(id)
signal score(id, amount)
signal excite(value)

var id := 0


func set_active(_active=true) -> void:
	active = _active

func set_points(_points) -> void:
	points = _points

func set_id(id) -> void:
	self.id = id

func on_bump(ball) -> void:
	pass
