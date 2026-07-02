extends Node

const ZOOM_AMOUNT: float = 0.1

@onready var game_root: Node = get_parent()
@onready var tower_area: Control = game_root.get_node("TowerArea") as Control

var mouse_dragging: bool = false
var last_mouse_pos: Vector2 = Vector2.ZERO
var active_points: Dictionary = {}
var scale_start_distance: float = 0.0
var scale_start_zoom: float = 1.0

func _unhandled_input(event: InputEvent) -> void:
	if not _is_game_started():
		return
	if event is InputEventMouseButton:
		_handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event)
	elif event is InputEventScreenTouch:
		_handle_screen_point(event)
	elif event is InputEventScreenDrag:
		_handle_screen_drag(event)

func _is_game_started() -> bool:
	return game_root.get("game_started") == true

func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _inside_tower_area(event.position):
			mouse_dragging = true
			last_mouse_pos = event.position
			get_viewport().set_input_as_handled()
		elif not event.pressed:
			mouse_dragging = false
		return
	if not event.pressed or not _inside_tower_area(event.position):
		return
	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		_zoom_camera(ZOOM_AMOUNT)
		get_viewport().set_input_as_handled()
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		_zoom_camera(-ZOOM_AMOUNT)
		get_viewport().set_input_as_handled()

func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if not mouse_dragging:
		return
	var delta: Vector2 = event.position - last_mouse_pos
	last_mouse_pos = event.position
	_pan_camera(delta)
	get_viewport().set_input_as_handled()

func _handle_screen_point(event: InputEventScreenTouch) -> void:
	if event.pressed:
		if not _inside_tower_area(event.position):
			return
		active_points[event.index] = event.position
		if active_points.size() >= 2:
			_begin_scale()
		get_viewport().set_input_as_handled()
	else:
		if active_points.has(event.index):
			active_points.erase(event.index)
			_begin_scale()
			get_viewport().set_input_as_handled()

func _handle_screen_drag(event: InputEventScreenDrag) -> void:
	if not active_points.has(event.index):
		return
	active_points[event.index] = event.position
	if active_points.size() == 1:
		_pan_camera(event.relative)
	elif active_points.size() >= 2:
		_apply_scale()
	get_viewport().set_input_as_handled()

func _inside_tower_area(point: Vector2) -> bool:
	return tower_area.get_global_rect().has_point(point)

func _point_positions() -> Array[Vector2]:
	var result: Array[Vector2] = []
	var keys: Array = active_points.keys()
	for index: int in range(keys.size()):
		result.append(active_points[keys[index]] as Vector2)
	return result

func _begin_scale() -> void:
	scale_start_distance = 0.0
	scale_start_zoom = float(game_root.get("camera_zoom"))
	if active_points.size() < 2:
		return
	var points: Array[Vector2] = _point_positions()
	scale_start_distance = points[0].distance_to(points[1])
	if scale_start_distance < 1.0:
		scale_start_distance = 1.0

func _apply_scale() -> void:
	if scale_start_distance <= 0.0:
		_begin_scale()
	var points: Array[Vector2] = _point_positions()
	if points.size() < 2:
		return
	var distance: float = points[0].distance_to(points[1])
	var current_zoom: float = float(game_root.get("camera_zoom"))
	var target_zoom: float = scale_start_zoom * distance / scale_start_distance
	_zoom_camera(target_zoom - current_zoom)

func _pan_camera(delta: Vector2) -> void:
	game_root.call("_pan_camera", delta)

func _zoom_camera(delta: float) -> void:
	game_root.call("_zoom_camera", delta)
