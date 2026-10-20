class_name TeleportHole
extends Element

enum HOLE_VARIANT {
	BLUE = 1,
	RED
}

@onready var ball_detector := $BallDetector
@onready var cool_down := $CoolDownTimer

@export var force := 1000.0

func _init() -> void:
	category = Category.CAPTURE

func _ready() -> void:
	ball_detector.body_entered.connect(_on_ball_entered)

func spawn_ball() -> void:
	print("asked to spawn ball!")
	cool_down.start()
	summon_ball.emit(global_position, Vector2.from_angle(rotation)*force)

func _on_ball_entered(ball) -> void:
	if cool_down.time_left > 0.0:
		return
	print("got a ball!")
	ball.queue_free()
	trigger.emit(id)
	cool_down.start()

@export var variant : HOLE_VARIANT = HOLE_VARIANT.BLUE:
	set(value):
		$Sprite2D.texture = load("res://pinball_machine/elements/teleport_hole/hole{0}.png".format([value]))
		variant = value

@export var strength := 500.0;
