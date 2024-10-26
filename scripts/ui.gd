extends Control


const BossUI = preload("res://scenes/hud/boss_ui.tscn")

var boss_ui = {}

func _on_player_remaining_ammo_changed(new_quantiy: Variant) -> void:
	%AmmoLabel.text = "%s" % new_quantiy


func _on_player_life_changed(new_life: Variant) -> void:
	%PlayerHealthLabel.text = "%s" % new_life
	#$sPlayerHealthBar.value = new_life

func _process(_delta: float) -> void:
	for boss in get_tree().get_nodes_in_group("boss"):
		if boss not in boss_ui:
			boss_ui[boss] = BossUI.instantiate()
			$VBoxContainer.add_child(boss_ui[boss])
			boss_ui[boss].get_node("%BossNameLabel").text = boss.type
		var life_component = boss.get_node("LifeComponent")
		var boss_health = life_component.life
		#boss_ui[boss].get_node("BossHealthLabel").text = "Health: %s" % boss_health
		boss_ui[boss].get_node("%BossHealthBar").value = boss_health
		boss_ui[boss].get_node("%BossHealthBar").max_value = life_component.initial_life
		
	var keys_to_erase = []
	for boss in boss_ui:
		if not is_instance_valid(boss):
			keys_to_erase.append(boss)
			boss_ui[boss].queue_free()
	
	for key in keys_to_erase:
		boss_ui.erase(key)
