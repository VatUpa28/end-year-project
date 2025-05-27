extends Panel

@onready var cb_up = $CheckBoxUp
@onready var cb_down = $CheckBoxDown
@onready var cb_left = $CheckBoxLeft
@onready var cb_right = $CheckBoxRight

var current_piece = null

func show_for(piece):
	current_piece = piece
	visible = true
	
	cb_up.pressed = current_piece.allowed_dirs.get("up", false)
	cb_down.pressed = current_piece.allowed_dirs.get("down", false)
	cb_left.pressed = current_piece.allowed_dirs.get("left", false)
	cb_right.pressed = current_piece.allowed_dirs.get("right", false)

func _on_Button_pressed():
	if current_piece:
		current_piece.allowed_dirs["up"] = cb_up.pressed
		current_piece.allowed_dirs["down"] = cb_down.pressed
		current_piece.allowed_dirs["left"] = cb_left.pressed
		current_piece.allowed_dirs["right"] = cb_right.pressed
	visible = false
