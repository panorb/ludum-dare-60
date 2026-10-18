class_name ShopItem
extends PanelContainer

signal pressed(entry: ShopEntry)

var entry: ShopEntry


func setup(new_entry: ShopEntry) -> void:
	entry = new_entry
	%Icon.texture = entry.icon
	%NameTag.text = entry.title.to_upper()
	%Price.text = str(entry.price)
	%SetSticker.visible = entry.is_set

func _gui_input(event: InputEvent) -> void:
	# Fires on release, so the release can't count as a placement click.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		pressed.emit(entry)
