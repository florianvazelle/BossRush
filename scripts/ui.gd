extends Control


func _on_player_remaining_ammo_changed(new_quantiy: Variant) -> void:
	$AmmoLabel.text = "Remaining ammo: %s" % new_quantiy
