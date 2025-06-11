extends "res://Pieces/piece.gd"

func _ready():
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
	init_dirs(allowed_dirs)
	# Optional debug:
	# print(name, "allowed_dirs initialized to", original_dirs)

func get_allowed_dirs() -> Dictionary:
	return allowed_dirs.duplicate()
