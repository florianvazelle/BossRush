class_name Boss
extends RigidBody3D

var Patterns: Array[Pattern] = [
	# Charge (maybe made AoE?)
	preload("res://scenes/pattern/stun_attack.tscn").instantiate(),
	preload("res://scenes/pattern/stun_attack_variation.tscn").instantiate(),
	preload("res://scenes/pattern/forward_attack.tscn").instantiate(),
]

enum State {NOOP, SETUP_PATTERN, ATTACK}

@export var enabled := true

var current_pattern: Pattern
var pattern_cooldown: float = 0
var state: State
var pattern_transform: Transform3D

@onready var weakpoint: Weakpoint = $Weakpoint
@onready var blink_component = $BlinkComponent
@onready var life_component = $LifeComponent
@onready var player: Node3D = get_tree().get_nodes_in_group(&"player")[0]
@onready var debug_state_label: Label3D = $DebugStateLabel


func _ready():
	weakpoint.connect("hit", hit)
	weakpoint.connect("hit", blink_component.blink)
	weakpoint.connect("hit", life_component.apply_damage)

	set_state(State.SETUP_PATTERN)


func hit(damage: int) -> void:
	# cancel current action and wait 4s
	set_state(State.NOOP)
	pattern_cooldown = 4.0
	
	apply_central_impulse((global_position - player.global_position).normalized() * 20)
	
	# TODO: play hit sfx
	print("hit")
	
	
func set_state(new_state):
	# set new state to ATTACK
	if new_state == State.ATTACK: 
		state = State.ATTACK
		pattern_cooldown = 0
		linear_velocity = Vector3.ZERO
		
		# Update the matrix to apply to the pattern
		var current_target := player.global_position
		current_target.y = 0
		pattern_transform.origin = current_target

		# Made the boss looking to the player
		var dest := current_pattern.end_pos(pattern_transform)
		look_at(Vector3(dest.x, global_position.y, dest.z), Vector3.UP, true)
		
	elif new_state == State.SETUP_PATTERN: 
		state = State.SETUP_PATTERN
		current_pattern = Patterns[randi() % Patterns.size()]
		
		# Compute the "world matrix" to apply to the pattern
		# This is usefull to always focus the player and made some variation with the rotation
		var current_target := player.global_position
		current_target.y = 0
		pattern_transform = Transform3D(Basis(Vector3.UP, randf_range(0, TAU)), current_target)
		
		# Made the boss looking to the player
		var dest := current_pattern.start_pos(pattern_transform)
		look_at(Vector3(dest.x, global_position.y, dest.z), Vector3.UP, true)

	# set new state to NOOP
	elif new_state == State.NOOP: 
		state = State.NOOP
		pattern_cooldown = 0
		current_pattern = null
		linear_velocity = Vector3.ZERO


func _process(delta):
	if not enabled:
		return
		
	if debug_state_label != null:
		if state == State.ATTACK: 
			debug_state_label.set_text("Attack (%s)" % current_pattern.pattern_name)
		elif state == State.SETUP_PATTERN: 
			debug_state_label.set_text("Prepare Attack (%s)" % current_pattern.pattern_name)
		else: 
			debug_state_label.set_text("NOOP")
	
	if state == State.NOOP:
		if pattern_cooldown > 0.0:
			set_state(State.SETUP_PATTERN)

	elif state == State.SETUP_PATTERN:
		if global_position.distance_to(current_pattern.start_pos(pattern_transform)) < 2.5:
			set_state(State.ATTACK)

		apply_central_impulse((current_pattern.start_pos(pattern_transform) - global_position).normalized() * delta * 10)

	elif state == State.ATTACK:
		# apply the pattern
		apply_central_impulse(current_pattern.attack_direction(pattern_transform).normalized() * delta * 10)
		
		if pattern_cooldown > 2.5:
			set_state(State.NOOP)

	pattern_cooldown += delta
