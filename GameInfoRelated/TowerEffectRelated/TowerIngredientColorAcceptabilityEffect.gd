extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"


enum AcceptabilityType {
	WHITELIST = 0,
	BLACKLIST = 1,
}

var color_list : Array
var acceptability_type : int

func _init(arg_color_list : Array, arg_acceptability_type : int, 
		arg_effect_uuid : int).(EffectType.INGREDIENT_COLOR_ACCEPTABILITY,
		arg_effect_uuid):
	
	color_list = arg_color_list.duplicate(false)
	acceptability_type = arg_acceptability_type



# duplicate

func _shallow_duplicate():
	var copy = get_script().new(color_list, acceptability_type, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy

func _get_copy_scaled_by(scale):
	var copy = get_script().new(color_list, acceptability_type, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy

