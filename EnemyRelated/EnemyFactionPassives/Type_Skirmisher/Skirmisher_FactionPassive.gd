extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"

const MapManager = preload("res://GameElementsRelated/MapManager.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")
const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")

const AbstractSkirmisherEnemy = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd")


enum PathType {
	BLUE_PATH = 0,
	RED_PATH = 1
}

var game_elements : GameElements
var map_manager : MapManager
var enemy_manager : EnemyManager

var paths_for_blues : Array = []
var paths_for_reds : Array = []


func _apply_faction_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
		map_manager = game_elements.map_manager
		enemy_manager = game_elements.enemy_manager
	
	_set_blue_and_red_paths()
	
	if !enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		enemy_manager.connect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path", [], CONNECT_PERSIST)
	
	
	._apply_faction_to_game_elements(arg_game_elements)


func _remove_faction_from_game_elements(arg_game_elements : GameElements):
	if enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		enemy_manager.disconnect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path")
	
	_reverse_actions_on_path_generation()
	
	._remove_faction_from_game_elements(arg_game_elements)


#

func _set_blue_and_red_paths():
	var all_paths = map_manager.base_map.get_all_enemy_paths()
	
	for path in all_paths:
		if !path.marker_id_to_value_map.has(EnemyPath.MarkerIds.SKIRMISHER_CLONE_OF_BASE_PATH) and !path.marker_id_to_value_map.has(EnemyPath.MarkerIds.SKIRMISHER_BASE_PATH_ALREADY_CLONED):
			paths_for_blues.append(path)
	
	for blue_path in paths_for_blues:
		var red_path = blue_path.get_copy_of_path(true)
		red_path.marker_id_to_value_map[EnemyPath.MarkerIds.SKIRMISHER_CLONE_OF_BASE_PATH] = blue_path #Storing pair path
		
		paths_for_reds.append(red_path)
		
		blue_path.marker_id_to_value_map[EnemyPath.MarkerIds.SKIRMISHER_BASE_PATH_ALREADY_CLONED] = red_path #storing pair path
		
		map_manager.base_map.add_enemy_path(red_path)


func _reverse_actions_on_path_generation():
	var all_paths = map_manager.base_map.all_enemy_paths.duplicate(false)
	
	for path in paths_for_blues:
		path.marker_id_to_value_map.erase(EnemyPath.MarkerIds.SKIRMISHER_BASE_PATH_ALREADY_CLONED)
	
	var paths_to_remove : Array = []
	for path in paths_for_reds:
		map_manager.base_map.remove_enemy_path(path)
		paths_to_remove.append(path)
	
	for path in paths_to_remove:
		paths_for_reds.erase(path)
		path.queue_free()

#

func _before_enemy_is_added_to_path(enemy, path):
	var path_index = enemy_manager.get_spawn_path_to_take_index()
	
	if enemy.enemy_spawn_metadata_from_ins != null and enemy.enemy_spawn_metadata_from_ins.has(StoreOfEnemyMetadataIdsFromIns.SKIRMISHER_SPAWN_AT_PATH_TYPE):
		var path_type = enemy.enemy_spawn_metadata_from_ins[StoreOfEnemyMetadataIdsFromIns.SKIRMISHER_SPAWN_AT_PATH_TYPE]
		
		if enemy.get("skirmisher_path_color_type"):
			enemy.skirmisher_path_color_type = path_type
		
		if path_type == PathType.RED_PATH:
			_add_enemy_to_red_path(enemy, path_index)
		else:
			_add_enemy_to_blue_path(enemy, path_index)
		
	else:
		_add_enemy_to_blue_path(enemy, path_index)


func _add_enemy_to_blue_path(enemy, path_index):
	var path = _get_path_to_use(path_index, paths_for_blues)
	
	path.add_child(enemy)

func _get_path_to_use(path_index, paths):
	var index = path_index * paths.size()
	
	if index > paths.size():
		index = 0
	
	return paths[index]


func _add_enemy_to_red_path(enemy, path_index):
	var path = _get_path_to_use(path_index, paths_for_reds)
	
	path.add_child(enemy)

