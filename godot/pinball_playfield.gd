extends Node2D

signal game_over(highscore: int)
signal score_changed(score: int)

@onready var flipper_right := $FlipperRight
@onready var flipper_left := $FlipperLeft

const BALL_SCENE = preload("res://ball.tscn")

var sim_speed_factor := 1.0
func set_sim_speed(factor: float) -> void:
	sim_speed_factor = factor
	flipper_right.set_sim_speed(factor)
	flipper_left.set_sim_speed(factor)

var running := false

func initialize_field() -> void:
	pass

func start() -> void:
	if running:
		return
	running = true
	plunge_ball()

func plunge_ball() -> void:
	var ball = BALL_SCENE.instantiate()
	add_child(ball)
	ball.global_position = Vector2(345, 590)
	ball.linear_velocity = Vector2(0, -1500)

func flip_left_press() -> void:
	flipper_left.press()
func flip_left_release() -> void:
	flipper_left.release()
func flip_right_press() -> void:
	flipper_right.press()
func flip_right_release() -> void:
	flipper_right.release()
