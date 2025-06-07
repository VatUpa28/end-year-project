extends Area2D

signal piece_clicked(piece)

var allowed_dirs: Dictionary = {}

var selected = false

var is_ready = false

func _ready():
	is_ready = true

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selected = !selected
		emit_signal("piece_clicked", self)

var original_modulate := Color.WHITE

func set_highlight(enable: bool) -> void:
	if enable:
		modulate = Color(0.3, 1.0, 1.0, 1.0)  # Cyan highlight
	else:
		modulate = original_modulate

func mark_corrupted(is_corrupted: bool) -> void:
	# Update visual state based on corruption
	if is_corrupted:
		modulate = Color(1, 0.3, 0.3)  # Red tint for corrupted
	else:
		modulate = original_modulate

	# Set metadata properly
	set_meta("corrupted", is_corrupted)
