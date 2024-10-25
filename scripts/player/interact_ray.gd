class_name InteractRay
extends RayCast3D

const E = preload("res://addons/controller_icons/assets/key/e.png")

@onready var icon = get_node(^"CenterContainer/VBoxContainer/TextureRect")
@onready var label: Label = get_node(^"CenterContainer/VBoxContainer/Label")
@onready var rect = get_node(^"../Canon/CenterContainer")


func _ready():
	add_exception(owner)


func _physics_process(_delta):
	if is_colliding():
		var detected = get_collider()
		if detected is Interactable and detected.is_interactable():
			icon.set_texture(E)
			label.set_text(detected.text)
			rect.hide()

			if Input.is_action_just_pressed(&"interact"):
				detected.interact()
				get_viewport().set_input_as_handled()
		else:
			icon.set_texture(null)
			label.set_text("")
			rect.show()
			
	else:
		icon.set_texture(null)
		label.set_text("")
		rect.show()
