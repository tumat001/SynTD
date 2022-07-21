
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const all_damage_types = [DamageType.PHYSICAL, DamageType.ELEMENTAL, DamageType.PURE]

# internal id -> on hit damage report  (map)
var all_post_mitigated_on_hit_damages : Dictionary
var all_effective_on_hit_damages : Dictionary

var dmg_instance_ref : WeakRef

# non-overkill post mitigated damage
func get_total_effective_damage(dmg_types_to_include : Array = all_damage_types) -> float:
	var total : float = 0
	
	for on_hit_rep in all_effective_on_hit_damages.values():
		if dmg_types_to_include.has(on_hit_rep.damage_type):
			total += on_hit_rep.damage
	
	return total

# includes overkilling post mitigated damage
func get_total_post_mitigated_damage(dmg_types_to_include : Array = all_damage_types) -> float:
	var total : float = 0
	
	for on_hit_rep in all_post_mitigated_on_hit_damages.values():
		if dmg_types_to_include.has(on_hit_rep.damage_type):
			total += on_hit_rep.damage
	
	return total


func get_total_effective_damage_excluding(blacklisted : Array, dmg_types_to_include : Array = all_damage_types) -> float:
	var total : float = 0
	
	for on_hit_rep_key in all_effective_on_hit_damages.keys():
		if !blacklisted.has(on_hit_rep_key):
			var on_hit_rep = all_effective_on_hit_damages[on_hit_rep_key]
			if dmg_types_to_include.has(on_hit_rep.damage_type):
				total += on_hit_rep.damage
	
	return total

func get_total_post_mitigated_damage_excluding(blacklisted : Array, dmg_types_to_include : Array = all_damage_types) -> float:
	var total : float = 0
	
	for on_hit_rep_key in all_post_mitigated_on_hit_damages.keys():
		if !blacklisted.has(on_hit_rep_key):
			var on_hit_rep = all_post_mitigated_on_hit_damages[on_hit_rep_key]
			if dmg_types_to_include.has(on_hit_rep.damage_type):
				total += on_hit_rep.damage
	
	return total

#

func get_total_effective_damages_by_type() -> Dictionary:
	var damages : Dictionary = {}
	
	for on_hit_rep in all_effective_on_hit_damages.values():
		if damages.has(on_hit_rep.damage_type):
			damages[on_hit_rep.damage_type] += on_hit_rep.damage
		else:
			damages[on_hit_rep.damage_type] = on_hit_rep.damage
	
	return damages

func get_total_effective_damages_by_type_excluding(blacklisted : Array) -> Dictionary:
	var damages : Dictionary = {}
	
	for on_hit_rep_key in all_effective_on_hit_damages.keys():
		if !blacklisted.has(on_hit_rep_key):
			var on_hit_rep = all_effective_on_hit_damages[on_hit_rep_key]
			
			if damages.has(on_hit_rep.damage_type):
				damages[on_hit_rep.damage_type] += on_hit_rep.damage
			else:
				damages[on_hit_rep.damage_type] = on_hit_rep.damage
	
	return damages
