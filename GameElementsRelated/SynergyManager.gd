extends Node

const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const ColorSynergyChecker = preload("res://GameInfoRelated/ColorSynergyChecker.gd")
const ColorSynergyResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")
const LeftPanel = preload("res://GameHUDRelated/LeftSidePanel/LeftPanel.gd")

var non_active_group_synergies_res : Array
var non_active_dominant_synergies_res : Array
var active_synergies_res : Array

var left_panel : LeftPanel

func update_synergies(towers : Array):
	var distinct_tower_infos : Array = _get_list_of_distinct_tower_infos(towers)
	var active_colors : Array = _convert_tower_info_to_colors(distinct_tower_infos)
	
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
	
	active_synergies_res = syn_res_to_activate
	non_active_dominant_synergies_res = results_of_dom
	non_active_group_synergies_res = results_of_compo
	
	# UPDATE OTHER COMPONENTS HERE
	_update_synergy_displayer()


func _get_list_of_distinct_tower_infos(towers: Array) -> Array:
	var info_bucket : Array = []
	var id_bucket : Array = []
	for tower in towers:
		var id = tower.tower_id
		if !id_bucket.has(id):
			id_bucket.append(id)
			info_bucket.append(Towers.get_tower_info(id))
	
	return info_bucket

func _convert_tower_info_to_colors(tower_infos: Array) -> Array:
	var all_colors : Array = []
	for tower_info in tower_infos:
		for color in tower_info.colors:
			all_colors.append(color)
	
	return all_colors

func _update_synergy_displayer():
	left_panel.active_synergies_res = active_synergies_res
	left_panel.non_active_composite_synergies_res = non_active_group_synergies_res
	left_panel.non_active_dominant_synergies_res = non_active_dominant_synergies_res
	left_panel.update_synergy_displayers()
