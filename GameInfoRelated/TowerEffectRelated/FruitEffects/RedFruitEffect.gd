extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")
const EnemyDmgOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyDmgOverTimeEffect.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")


var burn_effect : TowerOnHitEffectAdderEffect

func _init().(StoreOfTowerEffectsUUID.ING_RED_FRUIT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_RedFruit.png")
	description = "Attacks on hit burn enemies for 20 elemental damage over 10 seconds."


func _construct_burn_effect():
	var burn_dmg : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_RED_FRUIT)
	burn_dmg.flat_modifier = 0.5
	
	var burn_on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_RED_FRUIT, burn_dmg, DamageType.ELEMENTAL)
	var burn_dmg_instance = DamageInstance.new()
	burn_dmg_instance.on_hit_damages[burn_on_hit.internal_id] = burn_on_hit
	
	var enemy_burn_effect = EnemyDmgOverTimeEffect.new(burn_dmg_instance, StoreOfEnemyEffectsUUID.ING_RED_FRUIT_BURN, 0.5)
	enemy_burn_effect.is_timebound = true
	enemy_burn_effect.time_in_seconds = 10
	
	burn_effect = TowerOnHitEffectAdderEffect.new(enemy_burn_effect, StoreOfEnemyEffectsUUID.ING_RED_FRUIT_BURN)



func _make_modifications_to_tower(tower):
	_construct_burn_effect()
	
	tower.add_tower_effect(burn_effect)


func _undo_modifications_to_tower(tower):
	tower.remove_tower_effect(burn_effect)

