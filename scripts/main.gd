extends Control

const CELL_W: float = 108.0
const CELL_H: float = 58.0
const LEVEL_H: float = 74.0
const SURFACE_GAP: float = 84.0
const BASE_Y_PAD: float = 72.0
const TOP_UI_H: float = 112.0
const BOTTOM_UI_H: float = 176.0
const UI_PAD: float = 20.0
const MIN_TOWER_H: float = 180.0
const CAMERA_PAD: float = 64.0
const MIN_ZOOM: float = 0.55
const MAX_ZOOM: float = 1.65
const ZOOM_STEP: float = 0.1
const PAN_STEP: float = 96.0

const TERRAIN_KEYS: Array[String] = ["plateau", "river", "islands", "mountains"]
const SKY_COLORS: Array[Array] = [
	[Color(0.54, 0.76, 0.95, 1.0), Color(0.83, 0.91, 0.98, 1.0)],
	[Color(0.67, 0.78, 0.95, 1.0), Color(0.92, 0.93, 0.98, 1.0)],
	[Color(0.79, 0.73, 0.92, 1.0), Color(0.95, 0.90, 0.96, 1.0)],
	[Color(0.95, 0.78, 0.67, 1.0), Color(0.98, 0.90, 0.84, 1.0)],
	[Color(0.63, 0.82, 0.76, 1.0), Color(0.90, 0.96, 0.93, 1.0)]
]

const BUILDING_TYPES: Array[Dictionary] = [
	{"id":"housing", "title":"Жилище", "glyph":"H", "color":Color(0.74, 0.84, 0.76, 1.0), "residents":2, "energy":-1, "beauty":1, "tech":0, "comfort":0},
	{"id":"cafe", "title":"Кафе", "glyph":"C", "color":Color(0.88, 0.69, 0.62, 1.0), "residents":0, "energy":-1, "beauty":2, "tech":0, "comfort":3},
	{"id":"library", "title":"Библиотека", "glyph":"L", "color":Color(0.67, 0.77, 0.90, 1.0), "residents":0, "energy":-1, "beauty":1, "tech":2, "comfort":2},
	{"id":"workshop", "title":"Мастерская", "glyph":"M", "color":Color(0.76, 0.72, 0.66, 1.0), "residents":0, "energy":-2, "beauty":0, "tech":3, "comfort":0},
	{"id":"lab", "title":"Лаборатория", "glyph":"Lab", "color":Color(0.59, 0.88, 0.91, 1.0), "residents":0, "energy":-3, "beauty":1, "tech":5, "comfort":0},
	{"id":"university", "title":"Университет", "glyph":"U", "color":Color(0.55, 0.66, 0.92, 1.0), "residents":0, "energy":-3, "beauty":2, "tech":6, "comfort":2},
	{"id":"school", "title":"Школа", "glyph":"S", "color":Color(0.92, 0.81, 0.55, 1.0), "residents":0, "energy":-1, "beauty":1, "tech":2, "comfort":3},
	{"id":"shop", "title":"Лавка", "glyph":"Shop", "color":Color(0.84, 0.62, 0.46, 1.0), "residents":0, "energy":-1, "beauty":2, "tech":1, "comfort":2}
]

const SHAPES: Array[Dictionary] = [
	{"id":"1x1", "title":"1x1", "cells":[Vector2i(0, 0)]},
	{"id":"1x2", "title":"1 wide / 2 high", "cells":[Vector2i(0, 0), Vector2i(0, 1)]},
	{"id":"1x3", "title":"1 wide / 3 high", "cells":[Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2)]},
	{"id":"2x1", "title":"2 wide / 1 high", "cells":[Vector2i(0, 0), Vector2i(1, 0)]},
	{"id":"2x2", "title":"2x2", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]},
	{"id":"2x3", "title":"2 wide / 3 high", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]},
	{"id":"3x1", "title":"3 wide / 1 high", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)]},
	{"id":"3x2", "title":"3 wide / 2 high", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]},
	{"id":"3x3", "title":"3x3", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2)]},
	{"id":"L2_left", "title":"L 2x2 left", "cells":[Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0)]},
	{"id":"L2_right", "title":"L 2x2 right", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1)]},
	{"id":"L3_tall_left", "title":"Tall L left", "cells":[Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, 0)]},
	{"id":"L3_tall_right", "title":"Tall L right", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]},
	{"id":"L3_flat_left", "title":"Flat L left", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1)]},
	{"id":"L3_flat_right", "title":"Flat L right", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(2, 1)]},
	{"id":"corner_3_left", "title":"3x3 corner left", "cells":[Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, 0), Vector2i(2, 0)]},
	{"id":"corner_3_right", "title":"3x3 corner right", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2)]},
	{"id":"T3", "title":"T shape", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1)]},
	{"id":"T3_tall", "title":"Tall T shape", "cells":[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]},
	{"id":"U3", "title":"U shape", "cells":[Vector2i(0, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]}
]

@onready var title_label: Label = $Title
@onready var background_rect: ColorRect = $Background
@onready var menu_panel: Control = $MenuPanel
@onready var cells_option: OptionButton = $MenuPanel/CellsOption
@onready var terrain_option: OptionButton = $MenuPanel/TerrainOption
@onready var start_button: Button = $MenuPanel/StartButton
@onready var tower_area: Control = $TowerArea
@onready var tower: Control = $TowerArea/Tower
@onready var stats: Label = $Stats
@onready var level_info: Label = $LevelInfo
@onready var choice_bar: HBoxContainer = $ChoiceBar
@onready var choice_buttons: Array[Button] = [$ChoiceBar/Choice1 as Button, $ChoiceBar/Choice2 as Button, $ChoiceBar/Choice3 as Button]
@onready var level_up_button: Button = $LevelUpButton
@onready var hint: Label = $Hint
@onready var reset_button: Button = $ResetButton

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var game_started: bool = false
var cells_per_level: int = 3
var terrain_type: String = "plateau"
var surfaces: Array[Dictionary] = []
var placed_blocks: Array[Dictionary] = []
var current_choices: Array[Dictionary] = []
var selected_building: Dictionary = {}
var selected_choice_index: int = -1
var unlocked_level: int = 1
var camera_pan: Vector2 = Vector2.ZERO
var camera_zoom: float = 1.0
var turn: int = 0
var population: int = 0
var capacity: int = 0
var energy_produced: int = 0
var energy_required: int = 0
var beauty: int = 0
var technology: int = 0
var comfort: int = 0

func _ready() -> void:
	rng.randomize()
	_setup_menu_options()
	for index: int in range(choice_buttons.size()):
		choice_buttons[index].pressed.connect(_on_choice_pressed.bind(index))
	start_button.pressed.connect(_on_start_pressed)
	reset_button.pressed.connect(show_menu)
	level_up_button.pressed.connect(_on_level_up_pressed)
	_fit_fixed_layout()
	show_menu()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and is_node_ready():
		_fit_fixed_layout()
		if game_started:
			render_world()
			_focus_active_level()

func _fit_fixed_layout() -> void:
	var root_size: Vector2 = self.size
	if root_size.x < 1.0 or root_size.y < 1.0:
		return
	var bottom_y: float = root_size.y - BOTTOM_UI_H
	var tower_h: float = root_size.y - TOP_UI_H - BOTTOM_UI_H
	if tower_h < MIN_TOWER_H:
		tower_h = MIN_TOWER_H

	title_label.position = Vector2(0.0, 10.0)
	title_label.size = Vector2(root_size.x, 32.0)
	level_info.position = Vector2(UI_PAD, 46.0)
	level_info.size = Vector2(root_size.x - 400.0, 58.0)
	if level_info.size.x < 260.0:
		level_info.size = Vector2(root_size.x - UI_PAD * 2.0, 44.0)
	stats.position = Vector2(root_size.x - 360.0, 46.0)
	stats.size = Vector2(340.0, 92.0)
	stats.visible = game_started and root_size.x >= 720.0

	tower_area.position = Vector2(UI_PAD, TOP_UI_H)
	tower_area.size = Vector2(root_size.x - UI_PAD * 2.0, tower_h)
	choice_bar.position = Vector2(UI_PAD, bottom_y + 12.0)
	choice_bar.size = Vector2(root_size.x - UI_PAD * 2.0, 92.0)
	for button_index: int in range(choice_buttons.size()):
		choice_buttons[button_index].custom_minimum_size = Vector2(0.0, 90.0)
	level_up_button.position = Vector2(UI_PAD, root_size.y - 56.0)
	level_up_button.size = Vector2(190.0, 42.0)
	reset_button.position = Vector2(root_size.x - 186.0, root_size.y - 56.0)
	reset_button.size = Vector2(166.0, 42.0)
	hint.position = Vector2(226.0, root_size.y - 56.0)
	hint.size = Vector2(root_size.x - 432.0, 42.0)
	hint.visible = game_started and hint.size.x >= 120.0

	var menu_w: float = 620.0
	var menu_h: float = 500.0
	if root_size.x < menu_w + 40.0:
		menu_w = root_size.x - 40.0
	if root_size.y < menu_h + 40.0:
		menu_h = root_size.y - 40.0
	if menu_w < 320.0:
		menu_w = 320.0
	if menu_h < 360.0:
		menu_h = 360.0
	menu_panel.size = Vector2(menu_w, menu_h)
	menu_panel.position = Vector2((root_size.x - menu_w) / 2.0, (root_size.y - menu_h) / 2.0)

func _unhandled_input(event: InputEvent) -> void:
	if not game_started:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_UP:
			_pan_camera(Vector2(0.0, PAN_STEP))
		elif event.keycode == KEY_DOWN:
			_pan_camera(Vector2(0.0, -PAN_STEP))
		elif event.keycode == KEY_LEFT:
			_pan_camera(Vector2(PAN_STEP, 0.0))
		elif event.keycode == KEY_RIGHT:
			_pan_camera(Vector2(-PAN_STEP, 0.0))
		elif event.keycode == KEY_EQUAL or event.keycode == KEY_KP_ADD:
			_zoom_camera(ZOOM_STEP)
		elif event.keycode == KEY_MINUS or event.keycode == KEY_KP_SUBTRACT:
			_zoom_camera(-ZOOM_STEP)

func _setup_menu_options() -> void:
	cells_option.clear()
	for value: int in range(1, 6):
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
	_fit_fixed_layout()

func _on_start_pressed() -> void:
	var selected_cells: int = cells_option.get_selected_id()
	if selected_cells < 1:
		selected_cells = 1
	cells_per_level = selected_cells
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
	hint.visible = false
	reset_button.visible = true
	_fit_fixed_layout()
	_reset_state()
	_apply_run_background()
	_build_surfaces()
	roll_choices()
	render_world()
	_focus_active_level()
	hint.text = "Выбери постройку. Карточки уже отфильтрованы под свободные клетки."

func _reset_state() -> void:
	placed_blocks.clear()
	current_choices.clear()
	selected_building = {}
	selected_choice_index = -1
	unlocked_level = 1
	camera_pan = Vector2.ZERO
	camera_zoom = 1.0
	turn = 0
	population = 0
	capacity = 0
	energy_produced = 0
	energy_required = 0
	beauty = 2
	technology = 0
	comfort = 1

func _apply_run_background() -> void:
	if background_rect == null:
		return
	var color_index: int = rng.randi_range(0, SKY_COLORS.size() - 1)
	var colors: Array = SKY_COLORS[color_index]
	var top_color: Color = colors[0]
	var bottom_color: Color = colors[1]

	var gradient := Gradient.new()
	gradient.colors = PackedColorArray([top_color, bottom_color])
	gradient.offsets = PackedFloat32Array([0.0, 1.0])

	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill = GradientTexture2D.FILL_LINEAR
	texture.fill_from = Vector2(0.5, 0.0)
	texture.fill_to = Vector2(0.5, 1.0)
	texture.width = 32
	texture.height = 512

	var sky: TextureRect = get_node_or_null("SkyGradient")
	if sky == null:
		sky = TextureRect.new()
		sky.name = "SkyGradient"
		sky.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sky.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		sky.stretch_mode = TextureRect.STRETCH_SCALE
		add_child(sky)
		move_child(sky, 0)

	sky.position = Vector2.ZERO
	sky.size = size
	sky.texture = texture
	background_rect.color = Color(1, 1, 1, 0)

func _build_surfaces() -> void:
	surfaces.clear()
	var count: int = 1
	match terrain_type:
		"river": count = 2
		"islands": count = rng.randi_range(3, 4)
		"mountains": count = rng.randi_range(2, 4)
		_: count = 1
	for index: int in range(count):
		var cells: int = cells_per_level
		var base_raise: int = 0
		if terrain_type == "islands":
			cells = rng.randi_range(1, cells_per_level)
		elif terrain_type == "mountains":
			cells = rng.randi_range(1, cells_per_level)
			base_raise = rng.randi_range(0, 2)
		if cells < 1:
			cells = 1
		if cells > 5:
			cells = 5
		surfaces.append({"id": index, "cells": cells, "base_raise": base_raise, "x": 0.0})

func _layout_surfaces() -> void:
	var view_width: float = float(tower_area.size.x)
	if view_width < 920.0:
		view_width = 920.0
	var total_width: float = 0.0
	for surface_index: int in range(surfaces.size()):
		var surface: Dictionary = surfaces[surface_index]
		total_width += float(surface["cells"]) * CELL_W
	if surfaces.size() > 1:
		total_width += float(surfaces.size() - 1) * SURFACE_GAP
	var cursor: float = view_width / 2.0 - total_width / 2.0
	for index: int in range(surfaces.size()):
		var surface_to_layout: Dictionary = surfaces[index]
		surface_to_layout["x"] = cursor
		surfaces[index] = surface_to_layout
		cursor += float(surface_to_layout["cells"]) * CELL_W + SURFACE_GAP

func _on_choice_pressed(index: int) -> void:
	if index < 0 or index >= current_choices.size():
		return
	selected_building = current_choices[index]
	selected_choice_index = index
	_refresh_choice_buttons()
	render_world()
	hint.text = "Выбрано: %s, форма %s. Поставь на зелёную ячейку уровня %d." % [str(selected_building["title"]), str(selected_building["shape_title"]), unlocked_level]

func _on_slot_pressed(surface_index: int, cell_index: int) -> void:
	if selected_building.is_empty():
		hint.text = "Сначала выбери тип постройки внизу."
		return
	if not _can_place(selected_building, surface_index, unlocked_level, cell_index):
		hint.text = "Эта форма здесь не помещается. Выбери зелёную ячейку."
		return
	placed_blocks.append({"surface": surface_index, "cell": cell_index, "level": unlocked_level, "building": selected_building})
	turn += 1
	_apply_building_stats(selected_building)
	selected_building = {}
	selected_choice_index = -1
	roll_choices()
	render_world()
	_focus_active_level()
	hint.text = "Постройка размещена. Камера сфокусирована на активной высоте."

func _apply_building_stats(definition: Dictionary) -> void:
	var footprint: Array = definition["footprint"]
	var area: int = footprint.size()
	var energy_delta: int = int(definition["energy"])
	capacity += int(definition["residents"])
	if energy_delta > 0:
		energy_produced += energy_delta
	elif energy_delta < 0:
		energy_required += -energy_delta
	beauty += int(definition["beauty"])
	technology += int(definition["tech"])
	comfort += int(definition["comfort"])
	if area >= 4:
		beauty += 1
		comfort += 1
	var comfort_population_limit: int = comfort * 2
	population = capacity
	if population > comfort_population_limit:
		population = comfort_population_limit
	if population < 0:
		population = 0

func _on_level_up_pressed() -> void:
	if not _can_level_up():
		var req: Dictionary = _level_up_requirements()
		hint.text = "Level Up нужен: beauty %d, tech %d, residents %d и занятость текущего уровня." % [req["beauty"], req["tech"], req["population"]]
		return
	unlocked_level += 1
	selected_building = {}
	selected_choice_index = -1
	roll_choices()
	render_world()
	_focus_active_level()
	hint.text = "Открыт уровень %d. Камера поднята к новому уровню." % unlocked_level

func _can_level_up() -> bool:
	if _occupied_cells_on_level(unlocked_level) <= 0:
		return false
	var req: Dictionary = _level_up_requirements()
	return beauty >= int(req["beauty"]) and technology >= int(req["tech"]) and population >= int(req["population"])

func _level_up_requirements() -> Dictionary:
	var required_tech: int = unlocked_level - 1
	if required_tech < 0:
		required_tech = 0
	var required_population: int = unlocked_level - 1
	if required_population < 0:
		required_population = 0
	return {"beauty": unlocked_level * 2, "tech": required_tech, "population": required_population}

func _occupied_cells_on_level(level: int) -> int:
	var count: int = 0
	for block_index: int in range(placed_blocks.size()):
		var block: Dictionary = placed_blocks[block_index]
		var footprint: Array = block["building"]["footprint"]
		for footprint_index: int in range(footprint.size()):
			var rel: Vector2i = footprint[footprint_index] as Vector2i
			if int(block["level"]) + rel.y == level:
				count += 1
	return count

func roll_choices() -> void:
	current_choices.clear()
	var candidates: Array[Dictionary] = _available_choices()
	candidates.shuffle()
	var choice_count: int = candidates.size()
	if choice_count > 3:
		choice_count = 3
	for index: int in range(choice_count):
		current_choices.append(candidates[index])
	_refresh_choice_buttons()

func _available_choices() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for building_index: int in range(BUILDING_TYPES.size()):
		var building_type: Dictionary = BUILDING_TYPES[building_index]
		if not _is_building_type_unlocked(building_type):
			continue
		for shape_index: int in range(SHAPES.size()):
			var shape: Dictionary = SHAPES[shape_index]
			var choice: Dictionary = _make_choice(building_type, shape)
			if _has_valid_anchor(choice):
				result.append(choice)
	return result

func _make_choice(building_type: Dictionary, shape: Dictionary) -> Dictionary:
	var footprint: Array[Vector2i] = []
	var raw_cells: Array = shape["cells"]
	for index: int in range(raw_cells.size()):
		footprint.append(raw_cells[index] as Vector2i)
	return {
		"id": str(building_type["id"]), "title": str(building_type["title"]), "glyph": str(building_type["glyph"]),
		"color": building_type["color"] as Color, "residents": int(building_type["residents"]), "energy": int(building_type["energy"]),
		"beauty": int(building_type["beauty"]), "tech": int(building_type["tech"]), "comfort": int(building_type["comfort"]),
		"shape_id": str(shape["id"]), "shape_title": str(shape["title"]), "footprint": footprint,
		"shape_w": _footprint_width(footprint), "shape_h": _footprint_height(footprint)
	}

func _is_building_type_unlocked(item: Dictionary) -> bool:
	match str(item["id"]):
		"lab": return technology >= 3
		"university": return technology >= 5 and population >= 4
		"school": return population >= 2 or unlocked_level >= 2
		"shop": return population >= 2 or beauty >= 4
		_: return true

func _has_valid_anchor(choice: Dictionary) -> bool:
	for surface_index: int in range(surfaces.size()):
		var surface: Dictionary = surfaces[surface_index]
		var cells: int = int(surface["cells"])
		for cell: int in range(cells):
			if _can_place(choice, surface_index, unlocked_level, cell):
				return true
	return false

func _can_place(choice: Dictionary, surface_index: int, level: int, cell: int) -> bool:
	var surface: Dictionary = surfaces[surface_index]
	var surface_cells: int = int(surface["cells"])
	var footprint: Array = choice["footprint"]
	for index: int in range(footprint.size()):
		var rel: Vector2i = footprint[index] as Vector2i
		var target_cell: int = cell + rel.x
		var target_level: int = level + rel.y
		if target_cell < 0 or target_cell >= surface_cells:
			return false
		if _is_cell_occupied(surface_index, target_level, target_cell):
			return false
	return true

func _is_cell_occupied(surface_index: int, level: int, cell: int) -> bool:
	for block_index: int in range(placed_blocks.size()):
		var block: Dictionary = placed_blocks[block_index]
		if int(block["surface"]) != surface_index:
			continue
		var footprint: Array = block["building"]["footprint"]
		for footprint_index: int in range(footprint.size()):
			var rel: Vector2i = footprint[footprint_index] as Vector2i
			var occupied_cell: int = int(block["cell"]) + rel.x
			var occupied_level: int = int(block["level"]) + rel.y
			if occupied_cell == cell and occupied_level == level:
				return true
	return false

func _footprint_width(footprint: Array) -> int:
	var max_x: int = 0
	for index: int in range(footprint.size()):
		var rel: Vector2i = footprint[index] as Vector2i
		if rel.x > max_x:
			max_x = rel.x
	return max_x + 1

func _footprint_height(footprint: Array) -> int:
	var max_y: int = 0
	for index: int in range(footprint.size()):
		var rel: Vector2i = footprint[index] as Vector2i
		if rel.y > max_y:
			max_y = rel.y
	return max_y + 1

func _refresh_choice_buttons() -> void:
	for index: int in range(choice_buttons.size()):
		var button: Button = choice_buttons[index]
		if index < current_choices.size():
			var item: Dictionary = current_choices[index]
			button.disabled = false
			button.text = "%s\n%s %dx%d\n%s" % [str(item["glyph"]), str(item["title"]), int(item["shape_w"]), int(item["shape_h"]), str(item["shape_title"])]
			button.modulate = Color(1.0, 0.95, 0.55, 1.0) if index == selected_choice_index else Color(1.0, 1.0, 1.0, 1.0)
		else:
			button.disabled = true
			button.text = "Нет подходящего\nдомика"
			button.modulate = Color(0.55, 0.55, 0.55, 1.0)

func render_world() -> void:
	_clear_tower()
	_layout_surfaces()
	_draw_level_guide()
	for surface_index: int in range(surfaces.size()):
		_draw_surface(surface_index)
	for block_index: int in range(placed_blocks.size()):
		_draw_block(placed_blocks[block_index])
	_draw_current_level_slots()
	_update_level_button()
	update_stats()
	_apply_camera_bounds()

func _clear_tower() -> void:
	for child: Node in tower.get_children():
		child.queue_free()

func _draw_surface(surface_index: int) -> void:
	var surface: Dictionary = surfaces[surface_index]
	var cells: int = int(surface["cells"])
	var ground_width: float = float(cells) * CELL_W
	var x: float = float(surface["x"])
	var floor_bottom: float = _level_y(surface_index, 0) + CELL_H

	# Soft distant hills behind the ground.
	_add_rect(Vector2(x - 18.0, floor_bottom + 2.0), Vector2(ground_width + 36.0, 10.0), Color(0.52, 0.63, 0.72, 0.55))
	_add_rect(Vector2(x - 8.0, floor_bottom + 8.0), Vector2(ground_width + 16.0, 12.0), Color(0.42, 0.52, 0.60, 0.45))

	# Grass and soil directly under the first floor.
	_add_rect(Vector2(x, floor_bottom), Vector2(ground_width, 8.0), Color(0.32, 0.72, 0.30, 1.0))
	_add_rect(Vector2(x, floor_bottom + 8.0), Vector2(ground_width, 28.0), Color(0.34, 0.30, 0.26, 1.0))

func _draw_level_guide() -> void:
	for surface_index: int in range(surfaces.size()):
		var surface: Dictionary = surfaces[surface_index]
		var y: float = _level_y(surface_index, unlocked_level) - 10.0
		_add_rect(Vector2(float(surface["x"]), y), Vector2(float(surface["cells"]) * CELL_W, 4.0), Color(0.95, 0.84, 0.32, 0.95))

func _draw_block(block: Dictionary) -> void:
	var building: Dictionary = block["building"]
	var surface_index: int = int(block["surface"])
	var anchor_cell: int = int(block["cell"])
	var anchor_level: int = int(block["level"])
	var footprint: Array = building["footprint"]
	for index: int in range(footprint.size()):
		var rel: Vector2i = footprint[index] as Vector2i
		var pos: Vector2 = _slot_position(surface_index, anchor_level + rel.y, anchor_cell + rel.x)
		_add_rect(pos, Vector2(CELL_W, CELL_H), building["color"] as Color)
		var cell_text: String = str(building["glyph"])
		if index == 0:
			cell_text = "%s\n%s" % [str(building["glyph"]), str(building["shape_title"])]
		var label: Label = _add_label(pos, Vector2(CELL_W, CELL_H), cell_text)
		label.modulate = Color(0.08, 0.09, 0.11, 1.0)

func _draw_current_level_slots() -> void:
	for surface_index: int in range(surfaces.size()):
		var cells: int = int(surfaces[surface_index]["cells"])
		for cell: int in range(cells):
			if _is_cell_occupied(surface_index, unlocked_level, cell):
				continue
			var should_draw: bool = selected_building.is_empty()
			if not selected_building.is_empty():
				should_draw = _can_place(selected_building, surface_index, unlocked_level, cell)
			if not should_draw:
				continue
			var pos: Vector2 = _slot_position(surface_index, unlocked_level, cell)
			var slot_button: Button = Button.new()
			slot_button.position = pos
			slot_button.size = Vector2(CELL_W, CELL_H)
			slot_button.text = "L%d\nslot" % unlocked_level
			slot_button.modulate = Color(0.95, 0.84, 0.32, 0.85) if selected_building.is_empty() else Color(0.55, 0.95, 0.62, 1.0)
			slot_button.pressed.connect(_on_slot_pressed.bind(surface_index, cell))
			tower.add_child(slot_button)

func _add_rect(pos: Vector2, rect_size: Vector2, fill_color: Color) -> ColorRect:
	var rect: ColorRect = ColorRect.new()
	rect.position = pos
	rect.size = rect_size
	rect.color = fill_color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tower.add_child(rect)
	return rect

func _add_label(pos: Vector2, label_size: Vector2, label_text: String) -> Label:
	var label: Label = Label.new()
	label.position = pos
	label.size = label_size
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tower.add_child(label)
	return label

func _slot_position(surface_index: int, level: int, cell: int) -> Vector2:
	var surface: Dictionary = surfaces[surface_index]
	return Vector2(float(surface["x"]) + float(cell) * CELL_W + 4.0, _level_y(surface_index, level))

func _level_y(surface_index: int, level: int) -> float:
	var surface: Dictionary = surfaces[surface_index]
	var area_height: float = float(tower_area.size.y)
	if area_height < 640.0:
		area_height = 640.0
	var base_y: float = area_height - BASE_Y_PAD - float(surface["base_raise"]) * LEVEL_H
	return base_y - float(level) * LEVEL_H

func _surface_name(surface_index: int) -> String:
	match terrain_type:
		"river": return "Берег %d" % (surface_index + 1)
		"islands": return "Остров %d" % (surface_index + 1)
		"mountains": return "Гора %d" % (surface_index + 1)
		_: return "Плато"

func _update_level_button() -> void:
	var is_level_ready: bool = _can_level_up()
	level_up_button.disabled = not is_level_ready
	if is_level_ready:
		level_up_button.modulate = Color(0.55, 1.0, 0.52, 1.0)
	else:
		level_up_button.modulate = Color(0.55, 0.55, 0.55, 1.0)
	level_up_button.text = "Level Up"

func update_stats() -> void:
	var energy_balance: int = energy_produced - energy_required
	var energy_state: String = "LOW"
	if energy_balance >= 0:
		energy_state = "OK"
	var free_cells: int = _free_cells_on_level(unlocked_level)
	level_info.text = "Уровень: %d | Свободно: %d" % [unlocked_level, free_cells]
	stats.text = "Cells: %d\nTurn: %d\nBlocks: %d\nResidents: %d/%d\nEnergy: %d/%d (%s)\nBeauty: %d Tech: %d Comfort: %d" % [cells_per_level, turn, placed_blocks.size(), population, capacity, energy_produced, energy_required, energy_state, beauty, technology, comfort]

func _free_cells_on_level(level: int) -> int:
	var count: int = 0
	for surface_index: int in range(surfaces.size()):
		var cells: int = int(surfaces[surface_index]["cells"])
		for cell: int in range(cells):
			if not _is_cell_occupied(surface_index, level, cell):
				count += 1
	return count

func _selected_title() -> String:
	if selected_building.is_empty():
		return "ничего"
	return "%s %dx%d" % [str(selected_building["title"]), int(selected_building["shape_w"]), int(selected_building["shape_h"])]

func _terrain_title() -> String:
	match terrain_type:
		"river": return "Река"
		"islands": return "Острова"
		"mountains": return "Горы"
		_: return "Плато"

func _pan_camera(delta: Vector2) -> void:
	camera_pan += delta
	_apply_camera_bounds()

func _zoom_camera(delta: float) -> void:
	var old_zoom: float = camera_zoom
	camera_zoom += delta
	if camera_zoom < MIN_ZOOM:
		camera_zoom = MIN_ZOOM
	if camera_zoom > MAX_ZOOM:
		camera_zoom = MAX_ZOOM
	var center: Vector2 = tower_area.size / 2.0
	var world_center: Vector2 = (center - camera_pan) / old_zoom
	camera_pan = center - world_center * camera_zoom
	_apply_camera_bounds()

func _focus_active_level() -> void:
	var bounds: Rect2 = _content_bounds()
	var active_y: float = _active_level_y()
	var target_y: float = tower_area.size.y * 0.84
	camera_pan.y = target_y - active_y * camera_zoom
	camera_pan.x = tower_area.size.x / 2.0 - bounds.get_center().x * camera_zoom
	_apply_camera_bounds()

func _apply_camera_bounds() -> void:
	var bounds: Rect2 = _content_bounds()
	var view_size: Vector2 = tower_area.size
	var scaled_w: float = bounds.size.x * camera_zoom
	var scaled_h: float = bounds.size.y * camera_zoom

	if scaled_w <= view_size.x - CAMERA_PAD * 2.0:
		camera_pan.x = view_size.x / 2.0 - bounds.get_center().x * camera_zoom
	else:
		var min_x: float = view_size.x - CAMERA_PAD - (bounds.position.x + bounds.size.x) * camera_zoom
		var max_x: float = CAMERA_PAD - bounds.position.x * camera_zoom
		if camera_pan.x < min_x:
			camera_pan.x = min_x
		if camera_pan.x > max_x:
			camera_pan.x = max_x

	if scaled_h <= view_size.y - CAMERA_PAD * 2.0:
		camera_pan.y = view_size.y / 2.0 - bounds.get_center().y * camera_zoom
	else:
		var min_y: float = view_size.y - CAMERA_PAD - (bounds.position.y + bounds.size.y) * camera_zoom
		var max_y: float = CAMERA_PAD - bounds.position.y * camera_zoom
		if camera_pan.y < min_y:
			camera_pan.y = min_y
		if camera_pan.y > max_y:
			camera_pan.y = max_y

	tower.scale = Vector2(camera_zoom, camera_zoom)
	tower.position = camera_pan

func _content_bounds() -> Rect2:
	if surfaces.is_empty():
		return Rect2(Vector2.ZERO, tower_area.size)
	var min_x: float = 999999.0
	var min_y: float = 999999.0
	var max_x: float = -999999.0
	var max_y: float = -999999.0
	for surface_index: int in range(surfaces.size()):
		var surface: Dictionary = surfaces[surface_index]
		var sx: float = float(surface["x"])
		var sy: float = _level_y(surface_index, 0)
		min_x = min(min_x, sx)
		max_x = max(max_x, sx + float(surface["cells"]) * CELL_W)
		min_y = min(min_y, _level_y(surface_index, unlocked_level))
		max_y = max(max_y, sy + CELL_H + 64.0)
	for block_index: int in range(placed_blocks.size()):
		var block: Dictionary = placed_blocks[block_index]
		var footprint: Array = block["building"]["footprint"]
		for footprint_index: int in range(footprint.size()):
			var rel: Vector2i = footprint[footprint_index] as Vector2i
			var pos: Vector2 = _slot_position(int(block["surface"]), int(block["level"]) + rel.y, int(block["cell"]) + rel.x)
			min_x = min(min_x, pos.x)
			min_y = min(min_y, pos.y)
			max_x = max(max_x, pos.x + CELL_W)
			max_y = max(max_y, pos.y + CELL_H)
	min_x -= CAMERA_PAD
	min_y -= CAMERA_PAD
	max_x += CAMERA_PAD
	max_y += CAMERA_PAD
	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))

func _active_level_y() -> float:
	var result: float = 999999.0
	for surface_index: int in range(surfaces.size()):
		var y: float = _level_y(surface_index, unlocked_level)
		if y < result:
			result = y
	return result
