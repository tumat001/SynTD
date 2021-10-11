extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const PercentModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const bonus_damage_percent_threshold : float = 0.75
const bonus_damage_new_scale : float = 1.30

func _init().(StoreOfTowerEffectsUUID.ING_SPIKE):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Impale.png")
	description = "All of the tower's attacks deal 30% more damage to enemies below 75% health."


func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.connect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s", [], CONNECT_PERSIST)


func _on_enemy_hit_s(enemy, damage_register_id, damage_instance, module):
	if enemy._last_calculated_max_health != 0:
		var ratio_health = enemy.current_health / enemy._last_calculated_max_health
		
		if ratio_health < bonus_damage_percent_threshold:
			#damage_instance.on_hit_damages = damage_instance.get_copy_damage_only_scaled_by(bonus_damage_new_scale).on_hit_damages
			damage_instance.scale_only_damage_by(bonus_damage_new_scale)


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s")

