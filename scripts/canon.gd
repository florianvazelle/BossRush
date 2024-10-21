extends CSGCylinder3D

const Ammo := preload("res://scenes/ammo.tscn")

@onready var spawn = $Marker3D
@export var max_ammo_count = 10

var ammo_count = 0

func _init():
	ammo_count = max_ammo_count

func _unhandled_input(event):
	print(ammo_count)
	if event.is_action_pressed(&"shoot") and ammo_count > 0 and $CanonTimer.time_left == 0:
		# TODO: play shoot sfx
		
		var ammo := Ammo.instantiate()
		get_owner().get_parent().add_child(ammo)
		ammo.global_position = spawn.global_position
		
		var target: Vector3 = to_global(spawn.position + Vector3.UP)
		var dir: Vector3 = spawn.global_position - target
		var speed := 20
		ammo.apply_impulse(dir.normalized() * speed)
		
		ammo_count -= 1
		$CanonTimer.start()

func reload(ammo_qty: int):
	ammo_count += ammo_qty
