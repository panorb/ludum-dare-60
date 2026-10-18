extends PanelContainer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("flipper_charge"):
		celebrate_purchase()


func celebrate_purchase() -> void:
	$Bulbs.set_lights(Bulbs.LightMode.FLASH)
	$Bulbs.set_speed(8.0)
	await get_tree().create_timer(1.0).timeout
	$Bulbs.set_lights(Bulbs.LightMode.BLINK)
	$Bulbs.set_speed(3.0)
