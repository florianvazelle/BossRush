class_name Boss
extends RigidBody3D

const BlinkMaterial : ShaderMaterial = preload("res://resources/blink.tres")

var Patterns: Array[Pattern] = [
	preload("res://scenes/pattern/stun_attack.tscn").instantiate(),
	preload("res://scenes/pattern/forward_attack.tscn").instantiate(),
]

enum State {NOOP, SETUP_PATTERN, ATTACK}

var blink_activated: bool = false
var blink_timer: float = 0

var current_pattern: Pattern
var pattern_cooldown: float = 0
var state: State
var current_target: Vector3

@export var life = 10
@onready var blink_time: float = 2.0
@onready var weakpoint: Weakpoint = $Weakpoint
@onready var player = get_tree().get_nodes_in_group(&"player")[0]


func _ready():
	weakpoint.connect("hit", hit)
	setup_blink_material(self)
	set_state(State.SETUP_PATTERN)

func hit(damage: int) -> void:
	life -= damage
	
	# cancel current action and wait 4s
	set_state(State.NOOP)
	pattern_cooldown = 4.0
	
	apply_central_impulse((global_position - current_target).normalized() * 20)
	
	# play hit animation
	blink()
	# TODO: play hit sfx
	print("hit")
	
	
func set_state(new_state):
	# set new state to ATTACK
	if new_state == State.ATTACK: 
		state = State.ATTACK
		pattern_cooldown = 0
		linear_velocity = Vector3.ZERO
		current_target = player.global_position
		
	elif new_state == State.SETUP_PATTERN: 
		state = State.SETUP_PATTERN
		current_pattern = Patterns[randi() % Patterns.size()]
		current_target = player.global_position
		current_target.y = 0

	# set new state to NOOP
	elif new_state == State.NOOP: 
		state = State.NOOP
		pattern_cooldown = 0
		current_pattern = null
		linear_velocity = Vector3.ZERO

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
		
		return

	if state == State.NOOP:
		if pattern_cooldown > 0.0:
			set_state(State.SETUP_PATTERN)

	elif state == State.SETUP_PATTERN:
		if global_position.distance_to(current_pattern.start_pos(current_target)) < 2.5:
			set_state(State.ATTACK)
			
		apply_central_impulse((current_pattern.start_pos(current_target) - global_position).normalized() * delta * 10)

	elif state == State.ATTACK:
		# apply the pattern
		apply_central_impulse(current_pattern.attack_direction(current_target).normalized() * delta * 10)
		
		if pattern_cooldown > 2.5:
			set_state(State.NOOP)

	pattern_cooldown += delta


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
