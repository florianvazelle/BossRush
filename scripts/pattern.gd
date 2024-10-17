class_name Pattern
extends Node3D


@export var start: Marker3D
@export var end: Marker3D


func attack_direction(player_pos: Vector3) -> Vector3:
	return end_pos(player_pos) - start_pos(player_pos)


func start_pos(player_pos: Vector3):
	return player_pos + start.position * 2


func end_pos(player_pos: Vector3):
	return player_pos + end.position * 2
