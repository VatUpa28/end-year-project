extends CanvasLayer
@onready var timer_label = $TimerDisplayLabel
@onready var level_timer = $LevelTimer
func _ready() -> void:
	_update_timer_label()
	
func _update_timer_label() -> void:
	var time_left=int(level_timer.time_left)
	timer_label.text = "Time Remaining: %d" % time_left 
	
func _on_level_timer_timeout() -> void:
	timer_label.text = "Time's up!"
	get_tree().get_root().get_node("CanvasLayer/WinLosePanel").call("show_lose")
	
func _onUITimer_timeout():
	_update_timer_label()

	
	
