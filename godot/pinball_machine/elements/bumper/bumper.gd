@tool
class_name Bumper
extends Element

enum BUMPER_VARIANT {
	GREEN = 1,
	RED,
	YELLOW,
	BROKEN_1,
	BROKEN_2
}

const SECTOR := TAU / 3.0          # 120° pro Cushion
const START := -1.0 / 6.0 * PI     # Grenze oben links (-150°)


@export var variant : BUMPER_VARIANT = BUMPER_VARIANT.GREEN:
	set(value):
		$Sprite2D.texture = load("res://pinball_machine/elements/bumper/bumper{0}.png".format([value]))
		variant = value

@export var strength := 500.0;
var _cushion_tweens : Array[Tween] = [null, null, null]

func _init() -> void:
	category = Category.BUMPER

func set_active(_active=true) -> void:
	if _active:
		$Sprite2D.texture = load("res://pinball_machine/elements/bumper/bumper{0}.png".format([self.variant]))
	else:
		$Sprite2D.texture = load("res://pinball_machine/elements/bumper/disabled.png")
	active = _active

func set_points(_points) -> void:
	%ScoreLabel.text = str(_points)
	points = _points

signal body_entered

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Is this body a ball?
	if body is Ball:
		# Get ball
		var ball = body as Ball;
		# Calculate direction
		var direction := (body.global_position - global_position).normalized()
		# Give ball new force
		body.apply_central_impulse(direction * ball.mass * self.strength)
		# ??? 
		var local_dir := direction.rotated(-global_rotation)
		var index := posmod(floori((local_dir.angle() - START) / SECTOR), 3)
		
		if _cushion_tweens[index]:
			_cushion_tweens[index].kill()
		
		var cushion = %Cushions.get_child(index)
		
		BumperSounds.play()
		_cushion_tweens[index] = get_tree().create_tween()
		_cushion_tweens[index].tween_property(cushion, "scale", Vector2(0.22, 0.22), 0.1) \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_BOUNCE) \
			.from(Vector2(Vector2(0.16, 0.16)))
			
		_cushion_tweens[index].tween_property(cushion, "scale", Vector2(0.16, 0.16), 0.13) \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_CIRC) \
			.set_delay(0.15)
		
		if  self.active:
			self.trigger.emit(id)
			self.score.emit(category, points)

func on_bump(body: Node2D) -> void:
	body_entered.emit(body)
