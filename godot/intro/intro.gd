class_name Intro
extends Control

@onready var text_label := %TextLabel;

signal finisched

func _ready() -> void:
	var label_text_length : int = %TextLabel.text.length();
	var label_tween := get_tree().create_tween();
	label_tween.tween_property(%TextLabel, 'visible_characters', label_text_length, label_text_length/100);
	label_tween.set_loops().tween_property(%TextLabel, 'visible_characters', label_text_length-1, 1);
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		finisched.emit();
