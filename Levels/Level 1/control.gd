extends Control

@onready var timer_label = $TimerLabel
@onready var game_timer = $GameTimer
@onready var lose_panel: CanvasItem = get_node("../UI/LosePanel")

var time_left = 300

func _ready():
	update_timer_label()
	game_timer.wait_time = 1.0
	game_timer.timeout.connect(_on_timer_timeout)
	game_timer.start()

	if not timer_label:
		print("Error: TimerLabel not found")
	if not game_timer:
		print("Error: GameTimer not found")
	if not lose_panel:
		print("Error: LosePanel not found")

func _on_timer_timeout():
	time_left -= 1
	update_timer_label()
	if time_left <= 0:
		game_timer.stop()
		lose_panel.visible = true

func update_timer_label():
	var minutes = time_left / 60
	var seconds = time_left % 60
	timer_label.text = "%02d:%02d" % [int(minutes), seconds]
