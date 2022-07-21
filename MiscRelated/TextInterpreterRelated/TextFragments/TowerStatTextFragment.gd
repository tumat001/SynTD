extends "res://MiscRelated/TextInterpreterRelated/TextFragments/AbstractTextFragment.gd"


enum STAT_TYPE {
	BASE_DAMAGE,
	
	ON_HIT_DAMAGE,
	
	ATTACK_SPEED,
	
	RANGE,
	
	ABILITY_POTENCY
}


# Does not apply to on hit damage
enum STAT_BASIS {
	BASE,
	BONUS,
	TOTAL
}

#

const type_to_for_light_color_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "#F72302",
	STAT_TYPE.ATTACK_SPEED : "#D6AC00",
	STAT_TYPE.RANGE : "#01931B",
	STAT_TYPE.ABILITY_POTENCY : "#024FB1",
	STAT_TYPE.ON_HIT_DAMAGE : "#6F6F6F"
}

const type_to_for_dark_color_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "#FD6453",
	STAT_TYPE.ATTACK_SPEED : "#E8BA00",
	STAT_TYPE.RANGE : "#01931B",
	STAT_TYPE.ABILITY_POTENCY : "#024FB1",
	STAT_TYPE.ON_HIT_DAMAGE : "#B8B8B8"
}


const type_to_name_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "base damage",
	STAT_TYPE.ATTACK_SPEED : "attack speed",
	STAT_TYPE.RANGE : "range",
	STAT_TYPE.ABILITY_POTENCY : "ability potency",
}

const type_to_stat__total__get_method_of_tower_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "get_last_calculated_base_damage_of_main_attk_module",
	STAT_TYPE.ATTACK_SPEED : "get_last_calculated_attack_speed_of_main_attk_module",
	STAT_TYPE.RANGE : "get_last_calculated_range_of_main_attk_module",
	STAT_TYPE.ABILITY_POTENCY : "get_last_calculated_ability_potency",
	STAT_TYPE.ON_HIT_DAMAGE : "get_last_calculated_total_flat_on_hit_damages"
}

const type_to_stat__base__get_method_of_tower_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "get_base_base_damage_of_main_attk_module",
	STAT_TYPE.ATTACK_SPEED : "get_base_attack_speed_of_main_attk_module",
	STAT_TYPE.RANGE : "get_base_range_of_main_attk_module",
	STAT_TYPE.ABILITY_POTENCY : "get_base_ability_potency",
	STAT_TYPE.ON_HIT_DAMAGE : "get_last_calculated_total_flat_on_hit_damages"
}

const type_to_stat__bonus__get_method_of_tower_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "get_bonus_base_damage_of_main_attk_module",
	STAT_TYPE.ATTACK_SPEED : "get_bonus_attack_speed_of_main_attk_module",
	STAT_TYPE.RANGE : "get_bonus_range_of_main_attk_module",
	STAT_TYPE.ABILITY_POTENCY : "get_bonus_ability_potency",
	STAT_TYPE.ON_HIT_DAMAGE : "get_last_calculated_total_flat_on_hit_damages"
}


const type_to_stat__all__property_of_tower_info_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "base_damage",
	STAT_TYPE.ATTACK_SPEED : "base_attk_speed",
	STAT_TYPE.RANGE : "base_range",
	STAT_TYPE.ABILITY_POTENCY : "base_ability_potency",
}


const type_to_img_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseDamage.png",
	STAT_TYPE.ATTACK_SPEED : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseAtkSpeed.png",
	STAT_TYPE.RANGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseRange.png",
	STAT_TYPE.ABILITY_POTENCY : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseAbilityPotency.png",
	STAT_TYPE.ON_HIT_DAMAGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_OnHitMultiplier.png",
	
}

const basis_to_name_map : Dictionary = {
	STAT_BASIS.BASE : "base",
	STAT_BASIS.BONUS : "bonus",
	STAT_BASIS.TOTAL : "total"
}

#

var _tower
var _tower_info
var _stat_type
var _stat_basis
var _scale
var _damage_type
var _is_percent


func _init(arg_tower, 
		arg_tower_info, 
		arg_stat_type : int, 
		arg_stat_basis : int = STAT_BASIS.BASE, 
		arg_scale : float = 1.0,
		arg_damage_type : int = -1,
		arg_is_percent = false).(true):
	
	_tower = arg_tower
	_tower_info = arg_tower_info
	_stat_type = arg_stat_type
	_stat_basis = arg_stat_basis
	_scale = arg_scale
	_damage_type = arg_damage_type
	_is_percent = arg_is_percent
	
	update_damage_type_based_on_args()

func update_damage_type_based_on_args():
	if _stat_type == STAT_TYPE.ON_HIT_DAMAGE and _tower != null:
		var all_on_hits_have_same_type = _tower.get_all_on_hits_have_same_damage_type()
		var on_hit_type = _tower.get_damage_type_of_all_on_hits()
		
		if all_on_hits_have_same_type:
			_damage_type = on_hit_type
		else:
			_damage_type = DamageType.MIXED
		

#

func _get_as_numerical_value() -> float:
	var val : float = 0
	
	if _tower != null:
		if _stat_basis == STAT_BASIS.TOTAL:
			val = _tower.call(type_to_stat__total__get_method_of_tower_map[_stat_type])
		elif _stat_basis == STAT_BASIS.BASE:
			val = _tower.call(type_to_stat__base__get_method_of_tower_map[_stat_type])
		elif _stat_basis == STAT_BASIS.BONUS:
			val = _tower.call(type_to_stat__bonus__get_method_of_tower_map[_stat_type])
		
	elif _tower_info != null:
		if type_to_stat__all__property_of_tower_info_map.has(_stat_type):
			val = _tower_info.get(type_to_stat__all__property_of_tower_info_map[_stat_type])
	
	return val * _scale


func _get_as_text() -> String:
	var base_string = ""
	
	base_string += "%s%% " % [_scale * 100]
	base_string += "[img=<%s>]%s[/img] " % [width_img_val_placeholder, type_to_img_map[_stat_type]]
	
	if _stat_type != STAT_TYPE.ON_HIT_DAMAGE:
		base_string += "%s %s " % [basis_to_name_map[_stat_basis], type_to_name_map[_stat_type]]
	
	if _damage_type != -1:
		base_string += "[img=<%s>]%s[/img]" % [width_img_val_placeholder, dmg_type_to_img_map[_damage_type]] 
	
	return "[color=%s]%s[/color]" % [_get_type_color_map_to_use()[_stat_type], base_string]


func _get_type_color_map_to_use() -> Dictionary:
	if color_mode == ColorMode.FOR_DARK_BACKGROUND:
		return type_to_for_dark_color_map
	else:
		return type_to_for_light_color_map
