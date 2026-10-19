class_name DayInfo

extends PanelContainer


@onready var score: int:
	set(score): self.score_label.text = str(score)

@onready var day: int:
	set(day): self.day_panel.day = day

var title : String:
	set(value):
		%Title.text = value

var excitement_percent = 0.7:
	set(value):
		%ExcitementBar.value = value * 100.0
		excitement_percent = value
