# Used to keep track of enemy spawn paths, active paths, and indexes
#

extends Reference


var _spawn_paths : Array = []
var _natural_spawn_path_to_path_index_map : Dictionary = {}

var _spawn_path_index_to_take : int = 0
var _natural_spawn_path_index_to_take : int = 0


func add_enemy_spawn_path(arg_enemy_path):
	if !_spawn_paths.has(arg_enemy_path):
		_spawn_paths.append(arg_enemy_path)
		
		if !arg_enemy_path.is_connected("is_used_for_natural_spawning_changed", self, "_on_path_is_used_for_natural_spawning_changed"):
			arg_enemy_path.connect("is_used_for_natural_spawning_changed", self, "_on_path_is_used_for_natural_spawning_changed", [arg_enemy_path], CONNECT_PERSIST)
		
		if arg_enemy_path.is_used_for_natural_spawning:
			_natural_spawn_path_to_path_index_map[arg_enemy_path] = _spawn_paths.size() - 1


func remove_enemy_spawn_path(arg_enemy_path) -> bool:
	if _spawn_paths.has(arg_enemy_path):
		if arg_enemy_path.is_connected("is_used_for_natural_spawning_changed", self, "_on_path_is_used_for_natural_spawning_changed"):
			arg_enemy_path.disconnect("is_used_for_natural_spawning_changed", self, "_on_path_is_used_for_natural_spawning_changed")
		
		_spawn_paths.erase(arg_enemy_path)
		_natural_spawn_path_to_path_index_map.erase(arg_enemy_path)
		
		return true
	
	return false

func remove_all_enemy_spawn_paths():
	var to_remove : Array = []
	
	for path in _spawn_paths:
		to_remove.append(path)
	
	for path in to_remove:
		remove_enemy_spawn_path(path)

func get_spawn_paths__not_copy() -> Array:
	return _spawn_paths

##

func has_enemy_spawn_path(arg_path):
	return _spawn_paths.has(arg_path)

##

func get_spawn_path_index_to_take() -> int:
	return _spawn_path_index_to_take


func switch_path_index_to_next():
	_natural_spawn_path_index_to_take += 1
	
	if _natural_spawn_path_index_to_take >= _natural_spawn_path_to_path_index_map.values().size():
		_natural_spawn_path_index_to_take = 0
	
	_spawn_path_index_to_take = _natural_spawn_path_to_path_index_map.values()[_natural_spawn_path_index_to_take]


func get_path_based_on_current_index():
	return _spawn_paths[_spawn_path_index_to_take]


func reset_path_indices():
	_spawn_path_index_to_take = 0
	_natural_spawn_path_index_to_take = 0


#

func get_path_of_enemy(arg_enemy):
	for path in _spawn_paths:
		if path.get_children().has(arg_enemy):
			return path
	
	return null

#############

func _on_path_is_used_for_natural_spawning_changed(arg_val, arg_path):
	if arg_val:
		if !_natural_spawn_path_to_path_index_map.has(arg_path):
			_natural_spawn_path_to_path_index_map[arg_path] = _spawn_paths.size() - 1
		
	else:
		_natural_spawn_path_to_path_index_map.erase(arg_path)


