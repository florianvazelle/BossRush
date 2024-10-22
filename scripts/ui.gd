extends Control


func _on_player_remaining_ammo_changed(new_quantiy: Variant) -> void:
	$AmmoLabel.text = "Remaining ammo: %s" % new_quantiy


func _on_player_life_changed(new_life: Variant) -> void:
	$PlayerHealthLabel.text = "Health: %s" % new_life
	$PlayerHealthBar.value = new_life

func _process(delta: float) -> void:
	$BossNameLabel.text = "Ghost"
	var life_component = get_node_or_null("../Ghost/GhostBody/LifeComponent")
	var boss_health = 0
	if life_component != null:
		boss_health = life_component.life
	$BossHealthLabel.text = "Boss Health: %s" % boss_health
	$BossHealthBar.value = boss_health
