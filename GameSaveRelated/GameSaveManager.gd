extends Node

const settings_file_path = "user://game_settings.save"



#

func save_game_settings__of_settings_manager():
	var save_dict = GameSettingsManager._get_save_dict_for_game_settings()
	var save_file = File.new()
	
	var err_stat = save_file.open(settings_file_path, File.WRITE)
	
	if err_stat != OK:
		print("Saving error! -- Game settings of settings manager")
		return
	
	save_file.store_line(to_json(save_dict))
	
	save_file.close()


func load_game_settings__of_settings_manager():
	var load_file = File.new()
	
	if load_file.file_exists(settings_file_path):
		var err_stat = load_file.open(settings_file_path, File.WRITE)
		
		if err_stat != OK:
			print("Loading error! -- Game settings of settings manager")
		
		GameSettingsManager._load_game_settings(load_file)
		
		load_file.close()
		return true
		
	else:
		return false

