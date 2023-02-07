extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerEffect_DomSyn_VioletColorMasteryGiver = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_VioletColorMasteryGiver.gd")


const rounds_before_color_mastery : int = 1

const tier_4_tower_ing_boost : int = 50
const tier_4_tower_limit : int = 3
const tier_4_tower_violet_limit : int = 2

const tier_3_tower_ing_boost : int = 5
const tier_3_tower_limit : int = 6
const tier_3_tower_violet_limit : int = 3

const tier_2_tower_ing_boost : int = 2
const tier_2_tower_limit : int = 9
const tier_2_tower_violet_limit : int = 4

const tier_1_tower_ing_boost : int = 1
const tier_1_tower_limit : int = 14
const tier_1_tower_violet_limit : int = 6


var game_elements : GameElements
var current_ing_boost : int
var current_tier : int

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	var tower_manager := game_elements.tower_manager
	if !tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_added_or_removed"):
		tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_added_or_removed", [false], CONNECT_PERSIST)
		tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_added_or_removed", [true], CONNECT_PERSIST)
	
	current_tier = tier
	_attempt_apply_synergy_to_add_or_remove(tier)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _attempt_apply_synergy_to_add_or_remove(tier : int):
	var towers : Array = game_elements.tower_manager.get_all_active_towers()
	var towers_for_limit_count : Array = game_elements.tower_manager.get_all_active_towers_except_summonables_and_in_queue_free()
	#var violet_towers : Array = game_elements.tower_manager.get_all_active_towers_with_color(TowerColors.VIOLET)
	var violet_towers : Array = game_elements.tower_manager.get_all_in_map_towers_to_benefit_from_syn_with_color_except_summonables_and_in_queue_free(TowerColors.VIOLET)
	
	if tier == 4:
		if towers_for_limit_count.size() <= tier_4_tower_limit and violet_towers.size() <= tier_4_tower_violet_limit:
			current_ing_boost = tier_4_tower_ing_boost
			_add_towers_to_benefit_from_synergy(towers)
		else:
			_remove_towers_from_synergy(towers)
		
	elif tier == 3:
		if towers_for_limit_count.size() <= tier_3_tower_limit and violet_towers.size() <= tier_3_tower_violet_limit:
			current_ing_boost = tier_3_tower_ing_boost
			_add_towers_to_benefit_from_synergy(towers)
		else:
			_remove_towers_from_synergy(towers)
		
	elif tier == 2:
		if towers_for_limit_count.size() <= tier_2_tower_limit and violet_towers.size() <= tier_2_tower_violet_limit:
			current_ing_boost = tier_2_tower_ing_boost
			_add_towers_to_benefit_from_synergy(towers)
		else:
			_remove_towers_from_synergy(towers)
		
	elif tier == 1:
		if towers_for_limit_count.size() <= tier_1_tower_limit and violet_towers.size() <= tier_1_tower_violet_limit:
			current_ing_boost = tier_1_tower_ing_boost
			_add_towers_to_benefit_from_synergy(towers)
		else:
			_remove_towers_from_synergy(towers)



func _add_towers_to_benefit_from_synergy(towers : Array):
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	#if tower._tower_colors.has(TowerColors.VIOLET):
	if tower.is_benefit_from_syn_having_or_as_if_having_color(TowerColors.VIOLET):
		tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_SYNERGY, current_ing_boost)
		
		var giver_effect := TowerEffect_DomSyn_VioletColorMasteryGiver.new(rounds_before_color_mastery)
		tower.add_tower_effect(giver_effect)


func _remove_towers_from_synergy(towers : Array):
	for tower in towers:
		_tower_to_remove_from_synergy(tower)

func _tower_to_remove_from_synergy(tower : AbstractTower):
	tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_SYNERGY, 0)
	
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_EFFECT_GIVER)
	if effect != null:
		tower.remove_tower_effect(effect)


func _tower_added_or_removed(tower, removing : bool):
	_attempt_apply_synergy_to_add_or_remove(current_tier)
	
	if removing:
		_tower_to_remove_from_synergy(tower)



func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	current_ing_boost = 0
	current_tier = 0
	
	var violet_towers : Array = game_elements.tower_manager.get_all_active_towers()
	_remove_towers_from_synergy(violet_towers)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_added_or_removed"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_added_or_removed")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_added_or_removed")
	
	._remove_syn_from_game_elements(arg_game_elements, tier)
