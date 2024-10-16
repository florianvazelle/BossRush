class_name Boss
extends Node3D

const BlinkMaterial : ShaderMaterial= preload("res://resources/blink.tres")

var blink_activated: bool = false
var blink_timer: float = 0

@export var life = 10
@onready var blink_time: float = 2.0
@onready var weakpoint: Weakpoint = $Weakpoint

func _ready():
	weakpoint.connect("hit", hit)
	setup_blink_material(self)

func hit(damage: int) -> void:
	life -= damage
	# play hit animation
	blink()
	# TODO: play hit sfx
	print("hit")

func _process(delta):
	if life <= 0:
		dead()
	
	if blink_activated:
		if blink_timer <= 0:
			BlinkMaterial.set_shader_parameter("hit", false)
			blink_activated = false
		else:
			# decrease timer
			blink_timer -= delta

func setup_blink_material(root: Node):
	for child in root.get_children():
		if child is MeshInstance3D:
			child.set_material_overlay(BlinkMaterial)
		setup_blink_material(child)

func blink():
	BlinkMaterial.set_shader_parameter("hit", true)
	blink_activated = true
	# reset timer
	blink_timer = blink_time

func dead():
	# TODO: play dead animation
	# TODO: play dead sfx
	queue_free()
