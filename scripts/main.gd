extends Node3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Handle debug arguments
	var args := OS.get_cmdline_user_args()
	if "--win" in args:
		Global.set_score(self)
	elif "--dead" in args:
		Global.player_is_dead = true
		Global.set_score(self)
	elif "--1hp" in args:
		Global.debug_1hp = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"quit"):
		get_tree().quit()
	
	if event.is_action_pressed(&"change_mouse_input"):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta):
	if Global.player_is_dead:
		Global.set_score(self)
		
	for altar in get_tree().get_nodes_in_group("altar"):
		if not altar.triggered:
			return
	if len(get_tree().get_nodes_in_group("boss")) == 0:
		Global.set_score(self)
	
