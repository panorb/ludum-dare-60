class_name Placer
extends Node

signal placement_finished(placed: Node2D)
signal placement_cancelled
signal part_sold(sold: ShopEntry)

const PLACEMENT_LAYER := 1 << 16
const KEEP_CLEAR_LAYER := 1 << 17 
const HOVER_LAYER := 1 << 18

const ROTATE_STEP := PI / 12.0
const COLOR_OK := Color(1.0, 1.0, 1.0, 0.6)
const COLOR_BLOCKED := Color(0.925, 0.380, 0.290, 0.75)  # #ec614a
const HINT_COLOR := Color("ffa468")
const HINT_COLOR_BLOCKED := Color("ec614a")

enum Block { NONE, TOO_CLOSE, KEEP_CLEAR }

@export var table_view: SubViewportContainer
@export var sub_viewport: SubViewport
@export var placed_parts: Node2D
@export var sell_slot: Control

@onready var cursor_layer: CanvasLayer = $CursorLayer
@onready var link_line: Line2D = $CursorLayer/LinkLine
@onready var hint: Label = $CursorLayer/PlaceHint

@onready var pinball_machine := %PinballMachine

var _set: Node2D = null
var _parts: Array[Node2D] = []
var _index := 0
var _home: Node = null
var _part_scale := Vector2.ONE
var _block := Block.NONE


func is_placing() -> bool:
	return _set != null

func start(entry: ShopEntry) -> void:
	_set = entry.scene.instantiate()
	_set.set_meta("entry", entry)
	# _set.process_mode = Node.PROCESS_MODE_DISABLED
	placed_parts.add_child(_set)

	# If a set or single element is adding to the tree, it will connecting with mashine
	_set.score.connect(pinball_machine.on_score);
	_set.excite.connect(pinball_machine.on_excite);

	_parts.clear()
	if _set.is_in_group("part"):
		_parts.append(_set)  # a single part
	else:
		for child in _set.get_children():
			if child.is_in_group("part"):
				_parts.append(child)
				child.hide()

	_index = 0
	_pick_up_current()

func _pick_up_current() -> void:
	var part := _parts[_index]
	_home = part.get_parent()
	_part_scale = part.scale
	part.reparent(cursor_layer, false)
	#part.process_mode = Node.PROCESS_MODE_DISABLED
	part.scale = _part_scale * _table_scale()
	part.modulate = COLOR_OK
	part.show()

	_block = Block.NONE
	hint.show()
	_update_hint()
	link_line.closed = false
	link_line.visible = _index > 0

func _process(_delta: float) -> void:
	if not is_placing():
		return
	var mouse := get_viewport().get_mouse_position()
	_parts[_index].position = mouse
	hint.position = mouse + Vector2(-hint.size.x / 2.0, -80.0)
	if _index > 0:
		var previous := _world_to_screen(_parts[_index - 1].global_position)
		link_line.points = PackedVector2Array([
			link_line.to_local(previous),
			link_line.to_local(mouse),
		])

func _physics_process(_delta: float) -> void:
	if not is_placing():
		_update_hover()
		return
	var mouse := get_viewport().get_mouse_position()
	var part := _parts[_index]
	if table_view.get_global_rect().has_point(mouse):
		_block = _check_spot(part, _screen_to_world(mouse))
	else:
		_block = Block.NONE
	part.modulate = COLOR_OK if _block == Block.NONE else COLOR_BLOCKED
	_update_hint()

func _update_hint() -> void:
	match _block:
		Block.KEEP_CLEAR:
			hint.text = "KEEP CLEARED"
		Block.TOO_CLOSE:
			hint.text = "TOO CLOSE..."
		_:
			if _parts.size() > 1:
				hint.text = "PLACE %d OF %d" % [_index + 1, _parts.size()]
			else:
				hint.text = "PLACE THINGY"
	var blocked := _block != Block.NONE
	hint.add_theme_color_override("font_color", HINT_COLOR_BLOCKED if blocked else HINT_COLOR)

func _rotate_held(angle: float) -> void:
	var part := _parts[_index]
	if part.is_in_group("no_rotate"):
		return
	part.rotation = wrapf(part.rotation + angle, -PI, PI)

func _input(event: InputEvent) -> void:
	if not is_placing():
		_handle_sell_click(event)
		return
	
	if event.is_action_pressed("rotate_left", true):
		_rotate_held(-ROTATE_STEP)
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("rotate_right", true):
		_rotate_held(ROTATE_STEP)
		get_viewport().set_input_as_handled()
		return
	
	if not (event is InputEventMouseButton and event.pressed):
		return
	var click := event as InputEventMouseButton
	match click.button_index:
		MOUSE_BUTTON_LEFT:
			if table_view.get_global_rect().has_point(click.position):
				if _block == Block.NONE:
					_drop_current(click.position)
			elif sell_slot.get_global_rect().has_point(click.position):
				_cancel()
		MOUSE_BUTTON_RIGHT:
			_cancel()
	get_viewport().set_input_as_handled()

func _handle_sell_click(event: InputEvent) -> void:
	var click := event as InputEventMouseButton
	if click == null or not click.pressed or click.button_index != MOUSE_BUTTON_RIGHT:
		return
	if not table_view.get_global_rect().has_point(click.position):
		return
	var placed := _placed_at(_screen_to_world(click.position))
	if placed == null:
		return
	var entry : ShopEntry = placed.get_meta("entry")
	placed.queue_free()
	link_line.hide()
	part_sold.emit(entry)
	get_viewport().set_input_as_handled()

func _drop_current(screen_pos: Vector2) -> void:
	var part := _parts[_index]
	part.reparent(_home, false)
	part.scale = _part_scale
	part.global_position = _screen_to_world(screen_pos)
	part.modulate = Color.WHITE
	part.process_mode = Node.PROCESS_MODE_INHERIT

	_index += 1
	if _index < _parts.size():
		_pick_up_current()
		return

	var placed := _set
	_reset()
	#placed.process_mode = Node.PROCESS_MODE_INHERIT
	
	
	placement_finished.emit(placed)

func _cancel() -> void:
	var held := _parts[_index]
	if held != _set:
		held.queue_free()
	_set.queue_free()
	_reset()
	placement_cancelled.emit()

func _reset() -> void:
	_set = null
	_parts.clear()
	_home = null
	_block = Block.NONE
	hint.hide()
	link_line.hide()
	link_line.closed = false

func _check_spot(part: Node2D, world_pos: Vector2) -> Block:
	if _overlaps(part, world_pos, KEEP_CLEAR_LAYER):
		return Block.KEEP_CLEAR
	if _overlaps(part, world_pos, PLACEMENT_LAYER):
		return Block.TOO_CLOSE
	return Block.NONE

func _overlaps(part: Node2D, world_pos: Vector2, mask: int) -> bool:
	var zone := part.get_node_or_null("ExclusionZone") as Area2D
	if zone == null:
		return false
	var space := sub_viewport.world_2d.direct_space_state
	
	var part_xform := Transform2D(part.rotation, _part_scale, 0.0, world_pos)
	for child in zone.get_children():
		var shape_node := child as CollisionShape2D
		if shape_node == null or shape_node.shape == null:
			continue
		var params := PhysicsShapeQueryParameters2D.new()
		params.shape = shape_node.shape
		params.transform = part_xform * zone.transform * shape_node.transform
		params.collision_mask = mask
		params.collide_with_areas = true
		params.collide_with_bodies = false
		if not space.intersect_shape(params, 1).is_empty():
			return true
	return false

func _update_hover() -> void:
	var mouse := get_viewport().get_mouse_position()
	var set_root: Node2D = null
	if table_view.get_global_rect().has_point(mouse):
		set_root = _set_at(_screen_to_world(mouse))
	if set_root == null:
		link_line.hide()
		return

	# Connect all parts of the set, in the order they were placed.
	var points := PackedVector2Array()
	for child in set_root.get_children():
		if child.is_in_group("part"):
			points.append(link_line.to_local(_world_to_screen(child.global_position)))
	link_line.points = points
	link_line.closed = points.size() > 2  # a loop for sets with three or more parts
	link_line.show()

func _placed_at(world_pos: Vector2) -> Node2D:
	var params := PhysicsPointQueryParameters2D.new()
	params.position = world_pos
	params.collision_mask = HOVER_LAYER
	params.collide_with_areas = true
	params.collide_with_bodies = false
	for hit in sub_viewport.world_2d.direct_space_state.intersect_point(params, 8):
		# Walk up from the zone until we reach a direct child of PlacedParts.
		var node: Node = hit.collider
		while node != null and node.get_parent() != placed_parts:
			node = node.get_parent()
		if node != null:
			return node
	return null

func _set_at(world_pos: Vector2) -> Node2D:
	var placed := _placed_at(world_pos)
	if placed != null and not placed.is_in_group("part"):
		return placed  # a set, not a single part
	return null

func _screen_to_world(screen_pos: Vector2) -> Vector2:
	var local := table_view.get_global_transform_with_canvas().affine_inverse() * screen_pos
	local /= float(table_view.stretch_shrink)
	return sub_viewport.get_canvas_transform().affine_inverse() * local

func _world_to_screen(world_pos: Vector2) -> Vector2:
	var local := sub_viewport.get_canvas_transform() * world_pos
	local *= float(table_view.stretch_shrink)
	return table_view.get_global_transform_with_canvas() * local

func _table_scale() -> Vector2:
	return sub_viewport.get_canvas_transform().get_scale() \
		* table_view.get_global_transform_with_canvas().get_scale() \
		* float(table_view.stretch_shrink)
