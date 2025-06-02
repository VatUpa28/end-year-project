extends Panel

var player_won=false #have to update this somewhere else in my code...probably level 1 code.

func _ready():
	$RetryButton.connect("piece_clicked", Callable(self, "on_retry_clicked"))
	$NextButton.connect("piece_clicked", Callable(self, "on_next_clicked"))

func _on_next_pressed() -> void:
	if player_won:
		if get_tree().current_scene.name == "Level1":
			get_tree().change_scene_to_file("res://Levels/Level 2/Level2.tscn")
		elif get_tree().current_scene.name == "Level2":
			get_tree().change_scene_to_file("res://Levels/Level 3/Level3.tscn")
	else:
		print("You haven't won yet!")

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func show_win():
	$WinLabel.visible=true
	$LoseLabel.visible=false

func show_lose():
	$LoseLabel.visible=true
	$WinLabel.visible=false
