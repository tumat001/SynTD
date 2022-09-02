extends Node


signal on_descriptions_mode_changed(arg_new_val)
signal on_tower_drag_mode_changed(arg_new_val)
signal on_tower_drag_mode_search_radius_changed(arg_new_val)


enum DescriptionsMode {
	COMPLEX = 0, # The default
	SIMPLE = 1,
}
const description_mode_name_identifier := "Description Mode"
const descriptions_mode_to_explanation : Dictionary = {
	DescriptionsMode.COMPLEX : [
		"Tooltips display all information regarding the synergy or tower."
	],
	DescriptionsMode.SIMPLE : [
		"Tooltips display few information. Some informations are omitted."
	]
}
const descriptions_mode_to_name : Dictionary = {
	DescriptionsMode.COMPLEX : "Descriptive",
	DescriptionsMode.SIMPLE : "Simple"
}

var descriptions_mode : int setget set_descriptions_mode


#

enum TowerDragMode {
	EXACT = 0, # The default
	SNAP_TO_NEARBY_IN_MAP_PLACABLE = 1
}
const tower_drag_mode_name_identifier := "Tower Drag Mode"
const tower_drag_mode_to_explanation : Dictionary = {
	TowerDragMode.EXACT : [
		"Towers must be dropped inside tower slots to be placed there, otherwise the tower will return to its original location."
	],
	TowerDragMode.SNAP_TO_NEARBY_IN_MAP_PLACABLE : [
		"When a tower is dropped to an empty location, it will first search for a nearby tower slot to place itself."
	],
}
const tower_drag_mode_to_name : Dictionary = {
	TowerDragMode.EXACT : "Exact",
	TowerDragMode.SNAP_TO_NEARBY_IN_MAP_PLACABLE : "Snap To Nearby"
}
var tower_drag_mode : int setget set_tower_drag_mode

var tower_drag_mode_search_radius : float = 100 setget set_tower_drag_mode_search_radius


#

# SETS LOCATED HERE
func _ready():
	var load_success = GameSaveManager.load_game_settings__of_settings_manager()
	if !load_success:
		set_descriptions_mode(DescriptionsMode.SIMPLE)
		set_tower_drag_mode(TowerDragMode.SNAP_TO_NEARBY_IN_MAP_PLACABLE)


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

static func get_descriptions_to_use_based_on_color_synergy(arg_color_synergy,
		arg_game_settings_manager_from_source) -> Array:
	
	if arg_game_settings_manager_from_source == null:
		return arg_color_synergy.synergy_descriptions
	else:
		if arg_game_settings_manager_from_source.descriptions_mode == DescriptionsMode.COMPLEX:
			return arg_color_synergy.synergy_descriptions
		else:
			if arg_color_synergy.has_simple_description():
				return arg_color_synergy.synergy_simple_descriptions
			else:
				return arg_color_synergy.synergy_descriptions


######### TOWER DRAG MODE

func set_tower_drag_mode(arg_mode):
	tower_drag_mode = arg_mode
	
	emit_signal("on_tower_drag_mode_changed", tower_drag_mode)

func set_tower_drag_mode_search_radius(arg_val):
	tower_drag_mode_search_radius = arg_val
	
	emit_signal("on_tower_drag_mode_search_radius_changed", tower_drag_mode_search_radius)




#### SAVE RELATED for Settings & Controls ####
# called by game save manager
func _get_save_dict_for_game_settings():
	# NOTE: The order of identifiers/values matters. If that is changed, change the order in the load method.
	var save_dict := {
		description_mode_name_identifier : descriptions_mode,
		tower_drag_mode_name_identifier : tower_drag_mode
	}

# called by game save manager. Don't close it, as game save manager does it.
func _load_game_settings(arg_file : File):
	set_descriptions_mode(arg_file.get_var())
	set_tower_drag_mode(arg_file.get_var())
	

