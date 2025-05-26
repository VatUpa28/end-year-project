extends Area2D

@export var allowed_dirs = {
	"up": true,
	"down": true,
	"left": true,
	"right": true
}

var selected = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		selected = !selected
		print("-----")
		print("Piece clicked!")
		print("Selected: ", selected)
		print("Allowed Directions: ", allowed_dirs)
