extends PanelContainer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("flipper_charge"):
		celebrate_purchase()


func celebrate_purchase() -> void:
	var mat: ShaderMaterial = $Bulbs.material
	mat.set_shader_parameter("flash", true)
	mat.set_shader_parameter("speed", 8.0)
	await get_tree().create_timer(1.0).timeout
	mat.set_shader_parameter("flash", false)
	mat.set_shader_parameter("speed", 3.0)
