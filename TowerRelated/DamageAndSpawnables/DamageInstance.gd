

var on_hit_damages : Dictionary = {}
var on_hit_effects : Dictionary = {}


func get_copy_scaled_by(scale : float):
	var copy = get_script().new()
	
	for dmg_key in on_hit_damages.keys():
		copy.on_hit_damages[dmg_key] = on_hit_damages[dmg_key].get_copy_scaled_by(scale)
	
	for eff_key in on_hit_effects.keys():
		copy.on_hit_effects[eff_key] = on_hit_effects[eff_key]._get_copy_scaled_by(scale)
	
	return copy
