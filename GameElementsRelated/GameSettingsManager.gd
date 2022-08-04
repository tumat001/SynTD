extends Node


signal on_descriptions_mode_changed(arg_new_val)


enum DescriptionsMode {
	COMPLEX = 0, #The default
	SIMPLE = 1,
}

var descriptions_mode : int setget set_descriptions_mode


#

func _ready():
	set_descriptions_mode(DescriptionsMode.COMPLEX)

######### DESCRIPTIONS MODE

func set_descriptions_mode(arg_mode : int):
	descriptions_mode = arg_mode
	
	emit_signal("on_descriptions_mode_changed", arg_mode)


func toggle_descriptions_mode():
	if descriptions_mode == DescriptionsMode.COMPLEX:
		set_descriptions_mode(DescriptionsMode.SIMPLE)
		
	elif descriptions_mode == DescriptionsMode.SIMPLE:
		set_descriptions_mode(DescriptionsMode.COMPLEX)


static func get_descriptions_to_use_based_on_tower_type_info(arg_tower_type_info,
		arg_game_settings_manager_from_source) -> Array:
	
	if arg_game_settings_manager_from_source == null:
		return arg_tower_type_info.tower_descriptions
	else:
		if arg_game_settings_manager_from_source.descriptions_mode == DescriptionsMode.COMPLEX:
			return arg_tower_type_info.tower_descriptions
		else:
			if arg_tower_type_info.has_simple_description():
				return arg_tower_type_info.tower_simple_descriptions
			else:
				return arg_tower_type_info.tower_descriptions

static func get_descriptions_to_use_based_on_ability(arg_ability,
		arg_game_settings_manager_from_source) -> Array:
	
	if arg_game_settings_manager_from_source == null:
		return arg_ability.descriptions
	else:
		if arg_game_settings_manager_from_source.descriptions_mode == DescriptionsMode.COMPLEX:
			return arg_ability.descriptions
		else:
			if arg_ability.has_simple_description():
				return arg_ability.tower_simple_descriptions
			else:
				return arg_ability.tower_descriptions
	
##############

