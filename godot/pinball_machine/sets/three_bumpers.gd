class_name ThreeBumpers
extends Set

func _ready() -> void:
	var child_pinball_maschine_parts: Array[PinballMashinePart] = self.get_children() \
		.filter(func (child): child is PinballMashinePart);

	for child_pinball_maschine_part in child_pinball_maschine_parts:
		child_pinball_maschine_part.hit.connect(_on_hit)

func _on_hit(score: int, excitement: float):
	self.hit.emit(score, excitement);
