extends Node

@onready var start_time = Time.get_unix_time_from_system()
var player_is_dead: bool = false

var ammo_used: int = 0
var weakpoint_hit: int = 0
var played_time: float

var max_played_time := 10 * 60  # 10 minutes
var max_ammo_used := 15 + 37 + 26  # one ammo for each life point
var max_weakpoint_hit := floori(float(max_ammo_used) / 4.0)  # max_ammo_used / 4


func get_score():
	var score
	if player_is_dead:
		score = 0
	else:
		score = (
			(float(max_played_time - played_time) / float(max_played_time)) * 0.4 + 
			(float(max_ammo_used - ammo_used) / float(max_ammo_used)) * 0.2 + 
			(float(weakpoint_hit) / float(max_weakpoint_hit)) * 0.4
		)
		
	if score >= 0.9:
		return "S"
	elif score >= 0.8:
		return "A"
	elif score >= 0.7:
		return "B"
	elif score >= 0.6:
		return "C"
	elif score >= 0.5:
		return "D"
	elif score >= 0.4:
		return "E"
	elif score >= 0.3:
		return "F"
	elif score >= 0.2:
		return "G"
	else:
		return "H"


func set_score(main):
	var end_time = Time.get_unix_time_from_system()
	played_time = end_time - start_time
	
	main.get_node("UI/VBoxContainer2").hide()
	main.get_node("UI/VBoxContainer").hide()
	main.get_node("Player/Head/Canon/CenterContainer").hide()
	
	main.get_node("UI/EndPanel/CenterContainer/VBoxContainer/TimeRow/Value").set_text("%02d:%02d" % [played_time / 60, fmod(played_time, 60)])
	main.get_node("UI/EndPanel/CenterContainer/VBoxContainer/AmmoRow/Value").set_text(str(ammo_used))
	main.get_node("UI/EndPanel/CenterContainer/VBoxContainer/WeakpointRow/Value").set_text(str(weakpoint_hit))
	main.get_node("UI/EndPanel/CenterContainer/VBoxContainer/Score/Value").set_text(get_score())
	
	if player_is_dead:
		# Game Over
		main.get_node("UI/EndPanel/Advices").show()
		main.get_node("UI/EndPanel/ColorRect").set_color(Color("#00000071"))
		main.get_node("UI/EndPanel/CenterContainer/VBoxContainer/Label").set_text("You lose, try again..")
	else:
		main.get_node("AudioStreamPlayer").play()

		main.get_node("UI/EndPanel/ColorRect").set_color(Color("#ffffff86"))
		main.get_node("UI/EndPanel/CenterContainer/VBoxContainer/Label").set_text("You defeat all bosses !")
	
	main.get_node("UI/EndPanel").show()
	get_tree().paused = true
