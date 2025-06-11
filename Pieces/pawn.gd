extends "res://Pieces/piece.gd"

func _ready():
	var dirs = {
		"up": true,
		"down": false,
		"left": false,
		"right": false,
		"up_left": true,
		"up_right": true,
		"down_left": false,
		"down_right": false
	}
	init_dirs(allowed_dirs)
	# Optional debug:
	# print(name, "allowed_dirs initialized to", original_dirs)

func get_allowed_dirs() -> Dictionary:
	return allowed_dirs.duplicate()
