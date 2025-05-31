extends Panel

func show_win():
	$WinLabel.visible=true
	$LoseLabel.visible=false

func show_lose():
	$LoseLabel.visible=true
	$WinLabel.visible=false
