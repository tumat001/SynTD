const TowerColor = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const ColorSynergyCheckResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")


static func get_all_results(synergy_list : Array,
		active_tower_colors : Array) -> Array:
	
	var results : Array = []
	
	for synergy_a in synergy_list:
		var synergy : ColorSynergy = synergy_a
		var result : ColorSynergyCheckResults
		
		result = synergy.check_if_color_requirements_met(active_tower_colors)
		results.append(result)
	
	return results
	
static func sort_by_descending_total_towers(results_list : Array) -> Array:
	var returnval = results_list.duplicate()
	returnval.sort_custom(DescendingSorter, "_sort_descending")
	
	return returnval

# Returns what synergies are allowed to be activated. 
# along with the result..
static func get_synergies_with_results_to_activate(
		arg_result_list : Array, limit : int) -> Array:
	
	var result_list : Array = arg_result_list.duplicate()
	
	#Filter failed syns
	var to_remove_syn : Array = []
	
	for result in result_list:
		if !result.passed:
			to_remove_syn.append(result)
	
	for to_rem in to_remove_syn:
		result_list.erase(to_rem)
	
	#Remove those with same totals
	var raw_totals : Array = []
	var results_with_total_to_remove : Array = []
	
	for result in result_list:
		if raw_totals.has(result.raw_total):
			results_with_total_to_remove.append(result.raw_total)
		
		if !raw_totals.has(result.raw_total):
			raw_totals.append(result.raw_total)
	
	var results_to_remove : Array = []
	for result in result_list:
		if results_with_total_to_remove.has(result.raw_total):
			results_to_remove.append(result)
	
	for result in results_to_remove:
		result_list.erase(result)
	
	result_list.sort_custom(DescendingSorter, "_sort_descending")
	var synergies_to_activate = []
	
	for i in result_list.size():
		if i < limit:
			synergies_to_activate.append(result_list[i])
	
	return synergies_to_activate


class DescendingSorter:
	
	static func _sort_descending(res01, res02) -> bool:
		return res01.raw_total >= res02.raw_total
