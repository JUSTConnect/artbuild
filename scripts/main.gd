extends Control

const BUILDINGS := [
	{
		"id": "home",
		"title": "Small Home",
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
		"title": "Roof Cafe",
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
		"title": "Library",
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
		"title": "Workshop",
		"glyph": "T",
		"color": Color(0.76, 0.72, 0.66, 1.0),
		"residents": 0,
		"energy": -2,
		"beauty": 0,
		"tech": 3,
		"comfort": 0
	},
	{
		"id": "studio",
		"title": "Art Studio",
		"glyph": "A",
		"color": Color(0.88, 0.75, 0.92, 1.0),
		"residents": 0,
		"energy": -1,
		"beauty": 4,
		"tech": 0,
		"comfort": 1
	},
	{
		"id": "windmill",
		"title": "Windmill",
		"glyph": "W",
		"color": Color(0.91, 0.86, 0.55, 1.0),
		"residents": 0,
		"energy": 3,
		"beauty": 0,
		"tech": 1,
		"comfort": 0
	},
	{
		"id": "garden",
		"title": "Roof Garden",
		"glyph": "G",
		"color": Color(0.49, 0.75, 0.50, 1.0),
		"residents": 0,
		"energy": 0,
		"beauty": 3,
		"tech": 0,
		"comfort": 2
	},
	{
		"id": "bridge",
		"title": "Bridge",
		"glyph": "B",
		"color": Color(0.69, 0.55, 0.42, 1.0),
		"residents": 0,
		"energy": 0,
		"beauty": 1,
		"tech": 1,
		"comfort": 1
	}
]

@onready var tower: Control = $TowerArea/Tower
@onready var stats: Label = $Stats
@onready var choice_buttons: Array[Button] = [$ChoiceBar/Choice1, $ChoiceBar/Choice2, $ChoiceBar/Choice3]
@onready var hint: Label = $Hint
@onready var reset_button: Button = $ResetButton

var placed_blocks: Array[Dictionary] = []
var current_choices: Array[Dictionary] = []
var turn := 0
var population := 0
var capacity := 0
var energy_produced := 0
var energy_required := 0
var beauty := 0
var technology := 0
var comfort := 0
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	for index in range(choice_buttons.size()):
		choice_buttons[index].pressed.connect(_on_choice_pressed.bind(index))
	reset_button.pressed.connect(reset_game)
	reset_game()

func reset_game() -> void:
	for child in tower.get_children():
		child.queue_free()
	placed_blocks.clear()
	turn = 0
	population = 0
	capacity = 0
	energy_produced = 0
	energy_required = 0
	beauty = 2
	technology = 0
	comfort = 1
	_add_visual_block({
		"title": "Island Foundation",
		"glyph": "___",
		"color": Color(0.43, 0.55, 0.65, 1.0)
	}, 0)
	roll_choices()
	update_stats()
	hint.text = "Build a calm living tower. Choose one card below."

func _on_choice_pressed(index: int) -> void:
	if index < 0 or index >= current_choices.size():
		return
	build(current_choices[index])

func build(definition: Dictionary) -> void:
	turn += 1
	placed_blocks.append(definition)
	capacity += int(definition["residents"])
	energy_produced += max(int(definition["energy"]), 0)
	energy_required += abs(min(int(definition["energy"]), 0))
	beauty += int(definition["beauty"])
	technology += int(definition["tech"])
	comfort += int(definition["comfort"])
	population = min(capacity, max(0, comfort * 2))
	_add_visual_block(definition, placed_blocks.size())
	roll_choices()
	update_stats()
	hint.text = "Built: %s. Pick the next piece." % str(definition["title"])

func roll_choices() -> void:
	current_choices.clear()
	var pool := _available_pool()
	pool.shuffle()
	for index in range(min(3, pool.size())):
		current_choices.append(pool[index])
	for index in range(choice_buttons.size()):
		if index < current_choices.size():
			var item := current_choices[index]
			choice_buttons[index].disabled = false
			choice_buttons[index].text = "%s\n%s\nEnergy %s  Beauty +%d  Tech +%d" % [
				str(item["glyph"]),
				str(item["title"]),
				_signed(int(item["energy"])),
				int(item["beauty"]),
				int(item["tech"])
			]
		else:
			choice_buttons[index].disabled = true
			choice_buttons[index].text = "No choice"

func _available_pool() -> Array[Dictionary]:
	var pool: Array[Dictionary] = []
	for item in BUILDINGS:
		if _is_unlocked(item):
			pool.append(item)
	return pool

func _is_unlocked(item: Dictionary) -> bool:
	match str(item["id"]):
		"workshop":
			return technology >= 2
		"studio":
			return beauty >= 5
		"garden":
			return beauty >= 6 and population >= 2
		"bridge":
			return technology >= 2
		_:
			return true

func _add_visual_block(definition: Dictionary, index: int) -> void:
	var block := ColorRect.new()
	var width := 180.0 + float(rng.randi_range(-28, 34))
	if str(definition["glyph"]) == "___":
		width = 300.0
	var height := 54.0
	var x_offset := float(rng.randi_range(-72, 72))
	if index == 0:
		x_offset = 0.0
	var y := 650.0 - float(index) * 58.0
	block.position = Vector2(240.0 - width / 2.0 + x_offset, y)
	block.size = Vector2(width, height)
	block.color = definition["color"]
	block.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tower.add_child(block)

	var label := Label.new()
	label.position = block.position
	label.size = block.size
	label.text = "%s  %s" % [str(definition["glyph"]), str(definition["title"])]
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tower.add_child(label)

func update_stats() -> void:
	var energy_balance := energy_produced - energy_required
	var energy_state := "OK" if energy_balance >= 0 else "LOW"
	stats.text = "Turn: %d\nBlocks: %d\nResidents: %d/%d\nEnergy: %d/%d (%s)\nBeauty: %d\nTechnology: %d\nComfort: %d\n\nUnlocks:\nWorkshop/Bridge: tech 2\nArt Studio: beauty 5\nRoof Garden: beauty 6 + residents 2" % [
		turn,
		placed_blocks.size() + 1,
		population,
		capacity,
		energy_produced,
		energy_required,
		energy_state,
		beauty,
		technology,
		comfort
	]

func _signed(value: int) -> String:
	if value > 0:
		return "+%d" % value
	return str(value)
