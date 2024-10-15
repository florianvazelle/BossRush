extends CSGCylinder3D

const Ammo := preload("res://scenes/ammo.tscn")

@onready var spawn = $Marker3D

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_A:
					var ammo := Ammo.instantiate()
					get_owner().get_parent().add_child(ammo)
					ammo.global_position = spawn.global_position
					
					var target: Vector3 = to_global(spawn.position + Vector3.UP)
					var dir: Vector3 = spawn.global_position - target
					var speed := 15
					ammo.apply_impulse(dir.normalized() * speed)
