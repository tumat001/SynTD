extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const bonus_damage_percent_threshold : float = 0.5
const bonus_damage : float = 0.75
var bonus_on_hit : OnHitDamage

func _init().(StoreOfTowerEffectsUUID.ING_SPIKE):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Spike.png")
	description = "All of the tower's attacks deal additional 0.75 physical damage on hit to enemies below 50% health."


func _make_modifications_to_tower(tower):
	if bonus_on_hit == null:
		_construct_bonus_damage()
	
	if !tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.connect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s", [], CONNECT_PERSIST)


func _construct_bonus_damage():
	var mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_SPIKE)
	mod.flat_modifier = bonus_damage
	
	bonus_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_SPIKE, mod, DamageType.PHYSICAL)


func _on_enemy_hit_s(enemy, damage_register_id, damage_instance, module):
	if enemy._last_calculated_max_health != 0:
		var ratio_health = enemy.current_health / enemy._last_calculated_max_health
		
		if ratio_health < bonus_damage_percent_threshold:
			damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.ING_SPIKE] = bonus_on_hit



func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s")


