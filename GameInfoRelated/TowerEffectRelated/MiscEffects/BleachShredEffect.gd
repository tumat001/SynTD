extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")


const base_attack_count_trigger : int = 5
var attack_count : int = 0

var toughness_shred_effect : EnemyAttributesEffect


func _init().(StoreOfTowerEffectsUUID.ING_BLEACH):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Bleach.png")
	description = "Every 5th main attack reduces the enemy's toughness by 3 for 5 seconds. Does not stack."


func _make_modifications_to_tower(tower):
	if toughness_shred_effect == null:
		_construct_effect()
	
	if !tower.is_connected("on_main_attack_module_damage_instance_constructed", self, "_dmg_instance_constructed"):
		tower.connect("on_main_attack_module_damage_instance_constructed", self, "_dmg_instance_constructed", [], CONNECT_PERSIST)
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)

func _construct_effect():
	var tou_mod : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.ING_BLEACH_SHREAD)
	tou_mod.flat_modifier = -3
	
	toughness_shred_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, tou_mod, StoreOfEnemyEffectsUUID.ING_BLEACH_SHREAD)
	toughness_shred_effect.is_timebound = true
	toughness_shred_effect.time_in_seconds = 5


func _dmg_instance_constructed(damage_instance, module):
	attack_count += 1
	
	if attack_count >= base_attack_count_trigger:
		damage_instance.on_hit_effects[toughness_shred_effect.effect_uuid] = toughness_shred_effect._get_copy_scaled_by(1)
		attack_count = 0


func _on_round_end():
	attack_count = 0

# undo

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack_module_damage_instance_constructed", self, "_dmg_instance_constructed"):
		tower.disconnect("on_main_attack_module_damage_instance_constructed", self, "_dmg_instance_constructed")
		tower.disconnect("on_round_end", self, "_on_round_end")
