extends Node2D

signal game_over(score: int, is_highscore: bool)
signal score_changed(score: int)
signal excitement(value: int)

@onready var flipper_right := $FlipperRight
@onready var flipper_left := $FlipperLeft
@onready var drop_out := $DropOut
@onready var plunger := $Plunger

var score := 0
var highscore := 0
var active_balls := 0

# List of all balls in game
var balls: Array[Ball] :
	get: return self.get_children() \
		.filter(func(child): child is Ball)

# Position of all balls
var last_ball_positions: Dictionary[Ball, Vector2] = {}

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
	body.queue_free()
	active_balls -= 1
	if active_balls <= 0:
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
	pass #TODO this should reset the game, i.e., reset all game elements, such as drop targets

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
	active_balls += 1

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
