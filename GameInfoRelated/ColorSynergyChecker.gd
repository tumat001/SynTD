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
		arg_result_list : Array, limit : int, 
		remove_syns_with_same_totals : bool = true,
		syn_ids_to_always_activate : Array = []) -> Array:
	
	var result_list : Array = arg_result_list.duplicate()
	
	#Filter failed syns
	var to_remove : Array = []
	for result in result_list:
		if !result.passed:
			to_remove.append(result)
	
	for result in to_remove:
		result_list.erase(result)
	
	
	var syns_to_always_activate : Array = []
	
	#Remove those with same totals
	if remove_syns_with_same_totals:
		var raw_totals : Array = []
		var results_with_total_to_remove : Array = []
		
		for result in result_list:
			var syn_result_always_active : bool = syn_ids_to_always_activate.has(result.synergy.synergy_id) and result.synergy_tier != 0
			if syn_result_always_active:
				syns_to_always_activate.append(result)
			
			if !syn_ids_to_always_activate and raw_totals.has(result.raw_total):
				results_with_total_to_remove.append(result.raw_total)
			
			if !syn_ids_to_always_activate and !raw_totals.has(result.raw_total):
				raw_totals.append(result.raw_total)
		
		
		var results_to_remove : Array = []
		for result in result_list:
			if results_with_total_to_remove.has(result.raw_total):
				results_to_remove.append(result)
		
		for result in results_to_remove:
			result_list.erase(result)
	
	
	# ordering # note: not needed.
	#result_list.sort_custom(DescendingSorter, "_sort_descending")
	
	# limit and always active checks
	# done in a "not efficient" way to preserve ordering.
	var synergies_to_activate = []
	
	var i = 0
	for res in result_list:
		if i < limit or syns_to_always_activate.has(res):
			synergies_to_activate.append(res)
		
		i += 1
	
	return synergies_to_activate


class DescendingSorter:
	static func _sort_descending(res01, res02) -> bool:
		return res01.raw_total >= res02.raw_total


