extends Node

const SIDE_PAD: float = 48.0
const ROW_LABEL_W: float = 170.0
const FIELD_W: float = 132.0
const ROW_H: float = 42.0

var game_root: Control = null

func _ready() -> void:
	process_priority = 1700
	call_deferred("_bind_scene")

func _process(_delta: float) -> void:
	if game_root == null:
		_bind_scene()
	if game_root == null:
		return
	_fit_menu()

func _bind_scene() -> void:
	game_root = get_tree().current_scene as Control

func _fit_menu() -> void:
	var panel: Control = game_root.get_node_or_null("MenuPanel") as Control
	if panel == null or not panel.visible:
		return
	var root_size: Vector2 = game_root.size
	if root_size.x < 1.0 or root_size.y < 1.0:
		return
	var panel_w: float = root_size.x - 48.0
	if panel_w > 460.0:
		panel_w = 460.0
	if panel_w < 340.0:
		panel_w = 340.0
	var panel_h: float = 500.0
	if root_size.y < 760.0:
		panel_h = root_size.y - 160.0
	if panel_h < 420.0:
		panel_h = 420.0
	panel.size = Vector2(panel_w, panel_h)
	panel.position = Vector2((root_size.x - panel_w) / 2.0, (root_size.y - panel_h) / 2.0)

	_set_rect(panel, "MenuTitle", Vector2(0.0, 34.0), Vector2(panel_w, 34.0))
	_center_label(panel, "MenuTitle")

	var field_x: float = panel_w - SIDE_PAD - FIELD_W
	_set_rect(panel, "CellsLabel", Vector2(SIDE_PAD, 112.0), Vector2(ROW_LABEL_W, ROW_H))
	_set_rect(panel, "CellsOption", Vector2(field_x, 108.0), Vector2(FIELD_W, ROW_H))
	_set_rect(panel, "TerrainLabel", Vector2(SIDE_PAD, 184.0), Vector2(ROW_LABEL_W, ROW_H))
	_set_rect(panel, "TerrainOption", Vector2(field_x, 180.0), Vector2(FIELD_W, ROW_H))

	_set_rect(panel, "MenuInfo", Vector2(SIDE_PAD, 270.0), Vector2(panel_w - SIDE_PAD * 2.0, 86.0))
	_center_label(panel, "MenuInfo")

	var button_w: float = 190.0
	_set_rect(panel, "StartButton", Vector2((panel_w - button_w) / 2.0, panel_h - 92.0), Vector2(button_w, 52.0))

func _set_rect(parent: Node, path: String, pos: Vector2, rect_size: Vector2) -> void:
	var control: Control = parent.get_node_or_null(path) as Control
	if control == null:
		return
	control.position = pos
	control.size = rect_size

func _center_label(parent: Node, path: String) -> void:
	var label: Label = parent.get_node_or_null(path) as Label
	if label == null:
		return
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
