class_name ThreeBumpers
extends Set

func _ready() -> void:
	for child_pinball_maschine_part in self.child_pinball_maschine_parts:
		child_pinball_maschine_part.hit.connect(_on_score)
		child_pinball_maschine_part.excite.connect(_on_excite)

func _on_score(id, score: int):
	self.score.emit(id, score);

func _on_excite(excitement: float):
	self.excite.emit(excitement);

func reset() -> void:
	for child_pinball_maschine_part in self.child_pinball_maschine_parts:
		child_pinball_maschine_part.reset();
