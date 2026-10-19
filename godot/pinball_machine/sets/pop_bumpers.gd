class_name PopBumpers
extends Set

@onready var bumpers = [
	$Bumper1,
	$Bumper2,
	$Bumper3,
	$Bumper4,
	$Bumper5,
]
@onready var timer := $Timer

var _bumper_activation := {
	0: false,
	2: false,
	3: false,
	4: false,
	5: false,
}

func _ready() -> void:
	$Bumper1.set_id(0)
	$Bumper2.set_id(1)
	$Bumper3.set_id(2)
	$Bumper4.set_id(3)
	$Bumper5.set_id(4)
	$Bumper1.trigger.connect(_on_trigger)
	$Bumper2.trigger.connect(_on_trigger)
	$Bumper3.trigger.connect(_on_trigger)
	$Bumper4.trigger.connect(_on_trigger)
	$Bumper5.trigger.connect(_on_trigger)
	timer.timeout.connect(_on_second_ball)

func _on_trigger(id) -> void:
	if bumpers[id].active:
		bumpers[id].active = false
		_bumper_activation[id] = true
		for i in range(5):
			if not _bumper_activation[i]:
				break
			if i == 4:
				trigger_ball.emit()
				timer.start()

func _on_second_ball():
	trigger_ball.emit()
