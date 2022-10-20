extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerEffect_AnaSyn_RedOV_V2 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/Effects/TowerEffect_AnaSyn_RedOV_V2.gd")

var game_elements : GameElements
var curr_tier : int

const tier_1_dmg_amp_amount__initial : float = 1.30
const tier_1_dmg_amp_amount__empowered_bonus : float = 1.30

const tier_2_dmg_amp_amount__initial : float = 1.22
const tier_2_dmg_amp_amount__empowered_bonus : float = 1.22

const tier_3_dmg_amp_amount__initial : float = 1.15
const tier_3_dmg_amp_amount__empowered_bonus : float = 1.15

const dmg_amp_duration : float = 6.0
const main_attacks_for_dmg_amp_trigger : int = 8
const dmg_amp_trigger_before_empower : int = 4

var current_dmg_amp_amount__initial : float
var current_dmg_amp_amount__empowered_bonus : float


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	curr_tier = tier
	_update_current_dmg_amp_amounts_based_on_tier()
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _update_current_dmg_amp_amounts_based_on_tier():
	if curr_tier == 3:
		current_dmg_amp_amount__initial = tier_3_dmg_amp_amount__initial
		current_dmg_amp_amount__empowered_bonus = tier_3_dmg_amp_amount__empowered_bonus
	elif curr_tier == 2:
		current_dmg_amp_amount__initial = tier_2_dmg_amp_amount__initial
		current_dmg_amp_amount__empowered_bonus = tier_2_dmg_amp_amount__empowered_bonus
	elif curr_tier == 1:
		current_dmg_amp_amount__initial = tier_1_dmg_amp_amount__initial
		current_dmg_amp_amount__empowered_bonus = tier_1_dmg_amp_amount__empowered_bonus



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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_OV_V2_GIVER_EFFECT):
		var effect = TowerEffect_AnaSyn_RedOV_V2.new()
		effect.base_dmg_scale_boost_amount = current_dmg_amp_amount__initial
		effect.empowered_bonus_dmg_scale_boost_amount = current_dmg_amp_amount__empowered_bonus
		effect.buff_duration = dmg_amp_duration
		effect.main_attacks_for_dmg_amp_trigger = main_attacks_for_dmg_amp_trigger
		effect.dmg_amp_trigger_before_empower = dmg_amp_trigger_before_empower
		
		tower.add_tower_effect(effect)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_OV_V2_GIVER_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)
