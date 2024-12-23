extends Node

@export var feet_path: NodePath

var footsteep_timer: float = 0
var footsteep_list: Dictionary = {}

var dont_repeat: int = 0

@onready var feet: RayCast3D = get_node(feet_path)
@onready var character: MovementController = get_owner()
@onready var player: AudioStreamPlayer = get_node(^"AudioStreamPlayer")


func _ready() -> void:
	randomize()

	footsteep_list = {
		&"grass":
		[
			preload("res://assets/sounds/sfx/footsteep/grass/0.ogg"),
			preload("res://assets/sounds/sfx/footsteep/grass/1.ogg"),
			preload("res://assets/sounds/sfx/footsteep/grass/2.ogg"),
			preload("res://assets/sounds/sfx/footsteep/grass/3.ogg"),
			preload("res://assets/sounds/sfx/footsteep/grass/4.ogg"),
			preload("res://assets/sounds/sfx/footsteep/grass/5.ogg"),
		],
		&"concrete":
		[
			preload("res://assets/sounds/sfx/footsteep/concrete/0.ogg"),
			preload("res://assets/sounds/sfx/footsteep/concrete/1.ogg"),
			preload("res://assets/sounds/sfx/footsteep/concrete/2.ogg"),
			preload("res://assets/sounds/sfx/footsteep/concrete/3.ogg"),
			preload("res://assets/sounds/sfx/footsteep/concrete/4.ogg"),
			preload("res://assets/sounds/sfx/footsteep/concrete/5.ogg"),
			preload("res://assets/sounds/sfx/footsteep/concrete/6.ogg"),
		],
	}


func _process(_delta) -> void:
	if footsteep_timer <= 0 and character.direction and feet.is_colliding():
		var collider = feet.get_collider()

		if collider:
			for g in collider.get_groups():
				if footsteep_list.has(g):
					var footsteep_sounds = footsteep_list[g]

					if len(footsteep_sounds) > 0:
						var audio: AudioStreamOggVorbis = footsteep_sounds[
							randi() % len(footsteep_sounds)
						]

						player.stream = audio
						player.play()

						var temp_accel: float = character.get_accel() + float(character.speed - 10) / 4.0
						footsteep_timer = 1 - (0.06 * temp_accel)
						break
	else:
		footsteep_timer -= _delta
