class_name InteractRay
extends RayCast3D

const E = preload("res://addons/controller_icons/assets/key/e.png")

@onready var icon = get_node(^"CenterContainer/VBoxContainer/TextureRect")
@onready var label: Label = get_node(^"CenterContainer/VBoxContainer/Label")


func _ready():
	add_exception(owner)


func _physics_process(_delta):
	if is_colliding():
		var detected = get_collider()
		if detected is Interactable:
			icon.set_texture(E)
			label.set_text(detected.text)

			if Input.is_action_just_pressed(&"interact"):
				detected.interact()
				get_viewport().set_input_as_handled()
	else:
		icon.set_texture(null)
		label.set_text("")
