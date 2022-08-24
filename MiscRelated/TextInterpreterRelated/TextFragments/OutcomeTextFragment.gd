extends "res://MiscRelated/TextInterpreterRelated/TextFragments/AbstractTextFragment.gd"



var num_val : float
var is_percent : bool

var _damage_type : int
var _text_desc : String
var _has_space_between_num_and_text : bool
var _stat_type : int

func _init(arg_stat_type : int = -1,
		arg_damage_type : int = -1,
		arg_text_desc : String = "",
		arg_num_val : float = 0.0,
		arg_is_percent : bool = false,
		arg_has_spacing : bool = false).(true):
	
	num_val = arg_num_val
	is_percent = arg_is_percent
	
	_stat_type = arg_stat_type
	_damage_type = arg_damage_type
	_text_desc = arg_text_desc
	_has_space_between_num_and_text = arg_has_spacing

#

func _get_as_numerical_value() -> float:
	return num_val


func _get_as_text() -> String:
	if _text_desc == null:
		return str(num_val);
	else:
		var base_string = ""
		
		base_string += str(num_val)
		
		if is_percent:
			base_string += "%"
		
		if dmg_type_to_img_map.has(_damage_type):
			base_string += " [img=<%s>]%s[/img] " % [width_img_val_placeholder, dmg_type_to_img_map[_damage_type]]
		elif type_to_img_map.has(_stat_type):
			base_string += " [img=<%s>]%s[/img] " % [width_img_val_placeholder, type_to_img_map[_stat_type]]
		
		if _has_space_between_num_and_text:
			base_string += " " +_text_desc
		else:
			base_string += _text_desc
		
		
		return "[color=%s]%s[/color]" % [_get_type_color_map_to_use(_stat_type, _damage_type), base_string]

#

func get_deep_copy():
	var copy = get_script().new()
	
	._configure_copy_to_match_self(copy)
	
	copy.num_val = num_val
	copy._damage_type = _damage_type
	copy._text_desc = _text_desc
	copy._has_space_between_num_and_text = _has_space_between_num_and_text
	copy.is_percent = is_percent
	
	copy._stat_type = _stat_type
	
	return copy
