const TowerColor = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")


static func get_only_satisfied_results(synergy_list : Array,
		active_tower_colors : Array) -> Dictionary:
	
	var candidate_synergies : Array = []
	
	for syn in synergy_list:
		var synergy : ColorSynergy = syn
		if synergy.quick_incomplete_check_if_requirements_met(active_tower_colors):
			candidate_synergies.append(synergy)
	
	var syngergy_check_result_map : Dictionary = {}
	
	for candidate_synergy in candidate_synergies:
		var synergy : ColorSynergy = candidate_synergy
		var result : ColorSynergy.CheckResults
		
		result = synergy.check_if_color_requirements_met(active_tower_colors)
		if result.passed:
			syngergy_check_result_map[synergy] = result
	
	return syngergy_check_result_map


static func get_all_results(synergy_list : Array,
		active_tower_colors : Array) -> Dictionary:
	
	var syngergy_check_result_map : Dictionary = {}
	
	for synergy_a in synergy_list:
		var synergy : ColorSynergy = synergy_a
		var result : ColorSynergy.CheckResults
		
		result = synergy.check_if_color_requirements_met(active_tower_colors)
		syngergy_check_result_map[synergy] = result
	
	return syngergy_check_result_map

# Returns what synergies are allowed to be activated. 
# along with the result..
# First entry will be the top one to activate,
# unless if there is a rule to allow
# two dominant/color groups to be active.
static func get_synergies_with_results_to_activate(
		synergy_check_result_map : Dictionary) -> Array:
	
	#Filter failed syns
	var to_remove_syn : Array = []
	
	for syn_key in synergy_check_result_map:
		if !synergy_check_result_map[syn_key].passed:
			to_remove_syn.append(syn_key)
	
	for to_rem in to_remove_syn:
		synergy_check_result_map.erase(to_rem)
	
	#Totals
	var raw_totals : Array = []
	var to_remove : Array = []
	
	for result in synergy_check_result_map.values():
		if raw_totals.has(result.raw_total):
			to_remove.append(result.raw_total)
		
		if !raw_totals.has(result.raw_total):
			raw_totals.append(result.raw_total)
	
	for remov in to_remove:
		var i = raw_totals.find(remov)
		raw_totals.remove(i)
	
	
	var synergies_to_activate = []
	
	for synergy_key in synergy_check_result_map.keys():
		var result : ColorSynergy.CheckResults = synergy_check_result_map[synergy_key]
		var raw_total = result.raw_total
		
		if raw_totals.has(raw_total):
			synergies_to_activate.append([synergy_key, result])
	
	return synergies_to_activate
