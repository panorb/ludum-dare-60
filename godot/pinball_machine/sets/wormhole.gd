class_name Wormhole
extends Set

@onready var holes = [
	$TeleportHole1,
	$TeleportHole2,
]

func _ready() -> void:
	$TeleportHole1.set_id(0)
	$TeleportHole2.set_id(1)
	$TeleportHole1.trigger.connect(_on_trigger)
	$TeleportHole2.trigger.connect(_on_trigger)
	$TeleportHole1.summon_ball.connect(_summon_ball)
	$TeleportHole2.summon_ball.connect(_summon_ball)

func _summon_ball(_position, _velocity) -> void:
	summon_ball.emit(_position, _velocity)

func _on_trigger(id) -> void:
	print("wormhole triggered!")
	var _target_hole =  (id + 1) % 2
	holes[_target_hole].spawn_ball()

func reset() -> void:
	for child_pinball_maschine_part in self.child_pinball_maschine_parts:
		child_pinball_maschine_part.reset();
