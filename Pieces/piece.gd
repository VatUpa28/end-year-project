# res://Pieces/piece.gd
extends Area2D
class_name PieceBase

signal piece_clicked(piece)
signal piece_fixed

var allowed_dirs: Dictionary = {}
var original_dirs: Dictionary = {}

var selected = false
var original_modulate := Color.WHITE
var _pressed_inside := false

func _ready():
	original_modulate = modulate

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_pressed_inside = true
		else:
			if _pressed_inside:
				_pressed_inside = false
				emit_signal("piece_clicked", self)

func set_selected(value: bool):
	selected = value
	modulate = Color.CYAN if selected else original_modulate

func mark_corrupted(is_corrupted: bool):
	set_meta("corrupted", is_corrupted)
	if not is_corrupted:
		emit_signal("piece_fixed")  # ✅ Automatically triggers win check when fixed

func is_directions_correct() -> bool:
	for key in original_dirs:
		if allowed_dirs.get(key) != original_dirs.get(key):
			return false
	return true

func init_dirs(dirs: Dictionary) -> void:
	allowed_dirs = dirs.duplicate(true)
	original_dirs = dirs.duplicate(true)

func set_original_dirs() -> void:
	original_dirs = allowed_dirs.duplicate(true)

func try_fix():
	if is_directions_correct():
		mark_corrupted(false)  # ✅ This will emit signal if fixed
