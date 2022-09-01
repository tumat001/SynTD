extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerEffect_AnaSyn_GreenBY = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_AnaSyn_GreenBY.gd")


const damage_per_tick_tier_1 : float = 0.30
const max_damage_tier_1 : float = 6.0

const damage_per_tick_tier_2 : float = 0.17
const max_damage_tier_2 : float = 3.4

const damage_per_tick_tier_3 : float = 0.07
const max_damage_tier_3 : float = 1.4

const damage_per_tick_tier_4 : float = 0.03
const max_damage_tier_4 : float = 0.6

const seconds_per_tick : float = 1.0


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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.GREEN_BY_SCALING_EFFECT_GIVER):
		var effect = TowerEffect_AnaSyn_GreenBY.new()
		
		if curr_tier == 1:
			effect.damage_per_tick = damage_per_tick_tier_1
			effect.max_damage = max_damage_tier_1
		elif curr_tier == 2:
			effect.damage_per_tick = damage_per_tick_tier_2
			effect.max_damage = max_damage_tier_2
		elif curr_tier == 3:
			effect.damage_per_tick = damage_per_tick_tier_3
			effect.max_damage = max_damage_tier_3
		elif curr_tier == 4:
			effect.damage_per_tick = damage_per_tick_tier_4
			effect.max_damage = max_damage_tier_4
		
		effect.seconds_per_tick = seconds_per_tick
		
		tower.add_tower_effect(effect)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_BY_SCALING_EFFECT_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)
