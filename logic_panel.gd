extends Panel
var current_piece = null

func show_for(piece):
	current_piece = piece
	visible = true

func _on_Button_pressed():
	current_piece.allowed_dirs["up"] = $CheckBoxUp.pressed
	current_piece.allowed_dirs["down"] = $CheckBoxDown.pressed
	current_piece.allowed_dirs["right"] = $CheckBoxRight.pressed
	current_piece.allowed_dirs["left"] = $CheckBoxLeft.pressed
	visible = false

func _on_button_pressed() -> void:
	pass # Replace with function body.
