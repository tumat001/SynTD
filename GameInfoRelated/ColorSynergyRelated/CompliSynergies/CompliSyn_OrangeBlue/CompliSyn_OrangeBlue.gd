extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const AMAdder_CompliSyn_OrangeBlue = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/AMAdder_CompliSyn_OrangeBlue.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")


#const tower_ap_tier_1 : float = 1.0
#const tower_ap_tier_2 : float = 0.50
#const tower_ap_tier_3 : float = 0.25
#const tower_ap_tier_4 : float = 0.25

#var tower_ap_effect : TowerAttributesEffect
#var tower_ap_modi : FlatModifier

const explosion_damage : float = 3.8
const explosion_on_hit_damage_scale : float = 0.5#0.22


const expl_scale_tier_1 : float = 2.0
const expl_scale_tier_2 : float = 1.75
const expl_scale_tier_3 : float = 1.25
const expl_scale_tier_4 : float = 1.0

const expl_unit_time_tier_1 : float = 0.4
const expl_unit_time_tier_2 : float = 1.5
const expl_unit_time_tier_3 : float = 4.5
const expl_unit_time_tier_4 : float = 10.0

# When towers are overheating (100 heat)
const _explosion_cooldown_lowered_ratio : float = 0.5
# When towers are overheating (100 heat)
const _explosion_buffed_dmg_ratio : float = 1.25


var game_elements : GameElements
var curr_tier : int


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	#if tower_ap_effect == null:
	#	_construct_ap_effect()
	
	curr_tier = tier
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


#func _construct_ap_effect():
#	tower_ap_modi = FlatModifier.new(StoreOfTowerEffectsUUID.ORANGE_BLUE_AP_EFFECT)
#	tower_ap_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, tower_ap_modi, StoreOfTowerEffectsUUID.ORANGE_BLUE_AP_EFFECT)


# Remove

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	curr_tier = 0
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


#

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.ORANGE_BLUE_AM_ADDER):
		var expl_module_adder = AMAdder_CompliSyn_OrangeBlue.new(explosion_damage, _explosion_cooldown_lowered_ratio, _explosion_buffed_dmg_ratio)
		
		if curr_tier == 1:
			#tower_ap_modi.flat_modifier = tower_ap_tier_1
			expl_module_adder.explosion_scale = expl_scale_tier_1
			expl_module_adder.base_unit_time_per_explosion = expl_unit_time_tier_1
		elif curr_tier == 2:
			#tower_ap_modi.flat_modifier = tower_ap_tier_2
			expl_module_adder.explosion_scale = expl_scale_tier_2
			expl_module_adder.base_unit_time_per_explosion = expl_unit_time_tier_2
		elif curr_tier == 3:
			#tower_ap_modi.flat_modifier = tower_ap_tier_3
			expl_module_adder.explosion_scale = expl_scale_tier_3
			expl_module_adder.base_unit_time_per_explosion = expl_unit_time_tier_3
		elif curr_tier == 4:
			#tower_ap_modi.flat_modifier = tower_ap_tier_4
			expl_module_adder.explosion_scale = expl_scale_tier_4
			expl_module_adder.base_unit_time_per_explosion = expl_unit_time_tier_4
		
		expl_module_adder.explosion_on_hit_damage_scale = explosion_on_hit_damage_scale
		
		tower.add_tower_effect(expl_module_adder)
		#tower.add_tower_effect(tower_ap_effect._shallow_duplicate())



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.ORANGE_BLUE_AM_ADDER)
	if effect != null:
		tower.remove_tower_effect(effect)
	
	#if tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.ORANGE_BLUE_AP_EFFECT):
	#	tower.remove_tower_effect(tower_ap_effect)
