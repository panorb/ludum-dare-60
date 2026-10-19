extends Element

@onready var drop_area = $Area2D
@onready var blocker_standing = $StaticBodyStanding/CollisionShape2D
@onready var sprite_fallen = $SpriteFallen
@onready var sprite_standing = $SpriteStanding
@onready var fallen_sound = %FallenSoundPlayer

var standing = true

func _ready() -> void:
	drop_area.body_entered.connect(_on_drop)

func _on_drop(body) -> void:
	print("_on_drop")
	if standing:
		standing = false
		fall()

func reset() -> void:
	if not standing:
		standing = true
		standup()

func fall() -> void:
	fallen_sound.play()
	blocker_standing.set_deferred('disabled', true)
	sprite_fallen.show()
	sprite_standing.hide()
	score.emit(id, points)

func standup() -> void:
	blocker_standing.set_deferred('disabled', false)
	sprite_fallen.hide()
	sprite_standing.show()
