extends "res://Pieces/piece.gd"

func _init():
	allowed_dirs = {
		"up": false,
		"down": false,
		"left": false,
		"right": false,
		"up_left": false,
		"up_right": false,
		"down_left": false,
		"down_right": false
	}
	set_original_dirs()

func get_allowed_dirs() -> Dictionary:
	return allowed_dirs.duplicate()
