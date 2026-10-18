class_name Bumper
extends Element

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
		body.apply_central_impulse(direction * body.mass * 500.0)
		# ??? 
		self.trigger.emit(id)
		self.score.emit(id, points)

func on_bump(body: Node2D) -> void:
	body_entered.emit(body)
