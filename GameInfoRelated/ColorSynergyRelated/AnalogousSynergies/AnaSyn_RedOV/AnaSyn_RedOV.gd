extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerEffect_AnaSyn_RedOV = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_AnaSyn_RedOV.gd")

var game_elements : GameElements
var curr_tier : int

var tier_1_pierce_amount : float = 14.0
var tier_2_pierce_amount : float = 8.0
var tier_3_pierce_amount : float = 4.0


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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_OV_GIVER_EFFECT):
		var effect = TowerEffect_AnaSyn_RedOV.new()
		
		if curr_tier == 1:
			effect.base_armor_pierce_amount = tier_1_pierce_amount
			effect.base_toughness_pierce_amount = tier_1_pierce_amount
		elif curr_tier == 2:
			effect.base_armor_pierce_amount = tier_2_pierce_amount
			effect.base_toughness_pierce_amount = tier_2_pierce_amount
		elif curr_tier == 3:
			effect.base_armor_pierce_amount = tier_3_pierce_amount
			effect.base_toughness_pierce_amount = tier_3_pierce_amount
		
		tower.add_tower_effect(effect)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_OV_GIVER_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)
