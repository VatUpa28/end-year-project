extends Node2D

@onready var piece_scene: PackedScene = preload("res://Pieces/Piece.tscn")
@onready var board := $Board
@onready var logic_panel := $UI/LogicPanel

const GRID_SIZE = 8
const NUM_PIECES = 12
const CORRUPTION_CHANCE = 0.3  # 30% chance to corrupt each piece

func _ready():
	randomize()
	generate_random_board()

func generate_random_board():
	# Clear existing pieces
	for child in get_children():
		if child is Area2D:
			child.queue_free()

	var used_positions = []

	for i in range(NUM_PIECES):
		var piece = piece_scene.instantiate()
		var pos = get_random_grid_position(used_positions)
		used_positions.append(pos)

		# Convert to pixels
		var tile_size = board.tile_set.tile_size if board.tile_set else Vector2(16, 16)
		piece.position = pos * tile_size

		# Default allowed directions
		piece.allowed_dirs = {
			"up": true,
			"down": true,
			"left": true,
			"right": true
		}

		# Possibly corrupt the piece
		if randf() < CORRUPTION_CHANCE:
			corrupt_piece(piece)

		add_child(piece)

func get_random_grid_position(used):
	while true:
		var x = randi() % GRID_SIZE
		var y = randi() % GRID_SIZE
		var pos = Vector2i(x, y)
		if not used.has(pos):
			return pos

func corrupt_piece(piece):
	var dirs = ["up", "down", "left", "right"]
	dirs.shuffle()
	var num_to_corrupt = randi() % 2 + 1
	for i in range(num_to_corrupt):
		piece.allowed_dirs[dirs[i]] = false
	if piece.has_method("mark_corrupted"):
		piece.mark_corrupted()

func _on_ResetButton_pressed():
	get_tree().reload_current_scene()
