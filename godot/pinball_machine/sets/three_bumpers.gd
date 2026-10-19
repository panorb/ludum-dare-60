class_name ThreeBumpers
extends Set

@onready var bumpers = [
	$Bumper1,
	$Bumper2,
	$Bumper3,
]

func _ready() -> void:
	$Bumper1.set_id(0)
	$Bumper2.set_id(1)
	$Bumper3.set_id(2)
	$Bumper1.trigger.connect(_on_trigger)
	$Bumper2.trigger.connect(_on_trigger)
	$Bumper3.trigger.connect(_on_trigger)

func _on_trigger(id) -> void:
	var _target_bumper =  (id + 1) % 3
	bumpers[id].active = false
	bumpers[_target_bumper].active = true
