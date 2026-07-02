extends Control

@onready var status_label: Label = $Status

func _ready() -> void:
	status_label.text = "Artbuild Godot scaffold ready\n\nNext step: port domain systems from src/domain and src/game into GDScript or a Godot-friendly runtime adapter."
