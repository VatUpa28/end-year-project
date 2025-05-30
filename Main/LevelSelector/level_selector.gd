extends Node

func _on_level_1_selector_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level 1/Level1.tscn")


func _on_level_2_selector_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level 2/Level2.tscn")
