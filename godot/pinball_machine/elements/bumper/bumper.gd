@tool
class_name Bumper
extends Element

enum BUMPER_VARIANT {
	GREEN = 1,
	RED,
	YELLOW
}

@export var variant : BUMPER_VARIANT = BUMPER_VARIANT.GREEN:
	set(value):
		$Sprite2D.texture = load("res://pinball_machine/elements/bumper/bumper{0}.png".format([value]))
		variant = value

@export var strength := 500.0;

func set_points(_points) -> void:
	%ScoreLabel.text = str(_points)
	points = _points

signal body_entered

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Is this body a ball?
	if body is Ball and self.active:
		# Get ball
		var ball = body as Ball;
		# Calculate direction
		var direction := (body.global_position - global_position).normalized()
		# Give ball new force
		body.apply_central_impulse(direction * ball.mass * self.strength)
		# ??? 
		self.trigger.emit(id)
		self.score.emit(id, points)

func on_bump(body: Node2D) -> void:
	body_entered.emit(body)
