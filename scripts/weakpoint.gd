class_name Weakpoint
extends StaticBody3D

signal hit

# need to be align on blink_time in boss.gd ?
@export var invulnerability_time: float = 2.0

var invulnerability_activated: bool = false
var invulnerability_timer: float = 0

func hit_by_ammo(damage: int):
	var time_now = Time.get_unix_time_from_system()
	if not invulnerability_activated:
		emit_signal("hit", damage)
		invulnerability_activated = true
		# reset timer
		invulnerability_timer = invulnerability_time
	else:
		print("invulnerability")


func _process(delta):
	if invulnerability_timer <= 0:
		invulnerability_activated = false
	else:
		# decrease timer
		invulnerability_timer -= delta
