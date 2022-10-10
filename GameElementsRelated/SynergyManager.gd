extends Node

const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const ColorSynergyChecker = preload("res://GameInfoRelated/ColorSynergyChecker.gd")
const ColorSynergyResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")
const LeftPanel = preload("res://GameHUDRelated/LeftSidePanel/LeftPanel.gd")
const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const ConditonalClause = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const AbstractTowerModifyingSynergyEffect = preload("res://GameInfoRelated/ColorSynergyRelated/AbstractTowerModifyingSynergyEffect.gd")
const AbstractGameElementsModifyingSynergyEffect = preload("res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd")

enum DontAllowSameTotalsContionalClauseIds {
	GREEN_PATH_BLESSING = 10
	
	SYN_RED__DOMINANCE_SUPPLEMENT = 11
	SYN_RED__COMPLEMENTARY_SUPPLEMENT = 12
}

signal synergies_updated()

var non_active_group_synergies_res : Array
var non_active_dominant_synergies_res : Array
var active_synergies_res : Array

var active_dom_color_synergies_res : Array
var active_compo_color_synergies_res : Array


var previous_active_synergies_res : Array

var left_panel : LeftPanel
var tower_manager : TowerManager setget _set_tower_manager
var game_elements

#

var base_dominant_synergy_limit : int = 1
var _flat_dominant_synergy_limit_modi : Dictionary = {}
var last_calculated_dominant_synergy_limit : int

var base_composite_synergy_limit : int = 1
var _flat_composite_synergy_limit_modi : Dictionary = {}
var last_calculated_composite_synergy_limit : int

var dont_allow_same_total_conditonal_clause : ConditonalClause


#

func _ready():
	dont_allow_same_total_conditonal_clause = ConditonalClause.new()
	dont_allow_same_total_conditonal_clause.connect("clause_inserted", self, "_dont_allow_same_total_clause_added_or_removed", [], CONNECT_PERSIST)
	dont_allow_same_total_conditonal_clause.connect("clause_removed", self, "_dont_allow_same_total_clause_added_or_removed", [], CONNECT_PERSIST)
	
	calculate_final_composite_synergy_limit()
	calculate_final_dominant_synergy_limit()


#

func _set_tower_manager(arg_tower_manager):
	arg_tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_make_tower_benefit_from_active_synergies")
	arg_tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_undo_tower_benefit_from_active_synergies")
	
	tower_manager = arg_tower_manager

#

func update_synergies(towers : Array):
	var distinct_towers : Array = _get_list_of_distinct_towers(towers)
	var active_colors : Array = _convert_towers_to_colors(distinct_towers)
	
	var results_of_dom : Array = ColorSynergyChecker.get_all_results(TowerDominantColors.synergies.values(),
	active_colors)
	var results_of_compo : Array = ColorSynergyChecker.get_all_results(TowerCompositionColors.synergies.values(),
	active_colors)
	
	#Remove doms with raw_total of 0
	var to_remove : Array = []
	for res in results_of_dom:
		if res.raw_total == 0:
			to_remove.append(res)
	for to_rem in to_remove:
		results_of_dom.erase(to_rem)
	#Remove compos with raw_total of 0, or if only meets x - 1 of its colors
	to_remove.clear()
	for res in results_of_compo:
		if res.raw_total == 0 or (res.color_types_amount_met < res.color_types_amount_from_baseline - 1):
			to_remove.append(res)
	for to_rem in to_remove:
		results_of_compo.erase(to_rem)
	
	results_of_dom = ColorSynergyChecker.sort_by_descending_total_towers(results_of_dom)
	results_of_compo = ColorSynergyChecker.sort_by_descending_total_towers(results_of_compo)
	
	
	var syn_res_to_activate : Array = []
	var dom_to_activate : Array = ColorSynergyChecker.get_synergies_with_results_to_activate(results_of_dom, last_calculated_dominant_synergy_limit, dont_allow_same_total_conditonal_clause.is_passed)
	var compo_to_activate : Array = ColorSynergyChecker.get_synergies_with_results_to_activate(results_of_compo, last_calculated_composite_synergy_limit, dont_allow_same_total_conditonal_clause.is_passed)
	
	active_dom_color_synergies_res = []
	active_compo_color_synergies_res = []
	
	
	for res in dom_to_activate:
		syn_res_to_activate.append(res)
		results_of_dom.erase(res)
		active_dom_color_synergies_res.append(res)
	for res in compo_to_activate:
		syn_res_to_activate.append(res)
		results_of_compo.erase(res)
		active_compo_color_synergies_res.append(res)
	
	# Assign-ments
	
	previous_active_synergies_res = active_synergies_res
	
	active_synergies_res = syn_res_to_activate
	non_active_dominant_synergies_res = results_of_dom
	non_active_group_synergies_res = results_of_compo
	
	_update_synergy_displayer()
	
	_apply_active_synergies_and_remove_old(previous_active_synergies_res)
	call_deferred("emit_signal", "synergies_updated")


# Synergy Calculation

func _get_list_of_distinct_towers(towers: Array) -> Array:
	var tower_bucket : Array = []
	var id_bucket : Array = []
	for tower in towers:
		if is_instance_valid(tower) and tower.can_contribute_to_synergy_color_count:
			var id = tower.tower_id
			if !id_bucket.has(id):
				id_bucket.append(id)
				tower_bucket.append(tower)
	
	return tower_bucket

func _convert_towers_to_colors(towers: Array) -> Array:
	var all_colors : Array = []
	for tower in towers:
		for color in tower._tower_colors:
			all_colors.append(color)
	
	return all_colors


# Update displayer

func _update_synergy_displayer():
	left_panel.active_synergies_res = active_synergies_res
	left_panel.non_active_composite_synergies_res = non_active_group_synergies_res
	left_panel.non_active_dominant_synergies_res = non_active_dominant_synergies_res
	left_panel.update_synergy_displayers()


# Synergy application

# actually removes old first then adds new
func _apply_active_synergies_and_remove_old(previous_synergies_res : Array):
	var old_synergies_to_remove : Array = previous_synergies_res
	var new_synergies_to_apply : Array = []
	
	for active_syn_res in active_synergies_res:
		var has_functional_equivalent : bool = false
		var functionally_equal_syn_res : ColorSynergyResults
		var has_same_synergy_but_different_tier : bool = false
		var same_synergy_res_different_tier : ColorSynergyResults = null
		
		for previous_syn_res in previous_synergies_res:
			if !has_functional_equivalent:
				has_functional_equivalent = active_syn_res.functionally_equal_to(previous_syn_res)
				functionally_equal_syn_res = previous_syn_res
			
			if !has_same_synergy_but_different_tier:
				has_same_synergy_but_different_tier = (active_syn_res.synergy.synergy_effects == previous_syn_res.synergy.synergy_effects) and (active_syn_res.synergy_tier != previous_syn_res.synergy_tier) 
				if has_same_synergy_but_different_tier:
					same_synergy_res_different_tier = active_syn_res
		
		if !has_functional_equivalent:
			new_synergies_to_apply.append(active_syn_res)
		else:
			old_synergies_to_remove.erase(functionally_equal_syn_res)
	
	
	var all_towers = tower_manager.get_all_active_towers()
	
	if old_synergies_to_remove.size() != 0:
		_remove_synergies(old_synergies_to_remove, all_towers)
	
	if new_synergies_to_apply.size() != 0:
		_apply_synergies(new_synergies_to_apply, all_towers)


func _apply_synergies(synergies_reses : Array, towers : Array, tower_synergies_only : bool = false):
	for syn_res in synergies_reses:
		syn_res.synergy.apply_this_synergy_to_towers(syn_res.synergy_tier, towers, game_elements, tower_synergies_only)
#		var synergy_effects = syn_res.synergy.synergy_effects
#
#		for synergy_effect in synergy_effects:
#			if synergy_effect is AbstractTowerModifyingSynergyEffect:
#				for tower in towers:
#					synergy_effect._apply_syn_to_tower(tower, syn_res.synergy_tier)
#
#			elif synergy_effect is AbstractGameElementsModifyingSynergyEffect and !tower_synergies_only:
#				synergy_effect._apply_syn_to_game_elements(game_elements, syn_res.synergy_tier)


func _remove_synergies(synergies_reses : Array, towers : Array, tower_synergies_only : bool = false):
	for syn_res in synergies_reses:
		syn_res.synergy.remove_this_synergy_from_towers(syn_res.synergy_tier, towers, game_elements, tower_synergies_only)
#		var synergy_effects = syn_res.synergy.synergy_effects
#
#		for synergy_effect in synergy_effects:
#			if synergy_effect is AbstractTowerModifyingSynergyEffect:
#				for tower in towers:
#					synergy_effect._remove_syn_from_tower(tower, syn_res.synergy_tier)
#
#			elif synergy_effect is AbstractGameElementsModifyingSynergyEffect and !tower_synergies_only:
#				synergy_effect._remove_syn_from_game_elements(game_elements, syn_res.synergy_tier)


# From signals

func _make_tower_benefit_from_active_synergies(tower : AbstractTower):
	_apply_synergies(active_synergies_res, [tower], true)

func _undo_tower_benefit_from_active_synergies(tower : AbstractTower):
	_remove_synergies(active_synergies_res, [tower], true)

#

func add_dominant_syn_limit_modi(modi : FlatModifier):
	_flat_dominant_synergy_limit_modi[modi.internal_id] = modi
	calculate_final_dominant_synergy_limit()
	update_synergies(tower_manager.get_all_active_towers())

func add_composite_syn_limit_modi(modi : FlatModifier):
	_flat_composite_synergy_limit_modi[modi.internal_id] = modi
	calculate_final_composite_synergy_limit()
	update_synergies(tower_manager.get_all_active_towers())

func remove_dominant_syn_limit_modi(modi_id : int):
	_flat_dominant_synergy_limit_modi.erase(modi_id)
	calculate_final_dominant_synergy_limit()
	update_synergies(tower_manager.get_all_active_towers())

func remove_composite_syn_limit_modi(modi_id : int):
	_flat_composite_synergy_limit_modi.erase(modi_id)
	calculate_final_composite_synergy_limit()
	update_synergies(tower_manager.get_all_active_towers())


func calculate_final_dominant_synergy_limit() -> int:
	var final_val : int = base_dominant_synergy_limit
	
	for flat_modi in _flat_dominant_synergy_limit_modi.values():
		final_val += flat_modi.get_modification_to_value(base_dominant_synergy_limit)
	
	last_calculated_dominant_synergy_limit = final_val
	return final_val

func calculate_final_composite_synergy_limit() -> int:
	var final_val : int = base_composite_synergy_limit
	
	for flat_modi in _flat_composite_synergy_limit_modi.values():
		final_val += flat_modi.get_modification_to_value(base_composite_synergy_limit)
	
	last_calculated_composite_synergy_limit = final_val
	return final_val

#

func _dont_allow_same_total_clause_added_or_removed(id):
	update_synergies(tower_manager.get_all_active_towers())

#

func is_dom_color_synergy_active(syn) -> bool:
	for res in active_dom_color_synergies_res:
		if res.synergy == syn:
			return true
	
	return false

func is_compo_color_synergy_active(syn) -> bool:
	for res in active_compo_color_synergies_res:
		if res.synergy == syn:
			return true
	
	return false


func is_color_synergy_name_active__with_tier_being_equal_to(arg_syn_name : String, arg_tier : int):
	for res in active_synergies_res:
		if res.synergy.synergy_name == arg_syn_name and res.synergy_tier == arg_tier:
			return true
	
	return false


