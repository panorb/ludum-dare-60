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
var interactable: bool = true: set = _set_interactable
const SLANT_ANGLE_MIN: float = 0.1
const SLANT_ANGLE_MAX: float = 2.1

func _set_interactable(value: bool):
	interactable = value
	_update_state()

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
		%SetSticker.add_theme_stylebox_override("normal", load("res://shop/set_sticker_disabled.tres"))
		%SetSticker.add_theme_color_override("font_color", Color.BLACK)
		%NameTag.add_theme_stylebox_override("normal", load("res://shop/name_tag_disabled.tres"))
		%Price.add_theme_color_override("font_color", Color("#ec614a"))
		%Art.add_theme_stylebox_override("panel", load("res://shop/art_disabled.tres"))
	else:
		%SetSticker.add_theme_stylebox_override("normal", load("res://shop/set_sticker_enabled.tres"))
		%SetSticker.add_theme_color_override("font_color", Color("#38002c"))
		%NameTag.add_theme_stylebox_override("normal", load("res://shop/name_tag_enabled.tres"))
		%Price.add_theme_color_override("font_color", Color("#fff6ae"))
		%Art.add_theme_stylebox_override("panel", load("res://shop/art_enabled.tres"))
		
		if is_hovered:
			%Bulbs.set_lights(Bulbs.LightMode.ON)
		else:
			%Bulbs.set_lights(Bulbs.LightMode.OFF)
	
	if not interactable:
		%Bulbs.set_lights(Bulbs.LightMode.DISABLED)
	
