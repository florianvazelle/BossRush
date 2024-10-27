class_name Interactable
extends StaticBody3D

const HighlighMaterial = preload("res://resources/interactable.tres")

@export var text: String = ""

func _ready() -> void:
	setup_highlight_material(self) 


func is_interactable():
	return false


func interact():
	pass


func setup_highlight_material(root: Node):
	for child in root.get_children():
		if child is MeshInstance3D:
			child.set_material_overlay(HighlighMaterial)
		setup_highlight_material(child)


func remove_highlight_material(root: Node):
	for child in root.get_children():
		if child is MeshInstance3D:
			child.set_material_overlay(null)
		remove_highlight_material(child)
