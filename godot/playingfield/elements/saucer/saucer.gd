extends Element

@onready var pull_area = $OuterArea2D
@onready var hold_area = $InnerArea2D
@onready var hold_timer = $HoldTimer
@onready var reset_timer = $ResetTimer

@export var hold_time := 2.0
@export var out_force := 300.0

var open = true
var ball:RigidBody2D = null

func _ready() -> void:
	hold_timer.timeout.connect(_on_hold_timeout)
	reset_timer.timeout.connect(_on_reset_timeout)

func _on_hold_timeout() -> void:
	hold_timer.stop()
	reset_timer.start()
	ball.freeze = false
	ball.global_position = global_position
	ball.apply_central_impulse(Vector2.from_angle(rotation) * ball.mass * out_force)
	ball = null
	trigger.emit(id)
	score.emit(id, points)

func _on_reset_timeout() -> void:
	open = true
	reset_timer.stop()
	print("reset")

func _physics_process(_delta: float) -> void:
	if not active or not open:
		return
	for body in hold_area.get_overlapping_bodies():
		if body is RigidBody2D:
			if not body.freeze:
				print("holding!")
				ball = body
				ball.global_position = global_position
				ball.freeze = true
				hold_timer.wait_time = hold_time
				hold_timer.start()
				open = false
			return
	for body in pull_area.get_overlapping_bodies():
		if body is RigidBody2D:
			print("pulling!")
			var direction := ((body as Node2D).global_position - global_position)
			body.apply_central_force(-200000.0/direction.length()*direction.normalized())
