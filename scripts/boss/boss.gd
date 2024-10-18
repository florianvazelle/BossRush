class_name Boss
extends RigidBody3D

var Patterns: Array[Pattern] = [
	preload("res://scenes/pattern/stun_attack.tscn").instantiate(),
	preload("res://scenes/pattern/forward_attack.tscn").instantiate(),
]

enum State {NOOP, SETUP_PATTERN, ATTACK}

@export var enabled := true

var current_pattern: Pattern
var pattern_cooldown: float = 0
var state: State
var current_target: Vector3

@onready var weakpoint: Weakpoint = $Weakpoint
@onready var blink_component = $BlinkComponent
@onready var life_component = $LifeComponent
@onready var player = get_tree().get_nodes_in_group(&"player")[0]


func _ready():
	weakpoint.connect("hit", hit)
	weakpoint.connect("hit", blink_component.blink)
	weakpoint.connect("hit", life_component.apply_damage)

	set_state(State.SETUP_PATTERN)


func hit(damage: int) -> void:
	# cancel current action and wait 4s
	set_state(State.NOOP)
	pattern_cooldown = 4.0
	
	apply_central_impulse((global_position - current_target).normalized() * 20)
	
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
	if not enabled:
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
