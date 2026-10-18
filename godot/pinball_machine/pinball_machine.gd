extends Node2D

signal game_over(highscore: int)
signal score_changed(score: int)

@onready var flipper_right := $FlipperRight
@onready var flipper_left := $FlipperLeft
@onready var drop_out := $DropOut

var score := 0
var active_balls := 0

func _ready() -> void:
	drop_out.body_entered.connect(_on_drop_out)

func _on_drop_out(body: Node2D) -> void:
	body.queue_free()
	active_balls -= 1
	if active_balls <= 0:
		game_over.emit(score)
		score = 0
		running = false

const BALL_SCENE = preload("res://pinball_machine/ball.tscn")

var sim_speed_factor := 1.0
func set_sim_speed(factor: float) -> void:
	sim_speed_factor = factor
	flipper_right.set_sim_speed(factor)
	flipper_left.set_sim_speed(factor)

var running := false

func initialize_field() -> void:
	pass

func start() -> void:
	#if running:
	#	return
	running = true
	plunge_ball()

func plunge_ball() -> void:
	var ball = BALL_SCENE.instantiate()
	add_child(ball)
	ball.position = %BallSpawn.position
	#ball.linear_velocity = Vector2(0, -2200)
	ball.apply_central_impulse(Vector2.from_angle(%BallSpawn.rotation-PI/2) * 200)
	active_balls += 1

func flip_left_press() -> void:
	flipper_left.press()
func flip_left_release() -> void:
	flipper_left.release()
func flip_right_press() -> void:
	flipper_right.press()
func flip_right_release() -> void:
	flipper_right.release()
