extends Node

const settings_file_path = "user://game_settings.save"
const hotkey_controls_file_path = "user://game_hotkey_controls.save"
const map_selection_default_vals_file_path = "user://map_selection_default_vals.save"
const stats_file_path = "user://stats.save"


const game_controls_action_name_to_ignore_save : Array = [
	"ui_select",
	"ui_accept",
	"ui_cancel",
	"ui_focus_next",
	"ui_focus_prev",
	"ui_left",
	"ui_right",
	"ui_up",
	"ui_down",
	"ui_page_up",
	"ui_page_down",
	"ui_home",
	"ui_end",
]


# base methods

func _save_using_dict(arg_dict, arg_file_path, arg_print_err_msg):
	var save_dict = arg_dict
	var save_file = File.new()
	
	var err_stat = save_file.open(arg_file_path, File.WRITE)
	
	if err_stat != OK:
		print(arg_print_err_msg)
		return
	
	save_file.store_line(to_json(save_dict))
	
	save_file.close()

func _save_using_arr(arg_arr, arg_file_path, arg_print_err_msg):
	var save_arr = arg_arr
	var save_file = File.new()
	
	var err_stat = save_file.open(arg_file_path, File.WRITE)
	
	if err_stat != OK:
		print(arg_print_err_msg)
		return
	
	for ele in save_arr:
		save_file.store_line(to_json(ele))
	
	save_file.close()


#

func _ready():
	var load_success = load_game_hotkey_controls()
	
	


# GAME SETTINGS RELATED --------------

func save_game_settings__of_settings_manager():
	var save_dict = GameSettingsManager._get_save_dict_for_game_settings()
	var err_msg = "Saving error! -- Game settings of settings manager"
	_save_using_dict(save_dict, settings_file_path, err_msg)


func load_game_settings__of_settings_manager():
	var load_file = File.new()
	
	if load_file.file_exists(settings_file_path):
		var err_stat = load_file.open(settings_file_path, File.READ)
		
		if err_stat != OK:
			print("Loading error! -- Game settings of settings manager")
			return false
		
		GameSettingsManager._load_game_settings(load_file)
		
		load_file.close()
		return true
		
	else:
		return false


# GAME CONTROLS ---------------------

func save_game_controls__input_map():
	var save_dict = _get_game_controls_as_dict()
	var err_msg = "Saving error! -- Game controls"
	_save_using_dict(save_dict, hotkey_controls_file_path, err_msg)

func _get_game_controls_as_dict():
	var all_actions = InputMap.get_actions()
	var dict = {}
	for action_name in all_actions:
		if !game_controls_action_name_to_ignore_save.has(action_name):
			var input_events = InputMap.get_action_list(action_name)
			dict[action_name] = _convert_input_events_to_basic_prop_arr(input_events)
	
	return dict

func _convert_input_events_to_basic_prop_arr(arg_input_events : Array):
	var bucket = []
	for event in arg_input_events:
		# Order matters, since this is accessed by _load_game_hotkey_using_file
		bucket.append([event.echo, event.pressed, event.scancode])
	
	return bucket

#

func load_game_hotkey_controls():
	var load_file = File.new()
	
	if load_file.file_exists(hotkey_controls_file_path):
		var err_stat = load_file.open(hotkey_controls_file_path, File.READ)
		
		if err_stat != OK:
			print("Loading error! -- Game controls")
			return false
		
		_load_game_hotkey_using_file(load_file)
		
		load_file.close()
		return true
		
	else:
		return false

func _load_game_hotkey_using_file(arg_file : File):
	var data = parse_json(arg_file.get_line())
	if data != null:
		for action_name in data.keys():
			var event_data : Array = data[action_name]
			InputMap.action_erase_events(action_name)
			
			for i in event_data.size():
				var key_event : InputEventKey = InputEventKey.new()
				var key_data = event_data[i]
				key_event.echo = key_data[0]
				key_event.pressed = key_data[1]
				key_event.scancode = key_data[2]
				
				InputMap.action_add_event(action_name, key_event)


# MAP SELECTION DEFAULTS ---------------------

func save_map_selection_defaults__of_settings_manager():
	var save_arr = GameSettingsManager._get_save_arr_with_inner_info_for_map_selection_default_values()
	var err_msg = "Saving error! -- Map Default values of settings manager"
	_save_using_arr(save_arr, map_selection_default_vals_file_path, err_msg)


func load_map_selection_defaults__of_settings_manager():
	var load_file = File.new()
	
	if load_file.file_exists(map_selection_default_vals_file_path):
		var err_stat = load_file.open(map_selection_default_vals_file_path, File.READ)
		
		if err_stat != OK:
			print("Loading error! -- Game settings of settings manager")
			return false
		
		GameSettingsManager._load_map_selection_defaults(load_file)
		
		load_file.close()
		return true
		
	else:
		return false
	

## STATS ------------------------------------

func save_stats__of_stats_manager():
	var save_dict = StatsManager._get_save_dict_for_stats()
	var err_msg = "Saving error! -- Stats of stats manager"
	_save_using_dict(save_dict, stats_file_path, err_msg)

func load_stats__of_stats_manager():
	var load_file = File.new()
	
	if load_file.file_exists(stats_file_path):
		var err_stat = load_file.open(stats_file_path, File.READ)
		
		if err_stat != OK:
			print("Loading error! -- Stats of stats manager")
			return false
		
		StatsManager._load_stats(load_file)
		
		load_file.close()
		return true
		
	else:
		
		StatsManager._initialize_stats_from_scratch()
		return false
