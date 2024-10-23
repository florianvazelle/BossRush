class_name Altar
extends Interactable

@export var text: String
@export var boss: PackedScene

func interact():
	# Summon boss
	var boss = boss.instantiate()
	add_child(boss)
	boss.global_position.y = 5
	boss.get_children()[0].enabled = true
