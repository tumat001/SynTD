extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

enum CompatibilityType {
	WHITELIST = 0,
	BLACKLIST = 1,
}

var color_list : Array
var compatibility_type : int

func _init(arg_color_list : Array, arg_compatibility_type : int, 
		arg_effect_uuid : int).(EffectType.INGREDIENT_COLOR_COMPATIBILITY,
		arg_effect_uuid):
	
	color_list = arg_color_list.duplicate(false)
	compatibility_type = arg_compatibility_type


# modification of color array

func modify_ing_color_compatibility_list(arg_ing_color_list : Array):
	if compatibility_type == CompatibilityType.WHITELIST:
		for color in color_list:
			arg_ing_color_list.append(color)
		
	elif compatibility_type == CompatibilityType.BLACKLIST:
		for color in color_list:
			arg_ing_color_list.erase(color)


# duplicate

func _shallow_duplicate():
	var copy = get_script().new(color_list, compatibility_type, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy

func _get_copy_scaled_by(scale):
	var copy = get_script().new(color_list, compatibility_type, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy

