extends Area3D

signal ReloadPlayer(quantity)

@export var reload_scene: PackedScene
@export var max_concurrent_reloads = 5

var reload_count = 0

func _on_timer_spawn_pumpkin_timeout() -> void:
	if reload_count < max_concurrent_reloads:
		var spawn_size = $CollisionShape3D.shape.size
		var spawn_center = position
		var x = randi_range(spawn_center.x - spawn_size.x/2, spawn_center.x + spawn_size.x/2)
		var z = randi_range(spawn_center.z - spawn_size.z/2, spawn_center.z + spawn_size.z/2)
		var reload_position = global_position + Vector3(x,-0.5,z)
		var pumpkin = reload_scene.instantiate()
		pumpkin.position = reload_position
		add_child(pumpkin)
		reload_count += 1
		
		pumpkin.ReloadTaken.connect(_on_reload_taken)

func _on_reload_taken() -> void:
	ReloadPlayer.emit(5)
