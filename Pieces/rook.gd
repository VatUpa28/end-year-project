extends "res://Pieces/piece.gd"

func _ready():
	var allowed_dirs: Dictionary = {
		"up": true,
		"down": true,
		"left": true,
		"right": true,
		"up_left": false,
		"up_right": false,
		"down_left": false,
		"down_right": false
	}
