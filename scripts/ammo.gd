class_name Ammo
extends RigidBody3D

func _on_body_entered(body):
	if body is Weakpoint:
		body.hit_by_ammo(5)
	elif body is Boss:
		body.hit(1)
	# TODO: play explode animation
	# TODO: play explode sfx
	queue_free()
