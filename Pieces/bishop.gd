extends "res://Pieces/piece.gd"

func _ready():
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
