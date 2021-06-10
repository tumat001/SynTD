

# internal id -> on hit damage report  (map)
var all_post_mitigated_on_hit_damages : Dictionary
var all_effective_on_hit_damages : Dictionary


func get_total_effective_damage() -> float:
	var total : float = 0
	
	for on_hit_rep in all_effective_on_hit_damages.values():
		total += on_hit_rep.damage
	
	return total

func get_total_post_mitigated_damage() -> float:
	var total : float = 0
	
	for on_hit_rep in all_post_mitigated_on_hit_damages.values():
		total += on_hit_rep.damage
	
	return total


func get_total_effective_damage_excluding(blacklisted : Array) -> float:
	var total : float = 0
	
	for on_hit_rep_key in all_effective_on_hit_damages.keys():
		if !blacklisted.has(on_hit_rep_key):
			var on_hit_rep = all_effective_on_hit_damages[on_hit_rep_key]
			total += on_hit_rep.damage
	
	return total

func get_total_post_mitigated_damage_excluding(blacklisted : Array) -> float:
	var total : float = 0
	
	for on_hit_rep_key in all_post_mitigated_on_hit_damages.keys():
		if !blacklisted.has(on_hit_rep_key):
			var on_hit_rep = all_post_mitigated_on_hit_damages[on_hit_rep_key]
			total += on_hit_rep.damage
	
	return total
