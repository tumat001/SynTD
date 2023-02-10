

var on_hit_damages : Dictionary = {}
var on_hit_effects : Dictionary = {}


var final_toughness_pierce : float = 0
var final_percent_enemy_toughness_pierce : float = 0

var final_armor_pierce : float = 0
var final_percent_enemy_armor_pierce : float = 0

var final_resistance_pierce : float = 0
var final_percent_enemy_resistance_pierce : float = 0

var base_damage_multiplier : float = 1
var on_hit_damage_multiplier : float = 1
var on_hit_effect_multiplier : float = 1

var final_damage_multiplier : float = 1 # used only by Wyvern and Coronal for now.

#

var current_on_hit_damage_reapply_count : int = 0
var current_on_hit_effect_reapply_count : int = 0

# source of damage instance. Use to credit damage from burns/poisons/DOT (not from direct hits from bullets, etc).
var source_ref : WeakRef


func get_copy_scaled_by(scale : float):
	var copy = get_script().new()
	
	for dmg_key in on_hit_damages.keys():
		copy.on_hit_damages[dmg_key] = on_hit_damages[dmg_key].get_copy_scaled_by(1)
	
	for eff_key in on_hit_effects.keys():
		copy.on_hit_effects[eff_key] = on_hit_effects[eff_key]._get_copy_scaled_by(1)
	
	copy.base_damage_multiplier = base_damage_multiplier + (scale - 1)
	copy.on_hit_damage_multiplier = on_hit_damage_multiplier + (scale - 1)
	copy.on_hit_effect_multiplier = on_hit_effect_multiplier + (scale - 1)
	
	copy.final_toughness_pierce = final_toughness_pierce
	copy.final_percent_enemy_toughness_pierce = final_percent_enemy_toughness_pierce
	
	copy.final_armor_pierce = final_armor_pierce
	copy.final_percent_enemy_armor_pierce = final_percent_enemy_armor_pierce
	
	copy.final_resistance_pierce = final_resistance_pierce
	copy.final_percent_enemy_resistance_pierce = final_percent_enemy_resistance_pierce
	
	copy.source_ref = source_ref
	
	copy.current_on_hit_damage_reapply_count = current_on_hit_damage_reapply_count
	copy.current_on_hit_effect_reapply_count = current_on_hit_effect_reapply_count
	
	return copy


func get_copy_damage_only_scaled_by(scale : float):
	var copy = get_script().new()
	
	for dmg_key in on_hit_damages.keys():
		copy.on_hit_damages[dmg_key] = on_hit_damages[dmg_key].get_copy_scaled_by(1)
	
	for eff_key in on_hit_effects.keys():
		copy.on_hit_effects[eff_key] = on_hit_effects[eff_key]._get_copy_scaled_by(1)
	
	copy.base_damage_multiplier = base_damage_multiplier + (scale - 1)
	copy.on_hit_damage_multiplier = on_hit_damage_multiplier + (scale - 1)
	copy.on_hit_effect_multiplier = on_hit_effect_multiplier
	
	copy.final_toughness_pierce = final_toughness_pierce
	copy.final_percent_enemy_toughness_pierce = final_percent_enemy_toughness_pierce
	
	copy.final_armor_pierce = final_armor_pierce
	copy.final_percent_enemy_armor_pierce = final_percent_enemy_armor_pierce
	
	copy.final_resistance_pierce = final_resistance_pierce
	copy.final_percent_enemy_resistance_pierce = final_percent_enemy_resistance_pierce
	
	copy.source_ref = source_ref
	
	copy.current_on_hit_damage_reapply_count = current_on_hit_damage_reapply_count
	copy.current_on_hit_effect_reapply_count = current_on_hit_effect_reapply_count
	
	return copy

#

func scale_by(scale : float):
	base_damage_multiplier = base_damage_multiplier + (scale - 1)
	on_hit_damage_multiplier = on_hit_damage_multiplier + (scale - 1)
	on_hit_effect_multiplier = on_hit_effect_multiplier + (scale - 1)


func scale_only_damage_by(scale : float):
	base_damage_multiplier = base_damage_multiplier + (scale - 1)
	on_hit_damage_multiplier = on_hit_damage_multiplier + (scale - 1)


func scale_only_base_damage_by(scale : float):
	base_damage_multiplier = base_damage_multiplier + (scale - 1)

func scale_only_on_hit_damage_by(scale : float):
	on_hit_damage_multiplier = on_hit_damage_multiplier + (scale - 1)

func scale_only_on_hit_effect_by(scale : float):
	on_hit_effect_multiplier = on_hit_effect_multiplier + (scale - 1)

#


