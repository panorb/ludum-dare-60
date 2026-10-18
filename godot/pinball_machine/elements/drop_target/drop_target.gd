extends Element

@onready var drop_area = $Area2D
@onready var blocker_standing = $StaticBodyStanding/CollisionShape2D
@onready var sprite_fallen = $SpriteFallen
@onready var sprite_standing = $SpriteStanding

var standing = true

func _ready() -> void:
	drop_area.body_entered.connect(_on_drop)

func _on_drop(body) -> void:
	print("_on_drop")
	if not standing:
		return
	standing = false
	fall()

func fall() -> void:
	blocker_standing.set_deferred('disabled', true)
	sprite_fallen.show()
	sprite_standing.hide()

func standup() -> void:
	blocker_standing.set_deferred('disabled', false)
	sprite_fallen.hide()
	sprite_standing.show()
