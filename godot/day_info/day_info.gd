class_name DayInfo

extends PanelContainer

@onready var score_label: Label = %ScoreLabel;
@onready var day_panel: DayPanel = %DayPanel;

@onready var score: int:
	set(score): self.score_label.text = str(score);

@onready var day: int:
	set(day): self.day_panel.day = day;

func _ready() -> void:
	pass
