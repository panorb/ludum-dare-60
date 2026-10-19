class_name Set
extends PinballMashinePart

@onready var child_pinball_maschine_parts: Array[PinballMashinePart]:
	get: return get_ma_pinball_children()

func get_ma_pinball_children():
	var kiddies := get_children()
	var parts: Array[PinballMashinePart] = []
	for kiddy in kiddies:
		if kiddy is PinballMashinePart:
			parts.append(kiddy)
	return parts

func _on_score(id, score: int):
	self.score.emit(id, score);

func _on_excite(excitement: float):
	self.excite.emit(excitement);

func _ready() -> void:
	for child_pinball_maschine_part in self.child_pinball_maschine_parts:
		child_pinball_maschine_part.score.connect(_on_score)
		child_pinball_maschine_part.excite.connect(_on_excite)

func reset() -> void:
	for child_pinball_maschine_part in self.child_pinball_maschine_parts:
		if child_pinball_maschine_part.has_method("reset"):
			child_pinball_maschine_part.reset();
