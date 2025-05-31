extends Control

var current_piece = null

@onready var cb_up = $VBoxContainer/CheckBoxUp
@onready var cb_down = $VBoxContainer/CheckBoxDown
@onready var cb_left = $VBoxContainer/CheckBoxLeft
@onready var cb_right = $VBoxContainer/CheckBoxRight
@onready var cb_upleft = $VBoxContainer/CheckBoxUpLeft
@onready var cb_upright = $VBoxContainer/CheckBoxUpRight
@onready var cb_downleft = $VBoxContainer/CheckBoxDownLeft
@onready var cb_downright = $VBoxContainer/CheckBoxDownRight
@onready var apply_button = $ApplyButton

func _ready():
	randomize()  # Ensure randomness works
	apply_button.pressed.connect(Callable(self, "_on_ApplyButton_pressed"))
	visible = false  # Hide panel initially

func update_with_piece(piece):
	current_piece = piece
	visible = true

	if piece.name.to_lower().find("knight") != -1 and piece.is_corrupted:
		var dirs = ["up", "down", "left", "right", "up_left", "up_right", "down_left", "down_right"]
		dirs.shuffle()

		var corrupt_count = randi() % 4 + 2  # corrupt 2 to 5 directions

		# Start all directions as allowed
		for dir in dirs:
			piece.allowed_dirs[dir] = true

		# Corrupt random directions
		for i in range(corrupt_count):
			piece.allowed_dirs[dirs[i]] = false

	# Set checkboxes to reflect allowed_dirs
	cb_up.set_pressed(piece.allowed_dirs.get("up", false))
	cb_down.set_pressed(piece.allowed_dirs.get("down", false))
	cb_left.set_pressed(piece.allowed_dirs.get("left", false))
	cb_right.set_pressed(piece.allowed_dirs.get("right", false))
	cb_upleft.set_pressed(piece.allowed_dirs.get("up_left", false))
	cb_upright.set_pressed(piece.allowed_dirs.get("up_right", false))
	cb_downleft.set_pressed(piece.allowed_dirs.get("down_left", false))
	cb_downright.set_pressed(piece.allowed_dirs.get("down_right", false))

func _on_ApplyButton_pressed():
	if current_piece:
		current_piece.allowed_dirs["up"] = cb_up.is_pressed()
		current_piece.allowed_dirs["down"] = cb_down.is_pressed()
		current_piece.allowed_dirs["left"] = cb_left.is_pressed()
		current_piece.allowed_dirs["right"] = cb_right.is_pressed()
		current_piece.allowed_dirs["up_left"] = cb_upleft.is_pressed()
		current_piece.allowed_dirs["up_right"] = cb_upright.is_pressed()
		current_piece.allowed_dirs["down_left"] = cb_downleft.is_pressed()
		current_piece.allowed_dirs["down_right"] = cb_downright.is_pressed()

		current_piece.set_highlight(false)
		current_piece = null
		visible = false
