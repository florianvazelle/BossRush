extends Node

@export_node_path("CollisionObject3D") var body_path: NodePath = ^"../"

@export var initial_life := 10

@onready var body_node: CollisionObject3D = get_node(body_path)
@onready var life = initial_life


func apply_damage(damage: int) -> void:
	life -= damage


func _process(delta: float) -> void:
	if life <= 0:
		dead()
	
	if body_node is CharacterBody3D:
		for index in body_node.get_slide_collision_count():
			var collision: KinematicCollision3D = body_node.get_slide_collision(index)
			var collider: Object = collision.get_collider()
			if collider is Boss:
				apply_damage(1)
				# TODO: add cooldown


func dead() -> void:
	# TODO: play dead animation
	# TODO: play dead sfx
	queue_free()
