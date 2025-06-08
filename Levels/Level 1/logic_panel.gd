extends Control

var current_piece = null
var level_node = null

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
	if apply_button:
		apply_button.pressed.connect(_on_ApplyButton_pressed)
	visible = false

func update_with_piece(piece):
	current_piece = piece
	visible = true

	print("🧠 LogicPanel: updating piece ", piece.name)

	var directions = {
		"up": cb_up,
		"down": cb_down,
		"left": cb_left,
		"right": cb_right,
		"up_left": cb_upleft,
		"up_right": cb_upright,
		"down_left": cb_downleft,
		"down_right": cb_downright
	}

	# Ensure all directions exist
	for dir in directions.keys():
		if not piece.allowed_dirs.has(dir):
			piece.allowed_dirs[dir] = true  # Default to true if not present

		var val = piece.allowed_dirs.get(dir, true)
		var checkbox = directions[dir]

		if checkbox == null:
			print("❌ ERROR: Checkbox for", dir, "is null")
			continue

		if typeof(checkbox) != TYPE_OBJECT or not checkbox is CheckBox:
			print("❌ ERROR: Node for", dir, "is not a CheckBox! Got:", typeof(checkbox))
			continue

		if typeof(val) != TYPE_BOOL:
			print("❌ ERROR: Value for", dir, "is NOT a bool! Got:", typeof(val), " Value:", val)
			val = true  # default/fallback

		checkbox.set_pressed(val)

func _on_ApplyButton_pressed():
	if current_piece == null:
		print("⚠️ Apply pressed but no current piece selected")
		return

	current_piece.allowed_dirs["up"] = cb_up.is_pressed()
	current_piece.allowed_dirs["down"] = cb_down.is_pressed()
	current_piece.allowed_dirs["left"] = cb_left.is_pressed()
	current_piece.allowed_dirs["right"] = cb_right.is_pressed()
	current_piece.allowed_dirs["up_left"] = cb_upleft.is_pressed()
	current_piece.allowed_dirs["up_right"] = cb_upright.is_pressed()
	current_piece.allowed_dirs["down_left"] = cb_downleft.is_pressed()
	current_piece.allowed_dirs["down_right"] = cb_downright.is_pressed()

	# 🔍 Compare allowed_dirs to original_dirs
	var corrupted = false
	for dir in current_piece.allowed_dirs.keys():
		if current_piece.allowed_dirs[dir] != current_piece.original_dirs.get(dir, true):
			corrupted = true
			break

	current_piece.mark_corrupted(corrupted)
	current_piece.set_meta("corrupted", corrupted)

	print("✅ Applied changes to piece ", current_piece.name, "| Corrupted:", corrupted)

	if level_node != null:
		level_node.on_piece_fixed()
	else:
		print("❌ ERROR: Could not find Level1 node to check win condition")

	visible = false
	current_piece.set_selected(false)
	current_piece = null
