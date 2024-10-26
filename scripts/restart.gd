extends Node


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_R:
					get_tree().paused = false
					Loading.load_scene("res://scenes/main.tscn", true)
				KEY_ESCAPE:
					get_tree().quit()
