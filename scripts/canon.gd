extends CSGCylinder3D

const Ammo := preload("res://scenes/ammo.tscn")

@export var max_ammo_count = 10

@onready var spawn = $Marker3D
@onready var player: AudioStreamPlayer = get_node(^"AudioStreamPlayer")

var ammo_count = 0

func _init():
	ammo_count = max_ammo_count

func _unhandled_input(event):
	if event.is_action_pressed(&"shoot") and ammo_count > 0 and $CanonTimer.time_left == 0:
		Global.ammo_used += 1
		# TODO: play shoot sfx
		player.play()
		
		var ammo := Ammo.instantiate()
		get_owner().get_parent().add_child(ammo)
		ammo.global_position = spawn.global_position
		
		var dir = (Vector3.FORWARD * 50) - spawn.position
		var speed := 50
		ammo.apply_impulse(get_parent().global_basis * dir.normalized() * speed - spawn.position)
		
		ammo_count -= 1
		$CanonTimer.start()
		get_owner().remaining_ammo_changed.emit(ammo_count)


func reload(ammo_qty: int):
	ammo_count += ammo_qty
