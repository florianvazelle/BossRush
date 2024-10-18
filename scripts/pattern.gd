class_name Pattern
extends Node3D


@export var pattern_name: String
@export var start: Marker3D
@export var end: Marker3D


func attack_direction(world: Transform3D) -> Vector3:
	return end_pos(world) - start_pos(world)


func start_pos(world: Transform3D) -> Vector3:
	return world * start.position


func end_pos(world: Transform3D) -> Vector3:
	return world * end.position
