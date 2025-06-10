extends Node

func _on_start_button_pressed() -> void:
	$Tap.play()
	await get_tree().create_timer(0.075).timeout
	get_tree().change_scene_to_file("res://Main/LevelSelector/LevelSelector.tscn")

func _on_quit_button_pressed() -> void:
	$Tap.play()
	await get_tree().create_timer(0.075).timeout
	get_tree().quit()
