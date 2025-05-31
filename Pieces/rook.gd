extends "res://Pieces/piece.gd"

func _ready():
	allowed_dirs = {
		"up": true,
		"down": true,
		"left": true,
		"right": true,
		"up_left": false,
		"up_right": false,
		"down_left": false,
		"down_right": false
	}

var is_corrupted = false

func mark_corrupted():
	is_corrupted = true
