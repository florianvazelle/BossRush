extends Node

const DieSFX = preload("res://assets/sounds/sfx/hit/die1.ogg")

@export_node_path("CollisionObject3D") var body_path: NodePath = ^"../"

@export var initial_life := 10

@onready var body_node: CollisionObject3D = get_node(body_path)
@onready var life = initial_life

var cooldown_timer: float = 0

signal life_changed(new_life)

func apply_damage(damage: int) -> void:
	life -= damage
	life_changed.emit(life)


func _process(delta: float) -> void:
	if life <= 0:
		dead()
	
	if body_node is CharacterBody3D:
		if cooldown_timer <= 0:
			for index in body_node.get_slide_collision_count():
				var collision: KinematicCollision3D = body_node.get_slide_collision(index)
				var collider: Object = collision.get_collider()
				if collider is Boss:
					# TODO: add cooldown
					apply_damage(1)
					cooldown_timer = 2.0
		else:
			cooldown_timer -= delta

func dead() -> void:
	# TODO: play dead animation
	# TODO: play dead sfx
	if body_node is not CharacterBody3D:
		if body_node.enabled:
			body_node.enabled = false
			var audio_player = get_node(^"%AudioStreamPlayer")
			#audio_player.connect("finished", get_owner().queue_free)
			audio_player.stream = DieSFX
			audio_player.play()
			
			$"../Destruction".destroy()
	else:
		Global.player_is_dead = true
	
		#gzet_owner().queue_free()
