class_name ShopItem
extends PanelContainer

signal pressed(entry: ShopEntry)

var entry: ShopEntry
const SLANT_ANGLE_MIN: float = 0.1
const SLANT_ANGLE_MAX: float = 2.1


func setup(new_entry: ShopEntry, is_right_side: bool) -> void:
	entry = new_entry
	%Icon.texture = entry.icon
	%NameTag.text = entry.title.to_upper()
	%Price.text = str(entry.price)
	%SetSticker.visible = entry.is_set
	%NameTag.offset_transform_rotation = (float(is_right_side) * 2.0 - 1.0) * deg_to_rad(randf_range(SLANT_ANGLE_MIN, SLANT_ANGLE_MAX))

func _gui_input(event: InputEvent) -> void:
	# Fires on release, so the release can't count as a placement click.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		pressed.emit(entry)
