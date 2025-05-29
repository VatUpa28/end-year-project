extends Area2D

# Declare allowed directions dictionary
var allowed_dirs: Dictionary = {
	"up": false,
	"down": false,
	"left": false,
	"right": false,
	"up_left": false,
	"up_right": false,
	"down_left": false,
	"down_right": false
}

var selected = false
@onready var logic_panel = get_node_or_null("UI/LogicPanel")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		selected = !selected
		if selected and logic_panel:
			logic_panel.show_for(self)
		elif logic_panel:
			logic_panel.visible = false
