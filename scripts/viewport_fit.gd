extends Node

const TOP_HUD_H: float = 74.0
const BOTTOM_HUD_H: float = 140.0
const PAD: float = 12.0
const BUTTON_H: float = 34.0
const CHOICE_H: float = 66.0
const ROW_GAP: float = 8.0
const TOWER_TOP_EXTRA: float = 34.0
const TOWER_BOTTOM_GAP: float = 10.0

var game_root: Control = null

func _ready() -> void:
	process_priority = 1000
	call_deferred("_bind_scene")

func _process(_delta: float) -> void:
	if game_root == null:
		_bind_scene()
	if game_root == null:
		return
	_apply_compact_layout()
	_simplify_top_hud()
	_clean_level_button()

func _bind_scene() -> void:
	game_root = get_tree().current_scene as Control

func _apply_compact_layout() -> void:
	var root_size: Vector2 = game_root.size
	if root_size.x < 1.0 or root_size.y < 1.0:
		return

	_set_control_rect("TopHudBackdrop", Vector2.ZERO, Vector2(root_size.x, TOP_HUD_H))
	_set_control_rect("BottomHudBackdrop", Vector2(0.0, root_size.y - BOTTOM_HUD_H), Vector2(root_size.x, BOTTOM_HUD_H))
	_set_control_rect("Title", Vector2(0.0, 6.0), Vector2(root_size.x, 22.0))
	_set_control_rect("LevelInfo", Vector2(PAD, 30.0), Vector2(root_size.x - PAD * 2.0, 28.0))

	var stats: Label = game_root.get_node_or_null("Stats") as Label
	if stats != null:
		stats.visible = root_size.x >= 760.0
		stats.position = Vector2(root_size.x - 230.0, 20.0)
		stats.size = Vector2(220.0, 52.0)

	var tower_top: float = TOP_HUD_H + TOWER_TOP_EXTRA
	var tower_bottom: float = root_size.y - BOTTOM_HUD_H - TOWER_BOTTOM_GAP
	var tower_h: float = tower_bottom - tower_top
	if tower_h < 160.0:
		tower_h = 160.0
	_set_control_rect("TowerArea", Vector2(PAD, tower_top), Vector2(root_size.x - PAD * 2.0, tower_h))

	var choice_y: float = root_size.y - CHOICE_H - PAD
	var controls_y: float = choice_y - ROW_GAP - BUTTON_H
	if controls_y < tower_bottom + 2.0:
		controls_y = tower_bottom + 2.0

	var choice_bar: HBoxContainer = game_root.get_node_or_null("ChoiceBar") as HBoxContainer
	if choice_bar != null:
		choice_bar.position = Vector2(PAD, choice_y)
		choice_bar.size = Vector2(root_size.x - PAD * 2.0, CHOICE_H)
		var children: Array[Node] = choice_bar.get_children()
		for index: int in range(children.size()):
			var button: Button = children[index] as Button
			if button != null:
				button.custom_minimum_size = Vector2(0.0, CHOICE_H)

	_set_control_rect("LevelUpButton", Vector2(PAD, controls_y), Vector2(124.0, BUTTON_H))
	_set_control_rect("ResetButton", Vector2(root_size.x - PAD - 92.0, controls_y), Vector2(92.0, BUTTON_H))

	var hint: Label = game_root.get_node_or_null("Hint") as Label
	if hint != null:
		hint.visible = false
		hint.position = Vector2.ZERO
		hint.size = Vector2.ZERO

func _simplify_top_hud() -> void:
	var level_info: Label = game_root.get_node_or_null("LevelInfo") as Label
	if level_info == null:
		return
	if game_root.get("game_started") != true:
		return
	var unlocked_level: int = int(game_root.get("unlocked_level"))
	var free_cells: int = _free_cells_on_level(unlocked_level)
	level_info.text = "Уровень: %d | Свободно: %d" % [unlocked_level, free_cells]

func _clean_level_button() -> void:
	var level_button: Button = game_root.get_node_or_null("LevelUpButton") as Button
	if level_button != null:
		level_button.text = "Level Up"
	var hint: Label = game_root.get_node_or_null("Hint") as Label
	if hint != null:
		hint.visible = false

func _free_cells_on_level(level: int) -> int:
	var surfaces: Array = game_root.get("surfaces")
	var count: int = 0
	for surface_index: int in range(surfaces.size()):
		var surface: Dictionary = surfaces[surface_index]
		var cells: int = int(surface["cells"])
		for cell: int in range(cells):
			var occupied: bool = bool(game_root.call("_is_cell_occupied", surface_index, level, cell))
			if not occupied:
				count += 1
	return count

func _set_control_rect(path: String, pos: Vector2, rect_size: Vector2) -> void:
	var control: Control = game_root.get_node_or_null(path) as Control
	if control == null:
		return
	control.position = pos
	control.size = rect_size
