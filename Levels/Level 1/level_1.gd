extends Node2D

@onready var piece_scenes = [
	preload("res://Pieces/white-pawn.tscn"),
	preload("res://Pieces/white-rook.tscn"),
	preload("res://Pieces/white-bishop.tscn"),
	preload("res://Pieces/white-knight.tscn"),
	preload("res://Pieces/white-queen.tscn"),
	preload("res://Pieces/white-king.tscn"),
	preload("res://Pieces/black-pawn.tscn"),
	preload("res://Pieces/black-rook.tscn"),
	preload("res://Pieces/black-bishop.tscn"),
	preload("res://Pieces/black-knight.tscn"),
	preload("res://Pieces/black-queen.tscn"),
	preload("res://Pieces/black-king.tscn")
]

@onready var board = $Board
@onready var logic_panel = $UI/LogicPanel

const GRID_SIZE = 8
const NUM_PIECES = 12
const CORRUPTION_CHANCE = 0.3

var selected_piece = null

func _ready():
	randomize()
	generate_random_board()

func generate_random_board():
	# Remove old pieces
	for child in get_children():
		if child is Area2D:
			child.queue_free()

	var used_positions: Array = []

	# Define piece limits (standard chess rules)
	var max_piece_counts = {
		"white-pawn": 8, "white-rook": 2, "white-knight": 2, "white-bishop": 2,
		"white-queen": 1, "white-king": 1,
		"black-pawn": 8, "black-rook": 2, "black-knight": 2, "black-bishop": 2,
		"black-queen": 1, "black-king": 1
	}

	var current_piece_counts = {}
	for name in max_piece_counts.keys():
		current_piece_counts[name] = 0

	var available_pieces = piece_scenes.duplicate()

	var attempts = 0  # Prevent infinite loop
	while used_positions.size() < NUM_PIECES and attempts < 100:
		attempts += 1

		var piece_scene = available_pieces[randi() % available_pieces.size()]
		var scene_path = piece_scene.resource_path
		var piece_name = scene_path.get_file().get_basename()  # like "white-rook"

		if current_piece_counts[piece_name] < max_piece_counts[piece_name]:
			current_piece_counts[piece_name] += 1

			var piece = piece_scene.instantiate()  # <--- THIS MUST BE HERE

			var cell = get_random_grid_position(used_positions)
			used_positions.append(cell)

			var tile_pos = board.map_to_local(cell)
			var world_pos = board.to_global(tile_pos)

			add_child(piece)
			piece.global_position = world_pos

			if randf() < CORRUPTION_CHANCE:
				corrupt_piece(piece)

			piece.connect("piece_clicked", Callable(self, "on_piece_clicked"))  # <--- USE IT INSIDE THE BLOCK


func on_piece_clicked(piece):
	if selected_piece and selected_piece != piece:
		selected_piece.set_highlight(false)
		selected_piece = piece
		selected_piece.set_highlight(true)
		logic_panel.update_with_piece(piece)
	elif selected_piece == piece:
		selected_piece.set_highlight(false)
		selected_piece = null
		logic_panel.visible = false
	else:
		selected_piece = piece
		selected_piece.set_highlight(true)
		logic_panel.update_with_piece(piece)

func get_random_grid_position(used: Array) -> Vector2i:
	while true:
		var x = randi() % GRID_SIZE
		var y = randi() % GRID_SIZE
		var cell = Vector2i(x, y)
		if not used.has(cell):
			return cell
	return Vector2i(0, 0)

func corrupt_piece(piece):
	var dirs = ["up", "down", "left", "right", "up_left", "up_right", "down_left", "down_right"]
	dirs.shuffle()
	var corrupt_count = randi() % 2 + 1
	for i in range(corrupt_count):
		piece.allowed_dirs[dirs[i]] = false
	if piece.has_method("mark_corrupted"):
		piece.mark_corrupted()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/MainMenu/MainMenu.tscn")
