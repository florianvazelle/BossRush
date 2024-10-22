class_name Zombie
extends Boss


@onready var anim: AnimationPlayer = $"character-zombie/AnimationPlayer"

func _ready():
	super._ready()
	anim.play("holding-both")
