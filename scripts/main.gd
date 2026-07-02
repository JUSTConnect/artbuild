extends Control

const CELL_W := 108.0
const CELL_H := 58.0
const LEVEL_H := 74.0
const SURFACE_GAP := 84.0
const BASE_Y_PAD := 72.0
const TOP_SCROLL_PAD := 64.0

const TERRAIN_KEYS := ["plateau", "river", "islands", "mountains"]

const BUILDINGS := [
	{
		"id": "housing",
		"title": "Жилище",
		"glyph": "H",
		"color": Color(0.74, 0.84, 0.76, 1.0),
		"residents": 2,
		"energy": -1,
		"beauty": 1,
		"tech": 0,
		"comfort": 0
	},
	{
		"id": "cafe",
		"title": "Кафе",
		"glyph": "C",
		"color": Color(0.88, 0.69, 0.62, 1.0),
		"residents": 0,
		"energy": -1,
		"beauty": 2,
		"tech": 0,
		"comfort": 3
	},
	{
		"id": "library",
		"title": "Библиотека",
		"glyph": "L",
		"color": Color(0.67, 0.77, 0.90, 1.0),
		"residents": 0,
		"energy": -1,
		"beauty": 1,
		"tech": 2,
		"comfort": 2
	},
	{
		"id": "workshop",
		"title": "Мастерская",
		"glyph": "M",
		"color": Color(0.76, 0.72, 0.66, 1.0),
		"residents": 0,
		"energy": -2,
		"beauty": 0,
		"tech": 3,
		"comfort": 0
	},
	{
		"id": "lab",
		"title": "Лаборатория",
		"glyph": "Lab",
		"color": Color(0.59, 0.88, 0.91, 1.0),
		"residents": 0,
		"energy": -3,
		"beauty": 1,
		"tech": 5,
		"comfort": 0
	},
	{
		"id": "university",
		"title": "Университет",
		"glyph": "U",
		"color": Color(0.55, 0.66, 0.92, 1.0),
		"residents": 0,
		"energy": -3,
		"beauty": 2,
		"tech": 6,
		"comfort": 2
	},
	{
		"id": "school",
		"title": "Школа",
		"glyph": "S",
		"color": Color(0.92, 0.81, 0.55, 1.0),
		"residents": 0,
		"energy": -1,
		"beauty": 1,
		"tech": 2,
		"comfort": 3
	},
	{
		"id": "shop",
		"title": "Лавка",
		"glyph": "Shop",
		"color": Color(0.84, 0.62, 0.46, 1.0),
		"residents": 0,
		"energy": -1,
		"beauty": 2,
		"tech": 1,
		"comfort": 2
	}
]

@onready var menu_panel: Control = $MenuPanel
@onready var cells_option: OptionButton = $MenuPanel/CellsOption
@onready var terrain_option: OptionButton = $MenuPanel/TerrainOption
@onready var start_button: Button = $MenuPanel/StartButton
@onready var tower_area: Control = $TowerArea
@onready var tower: Control = $TowerArea/Tower
@onready var stats: Label = $Stats
@onready var level_info: Label = $LevelInfo
@onready var choice_bar: HBoxContainer = $ChoiceBar
@onready var choice_buttons := [$ChoiceBar/Choice1, $ChoiceBar/Choice2, $ChoiceBar/Choice3]
@onready var level_up_button: Button = $LevelUpButton
@onready var hint: Label = $Hint
@onready var reset_button: Button = $ResetButton

var rng := RandomNumberGenerator.new()
var game_started := false
var cells_per_level := 3
var terrain_type := "plateau"
var surfaces: Array[Dictionary] = []
var placed_blocks: Array[Dictionary] = []
var current_choices: Array[Dictionary] = []
var selected_building: Dictionary = {}
var selected_choice_index := -1
var unlocked_level := 1
var scroll_offset := 0.0

var turn := 0
var population := 0
var capacity := 0
var energy_produced := 0
var energy_required := 0
var beauty := 0
var technology := 0
var comfort := 0

func _ready() -> void:
	rng.randomize()
	_setup_menu_options()
	for index in range(choice_buttons.size()):
		choice_buttons[index].pressed.connect(_on_choice_pressed.bind(index))
	start_button.pressed.connect(_on_start_pressed)
	reset_button.pressed.connect(show_menu)
	level_up_button.pressed.connect(_on_level_up_pressed)
	show_menu()

func _unhandled_input(event: InputEvent) -> void:
	if not game_started:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_UP:
			_scroll_by(96.0)
		elif event.keycode == KEY_DOWN:
			_scroll_by(-96.0)

func _setup_menu_options() -> void:
	cells_option.clear()
	for value in range(1, 6):
		cells_option.add_item(str(value), value)
	cells_option.select(2)

	terrain_option.clear()
	terrain_option.add_item("Плато")
	terrain_option.add_item("Река")
	terrain_option.add_item("Острова")
	terrain_option.add_item("Горы")
	terrain_option.select(0)

func show_menu() -> void:
	game_started = false
	menu_panel.visible = true
	stats.visible = false
	level_info.visible = false
	tower_area.visible = false
	choice_bar.visible = false
	level_up_button.visible = false
	hint.visible = false
	reset_button.visible = false
	_clear_tower()

func _on_start_pressed() -> void:
	cells_per_level = max(1, cells_option.get_selected_id())
	terrain_type = TERRAIN_KEYS[terrain_option.selected]
	start_game()

func start_game() -> void:
	game_started = true
	menu_panel.visible = false
	stats.visible = true
	level_info.visible = true
	tower_area.visible = true
	choice_bar.visible = true
	level_up_button.visible = true
	hint.visible = true
	reset_button.visible = true
	_reset_state()
	_build_surfaces()
	roll_choices()
	render_world()
	hint.text = "Выбери постройку, затем нажми подсвеченную ячейку на текущем уровне. Скролл: стрелки Up/Down."

func _reset_state() -> void:
	placed_blocks.clear()
	current_choices.clear()
	selected_building = {}
	selected_choice_index = -1
	unlocked_level = 1
	scroll_offset = 0.0
	turn = 0
	population = 0
	capacity = 0
	energy_produced = 0
	energy_required = 0
	beauty = 2
	technology = 0
	comfort = 1

func _build_surfaces() -> void:
	surfaces.clear()
	var count := 1
	match terrain_type:
		"river":
			count = 2
		"islands":
			count = rng.randi_range(3, 4)
		"mountains":
			count = rng.randi_range(2, 4)
		_:
			count = 1

	for index in range(count):
		var cells := cells_per_level
		var base_raise := 0
		if terrain_type == "islands":
			cells = clampi(rng.randi_range(1, cells_per_level), 1, 5)
		elif terrain_type == "mountains":
			cells = clampi(rng.randi_range(1, cells_per_level), 1, 5)
			base_raise = rng.randi_range(0, 2)
		surfaces.append({
			"id": index,
			"cells": cells,
			"base_raise": base_raise,
			"x": 0.0
		})

func _layout_surfaces() -> void:
	var view_width := max(tower_area.size.x, 920.0)
	var total_width := 0.0
	for surface in surfaces:
		total_width += float(surface["cells"]) * CELL_W
	if surfaces.size() > 1:
		total_width += float(surfaces.size() - 1) * SURFACE_GAP

	var cursor := view_width / 2.0 - total_width / 2.0
	for index in range(surfaces.size()):
		var surface := surfaces[index]
		surface["x"] = cursor
		surfaces[index] = surface
		cursor += float(surface["cells"]) * CELL_W + SURFACE_GAP

func _on_choice_pressed(index: int) -> void:
	if index < 0 or index >= current_choices.size():
		return
	selected_building = current_choices[index]
	selected_choice_index = index
	_refresh_choice_buttons()
	render_world()
	hint.text = "Выбрано: %s. Поставь на уровень %d." % [str(selected_building["title"]), unlocked_level]

func _on_slot_pressed(surface_index: int, cell_index: int) -> void:
	if selected_building.is_empty():
		hint.text = "Сначала выбери тип постройки внизу."
		return
	if _is_occupied(surface_index, unlocked_level, cell_index):
		return

	placed_blocks.append({
		"surface": surface_index,
		"cell": cell_index,
		"level": unlocked_level,
		"building": selected_building
	})
	turn += 1
	_apply_building_stats(selected_building)
	selected_building = {}
	selected_choice_index = -1
	roll_choices()
	render_world()
	hint.text = "Постройка размещена на уровне %d. Следи за Level Up." % unlocked_level

func _apply_building_stats(definition: Dictionary) -> void:
	capacity += int(definition["residents"])
	energy_produced += max(int(definition["energy"]), 0)
	energy_required += abs(min(int(definition["energy"]), 0))
	beauty += int(definition["beauty"])
	technology += int(definition["tech"])
	comfort += int(definition["comfort"])
	population = min(capacity, max(0, comfort * 2))

func _on_level_up_pressed() -> void:
	if not _can_level_up():
		var req := _level_up_requirements()
		hint.text = "Level Up нужен: beauty %d, tech %d, residents %d и хотя бы 1 блок на текущем уровне." % [req["beauty"], req["tech"], req["population"]]
		return
	unlocked_level += 1
	selected_building = {}
	selected_choice_index = -1
	scroll_offset = 99999.0
	render_world()
	hint.text = "Открыт уровень %d. Теперь можно ставить ячейки выше." % unlocked_level

func _can_level_up() -> bool:
	if _blocks_on_level(unlocked_level) <= 0:
		return false
	var req := _level_up_requirements()
	return beauty >= int(req["beauty"]) and technology >= int(req["tech"]) and population >= int(req["population"])

func _level_up_requirements() -> Dictionary:
	return {
		"beauty": unlocked_level * 2,
		"tech": max(0, unlocked_level - 1),
		"population": max(0, unlocked_level - 1)
	}

func _blocks_on_level(level: int) -> int:
	var count := 0
	for block in placed_blocks:
		if int(block["level"]) == level:
			count += 1
	return count

func roll_choices() -> void:
	current_choices.clear()
	var pool := _available_pool()
	pool.shuffle()
	for index in range(min(3, pool.size())):
		current_choices.append(pool[index])
	_refresh_choice_buttons()

func _available_pool() -> Array[Dictionary]:
	var pool: Array[Dictionary] = []
	for item in BUILDINGS:
		if _is_building_unlocked(item):
			pool.append(item)
	return pool

func _is_building_unlocked(item: Dictionary) -> bool:
	match str(item["id"]):
		"lab":
			return technology >= 3
		"university":
			return technology >= 5 and population >= 4
		"school":
			return population >= 2 or unlocked_level >= 2
		"shop":
			return population >= 2 or beauty >= 4
		_:
			return true

func _refresh_choice_buttons() -> void:
	for index in range(choice_buttons.size()):
		var button: Button = choice_buttons[index]
		if index < current_choices.size():
			var item := current_choices[index]
			button.disabled = false
			button.text = "%s\n%s\nEnergy %s  Beauty +%d  Tech +%d" % [
				str(item["glyph"]),
				str(item["title"]),
				_signed(int(item["energy"])),
				int(item["beauty"]),
				int(item["tech"])
			]
			button.modulate = Color(1.0, 1.0, 1.0, 1.0) if index != selected_choice_index else Color(1.0, 0.95, 0.55, 1.0)
		else:
			button.disabled = true
			button.text = "Нет варианта"

func render_world() -> void:
	_clear_tower()
	_layout_surfaces()
	_draw_level_guide()
	for surface_index in range(surfaces.size()):
		_draw_surface(surface_index)
	for block in placed_blocks:
		_draw_block(block)
	_draw_current_level_slots()
	_update_level_button()
	update_stats()
	_apply_scroll_limits()

func _clear_tower() -> void:
	for child in tower.get_children():
		child.queue_free()

func _draw_surface(surface_index: int) -> void:
	var surface := surfaces[surface_index]
	var cells := int(surface["cells"])
	var ground_width := float(cells) * CELL_W
	var y := _level_y(surface_index, 0) + CELL_H + 8.0
	_add_rect(Vector2(float(surface["x"]), y), Vector2(ground_width, 24.0), Color(0.25, 0.28, 0.30, 1.0))
	var label := _add_label(Vector2(float(surface["x"]), y + 28.0), Vector2(ground_width, 28.0), _surface_name(surface_index))
	label.modulate = Color(0.75, 0.78, 0.82, 1.0)

func _draw_level_guide() -> void:
	for surface_index in range(surfaces.size()):
		var surface := surfaces[surface_index]
		var y := _level_y(surface_index, unlocked_level) - 10.0
		_add_rect(Vector2(float(surface["x"]), y), Vector2(float(surface["cells"]) * CELL_W, 4.0), Color(0.95, 0.84, 0.32, 0.95))

func _draw_block(block: Dictionary) -> void:
	var building: Dictionary = block["building"]
	var surface_index := int(block["surface"])
	var cell := int(block["cell"])
	var level := int(block["level"])
	var pos := _slot_position(surface_index, level, cell)
	_add_rect(pos, Vector2(CELL_W - 8.0, CELL_H - 8.0), building["color"])
	var label := _add_label(pos, Vector2(CELL_W - 8.0, CELL_H - 8.0), "%s\n%s" % [str(building["glyph"]), str(building["title"])])
	label.modulate = Color(0.08, 0.09, 0.11, 1.0)

func _draw_current_level_slots() -> void:
	for surface_index in range(surfaces.size()):
		var cells := int(surfaces[surface_index]["cells"])
		for cell in range(cells):
			if _is_occupied(surface_index, unlocked_level, cell):
				continue
			var pos := _slot_position(surface_index, unlocked_level, cell)
			var button := Button.new()
			button.position = pos
			button.size = Vector2(CELL_W - 8.0, CELL_H - 8.0)
			button.text = "Level %d\nslot" % unlocked_level
			button.modulate = Color(0.95, 0.84, 0.32, 0.85) if selected_building.is_empty() else Color(0.55, 0.95, 0.62, 1.0)
			button.pressed.connect(_on_slot_pressed.bind(surface_index, cell))
			tower.add_child(button)

func _add_rect(pos: Vector2, size: Vector2, color: Color) -> ColorRect:
	var rect := ColorRect.new()
	rect.position = pos
	rect.size = size
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tower.add_child(rect)
	return rect

func _add_label(pos: Vector2, size: Vector2, text: String) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = size
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tower.add_child(label)
	return label

func _slot_position(surface_index: int, level: int, cell: int) -> Vector2:
	var surface := surfaces[surface_index]
	return Vector2(float(surface["x"]) + float(cell) * CELL_W + 4.0, _level_y(surface_index, level))

func _level_y(surface_index: int, level: int) -> float:
	var surface := surfaces[surface_index]
	var base_y := max(tower_area.size.y, 640.0) - BASE_Y_PAD - float(surface["base_raise"]) * LEVEL_H
	return base_y - float(level) * LEVEL_H

func _surface_name(surface_index: int) -> String:
	match terrain_type:
		"river":
			return "Берег %d" % (surface_index + 1)
		"islands":
			return "Остров %d" % (surface_index + 1)
		"mountains":
			return "Гора %d" % (surface_index + 1)
		_:
			return "Плато"

func _is_occupied(surface_index: int, level: int, cell: int) -> bool:
	for block in placed_blocks:
		if int(block["surface"]) == surface_index and int(block["level"]) == level and int(block["cell"]) == cell:
			return true
	return false

func _update_level_button() -> void:
	var ready := _can_level_up()
	var req := _level_up_requirements()
	level_up_button.disabled = not ready
	level_up_button.modulate = Color(0.55, 1.0, 0.52, 1.0) if ready else Color(0.55, 0.55, 0.55, 1.0)
	level_up_button.text = "LEVEL UP" if ready else "Level Up\nB%d T%d R%d" % [req["beauty"], req["tech"], req["population"]]

func update_stats() -> void:
	var energy_balance := energy_produced - energy_required
	var energy_state := "OK" if energy_balance >= 0 else "LOW"
	var req := _level_up_requirements()
	level_info.text = "Текущий уровень строительства: %d  |  Выбрано: %s" % [unlocked_level, _selected_title()]
	stats.text = "Terrain: %s\nCells/level: %d\nTurn: %d\nBlocks: %d\nResidents: %d/%d\nEnergy: %d/%d (%s)\nBeauty: %d\nTechnology: %d\nComfort: %d\n\nNext Level needs:\nBeauty %d\nTechnology %d\nResidents %d" % [
		_terrain_title(),
		cells_per_level,
		turn,
		placed_blocks.size(),
		population,
		capacity,
		energy_produced,
		energy_required,
		energy_state,
		beauty,
		technology,
		comfort,
		req["beauty"],
		req["tech"],
		req["population"]
	]

func _selected_title() -> String:
	if selected_building.is_empty():
		return "ничего"
	return str(selected_building["title"])

func _terrain_title() -> String:
	match terrain_type:
		"river":
			return "Река"
		"islands":
			return "Острова"
		"mountains":
			return "Горы"
		_:
			return "Плато"

func _scroll_by(delta: float) -> void:
	scroll_offset += delta
	_apply_scroll_limits()

func _apply_scroll_limits() -> void:
	var max_offset := _max_scroll_offset()
	scroll_offset = clamp(scroll_offset, 0.0, max_offset)
	tower.position = Vector2(0.0, scroll_offset)

func _max_scroll_offset() -> float:
	var top_y := _top_content_y()
	return max(0.0, TOP_SCROLL_PAD - top_y)

func _top_content_y() -> float:
	var top_y := 999999.0
	for surface_index in range(surfaces.size()):
		top_y = min(top_y, _level_y(surface_index, unlocked_level))
	for block in placed_blocks:
		top_y = min(top_y, _level_y(int(block["surface"]), int(block["level"])))
	return top_y

func _signed(value: int) -> String:
	if value > 0:
		return "+%d" % value
	return str(value)
