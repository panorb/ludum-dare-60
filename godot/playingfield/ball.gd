extends RigidBody2D

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is StaticBody2D:
		print("bump1!") 
		if body.has_method("on_bump"):
			body.on_bump(self)

func _process(_delta: float) -> void:
	$Sprite2D.global_rotation = 0.0
