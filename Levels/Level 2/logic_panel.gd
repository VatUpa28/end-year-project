extends Control

var current_piece = null
var level_node = null  # Reference to the level node (set from level script)

var allowed_dirs = {
	"up": false,
	"down": false,
	"left": false,
	"right": false,
	"up_left": false,
	"up_right": false,
	"down_left": false,
	"down_right": false
}

@onready var le_up = $VBoxContainer/LineEditUp
@onready var le_down = $VBoxContainer/LineEditDown
@onready var le_left = $VBoxContainer/LineEditLeft
@onready var le_right = $VBoxContainer/LineEditRight
@onready var le_upleft = $VBoxContainer/LineEditUpLeft
@onready var le_upright = $VBoxContainer/LineEditUpRight
@onready var le_downleft = $VBoxContainer/LineEditDownLeft
@onready var le_downright = $VBoxContainer/LineEditDownRight

@onready var code_display = $VBoxContainer/CodeDisplay
@onready var apply_button = $ApplyButton

func _ready():
	apply_button.pressed.connect(Callable(self, "_on_ApplyButton_pressed"))

	# Connect all LineEdits so when text changes, code updates
	le_up.connect("text_changed", Callable(self, "_update_code_display"))
	le_down.connect("text_changed", Callable(self, "_update_code_display"))
	le_left.connect("text_changed", Callable(self, "_update_code_display"))
	le_right.connect("text_changed", Callable(self, "_update_code_display"))
	le_upleft.connect("text_changed", Callable(self, "_update_code_display"))
	le_upright.connect("text_changed", Callable(self, "_update_code_display"))
	le_downleft.connect("text_changed", Callable(self, "_update_code_display"))
	le_downright.connect("text_changed", Callable(self, "_update_code_display"))

	visible = false

func update_with_piece(piece):
	current_piece = piece
	visible = true

	if piece.allowed_dirs == null:
		piece.allowed_dirs = allowed_dirs.duplicate()

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
	if current_piece:
		current_piece.allowed_dirs["up"] = parse_bool(le_up.text)
		current_piece.allowed_dirs["down"] = parse_bool(le_down.text)
		current_piece.allowed_dirs["left"] = parse_bool(le_left.text)
		current_piece.allowed_dirs["right"] = parse_bool(le_right.text)
		current_piece.allowed_dirs["up_left"] = parse_bool(le_upleft.text)
		current_piece.allowed_dirs["up_right"] = parse_bool(le_upright.text)
		current_piece.allowed_dirs["down_left"] = parse_bool(le_downleft.text)
		current_piece.allowed_dirs["down_right"] = parse_bool(le_downright.text)

		current_piece.set_selected(false)
		current_piece = null
		visible = false

func parse_bool(text: String) -> bool:
	var lower_text = text.to_lower().strip_edges()
	return lower_text == "true" or lower_text == "1" or lower_text == "yes"

func _update_code_display():
	# Build the GDScript code snippet string
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
