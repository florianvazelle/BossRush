extends Node


func handle_end_hud():
	$UI/VBoxContainer2.hide()
	$UI/VBoxContainer.hide()
	$Player/Head/Canon/CenterContainer.hide()
	
	$UI/Win/VBoxContainer/TimeRow/Value.set_text("Time: %02d:%02d" % [played_time / 60, fmod(played_time, 60)])
	$UI/Win/VBoxContainer/AmmoRow/Value.set_text(ammo_used)
	$UI/Win/VBoxContainer/WeakpointRow/Value.set_text(weakpoint_hit)
	print(get_score())
	
	if player_is_dead:
		# Game Over
		$UI/Win/ColorRect.set_color(Color("#00000071"))
		$UI/GameOver/CenterContainer/Label.set_text("You lose, try again..")
	else:
		$UI/Win/ColorRect.set_color(Color("#ffffff86"))
		$UI/GameOver/CenterContainer/Label.set_text("You defeat all bosses !")
	get_tree().paused = true
