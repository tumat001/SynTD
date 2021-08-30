extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerEffect_AnaSyn_VioletRB = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_AnaSyn_VioletRB.gd")


const tier_1_major_amount : float = 9.0
const tier_2_phy_amount : float = 1.0
const tier_3_ele_amount : float = 1.0
const tier_4_range_amount : float = 20.0

var game_elements : GameElements
var curr_tier : int


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)

	
	curr_tier = tier
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(game_elements : GameElements, tier : int):
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	
	curr_tier = 0
	
	._remove_syn_from_game_elements(game_elements, tier)


#


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_RB_GIVER_EFFECT):
		var effect = TowerEffect_AnaSyn_VioletRB.new()
		
		if curr_tier == 1:
			effect.base_range_amount = tier_4_range_amount
			effect.base_ele_on_hit_amount = tier_3_ele_amount
			effect.base_phy_on_hit_amount = tier_2_phy_amount
			effect.base_major_phy_on_hit_amount = tier_1_major_amount
			
		elif curr_tier == 2:
			effect.base_range_amount = tier_4_range_amount
			effect.base_ele_on_hit_amount = tier_3_ele_amount
			effect.base_phy_on_hit_amount = tier_2_phy_amount
			effect.base_major_phy_on_hit_amount = 0
			
		elif curr_tier == 3:
			effect.base_range_amount = tier_4_range_amount
			effect.base_ele_on_hit_amount = tier_3_ele_amount
			effect.base_phy_on_hit_amount = 0
			effect.base_major_phy_on_hit_amount = 0
			
		elif curr_tier == 4:
			effect.base_range_amount = tier_4_range_amount
			effect.base_ele_on_hit_amount = 0
			effect.base_phy_on_hit_amount = 0
			effect.base_major_phy_on_hit_amount = 0
		
		tower.add_tower_effect(effect)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_RB_GIVER_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)
