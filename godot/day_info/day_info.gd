class_name DayInfo
extends PanelContainer

@onready var score_label: Label = %ScoreLabel

var score: int :
	set(score): self.score_label.text = str(score);
