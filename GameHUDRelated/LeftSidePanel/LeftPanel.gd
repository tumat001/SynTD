extends MarginContainer

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const ColorSynergyChecker = preload("res://GameInfoRelated/ColorSynergyChecker.gd")

var active_synergies_res : Array = []
var non_active_dominant_synergies_res : Array = []
var non_active_composite_synergies_res : Array = []

func _ready():
	# TODO REMOVE THIS EVENTUALLY
	_set_values_for_test()
	
	update_synergy_displayers()

func _set_values_for_test():
	var active_colors : Array = [
		TowerColors.RED, TowerColors.RED, TowerColors.RED,
		TowerColors.GREEN, TowerColors.GREEN, TowerColors.GREEN,
		TowerColors.BLUE, TowerColors.BLUE, TowerColors.BLUE, TowerColors.BLUE, TowerColors.BLUE,
		TowerColors.ORANGE, TowerColors.ORANGE, TowerColors.ORANGE,
		TowerColors.YELLOW
	]
	
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
	non_active_composite_synergies_res = results_of_compo

func update_synergy_displayers():
	$VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer.active_synergies_res = active_synergies_res
	$VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer.non_active_dominant_synergies_res = non_active_dominant_synergies_res
	$VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer.non_active_composite_synergies_res = non_active_composite_synergies_res
	
	$VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer.update_display()
	
	yield(get_tree(), "idle_frame")
	$VBoxContainer/ScrollContainer.scroll_vertical = $VBoxContainer/ScrollContainer.get_v_scrollbar().max_value

