class_name PinballMachine
extends Node2D

const BALLS_GROUP = 'ball';

signal game_over(score: int, is_highscore: bool)
signal score_changed(score: int)
signal excitement(value: int)

@onready var flipper_right := $FlipperRight
@onready var flipper_left := $FlipperLeft
@onready var drop_out := $DropOut
@onready var plunger := $Plunger

var score := 0
var highscore := 0
var active_balls : int:
	get: return self.get_tree().get_node_count_in_group('ball');
var is_highscore_active := false

func _ready() -> void:
	drop_out.body_entered.connect(_on_drop_out)
	for child in get_children():
		if child is Element:
			child.score.connect(on_score)
			child.excite.connect(on_excite)

func on_score(id, points):
	if not points:
		return
	score += points
	print(score)
	score_changed.emit(points)
	excitement.emit(points)

func on_excite(value) -> void:
	excitement.emit(value)

func _on_drop_out(body: Node2D) -> void:
	var _active_balls = self.active_balls - 1;
	body.queue_free()
	if _active_balls < 1 and self.is_highscore_active:
		print("highscore:", score)
		var is_highscore = false
		if score > highscore:
			highscore = score
			is_highscore = true
		game_over.emit(score, is_highscore)
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

func reset() -> void:
	#TODO this should reset the game, i.e., reset all game elements, such as drop targets
	# Remove/reset balls
	## Laod balls from group
	var removing_balls = self.get_tree().get_nodes_in_group('ball');
	## Remove all balls
	for ball in removing_balls:
		ball.queue_free();
	# stop game
	self.running = false
	
	# Reset score
	self.score = 0;

func start() -> void:
	if running:
		return
	running = true
	plunge_ball()

func plunge_ball() -> void:
	var ball = BALL_SCENE.instantiate()
	add_child(ball)
	ball.position = %BallSpawn.position
	#ball.linear_velocity = Vector2(0, -2200)
	ball.apply_central_impulse(Vector2.from_angle(%BallSpawn.rotation-PI/2) * 200)

func flip_left_press() -> void:
	flipper_left.press()
func flip_left_release() -> void:
	flipper_left.release()
func flip_right_press() -> void:
	flipper_right.press()
func flip_right_release() -> void:
	flipper_right.release()

func plunger_charge() -> void:
	plunger.press()
func plunger_release() -> void:
	plunger.release()
