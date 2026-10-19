class_name DayPanel
extends PanelContainer

@onready var title: Label = %Title;

var day: int = 0:
	set(day):
		title.text = 'Day ' + str(day);
