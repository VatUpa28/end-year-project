extends Control

var current_piece = null
var level_node = null

@onready var le_up = $VBoxContainer/LineEditUp
@onready var le_down = $VBoxContainer/LineEditDown
@onready var le_left = $VBoxContainer/LineEditLeft
@onready var le_right = $VBoxContainer/LineEditRight
@onready var le_upleft = $VBoxContainer/LineEditUpLeft
@onready var le_upright = $VBoxContainer/LineEditUpRight
@onready var le_downleft = $VBoxContainer/LineEditDownLeft
@onready var le_downright = $VBoxContainer/LineEditDownRight

@onready var apply_button = $ApplyButton
#@onready var code_display = $VBoxContainer/CodeDisplay

func _ready():
	level_node = get_node("res://Levels/Level 2/level_2.gd") 

	if apply_button:
		apply_button.pressed.connect(_on_ApplyButton_pressed)

	for le in [
		le_up, le_down, le_left, le_right,
		le_upleft, le_upright, le_downleft, le_downright
	]:
		if le:
			le.connect("text_changed", Callable(self, "_update_code_display"))
	visible = false


func update_with_piece(piece):
	current_piece = piece
	visible = true

	print("🧠 LogicPanel: updating piece ", piece.name)

	le_up.text = str(piece.allowed_dirs.get("up", false))
	le_down.text = str(piece.allowed_dirs.get("down", false))
	le_left.text = str(piece.allowed_dirs.get("left", false))
	le_right.text = str(piece.allowed_dirs.get("right", false))
	le_upleft.text = str(piece.allowed_dirs.get("up_left", false))
	le_upright.text = str(piece.allowed_dirs.get("up_right", false))
	le_downleft.text = str(piece.allowed_dirs.get("down_left", false))
	le_downright.text = str(piece.allowed_dirs.get("down_right", false))

	_update_code_display()

func _on_ApplyButton_pressed():
	if current_piece == null:
		print("⚠️ Apply pressed but no current piece selected")
		return

	current_piece.allowed_dirs["up"] = parse_bool(le_up.text)
	current_piece.allowed_dirs["down"] = parse_bool(le_down.text)
	current_piece.allowed_dirs["left"] = parse_bool(le_left.text)
	current_piece.allowed_dirs["right"] = parse_bool(le_right.text)
	current_piece.allowed_dirs["up_left"] = parse_bool(le_upleft.text)
	current_piece.allowed_dirs["up_right"] = parse_bool(le_upright.text)
	current_piece.allowed_dirs["down_left"] = parse_bool(le_downleft.text)
	current_piece.allowed_dirs["down_right"] = parse_bool(le_downright.text)

	print("✅ Applied changes to piece ", current_piece.name)

	if level_node != null:
		level_node.on_piece_fixed()
	else:
		print("❌ ERROR: Could not find Level node to check win condition")

	visible = false
	current_piece.set_selected(false)
	current_piece = null

func parse_bool(text: String) -> bool:
	var lower = text.to_lower().strip_edges()
	return lower == "true" or lower == "1" or lower == "yes"

func _update_code_display():
	var code = "allowed_dirs = {\n"
	code += "\t\"up\": " + str(parse_bool(le_up.text)) + ",\n"
	code += "\t\"down\": " + str(parse_bool(le_down.text)) + ",\n"
	code += "\t\"left\": " + str(parse_bool(le_left.text)) + ",\n"
	code += "\t\"right\": " + str(parse_bool(le_right.text)) + ",\n"
	code += "\t\"up_left\": " + str(parse_bool(le_upleft.text)) + ",\n"
	code += "\t\"up_right\": " + str(parse_bool(le_upright.text)) + ",\n"
	code += "\t\"down_left\": " + str(parse_bool(le_downleft.text)) + ",\n"
	code += "\t\"down_right\": " + str(parse_bool(le_downright.text)) + "\n"
	code += "}"
	#code_display.text = code
