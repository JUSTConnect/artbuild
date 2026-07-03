extends Node

const TOP_HUD_H: float = 76.0
const BOTTOM_HUD_H: float = 112.0
const PAD: float = 12.0
const BUTTON_H: float = 34.0
const CHOICE_H: float = 64.0

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

func _bind_scene() -> void:
	game_root = get_tree().current_scene as Control

func _apply_compact_layout() -> void:
	var root_size: Vector2 = game_root.size
	if root_size.x < 1.0 or root_size.y < 1.0:
		return

	_set_control_rect("TopHudBackdrop", Vector2.ZERO, Vector2(root_size.x, TOP_HUD_H))
	_set_control_rect("BottomHudBackdrop", Vector2(0.0, root_size.y - BOTTOM_HUD_H), Vector2(root_size.x, BOTTOM_HUD_H))
	_set_control_rect("Title", Vector2(0.0, 6.0), Vector2(root_size.x, 22.0))
	_set_control_rect("LevelInfo", Vector2(PAD, 28.0), Vector2(root_size.x - PAD * 2.0, 32.0))

	var stats: Label = game_root.get_node_or_null("Stats") as Label
	if stats != null:
		stats.visible = root_size.x >= 760.0
		stats.position = Vector2(root_size.x - 230.0, 22.0)
		stats.size = Vector2(220.0, 52.0)

	var tower_h: float = root_size.y - TOP_HUD_H - BOTTOM_HUD_H
	if tower_h < 160.0:
		tower_h = 160.0
	_set_control_rect("TowerArea", Vector2(PAD, TOP_HUD_H), Vector2(root_size.x - PAD * 2.0, tower_h))

	var choice_bar: HBoxContainer = game_root.get_node_or_null("ChoiceBar") as HBoxContainer
	if choice_bar != null:
		choice_bar.position = Vector2(PAD, root_size.y - BOTTOM_HUD_H + 8.0)
		choice_bar.size = Vector2(root_size.x - PAD * 2.0, CHOICE_H)
		var children: Array[Node] = choice_bar.get_children()
		for index: int in range(children.size()):
			var button: Button = children[index] as Button
			if button != null:
				button.custom_minimum_size = Vector2(0.0, CHOICE_H)

	_set_control_rect("LevelUpButton", Vector2(PAD, root_size.y - BUTTON_H - 8.0), Vector2(120.0, BUTTON_H))
	_set_control_rect("ResetButton", Vector2(root_size.x - 104.0, root_size.y - BUTTON_H - 8.0), Vector2(92.0, BUTTON_H))

	var hint: Label = game_root.get_node_or_null("Hint") as Label
	if hint != null:
		hint.position = Vector2(138.0, root_size.y - BUTTON_H - 8.0)
		hint.size = Vector2(root_size.x - 252.0, BUTTON_H)
		hint.visible = hint.size.x >= 160.0

func _set_control_rect(path: String, pos: Vector2, rect_size: Vector2) -> void:
	var control: Control = game_root.get_node_or_null(path) as Control
	if control == null:
		return
	control.position = pos
	control.size = rect_size
