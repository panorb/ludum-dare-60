class_name Set
extends PinballMashinePart

@onready var child_pinball_maschine_parts: Array[PinballMashinePart]:
	get: return self.get_children() \
		.filter(func (child): child is PinballMashinePart);
