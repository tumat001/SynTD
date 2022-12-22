extends "res://MapsRelated/BaseMap.gd"


func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	arg_game_elements.enemy_manager.current_path_to_spawn_pattern = arg_game_elements.enemy_manager.PathToSpawnPattern.SWITCH_PER_SPAWN

