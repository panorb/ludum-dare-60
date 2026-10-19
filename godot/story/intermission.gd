class_name Intermission
extends Control

var _first_time = true
var _lines = []
signal finished

func start(lines: Array[String]):
	_lines = lines
	visible = true
	ended = false
	
	if not _first_time:
		get_tree().create_tween() \
			.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0) \
			.from(Color(1.0, 1.0, 1.0, 0.0))
	
	_first_time = false
	_present_line()

var line_read_tween = null
var ended = false

func _on_line_finished():
	%Bulbs.set_lights(Bulbs.LightMode.BLINK)

func _present_line():
	if len(_lines) == 0:
		if not ended:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.6) \
				.from(Color(1.0, 1.0, 1.0, 1.0))
			tween.tween_callback(hide)
			finished.emit()
		ended = true
		return
	
	%Bulbs.set_lights(Bulbs.LightMode.OFF)
	var next_line = _lines.pop_front() + "↪"
	
	if line_read_tween:
		line_read_tween.kill()
	
	%TextLine.text = next_line
	line_read_tween = get_tree().create_tween()
	line_read_tween.tween_property(%TextLine, "visible_ratio", 1.0, pow(len(next_line), 0.7) * 0.115) \
		.from(0.0)
	line_read_tween.tween_callback(_on_line_finished)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_present_line()
