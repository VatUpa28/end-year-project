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
	if apply_button == null:
		print("ApplyButton node not found!")
	else:
		apply_button.pressed.connect(Callable(self, "_on_ApplyButton_pressed"))
	visible = false

func update_with_piece(piece):
	current_piece = piece
	visible = true

	print("LogicPanel: updating piece ", piece.name)

	var directions = ["up", "down", "left", "right", "up_left", "up_right", "down_left", "down_right"]

	for dir in directions:
		var val = piece.allowed_dirs.get(dir, false)
		print("Direction:", dir, "Value:", val, "Type:", typeof(val))

		# Defensive check: if not bool, print warning and fix
		if typeof(val) != TYPE_BOOL:
			print("Warning: allowed_dirs[", dir, "] is not bool but type ", typeof(val))
			val = false

		var toggle = null
		match dir:
			"up":
				toggle = cb_up
			"down":
				toggle = cb_down
			"left":
				toggle = cb_left
			"right":
				toggle = cb_right
			"up_left":
				toggle = cb_upleft
			"up_right":
				toggle = cb_upright
			"down_left":
				toggle = cb_downleft
			"down_right":
				toggle = cb_downright

		if toggle == null:
			print("ERROR: Toggle for ", dir, " is null!")
		else:
			print("Setting toggle for ", dir, " to ", val)
			toggle.set_pressed(val)


func _on_ApplyButton_pressed():
	if current_piece == null:
		print("Apply pressed but no current piece")
		return

	current_piece.allowed_dirs["up"] = cb_up.pressed
	current_piece.allowed_dirs["down"] = cb_down.pressed
	current_piece.allowed_dirs["left"] = cb_left.pressed
	current_piece.allowed_dirs["right"] = cb_right.pressed
	current_piece.allowed_dirs["up_left"] = cb_upleft.pressed
	current_piece.allowed_dirs["up_right"] = cb_upright.pressed
	current_piece.allowed_dirs["down_left"] = cb_downleft.pressed
	current_piece.allowed_dirs["down_right"] = cb_downright.pressed

	# Corrupted means any direction set to false (adjust logic if needed)
	var corrupted = false
	for value in current_piece.allowed_dirs.values():
		if typeof(value) == TYPE_BOOL and value == false:
			corrupted = true
			break

	current_piece.mark_corrupted(corrupted)
	current_piece.set_meta("corrupted", corrupted)

	print("Applied changes. Piece ", current_piece.name, " corrupted: ", corrupted)

	visible = false
