extends "res://MiscRelated/TextInterpreterRelated/TextFragments/AbstractTextFragment.gd"


enum STAT_BASIS {
	BASE,
	BONUS,
	TOTAL,  #BASE_PLUS_BONUS
}

#TODO unfinished
const type_to_stat__total__get_method_of_enemy_map : Dictionary = {
	STAT_TYPE.ENEMY_STAT__HEALTH : "get_last_calculated_max_health",
	STAT_TYPE.ENEMY_STAT__MOV_SPEED : "",
	STAT_TYPE.ENEMY_STAT__ARMOR : "",
	STAT_TYPE.ENEMY_STAT__TOUGHNESS : "",
	STAT_TYPE.ENEMY_STAT__RESISTANCE : "",
	STAT_TYPE.ENEMY_STAT__PLAYER_DMG : "",
	STAT_TYPE.ENEMY_STAT__EFFECT_VUL : "",
	STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY : "",
}

#TODO unfinished
const type_to_stat__base__get_method_of_enemy_map : Dictionary = {
	STAT_TYPE.ENEMY_STAT__HEALTH : "",
	STAT_TYPE.ENEMY_STAT__MOV_SPEED : "",
	STAT_TYPE.ENEMY_STAT__ARMOR : "",
	STAT_TYPE.ENEMY_STAT__TOUGHNESS : "",
	STAT_TYPE.ENEMY_STAT__RESISTANCE : "",
	STAT_TYPE.ENEMY_STAT__PLAYER_DMG : "",
	STAT_TYPE.ENEMY_STAT__EFFECT_VUL : "",
	STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY : "",
}

#TODO unfinished
const type_to_stat__bonus__get_method_of_enemy_map : Dictionary = {
	STAT_TYPE.ENEMY_STAT__HEALTH : "",
	STAT_TYPE.ENEMY_STAT__MOV_SPEED : "",
	STAT_TYPE.ENEMY_STAT__ARMOR : "",
	STAT_TYPE.ENEMY_STAT__TOUGHNESS : "",
	STAT_TYPE.ENEMY_STAT__RESISTANCE : "",
	STAT_TYPE.ENEMY_STAT__PLAYER_DMG : "",
	STAT_TYPE.ENEMY_STAT__EFFECT_VUL : "",
	STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY : "",
}

const type_to_stat__all__property_of_enemy_info_map : Dictionary = {
	STAT_TYPE.ENEMY_STAT__HEALTH : "base_health",
	STAT_TYPE.ENEMY_STAT__MOV_SPEED : "base_movement_speed",
	STAT_TYPE.ENEMY_STAT__ARMOR : "base_armor",
	STAT_TYPE.ENEMY_STAT__TOUGHNESS : "base_toughness",
	STAT_TYPE.ENEMY_STAT__RESISTANCE : "base_resistance",
	STAT_TYPE.ENEMY_STAT__PLAYER_DMG : "base_player_damage",
	STAT_TYPE.ENEMY_STAT__EFFECT_VUL : "base_effect_vulnerability",
	STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY : "base_ability_potency",
	
}

const basis_to_name_map : Dictionary = {
	STAT_BASIS.BASE : "base",
	STAT_BASIS.BONUS : "bonus",
	STAT_BASIS.TOTAL : "total",
}


var _enemy
var _enemy_info
var _stat_type
var _stat_basis
var _scale
var _is_percent


func _init(arg_enemy, 
		arg_enemy_info, 
		arg_stat_type : int, 
		arg_stat_basis : int = STAT_BASIS.BASE, 
		arg_scale : float = 1.0,
		arg_is_percent = false).(true):
	
	_enemy = arg_enemy
	_stat_type = arg_stat_type
	_stat_basis = arg_stat_basis
	_scale = arg_scale
	_is_percent = arg_is_percent
	
	if arg_enemy_info is WeakRef:
		_enemy_info = arg_enemy_info
	else:
		_enemy_info = weakref(arg_enemy_info)



func _get_as_numerical_value() -> float:
	var val : float = 0
	
	if is_instance_valid(_enemy):
		if _stat_basis == STAT_BASIS.TOTAL:
			val = _enemy.call(type_to_stat__total__get_method_of_enemy_map[_stat_type])
		elif _stat_basis == STAT_BASIS.BASE:
			val = _enemy.call(type_to_stat__base__get_method_of_enemy_map[_stat_type])
		elif _stat_basis == STAT_BASIS.BONUS:
			val = _enemy.call(type_to_stat__bonus__get_method_of_enemy_map[_stat_type])
		
	elif _enemy_info != null and _enemy_info.get_ref() != null:
		if _stat_basis != STAT_BASIS.BONUS: #or _stat_basis != STAT_BASIS.BASE_PLUS_MODIFIED_BONUS_SCALING:
			if type_to_stat__all__property_of_enemy_info_map.has(_stat_type):
				val = _enemy_info.get_ref().get(type_to_stat__all__property_of_enemy_info_map[_stat_type])
		else:
			val = 0.0
	
	return val * _scale


func _get_as_text() -> String:
	var base_string = ""
	
	base_string += "%s%% " % [_scale * 100]
	base_string += "[img=<%s>]%s[/img] " % [width_img_val_placeholder, type_to_img_map[_stat_type]]
	
	base_string += "%s %s" % [basis_to_name_map[_stat_basis], type_to_name_map[_stat_type]]
	
	return "[color=%s]%s[/color]" % [_get_type_color_map_to_use(_stat_type, -1), base_string]



