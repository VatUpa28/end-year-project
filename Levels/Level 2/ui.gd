extends CanvasLayer

var player_won=false #have to update this somewhere else in my code...probably level 1 code.
@onready var retry_button = $RetryButton
@onready var next_button = $NextButton
@onready var home_button = $HomeButton
func _ready():
	if retry_button and next_button: 
		retry_button.connect("piece_clicked", Callable(self, "on_retry_clicked"))
		next_button.connect("piece_clicked", Callable(self, "on_next_clicked"))
	

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
	
func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/MainMenu/MainMenu.tscn")

func show_lose():
	$WinLabel.visible=false
	$LoseLabel.visible=true
	
func show_win():
	$WinLabel.visible=true
	$LoseLabel.visible=false
