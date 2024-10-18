extends Area3D

signal ReloadTaken(ammo_quantity)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed(&"interact") and has_overlapping_bodies() and $VisibilityNotifier.is_on_screen():
		if $TakeReloadTimer.is_stopped():
			$TakeReloadTimer.start()
	else:
		$TakeReloadTimer.stop()
	


func _on_take_reload_timer_timeout() -> void:
	ReloadTaken.emit(5)
	queue_free()
