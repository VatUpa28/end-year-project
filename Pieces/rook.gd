extends "res://Pieces/piece.gd"

func _init():
	allowed_dirs = {
		"up": true,
		"down": true,
		"left": true,
		"right": true,
		"up_left": false,
		"up_right": false,
		"down_left": false,
		"down_right": false
	}
	set_original_dirs()

func get_allowed_dirs() -> Dictionary:
	return allowed_dirs.duplicate()
