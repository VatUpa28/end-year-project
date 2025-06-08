extends Area2D

signal piece_clicked(piece)

var allowed_dirs: Dictionary = {}
var original_dirs: Dictionary = {}

var selected = false
var is_ready = false
var original_modulate := Color.WHITE

func _ready():
	is_ready = true
	original_modulate = modulate  # Store the original color at ready

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("piece_clicked", self)

# Use this to highlight the piece as selected or deselected
func set_selected(enable: bool) -> void:
	selected = enable
	if selected:
		modulate = Color(0.3, 1.0, 1.0, 1.0)  # Cyan highlight for selection
	else:
		# If piece is corrupted, keep red tint, else reset to original color
		if get_meta("corrupted", false):
			modulate = Color(1, 0.3, 0.3)  # Red tint for corrupted
		else:
			modulate = original_modulate

# Mark the piece as corrupted or not and update color accordingly
func mark_corrupted(is_corrupted: bool) -> void:
	set_meta("corrupted", is_corrupted)
	if is_corrupted:
		modulate = Color(1, 0.3, 0.3)  # Red tint for corrupted
	else:
		modulate = original_modulate

func set_original_dirs():
	original_dirs = allowed_dirs.duplicate(true)  # Save a copy of original directions

func is_directions_correct() -> bool:
	for dir in original_dirs.keys():
		if allowed_dirs.get(dir, false) != original_dirs.get(dir, false):
			return false
	return true
