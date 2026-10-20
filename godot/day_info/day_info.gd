class_name DayInfo

extends PanelContainer


@onready var score: int:
	set(score): self.score_label.text = str(score)

@onready var day: int:
	set(day): self.day_panel.day = day

var title : String:
	set(value):
		%Title.text = value

const OPENING_MINUTE := 13 * 60
const CLOSING_MINUTE := 19 * 60

var day_progress := 0.0:
	set(value):
		day_progress = clampf(value, 0.0, 1.0)
		var minute := int(lerpf(OPENING_MINUTE, CLOSING_MINUTE, day_progress))
		%ClockValue.text = "%02d:%02d" % [minute / 60, minute % 60]

var excitement_percent = 0.7:
	set(value):
		%ExcitementBar.value = value * 100.0
		excitement_percent = value
