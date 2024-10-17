extends Node

@export_node_path("CharacterBody3D") var controller_path: NodePath = ^"../"

@export var initial_life := 10

@onready var player: CharacterBody3D = get_node(controller_path)
@onready var life = initial_life


func hit(damage):
	life -= damage


func _process(delta):
	if life <= 0:
		dead()

	for index in player.get_slide_collision_count():
		var collision := player.get_slide_collision(index)
		var body := collision.get_collider()
		if body is Boss:
			hit(1)
			# TODO: add cooldown
		

func dead():
	print("dead")
