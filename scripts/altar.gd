class_name Altar
extends Interactable

var triggered: bool = false

@export var boss: PackedScene

@onready var audio_player = $"../AudioStreamPlayer"

func _ready():
	text = "Summon"

func is_interactable():
	return not triggered


func interact():
	if triggered:
		return

	triggered = true

	# Summon boss
	audio_player.play()
	var boss = boss.instantiate()
	add_child(boss)
	boss.global_position.y = 5
	boss.get_children()[0].enabled = true