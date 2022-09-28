extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")

const RedOV_BoostIndicator_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV/BoostIndicator/RedOV_BoostIndicator.tscn")

const scale_after_conditions : float = 2.0
const kill_count_condition : int = 4
const damage_amount_condition : float = 140.0

var armor_pierce_effect : TowerAttributesEffect
var armor_pierce_modi : FlatModifier

var toughness_pierce_effect : TowerAttributesEffect
var toughness_pierce_modi : FlatModifier


var base_armor_pierce_amount : float
var base_toughness_pierce_amount : float

var _current_kill_count : int = 0
var _current_damage_amount : float = 0

var attached_tower


func _init().(StoreOfTowerEffectsUUID.RED_OV_GIVER_EFFECT):
	pass



func _make_modifications_to_tower(tower):
	attached_tower = tower
	
	if armor_pierce_effect == null:
		_construct_effects()
		tower.add_tower_effect(armor_pierce_effect)
		tower.add_tower_effect(toughness_pierce_effect)
	
	if !tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
	
	if !tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigated_dmg_dealt"):
		tower.connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigated_dmg_dealt", [], CONNECT_PERSIST)


func _undo_modifications_to_tower(tower):
	tower.remove_tower_effect(armor_pierce_effect)
	tower.remove_tower_effect(toughness_pierce_effect)
	
	if tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.disconnect("on_round_end", self, "_on_round_end")
	
	if tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigated_dmg_dealt"):
		tower.disconnect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigated_dmg_dealt")


#

func _construct_effects():
	armor_pierce_modi = FlatModifier.new(StoreOfTowerEffectsUUID.RED_OV_ARMOR_PIERCE_EFFECT)
	armor_pierce_modi.flat_modifier = base_armor_pierce_amount
	
	armor_pierce_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ARMOR_PIERCE, armor_pierce_modi, StoreOfTowerEffectsUUID.RED_OV_ARMOR_PIERCE_EFFECT)
	armor_pierce_effect.is_timebound = false
	
	
	toughness_pierce_modi = FlatModifier.new(StoreOfTowerEffectsUUID.RED_OV_TOUGHNESS_PIERCE_EFFECT)
	toughness_pierce_modi.flat_modifier = base_toughness_pierce_amount
	
	toughness_pierce_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_TOUGHNESS_PIERCE, toughness_pierce_modi, StoreOfTowerEffectsUUID.RED_OV_TOUGHNESS_PIERCE_EFFECT)
	toughness_pierce_effect.is_timebound = false


#

func _on_round_end():
	_current_damage_amount = 0
	_current_kill_count = 0
	
	if !attached_tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigated_dmg_dealt"):
		attached_tower.connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigated_dmg_dealt", [], CONNECT_PERSIST)
	
	armor_pierce_effect.attribute_as_modifier.flat_modifier = base_armor_pierce_amount
	toughness_pierce_effect.attribute_as_modifier.flat_modifier = base_toughness_pierce_amount
	
	_update_tower_module_values()


func _update_tower_module_values():
	for module in attached_tower.all_attack_modules:
		module.calculate_final_armor_pierce()
		module.calculate_final_toughness_pierce()


#

func _on_any_post_mitigated_dmg_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	_current_damage_amount += damage_instance_report.get_total_effective_damage()
	if killed:
		_current_kill_count += 1
	
	if _current_damage_amount >= damage_amount_condition or _current_kill_count >= kill_count_condition:
		_boost_current_effects()

func _boost_current_effects():
	if attached_tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigated_dmg_dealt"):
		attached_tower.disconnect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigated_dmg_dealt")
	
	armor_pierce_effect.attribute_as_modifier.flat_modifier = base_armor_pierce_amount * scale_after_conditions
	toughness_pierce_effect.attribute_as_modifier.flat_modifier = base_toughness_pierce_amount * scale_after_conditions
	
	_update_tower_module_values()
	
	call_deferred("_construct_boost_effect_sprite")

func _construct_boost_effect_sprite():
	var particle = RedOV_BoostIndicator_Scene.instance()
	particle.position = attached_tower.global_position
	particle.position.y -= 8
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)


