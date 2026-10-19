class_name Set
extends PinballMashinePart

@onready var child_pinball_maschine_parts: Array[PinballMashinePart]:
	get: return self.get_children() \
		.filter(func (child): child is PinballMashinePart);

func _on_score(id, score: int):
	self.score.emit(id, score);

func _on_excite(excitement: float):
	self.excite.emit(excitement);

func _ready() -> void:
	for child_pinball_maschine_part in self.child_pinball_maschine_parts:
		child_pinball_maschine_part.hit.connect(_on_score)
		child_pinball_maschine_part.excite.connect(_on_excite)

func reset() -> void:
	for child_pinball_maschine_part in self.child_pinball_maschine_parts:
		child_pinball_maschine_part.reset();
