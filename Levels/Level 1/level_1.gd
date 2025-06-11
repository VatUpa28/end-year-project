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
@onready var logic_panel := $UI/LogicPanel
@onready var win_panel := $UI/WinPanel
@onready var reset_button := $UI/HBoxContainer/Restart
@onready var home_button := $UI/HBoxContainer/Home

const GRID_SIZE = 8
const NUM_PIECES = 12
const CORRUPTION_CHANCE = 0.35

var selected_piece = null
var win_shown = false
var board_ready = false

func _ready():
	randomize()
	board_ready = false
	logic_panel.level_node = self
	logic_panel.visible = false
	if win_panel:
		win_panel.visible = false
	win_shown = false
	generate_random_board()
	board_ready = true

func deselect_current_piece():
	if selected_piece:
		selected_piece.set_selected(false)
	selected_piece = null
	logic_panel.visible = false

func generate_random_board():
	board_ready = false
	deselect_current_piece()
	if win_panel:
		win_panel.visible = false
	win_shown = false

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
	var corrupted_pieces: Array = []

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
			piece.connect("piece_clicked", Callable(self, "on_piece_clicked"))
			piece.connect("piece_fixed", Callable(self, "on_piece_fixed"))

			var should_corrupt = randf() < CORRUPTION_CHANCE
			piece.allowed_dirs = get_default_dirs(piece_name)
			piece.set_original_dirs()

			if should_corrupt:
				corrupt_piece(piece)
				if piece.get_meta("corrupted", false):
					corrupted_pieces.append(piece)
				else:
					for dir in piece.allowed_dirs.keys():
						piece.allowed_dirs[dir] = false
					piece.mark_corrupted(true)
					corrupted_pieces.append(piece)
			else:
				piece.mark_corrupted(false)

	if corrupted_pieces.size() == 0:
		var all_pieces = []
		for child in get_children():
			if child is Area2D and child.has_method("mark_corrupted"):
				all_pieces.append(child)
		all_pieces.shuffle()
		if all_pieces.size() > 0:
			var piece_to_force = all_pieces[0]
			corrupt_piece(piece_to_force)
			if piece_to_force.get_meta("corrupted", false):
				corrupted_pieces.append(piece_to_force)

	board_ready = true

func corrupt_piece(piece):
	piece.allowed_dirs = get_default_dirs(piece.name)
	piece.set_original_dirs()
	var true_dirs = []
	for dir in piece.original_dirs.keys():
		if piece.original_dirs.get(dir, false):
			true_dirs.append(dir)
	if true_dirs.size() > 0:
		var dir_to_flip = true_dirs[randi() % true_dirs.size()]
		piece.allowed_dirs[dir_to_flip] = false
		piece.mark_corrupted(true)
	else:
		piece.mark_corrupted(true)

func get_default_dirs(piece_name: String) -> Dictionary:
	var dirs := {
		"up": false, "down": false, "left": false, "right": false,
		"up_left": false, "up_right": false, "down_left": false, "down_right": false
	}
	var lower_name = piece_name.to_lower()
	if lower_name.find("pawn") != -1:
		dirs["up"] = true
		dirs["up_left"] = true
		dirs["up_right"] = true
	elif lower_name.find("rook") != -1:
		dirs["up"] = true
		dirs["down"] = true
		dirs["left"] = true
		dirs["right"] = true
	elif lower_name.find("bishop") != -1:
		dirs["up_left"] = true
		dirs["up_right"] = true
		dirs["down_left"] = true
		dirs["down_right"] = true
	elif lower_name.find("queen") != -1:
		for dir in dirs.keys():
			dirs[dir] = true
	elif lower_name.find("king") != -1:
		for dir in dirs.keys():
			dirs[dir] = true
	elif lower_name.find("knight") != -1:
		pass
	return dirs

func on_piece_clicked(piece):
	if selected_piece == piece:
		deselect_current_piece()
	else:
		if selected_piece:
			selected_piece.set_selected(false)
		selected_piece = piece
		selected_piece.set_selected(true)
		logic_panel.update_with_piece(piece)
		logic_panel.visible = true

func get_random_grid_position(used: Array) -> Vector2i:
	while true:
		var x = randi() % GRID_SIZE
		var y = randi() % GRID_SIZE
		var cell = Vector2i(x, y)
		if not used.has(cell):
			return cell
	return Vector2i(0, 0)

func check_win_condition() -> bool:
	if not board_ready:
		return false

	var corrupted_count = 0
	for child in get_children():
		if child is Area2D and child.has_method("mark_corrupted"):
			if child.get_meta("corrupted", false):
				corrupted_count += 1

	if corrupted_count == 0 and not win_shown:
		win_shown = true
		if win_panel:
			win_panel.visible = true
		reset_button.disabled = true
		home_button.disabled = true
	return corrupted_count == 0

func on_piece_fixed():
	check_win_condition()

func _on_restart_pressed() -> void:
	if selected_piece:
		selected_piece.set_selected(false)
		selected_piece = null
		logic_panel.visible = false
	get_tree().reload_current_scene()

func _on_home_pressed() -> void:
	if selected_piece:
		selected_piece.set_selected(false)
		selected_piece = null
		logic_panel.visible = false
	get_tree().change_scene_to_file("res://Main/MainMenu/MainMenu.tscn")

func _on_home_button_pressed() -> void:
	_on_home_pressed()

func _on_level_selector_pressed() -> void:
	if selected_piece:
		selected_piece.set_selected(false)
		selected_piece = null
		logic_panel.visible = false
	get_tree().change_scene_to_file("res://Main/LevelSelector/LevelSelector.tscn")

func _on_next_button_pressed() -> void:
	if selected_piece:
		selected_piece.set_selected(false)
		selected_piece = null
		logic_panel.visible = false
	get_tree().change_scene_to_file("res://Levels/Level 2/Level2.tscn")

func _on_retry_button_pressed() -> void:
	_on_restart_pressed()
