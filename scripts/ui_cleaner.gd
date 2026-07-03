extends Node

var game_root: Control = null

func _ready() -> void:
	process_priority = 1600
	call_deferred("_bind_scene")

func _process(_delta: float) -> void:
	if game_root == null:
		_bind_scene()
	if game_root == null:
		return
	if game_root.get("game_started") != true:
		return
	var level: int = int(game_root.get("unlocked_level"))
	var level_info: Label = game_root.get_node_or_null("LevelInfo") as Label
	if level_info != null:
		level_info.text = "Уровень: %d | Свободно: %d" % [level, _free_cells(level)]
	var level_button: Button = game_root.get_node_or_null("LevelUpButton") as Button
	if level_button != null:
		level_button.text = "Level Up"
	var stats: Label = game_root.get_node_or_null("Stats") as Label
	if stats != null:
		stats.visible = false
	var hint: Label = game_root.get_node_or_null("Hint") as Label
	if hint != null:
		hint.visible = false

func _bind_scene() -> void:
	game_root = get_tree().current_scene as Control

func _free_cells(level: int) -> int:
	var count: int = 0
	var surfaces: Array = game_root.get("surfaces")
	for surface_index: int in range(surfaces.size()):
		var surface: Dictionary = surfaces[surface_index]
		for cell: int in range(int(surface["cells"])):
			if not bool(game_root.call("_is_cell_occupied", surface_index, level, cell)):
				count += 1
	return count
