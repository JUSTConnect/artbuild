extends Node

const COLORS: Array[Color] = [
	Color(0.46, 0.70, 0.96, 1.0),
	Color(0.78, 0.62, 0.94, 1.0),
	Color(0.96, 0.68, 0.48, 1.0),
	Color(0.55, 0.78, 0.70, 1.0),
	Color(0.38, 0.48, 0.76, 1.0)
]

var game_root: Control = null
var was_running: bool = false

func _ready() -> void:
	randomize()
	call_deferred("_bind_scene")

func _process(_delta: float) -> void:
	if game_root == null:
		_bind_scene()
	if game_root == null:
		return
	var running: bool = game_root.get("game_started") == true
	if running and not was_running:
		_apply_color()
	was_running = running

func _bind_scene() -> void:
	game_root = get_tree().current_scene as Control

func _apply_color() -> void:
	var bg: ColorRect = game_root.get_node_or_null("Background") as ColorRect
	if bg == null:
		return
	bg.color = COLORS[randi() % COLORS.size()]
