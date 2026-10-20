class_name  Slingshot
extends Element

@onready var push_back_static_body_2d := %PushBackStaticBody2D;
@onready var push_back_collision_shape_2d := %PushBackCollisionShape2D;
@onready var push_back_audio_stream_player := %PushBackAudioStreamPlayer

@export var strength := 500.0;

func _init() -> void:
	category = Category.SLINGSHOT

func _ready() -> void:
	push_back_static_body_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Is this body a ball?
	if body is Ball and self.active:
		var ball = body as Ball;
		var direction := (body.global_position - global_position).normalized()
		body.apply_central_impulse(direction * ball.mass * self.strength) 
		self.trigger.emit(id)
		self.score.emit(category, points)
		self.excite.emit(category, 3)
		
		# play push back sound
		push_back_audio_stream_player.play()
