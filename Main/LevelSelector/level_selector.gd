extends Node

func _on_level_1_selector_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level 1/Level1.tscn")

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/MainMenu/MainMenu.tscn")
