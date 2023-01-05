extends Node

const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")

const EnemySpawnLocIndicator_Flag_Scene = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/EnemySpawnLocIndicator_Flag.tscn")
const EnemySpawnLocIndicator_Flag = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/EnemySpawnLocIndicator_Flag.gd")

signal on_enemy_path_added(enemy_path)
signal on_enemy_path_removed(enemy_path)
signal on_all_enemy_paths_changed(new_all_paths)

signal any_enemy_path_is_curve_defer_changed(enemy_path, curve_defer_status_of_path, arg_last_calculated_any_path_is_curve_deferred) 
signal last_calculated_any_enemy_path_is_curve_deferred_changed(arg_val)

signal in_map_placable_added(arg_placable)


const default_flag_offset_from_path : float = 30.0

enum EnemyPathState {
	USED_AND_ACTIVE = 0,
	NOT_USED_AND_ACTIVE = 1,
	
	ANY = 2
}

var all_in_map_placables : Array = []
var _all_enemy_paths : Array = []


var _all_paths_with_last_calc_curve_deferred : Array = []
var last_calculated_any_path_is_curve_deferred : bool


var flag_to_path_map : Dictionary = {}
var path_to_flags_map : Dictionary = {}


onready var _in_map_placables = $InMapPlacables
onready var _enemy_paths = $EnemyPaths
onready var _environment = $Environment
onready var _terrain_node_parent = $Terrain

#

func _ready():
	_environment.z_index = ZIndexStore.MAP_ENVIRONMENT
	
	for placables in _in_map_placables.get_children():
		if placables is InMapAreaPlacable:
			#all_in_map_placables.append(placables)
			add_in_map_placable(placables, placables.global_position)
	
	for path in _enemy_paths.get_children():
		_add_enemy_path_and_register_connections(path)
	
	for terrain in _terrain_node_parent.get_children():
		add_terrain_node(terrain)


func _add_enemy_path_and_register_connections(path : EnemyPath):
	if !_all_enemy_paths.has(path):
		_all_enemy_paths.append(path)
		
		if !path.is_connected("last_calculated_curve_change_defer_changed", self, "_on_path_last_calculated_curve_change_defer_changed"):
			path.connect("last_calculated_curve_change_defer_changed", self, "_on_path_last_calculated_curve_change_defer_changed", [path], CONNECT_PERSIST)

func _remove_enemy_path_and_unregister_connections(path : EnemyPath):
	if _all_enemy_paths.has(path):
		_all_enemy_paths.erase(path)
		
		if path.is_connected("last_calculated_curve_change_defer_changed", self, "_on_path_last_calculated_curve_change_defer_changed"):
			path.disconnect("last_calculated_curve_change_defer_changed", self, "_on_path_last_calculated_curve_change_defer_changed")
	
	_attempt_remove_path_to_curve_change_deferred_arr(path)

# path related -- for public

func add_enemy_path(path : EnemyPath, emit_signals : bool = true):
	if is_instance_valid(path):
		_add_enemy_path_and_register_connections(path)
		if emit_signals:
			emit_signal("on_enemy_path_added", path)
			emit_signal("on_all_enemy_paths_changed", get_all_enemy_paths())
		
		add_child(path)

func remove_enemy_path(path : EnemyPath, emit_signals : bool = true):
	if is_instance_valid(path):
		_remove_enemy_path_and_unregister_connections(path)
		if emit_signals:
			emit_signal("on_enemy_path_removed", path)
			emit_signal("on_all_enemy_paths_changed", get_all_enemy_paths())
		
		remove_child(path)


func get_all_enemy_paths():
	return _all_enemy_paths.duplicate(false)




func get_random_enemy_path__with_params(arg_path_state : int = EnemyPathState.ANY , arg_paths_to_choose_from : Array = _all_enemy_paths) -> EnemyPath:
	var bucket = []
	if arg_path_state == EnemyPathState.USED_AND_ACTIVE:
		for path in arg_paths_to_choose_from:
			if path.is_used_and_active:
				bucket.append(path)
		
	elif arg_path_state == EnemyPathState.NOT_USED_AND_ACTIVE:
		for path in arg_paths_to_choose_from:
			if !path.is_used_and_active:
				bucket.append(path)
		
	elif arg_path_state == EnemyPathState.ANY:
		for path in arg_paths_to_choose_from:
			bucket.append(path)
	
	#
	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TARGETING)
	
	var rng_i = rng.randi_range(0, bucket.size() - 1)
	
	if bucket.size() > 0:
		return bucket[rng_i]
	else:
		return null


func get_random_enemy_path(arg_paths_to_choose_from : Array = _all_enemy_paths) -> EnemyPath:
	return get_random_enemy_path__with_params(EnemyPathState.ANY, arg_paths_to_choose_from)


# path related (helper funcs)

func get_path_point_closest_to_point(arg_coord : Vector2, paths_to_inspect : Array = _all_enemy_paths) -> Vector2:
	var nearest_points_per_path : Array = []
	
	for path_v in paths_to_inspect:
		var path : EnemyPath = path_v
		nearest_points_per_path.append(path.curve.get_closest_point(arg_coord))
		
	
	return nearest_points_per_path.min()

func get_exit_position_of_path(arg_path : EnemyPath):
	return arg_path.curve.get_point_position(arg_path.curve.get_point_count() - 1)

func get_average_exit_position_of_all_paths():
	var average_pos : Vector2
	for path in _all_enemy_paths:
		average_pos += get_exit_position_of_path(path)
	
	return average_pos / _all_enemy_paths.size()



# glow related

func make_all_placables_glow():
	for placables in all_in_map_placables:
		placables.set_area_texture_to_glow()

func make_all_placables_not_glow():
	for placables in all_in_map_placables:
		placables.set_area_texture_to_not_glow()

func make_all_placables_with_towers_glow():
	for placables in all_in_map_placables:
		if is_instance_valid(placables.tower_occupying):
			placables.set_area_texture_to_glow()

func make_all_placables_with_no_towers_glow():
	for placables in all_in_map_placables:
		if !is_instance_valid(placables.tower_occupying):
			placables.set_area_texture_to_glow()


func make_all_placables_with_tower_colors_glow(tower_colors : Array):
	for placables in all_in_map_placables:
		if is_instance_valid(placables.tower_occupying):
			for color in tower_colors:
				if placables.tower_occupying._tower_colors.has(color):
					placables.set_area_texture_to_glow()
					break


# hidden related

func make_all_placables_hidden():
	for placables in all_in_map_placables:
		placables.set_hidden(true)

func make_all_placables_not_hidden():
	for placables in all_in_map_placables:
		placables.set_hidden(false)

#

func get_placable_with_node_name(arg_name):
	return _in_map_placables.get_node(arg_name)


####### placable related


func get_all_placables():
	return all_in_map_placables

func get_all_placables__copy():
	return all_in_map_placables.duplicate(true)

func add_in_map_placable(arg_placable, arg_custom_pos : Vector2, arg_emit_signal : bool = true):
	if !all_in_map_placables.has(arg_placable):
		all_in_map_placables.append(arg_placable)
		
		arg_placable.global_position = arg_custom_pos
		
		if arg_placable.get_parent() == null:
			_in_map_placables.add_child(arg_placable)
		
		if arg_emit_signal:
			emit_signal("in_map_placable_added", arg_placable)


################

func add_terrain_node(arg_terrain, arg_z_index_to_use : int = ZIndexStore.TERRAIN_ABOVE_MAP_ENVIRONMENT):
	if arg_terrain.get_parent() == null:
		_terrain_node_parent.add_child(arg_terrain)
	
	if arg_terrain.get("z_index"):
		arg_terrain.z_index = arg_z_index_to_use

func get_all_terrains():
	return _terrain_node_parent.get_children()


###############

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	for path in _all_enemy_paths:
		create_spawn_loc_flag_at_path(path)
	
	arg_game_elements.stage_round_manager.connect("round_started", self, "_on_round_started", [], CONNECT_PERSIST)


################

# if changing params, change "_listen_for_path_curve_change__for_flag_placement" params as well
func create_spawn_loc_flag_at_path(arg_enemy_path : EnemyPath, 
		arg_offset_from_start : float = default_flag_offset_from_path, 
		arg_flag_texture_id : int = EnemySpawnLocIndicator_Flag.FlagTextureIds.ORANGE,
		arg_hide_if_path_is_not_used_for_natural_spawning : bool = true) -> EnemySpawnLocIndicator_Flag:
	
	if arg_enemy_path.curve != null:
		var flag = EnemySpawnLocIndicator_Flag_Scene.instance()
		CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(flag)
		
		flag.set_flag_texture_id(arg_flag_texture_id)
		flag.hide_if_path_is_not_used_for_natural_spawning = arg_hide_if_path_is_not_used_for_natural_spawning
		flag.enemy_path_associated = arg_enemy_path
		
		if arg_offset_from_start < 0:
			arg_offset_from_start = arg_enemy_path.curve.get_baked_length() + arg_offset_from_start
		
		flag.offset_from_path_start = arg_offset_from_start
		_set_flag_global_position_based(flag, arg_enemy_path)
		_update_flag_visibility(flag, arg_enemy_path, true)
		
		flag_to_path_map[flag] = arg_enemy_path
		if !path_to_flags_map.has(arg_enemy_path):
			path_to_flags_map[arg_enemy_path] = []
		path_to_flags_map[arg_enemy_path].append(flag)
		
		
		if !arg_enemy_path.is_connected("curve_changed", self, "_on_curve_path_changed__for_flag_relocation"):
			arg_enemy_path.connect("curve_changed", self, "_on_curve_path_changed__for_flag_relocation", [arg_enemy_path], CONNECT_PERSIST)
		
		if !arg_enemy_path.is_connected("is_used_for_natural_spawning_changed", self, "_on_path_is_used_for_natural_spawning_changed"):
			arg_enemy_path.connect("is_used_for_natural_spawning_changed", self, "_on_path_is_used_for_natural_spawning_changed", [arg_enemy_path], CONNECT_PERSIST)
		
		
		return flag
		
	else:
		_listen_for_path_curve_change__for_flag_placement(arg_enemy_path, arg_offset_from_start, arg_flag_texture_id, arg_hide_if_path_is_not_used_for_natural_spawning)
		
		return null

func _set_flag_global_position_based(flag, arg_enemy_path):
	flag.global_position = arg_enemy_path.curve.interpolate_baked(flag.offset_from_path_start)
	


func _listen_for_path_curve_change__for_flag_placement(arg_path : EnemyPath, arg_offset_from_start, arg_flag_texture_id, arg_hide_if_path_is_not_used_for_natural_spawning):
	if !arg_path.is_connected("curve_changed", self, "_on_curve_path_changed__for_flag_placement"):
		arg_path.connect("curve_changed", self, "_on_curve_path_changed__for_flag_placement", [arg_path, arg_offset_from_start, arg_flag_texture_id, arg_hide_if_path_is_not_used_for_natural_spawning], CONNECT_PERSIST)

func _on_curve_path_changed__for_flag_placement(arg_curve, arg_curve_id, arg_path, arg_offset_from_start, arg_flag_texture_id, arg_hide_if_path_is_not_used_for_natural_spawning):
	if arg_curve != null:
		if arg_path.is_connected("curve_changed", self, "_on_curve_path_changed__for_flag_placement"):
			arg_path.disconnect("curve_changed", self, "_on_curve_path_changed__for_flag_placement")
		
		create_spawn_loc_flag_at_path(arg_path, arg_offset_from_start, arg_flag_texture_id, arg_hide_if_path_is_not_used_for_natural_spawning)


func _on_curve_path_changed__for_flag_relocation(arg_curve, arg_curve_id, arg_enemy_path):
	for flag in path_to_flags_map[arg_enemy_path]:
		if is_instance_valid(flag):
			_set_flag_global_position_based(flag, arg_enemy_path)
			
			_update_flag_visibility(flag, arg_enemy_path, true)


func _on_path_is_used_for_natural_spawning_changed(arg_val, arg_enemy_path):
	for flag in path_to_flags_map[arg_enemy_path]:
		if is_instance_valid(flag):
			_update_flag_visibility(flag, arg_enemy_path, arg_enemy_path.is_used_for_natural_spawning)

func _update_flag_visibility(arg_flag, arg_enemy_path, arg_attempted_val):
	if is_instance_valid(arg_enemy_path):
		if arg_flag.hide_if_path_is_not_used_for_natural_spawning and !arg_enemy_path.is_used_for_natural_spawning:
			arg_flag.visible = false
		else:
			arg_flag.visible = arg_attempted_val
		
	else:
		arg_flag.visible = false
	

func attempt_make_flag_visible_following_conditions(arg_flag):
	_update_flag_visibility(arg_flag, arg_flag.enemy_path_associated, true)

##

func _on_round_started(arg_stageround):
	for flag in flag_to_path_map.keys():
		flag.visible = false
		


#############

func _on_path_last_calculated_curve_change_defer_changed(arg_val, arg_path):
	if arg_val:
		_attempt_add_path_to_curve_change_deferred_arr(arg_path)
		
	else:
		_attempt_remove_path_to_curve_change_deferred_arr(arg_path)

func _attempt_add_path_to_curve_change_deferred_arr(path : EnemyPath):
	if !_all_paths_with_last_calc_curve_deferred.has(path):
		_all_paths_with_last_calc_curve_deferred.append(path)
		
		last_calculated_any_path_is_curve_deferred = true
		emit_signal("any_enemy_path_is_curve_defer_changed", path, true, last_calculated_any_path_is_curve_deferred)
		emit_signal("last_calculated_any_enemy_path_is_curve_deferred_changed", last_calculated_any_path_is_curve_deferred)

func _attempt_remove_path_to_curve_change_deferred_arr(path : EnemyPath):
	if _all_paths_with_last_calc_curve_deferred.has(path):
		_all_paths_with_last_calc_curve_deferred.erase(path)
		
		last_calculated_any_path_is_curve_deferred = _all_paths_with_last_calc_curve_deferred.size() == 0
		emit_signal("any_enemy_path_is_curve_defer_changed", path, false, last_calculated_any_path_is_curve_deferred)
		emit_signal("last_calculated_any_enemy_path_is_curve_deferred_changed", last_calculated_any_path_is_curve_deferred)

