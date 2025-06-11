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
@onready var lose_panel := $UI/LosePanel
@onready var reset_button := $UI/HBoxContainer/Restart
@onready var home_button := $UI/HBoxContainer/Home

const GRID_SIZE = 8
const NUM_PIECES = 12
const CORRUPTION_CHANCE = 0.4

var selected_piece = null
var win_shown = false

func _ready():
	randomize()
	generate_random_board()

func generate_random_board():
	for child in get_children():
		if child is Area2D and child.has_method("mark_corrupted"):
			child.queue_free()

	var used_positions: Array = []
	
	const MAX_PIECES = {
		"white" : {
			"king" : 1,
			"queen" : 1,
			"rook" : 2,
			"bishop" : 2,
			"knight" : 2,
			"pawn" : 8
		},
		"black" : {
			"king" : 1,
			"queen" : 1,
			"rook" : 2,
			"bishop" : 2,
			"knight" : 2,
			"pawn" : 8
		}
	}
	
	var current_piece_counts = {
		"white" : {
			"king" : 0,
			"queen" : 0,
			"rook" : 0,
			"bishop" : 0,
			"knight" : 0,
			"pawn" : 8
		},
		"black" : {
			"king" : 0,
			"queen" : 0,
			"rook" : 0,
			"bishop" : 0,
			"knight" : 0,
			"pawn" : 0
		}
	}
	
	var attempts = 0
	var any_corrupted = false
	
	while used_positions.size() < NUM_PIECES and attempts < 1000:
		attempts += 1

		var piece_scene = piece_scenes[randi() % piece_scenes.size()]		
		var scene_path = piece_scene.resource_path
		var piece_name = scene_path.get_file().get_basename()  # e.g. "white-rook"
		
		var parts = piece_name.split("-")
		if parts.size() < 2:
			continue
		
		var color = parts[0]
		var piece_type = parts[1] 
		
		if current_piece_counts[color][piece_type] < MAX_PIECES[color][piece_type]:
			current_piece_counts[color][piece_type] += 1

			var piece = piece_scene.instantiate()

			var cell = get_random_grid_position(used_positions)
			used_positions.append(cell)

			var tile_pos = board.map_to_local(cell)
			var world_pos = board.to_global(tile_pos)

			add_child(piece)
			piece.global_position = world_pos

			# For level 2, do NOT corrupt or highlight in red.
			# So, skip corrupt_piece(piece) here

			piece.connect("piece_clicked", Callable(self, "on_piece_clicked"))

func corrupt_piece(piece):
	piece.allowed_dirs = get_default_dirs(piece.name)
	piece.set_original_dirs()

	var dirs = piece.allowed_dirs.keys()
	dirs.shuffle()
	var corrupt_count = randi() % 2 + 1
	for i in range(corrupt_count):
		piece.allowed_dirs[dirs[i]] = false

	# Now check if corrupted
	if not piece.is_directions_correct():
		piece.mark_corrupted(true)
	else:
		piece.mark_corrupted(false)
		
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
	elif piece_name.contains("queen"):
		for dir in dirs.keys():
			dirs[dir] = true
	elif piece_name.contains("king"):
		for dir in dirs.keys():
			dirs[dir] = true
	elif piece_name.contains("knight"):
		# Knights move in L-shapes; not handled by this system
		pass

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
	while true:
		var x = randi() % GRID_SIZE
		var y = randi() % GRID_SIZE
		var cell = Vector2i(x, y)
		if not used.has(cell):
			return cell
	return Vector2i(0, 0)

# No corrupt_piece function call since pieces aren't corrupted in this level

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
		print("✅ WIN CONDITION MET!") #why do we need this
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
