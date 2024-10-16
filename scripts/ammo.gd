class_name Ammo
extends RigidBody3D

@export var damage: int = 1

func _on_body_entered(body):
	if body is Weakpoint:
		body.hit_by_ammo(damage)
