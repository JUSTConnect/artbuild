extends Node

const ASSET_BASE: String = "base_cell"
const ASSET_WINDOW: String = "window"
const ASSET_DOOR: String = "door"
const ASSET_ROOF: String = "roof"
const ASSET_DECOR: String = "decor"

const DEFAULT_ASSETS: Array[Dictionary] = [
	{"id":"base_wood_01", "kind":ASSET_BASE, "style":"wood", "label":"Wood wall A", "color":Color(0.66, 0.48, 0.34, 1.0), "rarity":1},
	{"id":"base_wood_02", "kind":ASSET_BASE, "style":"wood", "label":"Wood wall B", "color":Color(0.74, 0.55, 0.38, 1.0), "rarity":1},
	{"id":"base_brick_01", "kind":ASSET_BASE, "style":"brick", "label":"Brick wall A", "color":Color(0.70, 0.38, 0.30, 1.0), "rarity":1},
	{"id":"base_stone_01", "kind":ASSET_BASE, "style":"stone", "label":"Stone wall A", "color":Color(0.54, 0.55, 0.58, 1.0), "rarity":1},
	{"id":"window_square_01", "kind":ASSET_WINDOW, "style":"any", "label":"Square window", "color":Color(0.62, 0.84, 0.95, 1.0), "rarity":1},
	{"id":"window_round_01", "kind":ASSET_WINDOW, "style":"any", "label":"Round window", "color":Color(0.58, 0.76, 0.92, 1.0), "rarity":1},
	{"id":"door_wood_01", "kind":ASSET_DOOR, "style":"wood", "label":"Wood door", "color":Color(0.28, 0.17, 0.10, 1.0), "rarity":1},
	{"id":"door_dark_01", "kind":ASSET_DOOR, "style":"any", "label":"Dark door", "color":Color(0.18, 0.13, 0.12, 1.0), "rarity":1},
	{"id":"roof_red_01", "kind":ASSET_ROOF, "style":"any", "label":"Red roof", "color":Color(0.66, 0.22, 0.18, 1.0), "rarity":1},
	{"id":"roof_blue_01", "kind":ASSET_ROOF, "style":"any", "label":"Blue roof", "color":Color(0.26, 0.38, 0.66, 1.0), "rarity":1},
	{"id":"decor_plant_01", "kind":ASSET_DECOR, "style":"any", "label":"Plant", "color":Color(0.24, 0.58, 0.28, 1.0), "rarity":1},
	{"id":"decor_sign_01", "kind":ASSET_DECOR, "style":"any", "label":"Sign", "color":Color(0.90, 0.78, 0.38, 1.0), "rarity":1}
]

var assets: Array[Dictionary] = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	assets = DEFAULT_ASSETS.duplicate(true)

func create_asset(id: String, kind: String, style: String, label: String, color: Color, rarity: int = 1) -> Dictionary:
	return {"id": id, "kind": kind, "style": style, "label": label, "color": color, "rarity": rarity}

func create_blueprint(seed_value: int, footprint: String, style: String, cells: Array[Dictionary], roof: Dictionary) -> Dictionary:
	return {
		"seed": seed_value,
		"footprint": footprint,
		"style": style,
		"cells": cells,
		"roof": roof,
		"version": 1
	}

func generate(params: Dictionary = {}) -> Dictionary:
	var seed_value: int = int(params.get("seed", rng.randi()))
	var local_rng: RandomNumberGenerator = RandomNumberGenerator.new()
	local_rng.seed = seed_value
	var footprint: String = str(params.get("footprint", "1x1"))
	var style: String = str(params.get("style", "wood"))
	var base_asset: Dictionary = _pick_asset(ASSET_BASE, style, local_rng)
	var window_asset: Dictionary = _pick_asset(ASSET_WINDOW, style, local_rng)
	var door_asset: Dictionary = _pick_asset(ASSET_DOOR, style, local_rng)
	var decor_asset: Dictionary = _pick_asset(ASSET_DECOR, style, local_rng)
	var roof_asset: Dictionary = _pick_asset(ASSET_ROOF, style, local_rng)
	var cells: Array[Dictionary] = [
		{
			"x": 0,
			"y": 0,
			"base": base_asset,
			"windows": [window_asset],
			"door": door_asset,
			"decor": [decor_asset]
		}
	]
	return create_blueprint(seed_value, footprint, style, cells, roof_asset)

func blueprint_summary(blueprint: Dictionary) -> String:
	if blueprint.is_empty():
		return "No blueprint"
	var cell: Dictionary = (blueprint["cells"] as Array)[0]
	var base_asset: Dictionary = cell["base"]
	var door_asset: Dictionary = cell["door"]
	var roof_asset: Dictionary = blueprint["roof"]
	return "Seed %d | %s | %s | %s | %s" % [int(blueprint["seed"]), str(blueprint["style"]), str(base_asset["label"]), str(door_asset["label"]), str(roof_asset["label"])]

func _pick_asset(kind: String, style: String, local_rng: RandomNumberGenerator) -> Dictionary:
	var candidates: Array[Dictionary] = []
	for index: int in range(assets.size()):
		var asset: Dictionary = assets[index]
		if str(asset["kind"]) != kind:
			continue
		var asset_style: String = str(asset["style"])
		if asset_style == style or asset_style == "any":
			candidates.append(asset)
	if candidates.is_empty():
		return {}
	return candidates[local_rng.randi_range(0, candidates.size() - 1)]
