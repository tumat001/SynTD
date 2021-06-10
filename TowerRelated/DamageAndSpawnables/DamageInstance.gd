

var on_hit_damages : Dictionary = {}
var on_hit_effects : Dictionary = {}


var final_toughness_pierce : float = 0
var final_percent_enemy_toughness_pierce : float = 0

var final_armor_pierce : float = 0
var final_percent_enemy_armor_pierce : float = 0

var final_resistance_pierce : float = 0
var final_percent_enemy_resistance_pierce : float = 0

func get_copy_scaled_by(scale : float):
	var copy = get_script().new()
	
	for dmg_key in on_hit_damages.keys():
		copy.on_hit_damages[dmg_key] = on_hit_damages[dmg_key].get_copy_scaled_by(scale)
	
	for eff_key in on_hit_effects.keys():
		copy.on_hit_effects[eff_key] = on_hit_effects[eff_key]._get_copy_scaled_by(scale)
	
	
	copy.final_toughness_pierce = final_toughness_pierce
	copy.final_percent_enemy_toughness_pierce = final_percent_enemy_toughness_pierce
	
	copy.final_armor_pierce = final_armor_pierce
	copy.final_percent_enemy_armor_pierce = final_percent_enemy_armor_pierce
	
	copy.final_resistance_pierce = final_resistance_pierce
	copy.final_percent_enemy_resistance_pierce = final_percent_enemy_resistance_pierce
	
	return copy
