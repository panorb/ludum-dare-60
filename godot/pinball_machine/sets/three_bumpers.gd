class_name ThreeBumpers
extends Set

func _ready() -> void:
	for child_pinball_maschine_part in self.child_pinball_maschine_parts:
		child_pinball_maschine_part.hit.connect(_on_hit)

func _on_hit(score: int, excitement: float):
	self.hit.emit(score, excitement);

func reset() -> void:
	for child_pinball_maschine_part in self.child_pinball_maschine_parts:
		child_pinball_maschine_part.reset();
