extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const DamageType = preload("res://GameInfoRelated/DamageType.gd")

func _init().(StoreOfTowerEffectsUUID.GREEN_PATH_OVERCOME_EFFECT):
	pass


func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit"):
		tower.connect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit", [], CONNECT_PERSIST)


func _on_enemy_hit(enemy, damage_register_id, damage_instance, module):
	var enemy_effective_armor = enemy._last_calculated_final_armor - damage_instance.final_armor_pierce
	var enemy_effective_toughness = enemy._last_calculated_final_toughness - damage_instance.final_toughness_pierce
	
	if enemy_effective_armor > enemy_effective_toughness:
		for on_hit_dmg in damage_instance.on_hit_damages.values():
			on_hit_dmg.damage_type = DamageType.ELEMENTAL
		
	elif enemy_effective_armor < enemy_effective_toughness:
		for on_hit_dmg in damage_instance.on_hit_damages.values():
			on_hit_dmg.damage_type = DamageType.PHYSICAL
		

#

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit"):
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit")

