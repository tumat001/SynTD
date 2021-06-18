extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const bonus_damage_percent_threshold : float = 0.45
const bonus_damage : float = 1.0
var bonus_damage_instance : DamageInstance

func _init().(StoreOfTowerEffectsUUID.ING_SPIKE):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Spike.png")
	description = "All of the tower's attacks deal additional 1 physical damage to enemies below 45% health."


func _make_modifications_to_tower(tower):
	if bonus_damage_instance == null:
		_construct_bonus_damage_instance()
	
	if !tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.connect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s", [], CONNECT_PERSIST)


func _construct_bonus_damage_instance():
	var mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_SPIKE)
	mod.flat_modifier = bonus_damage
	
	var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_SPIKE, mod, DamageType.PHYSICAL)
	
	bonus_damage_instance = DamageInstance.new()
	bonus_damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.ING_SPIKE] = on_hit


func _on_enemy_hit_s(enemy, damage_register_id, damage_instance, module):
	if enemy._last_calculated_max_health != 0:
		var ratio_health = enemy.current_health / enemy._last_calculated_max_health
		
		if ratio_health < bonus_damage_percent_threshold:
			call_deferred("_deal_bonus_damage", enemy)

func _deal_bonus_damage(enemy):
	if enemy != null:
		enemy.hit_by_damage_instance(bonus_damage_instance)



func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s"):
		tower.disconnect("on_any_attack_module_enemy_hit", self, "_on_enemy_hit_s")


