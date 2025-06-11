extends "res://Pieces/piece.gd"

func _ready():
	allowed_dirs = {
		"up": true,
		"down": true,
		"left": true,
		"right": true,
		"up_left": true,
		"up_right": true,
		"down_left": true,
		"down_right": true
	}
	init_dirs(allowed_dirs)
	# Optional debug:
	# print(name, "allowed_dirs initialized to", original_dirs)

func get_allowed_dirs() -> Dictionary:
	return allowed_dirs.duplicate()
