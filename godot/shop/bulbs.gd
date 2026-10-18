class_name Bulbs
extends ColorRect

enum LightMode { BLINK, FLASH, ON, OFF, DISABLED }

func _ready() -> void:
	material = material.duplicate()
	resized.connect(_update_size)
	_update_size()

func _update_size() -> void:
	material.set_shader_parameter("size", size)

func set_lights(mode: LightMode) -> void:
	material.set_shader_parameter("mode", mode)

func set_speed(speed: float) -> void:
	material.set_shader_parameter("speed", speed)
