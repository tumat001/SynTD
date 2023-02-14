extends Node

const MapTypeInformation = preload("res://MapsRelated/MapTypeInformation.gd")
const GameModeTypeInformation = preload("res://GameplayRelated/GameModeRelated/GameModeTypeInformation.gd")


signal on_descriptions_mode_changed(arg_new_val)
signal on_tower_drag_mode_changed(arg_new_val)
signal on_tower_drag_mode_search_radius_changed(arg_new_val)
signal on_auto_show_extra_tower_info_mode_changed(arg_new_val)
signal on_show_synergy_difficulty_mode_changed(arg_new_val)

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

const default_descriptions_mode : int = DescriptionsMode.SIMPLE
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

const default_tower_drag_mode : int = TowerDragMode.SNAP_TO_NEARBY_IN_MAP_PLACABLE
var tower_drag_mode : int setget set_tower_drag_mode

var tower_drag_mode_search_radius : float = 100 setget set_tower_drag_mode_search_radius


# AUTO SHOW EXTRA INFO MODE
enum AutoShowExtraTowerInfoMode {
	DONT_AUTO_SHOW = 0,
	AUTO_SHOW = 1
}
const auto_show_extra_tower_info_mode_name_identifier := "Show Extra Tower Info"
const auto_show_extra_tower_info_mode_to_explanation : Dictionary = {
	AutoShowExtraTowerInfoMode.DONT_AUTO_SHOW : [
		"Extra info is hidden and must be manually brought up when viewing tower information (right side panel)."
	],
	AutoShowExtraTowerInfoMode.AUTO_SHOW : [
		"Extra info is brought up automatically when viewing tower information (right panel)."
	],
}
const auto_show_extra_tower_info_mode_to_name : Dictionary = {
	AutoShowExtraTowerInfoMode.DONT_AUTO_SHOW : "Don't Auto Show",
	AutoShowExtraTowerInfoMode.AUTO_SHOW : "Auto Show"
}

const default_auto_show_extra_tower_info_mode = AutoShowExtraTowerInfoMode.DONT_AUTO_SHOW
var auto_show_extra_tower_info_mode : int setget set_auto_show_extra_tower_info_mode


# SHOW SYNERGY DIFFICULTY
enum ShowSynergyDifficulty {
	SHOW = 0,
	DONT_SHOW = 1,
}
const show_synergy_difficulty_mode_name_identifier := "Show Synergy Difficulty"
const show_synergy_difficulty_mode_to_explanation : Dictionary = {
	ShowSynergyDifficulty.SHOW : [
		"Show the difficulty rating of synergies in the tooltip."
	],
	ShowSynergyDifficulty.DONT_SHOW : [
		"Do not show the difficulty rating of synergies in the tooltip."
	],
}
const show_synergy_difficulty_mode_to_name : Dictionary = {
	ShowSynergyDifficulty.SHOW : "Show",
	ShowSynergyDifficulty.DONT_SHOW : "Don't Show"
}
const default_show_synergy_difficulty_mode = ShowSynergyDifficulty.SHOW
var show_synergy_difficulty_mode : int setget set_show_synergy_difficulty_mode


# MAP SELECTION DEFAULT VALUES
var map_id_to_last_chosen_mode_id_map : Dictionary
var last_chosen_map_id = null

#


# SETS LOCATED HERE
#func _ready():
func _on_singleton_initialize():
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

static func get_descriptions_to_use_based_on_x_type_info(arg_x_type_info,
		arg_game_settings_manager_from_source) -> Array:
	
	if arg_game_settings_manager_from_source == null:
		return arg_x_type_info.get_description__for_almanac_use()
	else:
		if arg_game_settings_manager_from_source.descriptions_mode == DescriptionsMode.COMPLEX:
			return arg_x_type_info.get_description__for_almanac_use()
		else:
			if arg_x_type_info.has_simple_description():
				return arg_x_type_info.get_simple_description__for_almanac_use()
			else:
				return arg_x_type_info.get_description__for_almanac_use()



######### TOWER DRAG MODE

func set_tower_drag_mode(arg_mode):
	tower_drag_mode = arg_mode
	
	emit_signal("on_tower_drag_mode_changed", tower_drag_mode)

func set_tower_drag_mode_search_radius(arg_val):
	tower_drag_mode_search_radius = arg_val
	
	emit_signal("on_tower_drag_mode_search_radius_changed", tower_drag_mode_search_radius)


########### MAP SELECTION DEFAULT VALUES

func _initialize_map_selection_default_vals__called_from_ready():
	var load_success = GameSaveManager.load_map_selection_defaults__of_settings_manager()
	if !load_success: # place defaults default
		_generate_and_set_map_selection_default_vals()

func _generate_and_set_map_selection_default_vals():
	map_id_to_last_chosen_mode_id_map = {}
	for map_id in StoreOfMaps.map_id_to_map_name_dict.keys():
		var last_chosen_mode_id_for_map = null
		var map_type_info : MapTypeInformation = StoreOfMaps.get_map_type_information_from_id(map_id)
		var mode_ids_accessible_from_menu : Array = map_type_info.game_mode_ids_accessible_from_menu
		
		if mode_ids_accessible_from_menu.size() > 0:
			last_chosen_mode_id_for_map = mode_ids_accessible_from_menu[0]
		
		map_id_to_last_chosen_mode_id_map[map_id] = last_chosen_mode_id_for_map
		
		if last_chosen_map_id == null:
			last_chosen_map_id = map_id


# called by game save manager. Don't close it, as game save manager does it.
# called when load_map_selection_defaults__of_settings_manager returns true
func _load_map_selection_defaults(arg_file : File):
	# First line: map id to mode id map
	var map_name_to_last_chosen_mode_id_map__string_key : Dictionary = parse_json(arg_file.get_line())
	#for map_name in map_name_to_last_chosen_mode_id_map__string_key.keys():
	#	#if StoreOfMaps.map_name_to_map_id_dict.has(map_name):
	#	var id = StoreOfMaps.map_name_to_map_id_dict[map_name]
	#	map_id_to_last_chosen_mode_id_map[id] = map_name_to_last_chosen_mode_id_map__string_key[map_name]
	
	for map_name in StoreOfMaps.map_name_to_map_id_dict.keys():
		var id = StoreOfMaps.map_name_to_map_id_dict[map_name]
		
		if map_name_to_last_chosen_mode_id_map__string_key.has(map_name):
			map_id_to_last_chosen_mode_id_map[id] = map_name_to_last_chosen_mode_id_map__string_key[map_name]
		else:
			map_id_to_last_chosen_mode_id_map[id] = StoreOfGameMode.Mode.STANDARD_BEGINNER
	
	# next line, last chosen map id
	last_chosen_map_id = parse_json(arg_file.get_line())
	if !StoreOfMaps.map_id_to_map_name_dict.keys().has(last_chosen_map_id):
		last_chosen_map_id = StoreOfMaps.default_map_id_for_empty


# called by game save manager
func _get_save_arr_with_inner_info_for_map_selection_default_values():
	# NOTE: The order of identifiers/values matters. If that is changed, change the order in the load method.
	var save_arr = []
	var map_name_to_mode_save_dict = {}
	for map_name in StoreOfMaps.map_name_to_map_id_dict.keys():
		var map_id = StoreOfMaps.map_name_to_map_id_dict[map_name]
		if map_id_to_last_chosen_mode_id_map.has(map_id):
			map_name_to_mode_save_dict[map_name] = map_id_to_last_chosen_mode_id_map[map_id]
	
	var last_chosen_map_id_to_save = last_chosen_map_id
	
	#
	save_arr.append(map_name_to_mode_save_dict)
	save_arr.append(last_chosen_map_id_to_save)
	
	return save_arr


########### AUTO SHOW EXTRA TOWER INFO MODE

func set_auto_show_extra_tower_info_mode(arg_mode):
	auto_show_extra_tower_info_mode = arg_mode
	
	emit_signal("on_auto_show_extra_tower_info_mode_changed", auto_show_extra_tower_info_mode)


########### SHOW SYNERGY DIFFICUTLY MODE

func set_show_synergy_difficulty_mode(arg_mode):
	show_synergy_difficulty_mode = arg_mode
	
	emit_signal("on_show_synergy_difficulty_mode_changed", show_synergy_difficulty_mode)



#### SAVE RELATED for Settings & Controls #### 
#### KEEP AT BOTTOM #####################

func _initialize_settings__called_from_ready():
	var load_success = GameSaveManager.load_game_settings__of_settings_manager()
	if !load_success: # default
		set_descriptions_mode(default_descriptions_mode)
		set_tower_drag_mode(default_tower_drag_mode)
		set_auto_show_extra_tower_info_mode(default_auto_show_extra_tower_info_mode)
		set_show_synergy_difficulty_mode(default_show_synergy_difficulty_mode)

# called by game save manager
func _get_save_dict_for_game_settings():
	# NOTE: The order of identifiers/values matters. If that is changed, change the order in the load method.
	var save_dict := {
		description_mode_name_identifier : descriptions_mode,
		tower_drag_mode_name_identifier : tower_drag_mode,
		auto_show_extra_tower_info_mode_name_identifier : auto_show_extra_tower_info_mode,
		show_synergy_difficulty_mode_name_identifier : show_synergy_difficulty_mode
	}
	
	return save_dict

# called by game save manager. Don't close it, as game save manager does it.
func _load_game_settings(arg_file : File):
	var data : Dictionary = parse_json(arg_file.get_line())
	
	if data != null:
		# DESCRIPTION MODE
		if data.has(description_mode_name_identifier):
			set_descriptions_mode(data[description_mode_name_identifier])
		else:
			set_descriptions_mode(default_descriptions_mode)
		
		# TOWER DRAG MODE
		if data.has(tower_drag_mode_name_identifier):
			set_tower_drag_mode(data[tower_drag_mode_name_identifier])
		else:
			set_tower_drag_mode(default_tower_drag_mode)
		
		# AUTO SHOW EXTRA TOWER INFO
		if data.has(auto_show_extra_tower_info_mode_name_identifier):
			set_auto_show_extra_tower_info_mode(data[auto_show_extra_tower_info_mode_name_identifier])
		else:
			set_auto_show_extra_tower_info_mode(default_auto_show_extra_tower_info_mode)
		
		# SHOW SYNERGY DIFFICULTY
		if data.has(show_synergy_difficulty_mode_name_identifier):
			set_show_synergy_difficulty_mode(data[show_synergy_difficulty_mode_name_identifier])
		else:
			set_show_synergy_difficulty_mode(default_show_synergy_difficulty_mode)
