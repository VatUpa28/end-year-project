extends "res://Pieces/piece.gd"

func _ready():
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
