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

	for i in range(NUM_PIECES):
		var piece_scene = piece_scenes[randi() % piece_scenes.size()]
		var piece = piece_scene.instantiate()

		# Pick a unique grid cell
		var cell = get_random_grid_position(used_positions)
		used_positions.append(cell)

		# Convert tile position to world position
		var tile_pos = board.map_to_local(cell)
		var world_pos = board.to_global(tile_pos)

		# Place piece
		add_child(piece)
		piece.global_position = world_pos

		# Randomly corrupt directions
		if randf() < CORRUPTION_CHANCE:
			corrupt_piece(piece)

		# Connect signal to logic panel and select/highlight logic
		piece.connect("piece_clicked", Callable(self, "on_piece_clicked"))

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
