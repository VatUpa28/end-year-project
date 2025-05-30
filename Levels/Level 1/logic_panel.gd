extends Control

var current_piece = null

@onready var cb_up = $VBoxContainer/CheckBoxUp
@onready var cb_down = $VBoxContainer/CheckBoxDown
@onready var cb_left = $VBoxContainer/CheckBoxLeft
@onready var cb_right = $VBoxContainer/CheckBoxRight
@onready var cb_upleft = $VBoxContainer/CheckBoxUpLeft
@onready var cb_upright = $VBoxContainer/CheckBoxUpRight
@onready var cb_downleft = $VBoxContainer/CheckBoxDownLeft
@onready var cb_downright = $VBoxContainer/CheckBoxDownRight
@onready var apply_button = $ApplyButton

func _ready():
	print("Apply button:", apply_button)
	if apply_button:
		apply_button.pressed.connect(_on_ApplyButton_pressed)
	else:
		print("Error: Apply button not found!")


func update_with_piece(piece):
	current_piece = piece
	visible = true
	# Use set_pressed(bool) to update checkboxes
	cb_up.set_pressed(piece.allowed_dirs.get("up", false))
	cb_down.set_pressed(piece.allowed_dirs.get("down", false))
	cb_left.set_pressed(piece.allowed_dirs.get("left", false))
	cb_right.set_pressed(piece.allowed_dirs.get("right", false))
	cb_upleft.set_pressed(piece.allowed_dirs.get("up_left", false))
	cb_upright.set_pressed(piece.allowed_dirs.get("up_right", false))
	cb_downleft.set_pressed(piece.allowed_dirs.get("down_left", false))
	cb_downright.set_pressed(piece.allowed_dirs.get("down_right", false))

func _on_ApplyButton_pressed():
	if current_piece:
		# Use is_pressed() to read checkbox states
		current_piece.allowed_dirs["up"] = cb_up.is_pressed()
		current_piece.allowed_dirs["down"] = cb_down.is_pressed()
		current_piece.allowed_dirs["left"] = cb_left.is_pressed()
		current_piece.allowed_dirs["right"] = cb_right.is_pressed()
		current_piece.allowed_dirs["up_left"] = cb_upleft.is_pressed()
		current_piece.allowed_dirs["up_right"] = cb_upright.is_pressed()
		current_piece.allowed_dirs["down_left"] = cb_downleft.is_pressed()
		current_piece.allowed_dirs["down_right"] = cb_downright.is_pressed()
		
		current_piece.set_highlight(false)
		current_piece = null
		
		print("Apply clicked — hiding LogicPanel.")
		visible = false
