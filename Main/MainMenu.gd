extends Node

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level 1/Level1.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
