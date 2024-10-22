extends Control


func _on_player_remaining_ammo_changed(new_quantiy: Variant) -> void:
	$AmmoLabel.text = "Remaining ammo: %s" % new_quantiy


func _on_player_life_changed(new_life: Variant) -> void:
	$PlayerHealthLabel.text = "Health: %s" % new_life
	$PlayerHealthBar.value = new_life

func _process(delta: float) -> void:
	$BossNameLabel.text = "Ghost"
	var boss_health = get_node("../Ghost").get_node("GhostBody/LifeComponent").life
	$BossHealthLabel.text = "Boss Health: %s" % boss_health
	$BossHealthBar.value = boss_health
