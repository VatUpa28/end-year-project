extends "res://Pieces/piece.gd"

func _init():
	allowed_dirs = {
		"up": true,
		"down": false,
		"left": false,
		"right": false,
		"up_left": true,
		"up_right": true,
		"down_left": false,
		"down_right": false
	}
func get_allowed_dirs() -> Dictionary:
	return allowed_dirs.duplicate()
