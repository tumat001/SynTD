extends "res://MiscRelated/TextInterpreterRelated/TextFragments/AbstractTextFragment.gd"


var _num_val : float
var _damage_type : int
var _text_desc : String
var _has_space_between_num_and_text : bool
var _is_percent : bool

func _init(arg_num_val : float, arg_is_percent : bool,
		arg_damage_type : int = -1,
		arg_text_desc : String = "", 
		arg_has_spacing : bool = false).(true):
	
	_num_val = arg_num_val
	_is_percent = arg_is_percent
	_damage_type = arg_damage_type
	_text_desc = arg_text_desc
	_has_space_between_num_and_text = arg_has_spacing

#

func _get_as_numerical_value() -> float:
	return _num_val

func _get_as_text() -> String:
	if _text_desc == null:
		return str(_num_val);
	else:
		var base_string = ""
		
		base_string += str(_num_val)
		
		if _is_percent:
			base_string += "%%"
		
		if dmg_type_to_img_map.has(_damage_type):
			base_string += "[img=<%s>]%s[/img]" % [width_img_val_placeholder, dmg_type_to_img_map[_damage_type]]
		
		if _has_space_between_num_and_text:
			base_string += " " + _text_desc
		else:
			base_string += _text_desc
		
		
		return "[color=%s]%s[/color]" % [_get_color_map_to_use()[_damage_type], base_string]

