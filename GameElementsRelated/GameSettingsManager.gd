extends Node

const MapTypeInformation = preload("res://MapsRelated/MapTypeInformation.gd")
const GameModeTypeInformation = preload("res://GameplayRelated/GameModeRelated/GameModeTypeInformation.gd")

signal on_descriptions_mode_changed(arg_new_val)
signal on_tower_drag_mode_changed(arg_new_val)
signal on_tower_drag_mode_search_radius_changed(arg_new_val)

# DESCRIPTIONS MODE
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


# TOWER DRAG MODE
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


# MAP SELECTION DEFAULT VALUES
var map_id_to_last_chosen_mode_id_map : Dictionary
var last_chosen_map_id : int = -1

#


# SETS LOCATED HERE
func _ready():
	_initialize_settings__called_from_ready()
	_initialize_map_selection_default_vals__called_from_ready()

######### DESCRIPTIONS MODE

func set_descriptions_mode(arg_mode : int):
	descriptions_mode = arg_mode
	
	emit_signal("on_descriptions_mode_changed", arg_mode)


func toggle_descriptions_mode():
	if descriptions_mode == DescriptionsMode.COMPLEX:
		set_descriptions_mode(DescriptionsMode.SIMPLE)
		
	elif descriptions_mode == DescriptionsMode.SIMPLE:
		set_descriptions_mode(DescriptionsMode.COMPLEX)
	
	
	GameSaveManager.save_game_settings__of_settings_manager()


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

func _initialize_settings__called_from_ready():
	var load_success = GameSaveManager.load_game_settings__of_settings_manager()
	if !load_success: # default
		set_descriptions_mode(DescriptionsMode.SIMPLE)
		set_tower_drag_mode(TowerDragMode.SNAP_TO_NEARBY_IN_MAP_PLACABLE)


# called by game save manager
func _get_save_dict_for_game_settings():
	# NOTE: The order of identifiers/values matters. If that is changed, change the order in the load method.
	var save_dict := {
		description_mode_name_identifier : descriptions_mode,
		tower_drag_mode_name_identifier : tower_drag_mode
	}
	
	return save_dict

# called by game save manager. Don't close it, as game save manager does it.
func _load_game_settings(arg_file : File):
	var data = parse_json(arg_file.get_line())
	
	if data != null:
		set_descriptions_mode(data[description_mode_name_identifier])
		set_tower_drag_mode(data[tower_drag_mode_name_identifier])


########### MAP SELECTION DEFAULT VALUES

func _initialize_map_selection_default_vals__called_from_ready():
	var load_success = GameSaveManager.load_map_selection_defaults__of_settings_manager()
	if !load_success: # place defaults default
		_generate_and_set_map_selection_default_vals()

func _generate_and_set_map_selection_default_vals():
	map_id_to_last_chosen_mode_id_map = {}
	for map_id in StoreOfMaps.MapsIds.values():
		var last_chosen_mode_id_for_map : int = -1
		var map_type_info : MapTypeInformation = StoreOfMaps.get_map_type_information_from_id(map_id)
		var mode_ids_accessible_from_menu : Array = map_type_info.game_mode_ids_accessible_from_menu
		
		if mode_ids_accessible_from_menu.size() > 0:
			last_chosen_mode_id_for_map = mode_ids_accessible_from_menu[0]
		
		map_id_to_last_chosen_mode_id_map[map_id] = last_chosen_mode_id_for_map
		
		if last_chosen_map_id == -1:
			last_chosen_map_id = map_id


# called by game save manager. Don't close it, as game save manager does it.
# called when load_map_selection_defaults__of_settings_manager returns true
func _load_map_selection_defaults(arg_file : File):
	# First line: map id to mode id map
	var map_name_to_last_chosen_mode_id_map__string_key : Dictionary = parse_json(arg_file.get_line())
	for map_name in map_name_to_last_chosen_mode_id_map__string_key.keys():
		var id = StoreOfMaps.MapsIds[map_name]
		map_id_to_last_chosen_mode_id_map[id] = map_name_to_last_chosen_mode_id_map__string_key[map_name]
	
	# next line, last chosen map id
	last_chosen_map_id = parse_json(arg_file.get_line())


# called by game save manager
func _get_save_arr_with_inner_info_for_map_selection_default_values():
	# NOTE: The order of identifiers/values matters. If that is changed, change the order in the load method.
	var save_arr = []
	var map_name_to_mode_save_dict = {}
	for map_name in StoreOfMaps.MapsIds.keys():
		var map_id = StoreOfMaps.MapsIds[map_name]
		if map_id_to_last_chosen_mode_id_map.has(map_id):
			map_name_to_mode_save_dict[map_name] = map_id_to_last_chosen_mode_id_map[map_id]
	
	var last_chosen_map_id_to_save : int = last_chosen_map_id
	
	#
	save_arr.append(map_name_to_mode_save_dict)
	save_arr.append(last_chosen_map_id_to_save)
	
	return save_arr

