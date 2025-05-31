extends "res://Pieces/piece.gd"

# Knight moves as relative tile offsets (Vector2i)
var knight_moves := [
	Vector2i(2, 1),
	Vector2i(2, -1),
	Vector2i(-2, 1),
	Vector2i(-2, -1),
	Vector2i(1, 2),
	Vector2i(1, -2),
	Vector2i(-1, 2),
	Vector2i(-1, -2)
]

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

# Function to get possible moves from current grid position
func get_knight_moves(current_pos: Vector2i) -> Array:
	var moves = []
	for offset in knight_moves:
		var new_pos = current_pos + offset
		# Optionally, check if new_pos is inside the board limits (0 to 7)
		if new_pos.x >= 0 and new_pos.x < 8 and new_pos.y >= 0 and new_pos.y < 8:
			moves.append(new_pos)
	return moves

var is_corrupted = false

func mark_corrupted():
	is_corrupted = true
