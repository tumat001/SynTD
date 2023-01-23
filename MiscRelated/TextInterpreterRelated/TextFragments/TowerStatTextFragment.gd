extends "res://MiscRelated/TextInterpreterRelated/TextFragments/AbstractTextFragment.gd"



# Does not apply to on hit damage
enum STAT_BASIS {
	BASE,
	BONUS,
	TOTAL,  #BASE_PLUS_BONUS
	
	#BASE_PLUS_MODIFIED_BONUS_SCALING, # unused
}

#


const type_to_stat__total__get_method_of_tower_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "get_last_calculated_base_damage_of_main_attk_module",
	STAT_TYPE.ATTACK_SPEED : "get_last_calculated_attack_speed_of_main_attk_module",
	STAT_TYPE.RANGE : "get_last_calculated_range_of_main_attk_module",
	STAT_TYPE.ABILITY_POTENCY : "get_last_calculated_ability_potency",
	STAT_TYPE.ON_HIT_DAMAGE : "get_last_calculated_total_flat_on_hit_damages",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "get_last_calculated_percent_cdr",
	STAT_TYPE.PIERCE : "get_last_calculated_bullet_pierce",
	
}

const type_to_stat__base__get_method_of_tower_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "get_base_base_damage_of_main_attk_module",
	STAT_TYPE.ATTACK_SPEED : "get_base_attack_speed_of_main_attk_module",
	STAT_TYPE.RANGE : "get_base_range_of_main_attk_module",
	STAT_TYPE.ABILITY_POTENCY : "get_base_ability_potency",
	STAT_TYPE.ON_HIT_DAMAGE : "get_last_calculated_total_flat_on_hit_damages",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "get_base_percent_cdr",
	STAT_TYPE.PIERCE : "get_base_bullet_pierce",
	
}

const type_to_stat__bonus__get_method_of_tower_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "get_bonus_base_damage_of_main_attk_module",
	STAT_TYPE.ATTACK_SPEED : "get_bonus_attack_speed_of_main_attk_module",
	STAT_TYPE.RANGE : "get_bonus_range_of_main_attk_module",
	STAT_TYPE.ABILITY_POTENCY : "get_bonus_ability_potency",
	STAT_TYPE.ON_HIT_DAMAGE : "get_last_calculated_total_flat_on_hit_damages",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "get_bonus_percent_cdr",
	STAT_TYPE.PIERCE : "get_bonus_bullet_pierce",
	
}


const type_to_stat__all__property_of_tower_info_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "base_damage",
	STAT_TYPE.ATTACK_SPEED : "base_attk_speed",
	STAT_TYPE.RANGE : "base_range",
	STAT_TYPE.ABILITY_POTENCY : "base_ability_potency",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "base_percent_cdr",
	STAT_TYPE.PIERCE : "base_pierce"
	
}


const basis_to_name_map : Dictionary = {
	STAT_BASIS.BASE : "base",
	STAT_BASIS.BONUS : "bonus",
	STAT_BASIS.TOTAL : "total",
	#STAT_BASIS.BASE_PLUS_MODIFIED_BONUS_SCALING : "proportional total"
}

#

var _tower
var _tower_info
var _stat_type
var _stat_basis
var _scale
var _damage_type
var _is_percent

#for BASE_PLUS_MODIFIED_BONUS_SCALING
#var modified_bonus_scaling : float

# UPDATE DEEP COPY IF ARGS HAS CHANGED
func _init(arg_tower, 
		arg_tower_info, 
		arg_stat_type : int, 
		arg_stat_basis : int = STAT_BASIS.BASE, 
		arg_scale : float = 1.0,
		arg_damage_type : int = -1,
		arg_is_percent = false).(true):
	
	_tower = arg_tower
	_stat_type = arg_stat_type
	_stat_basis = arg_stat_basis
	_scale = arg_scale
	_damage_type = arg_damage_type
	_is_percent = arg_is_percent
	
	if arg_tower_info is WeakRef:
		_tower_info = arg_tower_info
	else:
		_tower_info = weakref(arg_tower_info)
	
	update_damage_type_based_on_args()

func update_damage_type_based_on_args():
	if _stat_type == STAT_TYPE.ON_HIT_DAMAGE and is_instance_valid(_tower):
		var all_on_hits_have_same_type = _tower.get_all_on_hits_have_same_damage_type()
		var on_hit_type = _tower.get_damage_type_of_all_on_hits()
		
		if all_on_hits_have_same_type:
			_damage_type = on_hit_type
		else:
			_damage_type = DamageType.MIXED
		

#

func _get_as_numerical_value() -> float:
	var val : float = 0
	
	if is_instance_valid(_tower):
		if _stat_basis == STAT_BASIS.TOTAL:
			val = _tower.call(type_to_stat__total__get_method_of_tower_map[_stat_type])
		elif _stat_basis == STAT_BASIS.BASE:
			val = _tower.call(type_to_stat__base__get_method_of_tower_map[_stat_type])
		elif _stat_basis == STAT_BASIS.BONUS:
			val = _tower.call(type_to_stat__bonus__get_method_of_tower_map[_stat_type])
		#elif _stat_basis == STAT_BASIS.BASE_PLUS_MODIFIED_BONUS_SCALING:
		#	var base_val = _tower.call(type_to_stat__base__get_method_of_tower_map[_stat_type])
		#	var bonus_val = _tower.call(type_to_stat__bonus__get_method_of_tower_map[_stat_type])
		#	
		#	val = base_val + (bonus_val * modified_bonus_scaling)
		
	elif _tower_info != null and _tower_info.get_ref() != null:
		if _stat_basis != STAT_BASIS.BONUS: #or _stat_basis != STAT_BASIS.BASE_PLUS_MODIFIED_BONUS_SCALING:
			if type_to_stat__all__property_of_tower_info_map.has(_stat_type):
				val = _tower_info.get_ref().get(type_to_stat__all__property_of_tower_info_map[_stat_type])
		else:
			val = 0.0
	
	return val * _scale


func _get_as_text() -> String:
	var base_string = ""
	
	base_string += "%s%% " % [_scale * 100]
	base_string += "[img=<%s>]%s[/img] " % [width_img_val_placeholder, type_to_img_map[_stat_type]]
	
	if _stat_type != STAT_TYPE.ON_HIT_DAMAGE:
		base_string += "%s %s" % [basis_to_name_map[_stat_basis], type_to_name_map[_stat_type]]
	
	if _damage_type != -1:
		base_string += "[img=<%s>]%s[/img]" % [width_img_val_placeholder, dmg_type_to_img_map[_damage_type]] 
	
	return "[color=%s]%s[/color]" % [_get_type_color_map_to_use(_stat_type, _damage_type), base_string]

#
#func _get_type_color_map_to_use() -> Dictionary:
#	if _stat_type != STAT_TYPE.ON_HIT_DAMAGE:
#		if color_mode == ColorMode.FOR_DARK_BACKGROUND:
#			return type_to_for_dark_color_map[_stat_type]
#		else:
#			return type_to_for_light_color_map[_stat_type]
#	else:
#		if color_mode == ColorMode.FOR_DARK_BACKGROUND:
#			return dmg_type_to_for_dark_color_map[_damage_type]
#		else:
#			return dmg_type_to_for_light_color_map[_damage_type]
#
##	if color_mode == ColorMode.FOR_DARK_BACKGROUND:
##		return type_to_for_dark_color_map
##	else:
##		return type_to_for_light_color_map

#

func get_deep_copy():
	var copy = get_script().new(_tower, _tower_info)
	
	._configure_copy_to_match_self(copy)
	
	copy._tower = _tower
	copy._tower_info = _tower_info
	copy._stat_type = _stat_type
	copy._stat_basis = _stat_basis
	copy._scale = _scale
	copy._damage_type = _damage_type
	
	copy._is_percent = _is_percent
	
	return copy

