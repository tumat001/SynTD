extends Node

const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const ColorSynergyChecker = preload("res://GameInfoRelated/ColorSynergyChecker.gd")
const ColorSynergyResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")
const LeftPanel = preload("res://GameHUDRelated/LeftSidePanel/LeftPanel.gd")
const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

const AbstractTowerModifyingSynergyEffect = preload("res://GameInfoRelated/ColorSynergyRelated/AbstractTowerModifyingSynergyEffect.gd")

var non_active_group_synergies_res : Array
var non_active_dominant_synergies_res : Array
var active_synergies_res : Array

var previous_active_synergies_res : Array

var left_panel : LeftPanel
var tower_manager : TowerManager setget _set_tower_manager


func _set_tower_manager(arg_tower_manager):
	arg_tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_make_tower_benefit_from_active_synergies")
	arg_tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_undo_tower_benefit_from_active_synergies")
	
	tower_manager = arg_tower_manager

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
	#Remove compos with raw_total of 0
	to_remove.clear()
	for res in results_of_compo:
		if res.raw_total == 0:
			to_remove.append(res)
	for to_rem in to_remove:
		results_of_compo.erase(to_rem)
	
	results_of_dom = ColorSynergyChecker.sort_by_descending_total_towers(results_of_dom)
	results_of_compo = ColorSynergyChecker.sort_by_descending_total_towers(results_of_compo)
	
	
	var syn_res_to_activate : Array = []
	var dom_to_activate : Array = ColorSynergyChecker.get_synergies_with_results_to_activate(results_of_dom, 1)
	var compo_to_activate : Array = ColorSynergyChecker.get_synergies_with_results_to_activate(results_of_compo, 1)
	
	for res in dom_to_activate:
		syn_res_to_activate.append(res)
		results_of_dom.erase(res)
	for res in compo_to_activate:
		syn_res_to_activate.append(res)
		results_of_compo.erase(res)
	
	# Assign-ments
	
	previous_active_synergies_res = active_synergies_res
	
	active_synergies_res = syn_res_to_activate
	non_active_dominant_synergies_res = results_of_dom
	non_active_group_synergies_res = results_of_compo
	
	_update_synergy_displayer()
	
	_apply_active_synergies_and_remove_old(previous_active_synergies_res)

# Synergy Calculation

func _get_list_of_distinct_towers(towers: Array) -> Array:
	var tower_bucket : Array = []
	var id_bucket : Array = []
	for tower in towers:
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
				has_same_synergy_but_different_tier = (active_syn_res.synergy.synergy_effect == previous_syn_res.synergy.synergy_effect) and (active_syn_res.synergy_tier != previous_syn_res.synergy_tier) 
				if has_same_synergy_but_different_tier:
					same_synergy_res_different_tier = active_syn_res
		
		if !has_functional_equivalent:
			new_synergies_to_apply.append(active_syn_res)
		else:
			old_synergies_to_remove.erase(functionally_equal_syn_res)
	
	
	var all_towers = tower_manager.get_all_active_towers()
	
	if old_synergies_to_remove.size() != 0:
		_remove_synergies_from_towers(old_synergies_to_remove, all_towers)
	
	if new_synergies_to_apply.size() != 0:
		_add_synergies_to_towers(new_synergies_to_apply, all_towers)
	

func _remove_synergies_from_towers(synergies_to_remove : Array, towers : Array):
	for tower in towers:
		for syn_res in synergies_to_remove:
			var synergy_effect = syn_res.synergy.synergy_effect
			
			if synergy_effect is AbstractTowerModifyingSynergyEffect:
				synergy_effect._remove_syn_from_tower(tower)

func _add_synergies_to_towers(synergies_to_add : Array, towers : Array):
	for tower in towers:
		for syn_res in synergies_to_add:
			var synergy_effect = syn_res.synergy.synergy_effect
			
			if synergy_effect is AbstractTowerModifyingSynergyEffect:
				synergy_effect._apply_syn_to_tower(tower, syn_res.synergy_tier)



func _make_tower_benefit_from_active_synergies(tower : AbstractTower):
	for syn_res in active_synergies_res:
		var synergy_effect = syn_res.synergy.synergy_effect
		
		if synergy_effect is AbstractTowerModifyingSynergyEffect:
			synergy_effect._apply_syn_to_tower(tower, syn_res.synergy_tier)


func _undo_tower_benefit_from_active_synergies(tower : AbstractTower):
	
	# Previous is used here since updating of active
	# syn res is done first before calling this method/signal
	for syn_res in active_synergies_res: #previous_active_synergies_res:
		var synergy_effect = syn_res.synergy.synergy_effect
		
		if synergy_effect is AbstractTowerModifyingSynergyEffect:
			synergy_effect._remove_syn_from_tower(tower)


