extends "res://Pieces/piece.gd"

func _ready():
	var allowed_dirs: Dictionary = {
		"up": true,
		"down": true,
		"left": true,
		"right": true,
		"up_left": true,
		"up_right": true,
		"down_left": true,
		"down_right": true
	}
