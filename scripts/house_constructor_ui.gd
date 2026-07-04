extends Node

const PANEL_W: float = 500.0
const PANEL_H: float = 720.0
const PAD: float = 18.0

var root: Control = null
var constructor_button: Button = null
var panel: Panel = null
var preview: Control = null
var summary_label: Label = null
var seed_box: SpinBox = null
var style_option: OptionButton = null
var footprint_option: OptionButton = null
var current_blueprint: Dictionary = {}

func _ready() -> void:
	process_priority = 1800
	call_deferred("_bind_scene")

func _process(_delta: float) -> void:
	if root == null:
		_bind_scene()
	if root == null:
		return
	_ensure_menu_button()
	_fit_constructor_button()
	_fit_panel()

func _bind_scene() -> void:
	root = get_tree().current_scene as Control

func _ensure_menu_button() -> void:
	if constructor_button != null and is_instance_valid(constructor_button):
		return
	var menu_panel: Control = root.get_node_or_null("MenuPanel") as Control
	if menu_panel == null:
		return
	constructor_button = Button.new()
	constructor_button.name = "ConstructorButton"
	constructor_button.text = "Конструктор"
	constructor_button.pressed.connect(_open_constructor)
	menu_panel.add_child(constructor_button)

func _fit_constructor_button() -> void:
	var menu_panel: Control = root.get_node_or_null("MenuPanel") as Control
	if menu_panel == null or constructor_button == null:
		return
	constructor_button.visible = menu_panel.visible
	constructor_button.size = Vector2(190.0, 46.0)
	constructor_button.position = Vector2((menu_panel.size.x - 190.0) / 2.0, menu_panel.size.y - 144.0)

func _open_constructor() -> void:
	var menu_panel: Control = root.get_node_or_null("MenuPanel") as Control
	if menu_panel != null:
		menu_panel.visible = false
	_ensure_panel()
	panel.visible = true
	_generate_blueprint()

func _close_constructor() -> void:
	if panel != null:
		panel.visible = false
	var menu_panel: Control = root.get_node_or_null("MenuPanel") as Control
	if menu_panel != null:
		menu_panel.visible = true

func _ensure_panel() -> void:
	if panel != null and is_instance_valid(panel):
		return
	panel = Panel.new()
	panel.name = "HouseConstructorPanel"
	panel.visible = false
	root.add_child(panel)

	var title: Label = _label("House Constructor", 24)
	title.name = "Title"
	panel.add_child(title)

	preview = Control.new()
	preview.name = "Preview"
	panel.add_child(preview)

	var param_title: Label = _label("Parameters", 16)
	param_title.name = "ParamTitle"
	panel.add_child(param_title)

	footprint_option = OptionButton.new()
	footprint_option.name = "FootprintOption"
	footprint_option.add_item("1x1")
	footprint_option.add_item("2x1")
	footprint_option.add_item("1x2")
	footprint_option.select(0)
	panel.add_child(footprint_option)

	style_option = OptionButton.new()
	style_option.name = "StyleOption"
	style_option.add_item("wood")
	style_option.add_item("brick")
	style_option.add_item("stone")
	style_option.select(0)
	panel.add_child(style_option)

	seed_box = SpinBox.new()
	seed_box.name = "SeedBox"
	seed_box.min_value = 0
	seed_box.max_value = 999999
	seed_box.value = randi() % 999999
	panel.add_child(seed_box)

	summary_label = _label("No blueprint", 14)
	summary_label.name = "Summary"
	panel.add_child(summary_label)

	var generate_button: Button = Button.new()
	generate_button.name = "GenerateButton"
	generate_button.text = "Generate"
	generate_button.pressed.connect(_generate_blueprint)
	panel.add_child(generate_button)

	var save_button: Button = Button.new()
	save_button.name = "SaveButton"
	save_button.text = "Save Variant"
	save_button.pressed.connect(_mark_saved)
	panel.add_child(save_button)

	var back_button: Button = Button.new()
	back_button.name = "BackButton"
	back_button.text = "Back"
	back_button.pressed.connect(_close_constructor)
	panel.add_child(back_button)

func _fit_panel() -> void:
	if panel == null or not panel.visible:
		return
	var root_size: Vector2 = root.size
	var w: float = min(PANEL_W, root_size.x - 32.0)
	var h: float = min(PANEL_H, root_size.y - 48.0)
	panel.size = Vector2(w, h)
	panel.position = Vector2((root_size.x - w) / 2.0, (root_size.y - h) / 2.0)
	_set_rect("Title", Vector2(PAD, 18.0), Vector2(w - PAD * 2.0, 34.0))
	_set_rect("Preview", Vector2(PAD, 70.0), Vector2(w - PAD * 2.0, 260.0))
	_set_rect("ParamTitle", Vector2(PAD, 348.0), Vector2(w - PAD * 2.0, 28.0))
	_set_rect("FootprintOption", Vector2(PAD, 392.0), Vector2(w - PAD * 2.0, 42.0))
	_set_rect("StyleOption", Vector2(PAD, 446.0), Vector2(w - PAD * 2.0, 42.0))
	_set_rect("SeedBox", Vector2(PAD, 500.0), Vector2(w - PAD * 2.0, 42.0))
	_set_rect("Summary", Vector2(PAD, 556.0), Vector2(w - PAD * 2.0, 54.0))
	var bw: float = (w - PAD * 2.0 - 18.0) / 3.0
	_set_rect("GenerateButton", Vector2(PAD, h - 64.0), Vector2(bw, 42.0))
	_set_rect("SaveButton", Vector2(PAD + bw + 9.0, h - 64.0), Vector2(bw, 42.0))
	_set_rect("BackButton", Vector2(PAD + (bw + 9.0) * 2.0, h - 64.0), Vector2(bw, 42.0))

func _generate_blueprint() -> void:
	if not Engine.has_singleton("HouseGenerator"):
		return
	var generator: Node = get_node("/root/HouseGenerator")
	var params: Dictionary = {
		"seed": int(seed_box.value) if seed_box != null else randi(),
		"footprint": footprint_option.get_item_text(footprint_option.selected) if footprint_option != null else "1x1",
		"style": style_option.get_item_text(style_option.selected) if style_option != null else "wood"
	}
	current_blueprint = generator.call("generate", params)
	if summary_label != null:
		summary_label.text = generator.call("blueprint_summary", current_blueprint)
	_draw_preview()

func _mark_saved() -> void:
	if summary_label != null:
		summary_label.text = "Saved draft: " + summary_label.text

func _draw_preview() -> void:
	if preview == null:
		return
	for child: Node in preview.get_children():
		child.queue_free()
	if current_blueprint.is_empty():
		return
	var cells: Array = current_blueprint["cells"]
	var cell: Dictionary = cells[0]
	var base_asset: Dictionary = cell["base"]
	var roof_asset: Dictionary = current_blueprint["roof"]
	var door_asset: Dictionary = cell["door"]
	var windows: Array = cell["windows"]
	var window_asset: Dictionary = windows[0]
	_add_rect(preview, Vector2(145.0, 92.0), Vector2(170.0, 120.0), base_asset["color"] as Color)
	_add_rect(preview, Vector2(130.0, 58.0), Vector2(200.0, 42.0), roof_asset["color"] as Color)
	_add_rect(preview, Vector2(180.0, 132.0), Vector2(42.0, 38.0), window_asset["color"] as Color)
	_add_rect(preview, Vector2(245.0, 142.0), Vector2(38.0, 70.0), door_asset["color"] as Color)
	var label: Label = _label(str(current_blueprint["footprint"]), 14)
	label.position = Vector2(0.0, 220.0)
	label.size = Vector2(preview.size.x, 26.0)
	preview.add_child(label)

func _label(text_value: String, font_size: int) -> Label:
	var label: Label = Label.new()
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _add_rect(parent: Control, pos: Vector2, rect_size: Vector2, color: Color) -> void:
	var rect: ColorRect = ColorRect.new()
	rect.position = pos
	rect.size = rect_size
	rect.color = color
	parent.add_child(rect)

func _set_rect(path: String, pos: Vector2, rect_size: Vector2) -> void:
	var control: Control = panel.get_node_or_null(path) as Control
	if control == null:
		return
	control.position = pos
	control.size = rect_size
