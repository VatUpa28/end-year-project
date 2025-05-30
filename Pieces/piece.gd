extends Area2D

signal piece_clicked(piece)

# Directional movement flags
var allowed_dirs: Dictionary = {}

var selected = false

func _ready():
	pass  # Optional: any setup code

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selected = !selected
		emit_signal("piece_clicked", self)

var original_modulate := Color.WHITE

func set_highlight(enable: bool) -> void:
	if enable:
		# Use a strong but clean highlight color (cyan works well)
		modulate = Color(0.3, 1.0, 1.0, 1.0)  # Cyan
	else:
		modulate = original_modulate
