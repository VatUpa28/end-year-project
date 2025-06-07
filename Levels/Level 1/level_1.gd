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
@onready var logic_panel := get_node("UI/LogicPanel")
@onready var win_panel := get_node("UI/WinPanel")

const GRID_SIZE = 8
const NUM_PIECES = 12
const CORRUPTION_CHANCE = 0.3

var selected_piece = null
var win_shown = false

func _ready():
	randomize()
	generate_random_board()

func generate_random_board():
	# Remove old pieces first
	for child in get_children():
		if child is Area2D and child.has_method("mark_corrupted"):
			child.queue_free()

	var used_positions: Array = []

	var max_piece_counts = {
		"white-pawn": 8, "white-rook": 2, "white-knight": 2, "white-bishop": 2,
		"white-queen": 1, "white-king": 1,
		"black-pawn": 8, "black-rook": 2, "black-knight": 2, "black-bishop": 2,
		"black-queen": 1, "black-king": 1
	}

	var current_piece_counts = {}
	for name in max_piece_counts.keys():
		current_piece_counts[name] = 0

	var attempts = 0

	while used_positions.size() < NUM_PIECES and attempts < 100:
		attempts += 1

		var piece_scene = piece_scenes[randi() % piece_scenes.size()]
		var scene_path = piece_scene.resource_path
		var piece_name = scene_path.get_file().get_basename()

		if current_piece_counts[piece_name] < max_piece_counts[piece_name]:
			current_piece_counts[piece_name] += 1

			var piece = piece_scene.instantiate()
			piece.name = piece_name + str(used_positions.size())

			var cell = get_random_grid_position(used_positions)
			used_positions.append(cell)

			var tile_pos = board.map_to_local(cell)
			var world_pos = board.to_global(tile_pos)

			add_child(piece)
			piece.global_position = world_pos

			if randf() < CORRUPTION_CHANCE:
				corrupt_piece(piece)
			else:
				piece.mark_corrupted(false)  # Make sure not corrupted initially

			piece.connect("piece_clicked", Callable(self, "on_piece_clicked"))

func corrupt_piece(piece):
	# Reset directions to true first
	for dir in ["up", "down", "left", "right", "up_left", "up_right", "down_left", "down_right"]:
		piece.allowed_dirs[dir] = true

	var dirs = ["up", "down", "left", "right", "up_left", "up_right", "down_left", "down_right"]
	dirs.shuffle()
	var corrupt_count = randi() % 2 + 1
	for i in range(corrupt_count):
		piece.allowed_dirs[dirs[i]] = false

	piece.mark_corrupted(true)

	check_win_condition()

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

func check_win_condition() -> bool:
	var corrupted_count = 0
	for child in get_children():
		if child is Area2D and child.has_method("mark_corrupted"):
			var is_corrupted = child.get_meta("corrupted", false)
			print("🔍", child.name, "corrupted:", is_corrupted)
			if is_corrupted:
				corrupted_count += 1

	print("⏳", corrupted_count, "corrupted pieces remain.")

	if corrupted_count == 0 and not win_shown:
		print("✅ WIN CONDITION MET!")
		win_shown = true
		win_panel.visible = true

	return corrupted_count == 0
