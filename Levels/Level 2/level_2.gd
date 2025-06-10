extends Node2D

@export var level_num := 1

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
@onready var logic_panel := $UI/LogicPanel
@onready var win_panel := $UI/WinPanel
@onready var reset_button := $UI/HBoxContainer/Restart
@onready var home_button := $UI/HBoxContainer/Home

const GRID_SIZE = 8
const NUM_PIECES = 12
const CORRUPTION_CHANCE_LEVEL1 = 0.35
const CORRUPTION_CHANCE_LEVEL2 = 0.4

var selected_piece = null
var win_shown = false

func _ready():
	randomize()
	if logic_panel.has_method("set_level_node"):
		logic_panel.set_level_node(self)
	generate_random_board()

func generate_random_board():
	for child in get_children():
		if child is Area2D and child.has_method("mark_corrupted"):
			child.queue_free()

	var used_positions: Array = []
	var corrupted_pieces: Array = []
	var all_pieces: Array = []

	var max_piece_counts = {
		"white-pawn": 8, "white-rook": 2, "white-knight": 2, "white-bishop": 2,
		"white-queen": 1, "white-king": 1,
		"black-pawn": 8, "black-rook": 2, "black-knight": 2, "black-bishop": 2,
		"black-queen": 1, "black-king": 1
	}

	var current_piece_counts = max_piece_counts.duplicate(true)
	for key in current_piece_counts:
		current_piece_counts[key] = 0

	var attempts = 0

	while used_positions.size() < NUM_PIECES and attempts < 1000:
		attempts += 1

		var piece_scene = piece_scenes[randi() % piece_scenes.size()]
		var piece_name = piece_scene.resource_path.get_file().get_basename()

		if current_piece_counts[piece_name] < max_piece_counts[piece_name]:
			current_piece_counts[piece_name] += 1

			var piece = piece_scene.instantiate()
			piece.name = piece_name + str(used_positions.size())

			var cell = get_random_grid_position(used_positions)
			used_positions.append(cell)

			var tile_pos = board.map_to_local(cell)
			var world_pos = board.to_global(tile_pos)
			piece.global_position = world_pos
			add_child(piece)

			piece.allowed_dirs = get_default_dirs(piece_name)
			piece.set_original_dirs()

			if level_num == 1:
				if randf() < CORRUPTION_CHANCE_LEVEL1:
					corrupt_piece(piece)
					if piece.get_meta("corrupted", false):
						corrupted_pieces.append(piece)
				else:
					piece.mark_corrupted(false)
				all_pieces.append(piece)

			piece.connect("piece_clicked", Callable(self, "on_piece_clicked"))

	# Force at least 2 corrupted pieces in Level 1
	if level_num == 1:
		while corrupted_pieces.size() < 2 and all_pieces.size() > 0:
			var candidate = all_pieces[randi() % all_pieces.size()]
			if not candidate.get_meta("corrupted", false):
				corrupt_piece(candidate)
				if candidate.get_meta("corrupted", false):
					corrupted_pieces.append(candidate)

func corrupt_piece(piece):
	piece.allowed_dirs = get_default_dirs(piece.name)
	piece.set_original_dirs()

	var dirs = piece.allowed_dirs.keys()
	dirs.shuffle()
	var corrupt_count = randi() % 2 + 1
	for i in range(corrupt_count):
		piece.allowed_dirs[dirs[i]] = false

	piece.mark_corrupted(not piece.is_directions_correct())

func get_default_dirs(piece_name: String) -> Dictionary:
	var dirs := {
		"up": false, "down": false, "left": false, "right": false,
		"up_left": false, "up_right": false, "down_left": false, "down_right": false
	}

	if piece_name.contains("pawn"):
		dirs["up"] = true
		dirs["up_left"] = true
		dirs["up_right"] = true
	elif piece_name.contains("rook"):
		dirs["up"] = true
		dirs["down"] = true
		dirs["left"] = true
		dirs["right"] = true
	elif piece_name.contains("bishop"):
		dirs["up_left"] = true
		dirs["up_right"] = true
		dirs["down_left"] = true
		dirs["down_right"] = true
	elif piece_name.contains("queen") or piece_name.contains("king"):
		for dir in dirs.keys():
			dirs[dir] = true
	return dirs

func on_piece_clicked(piece):
	if selected_piece and selected_piece != piece:
		selected_piece.set_selected(false)
		selected_piece = piece
		selected_piece.set_selected(true)
		logic_panel.update_with_piece(piece)
	elif selected_piece == piece:
		selected_piece.set_selected(false)
		selected_piece = null
		logic_panel.visible = false
	else:
		selected_piece = piece
		selected_piece.set_selected(true)
		logic_panel.update_with_piece(piece)

func get_random_grid_position(used: Array) -> Vector2i:
	var attempts = 0
	while attempts < 1000:
		var x = randi() % GRID_SIZE
		var y = randi() % GRID_SIZE
		var cell = Vector2i(x, y)
		if not used.has(cell):
			return cell
		attempts += 1
	return Vector2i(0, 0) 

func check_win_condition() -> bool:
	var corrupted_count = 0
	for child in get_children():
		if child is Area2D and child.has_method("mark_corrupted"):
			if child.get_meta("corrupted", false):
				corrupted_count += 1

	if corrupted_count == 0 and not win_shown:
		win_shown = true
		win_panel.visible = true
		reset_button.disabled = true
		home_button.disabled = true
	return corrupted_count == 0

func on_piece_fixed():
	check_win_condition()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/MainMenu/MainMenu.tscn")

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/MainMenu/MainMenu.tscn")

func _on_level_selector_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/LevelSelector/LevelSelector.tscn")

func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level 2/Level2.tscn")

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
