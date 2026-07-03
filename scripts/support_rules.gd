extends Node

const CELL_W: float = 108.0
const CELL_H: float = 58.0
const MATCH_EPSILON: float = 1.0

var game_root: Node = null
var tower_area: Control = null
var tower: Control = null

func _ready() -> void:
	call_deferred("_bind_scene")

func _bind_scene() -> void:
	game_root = get_tree().current_scene
	if game_root == null:
		return
	tower_area = game_root.get_node_or_null("TowerArea") as Control
	if tower_area != null:
		tower = tower_area.get_node_or_null("Tower") as Control

func _process(_delta: float) -> void:
	if not _is_ready_for_rules():
		return
	_filter_slot_buttons()

func _is_ready_for_rules() -> bool:
	if game_root == null or tower_area == null or tower == null:
		_bind_scene()
	if game_root == null or tower_area == null or tower == null:
		return false
	return game_root.get("game_started") == true

func _filter_slot_buttons() -> void:
	var buttons: Array[Node] = tower.get_children()
	for index: int in range(buttons.size()):
		var button: Button = buttons[index] as Button
		if button == null:
			continue
		if not _looks_like_slot(button):
			continue
		var slot: Dictionary = _slot_from_button(button)
		if slot.is_empty():
			button.disabled = true
			button.visible = false
			continue
		var has_rules_support: bool = _choice_has_support(int(slot["surface"]), int(slot["cell"]))
		if not has_rules_support:
			button.disabled = true
			button.visible = false

func _looks_like_slot(button: Button) -> bool:
	return button.text.find("slot") >= 0

func _slot_from_button(button: Button) -> Dictionary:
	var surfaces: Array = game_root.get("surfaces")
	var level: int = int(game_root.get("unlocked_level"))
	for surface_index: int in range(surfaces.size()):
		var surface: Dictionary = surfaces[surface_index]
		var cells: int = int(surface["cells"])
		for cell: int in range(cells):
			var expected: Variant = game_root.call("_slot_position", surface_index, level, cell)
			if expected is Vector2 and button.position.distance_to(expected) <= MATCH_EPSILON:
				return {"surface": surface_index, "cell": cell}
	return {}

func _choice_has_support(surface_index: int, anchor_cell: int) -> bool:
	var level: int = int(game_root.get("unlocked_level"))
	if level <= 1:
		return true
	var selected: Dictionary = game_root.get("selected_building")
	if selected.is_empty():
		return _cell_has_support(surface_index, level, anchor_cell)
	var footprint: Array = selected["footprint"]
	for index: int in range(footprint.size()):
		var rel: Vector2i = footprint[index] as Vector2i
		if rel.y != 0:
			continue
		if _cell_has_support(surface_index, level, anchor_cell + rel.x):
			return true
	return false

func _cell_has_support(surface_index: int, level: int, cell: int) -> bool:
	if level <= 1:
		return true
	return bool(game_root.call("_is_cell_occupied", surface_index, level - 1, cell))
