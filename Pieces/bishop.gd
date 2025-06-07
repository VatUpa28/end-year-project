extends "res://Pieces/piece.gd"

func _init():
	allowed_dirs = {
		"up": false,
		"down": false,
		"left": false,
		"right": false,
		"up_left": true,
		"up_right": true,
		"down_left": true,
		"down_right": true
	}
	
func get_allowed_dirs() -> Dictionary:
	return allowed_dirs.duplicate()
