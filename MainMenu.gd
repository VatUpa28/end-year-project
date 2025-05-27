extends Node


func _on_start_button_pressed() -> void:
	get_tree().change_scene("res://Main.tscn")
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()
