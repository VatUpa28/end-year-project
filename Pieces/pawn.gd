extends "res://Pieces/piece.gd"

func _ready():
	var allowed_dirs: Dictionary = {
		"up": true,
		"down": false,
		"left": false,
		"right": false,
		"up_left": false,
		"up_right": false,
		"down_left": false,
		"down_right": false
	}
