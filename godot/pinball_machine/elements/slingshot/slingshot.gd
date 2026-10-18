class_name  Slingshot
extends Element

@onready var push_back_static_body_2d := %PushBackStaticBody2D;
@onready var push_back_collision_shape_2d := %PushBackCollisionShape2D;

func _ready() -> void:
	push_back_static_body_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Is this body a ball?
	if body is Ball:
		var ball = body as Ball;
		var direction := (body.global_position - global_position).normalized()
		body.apply_central_impulse(direction * body.mass * 500.0)
		self.trigger.emit(id)
		self.score.emit(id, points)
