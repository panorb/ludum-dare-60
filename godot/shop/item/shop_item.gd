class_name ShopItem
extends PanelContainer

signal pressed(entry: ShopEntry)

var entry: ShopEntry
var is_active: bool = false:
	set(value):
		is_active = value
		_update_state()
var is_hovered: bool = false:
	set(value):
		is_hovered = value
		_update_state()
const SLANT_ANGLE_MIN: float = 0.1
const SLANT_ANGLE_MAX: float = 2.1


func _ready() -> void:
	mouse_entered.connect(_on_hover_changed.bind(true))
	mouse_exited.connect(_on_hover_changed.bind(false))
	_on_hover_changed(false)  # start with the normal look

func setup(new_entry: ShopEntry, is_right_side: bool) -> void:
	entry = new_entry
	%Icon.texture = entry.icon
	%NameTag.text = entry.title.to_upper()
	%Price.text = str(entry.price)
	%SetSticker.visible = entry.is_set
	%NameTag.offset_transform_rotation = (float(is_right_side) * 2.0 - 1.0) * deg_to_rad(randf_range(SLANT_ANGLE_MIN, SLANT_ANGLE_MAX))

func set_active(active: bool):
	is_active = active

func _gui_input(event: InputEvent) -> void:
	# Fires on release, so the release can't count as a placement click.
	if is_active and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		pressed.emit(entry)

func _on_hover_changed(hovered: bool) -> void:
	is_hovered = hovered

func _update_state():
	if not is_active:
		%Bulbs.set_lights(Bulbs.LightMode.DISABLED)
	elif is_hovered:
		%Bulbs.set_lights(Bulbs.LightMode.ON)
	else:
		%Bulbs.set_lights(Bulbs.LightMode.OFF)
