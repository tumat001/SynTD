extends Node

const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")

const EnemySpawnLocIndicator_Flag_Scene = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/EnemySpawnLocIndicator_Flag.tscn")
const EnemySpawnLocIndicator_Flag = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/EnemySpawnLocIndicator_Flag.gd")

signal on_enemy_path_added(enemy_path)
signal on_enemy_path_removed(enemy_path)
signal on_all_enemy_paths_changed(new_all_paths)


const default_flag_offset_from_path : float = 30.0

enum EnemyPathState {
	USED_AND_ACTIVE = 0,
	NOT_USED_AND_ACTIVE = 1,
	
	ANY = 2
}

var all_in_map_placables : Array = []
var _all_enemy_paths : Array = []

var flag_to_path_map : Dictionary = {}


onready var _in_map_placables = $InMapPlacables
onready var _enemy_paths = $EnemyPaths
onready var _environment = $Environment
onready var _terrain_node_parent = $Terrain

func _ready():
	_environment.z_index = ZIndexStore.MAP_ENVIRONMENT
	
	for placables in _in_map_placables.get_children():
		if placables is InMapAreaPlacable:
			all_in_map_placables.append(placables)
	
	for path in _enemy_paths.get_children():
		_all_enemy_paths.append(path)
	
	for terrain in _terrain_node_parent.get_children():
		add_terrain_node(terrain)

# path related

func add_enemy_path(path : EnemyPath, emit_signals : bool = true):
	if is_instance_valid(path):
		_all_enemy_paths.append(path)
		if emit_signals:
			emit_signal("on_enemy_path_added", path)
			emit_signal("on_all_enemy_paths_changed", get_all_enemy_paths())
		
		add_child(path)

func remove_enemy_path(path : EnemyPath, emit_signals : bool = true):
	if is_instance_valid(path):
		_all_enemy_paths.erase(path)
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

func create_spawn_loc_flag_at_path(arg_enemy_path : EnemyPath, arg_offset_from_start : float = default_flag_offset_from_path, arg_flag_texture_id : int = EnemySpawnLocIndicator_Flag.FlagTextureIds.ORANGE) -> EnemySpawnLocIndicator_Flag:
	var flag = EnemySpawnLocIndicator_Flag_Scene.instance()
	CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(flag)
	
	flag.set_flag_texture_id(arg_flag_texture_id)
	
	if arg_offset_from_start < 0:
		arg_offset_from_start = arg_enemy_path.curve.get_baked_length() + arg_offset_from_start
	flag.global_position = arg_enemy_path.curve.interpolate_baked(arg_offset_from_start)
	
	flag_to_path_map[flag] = arg_enemy_path
	
	return flag

func _on_round_started(arg_stageround):
	for flag in flag_to_path_map.keys():
		flag.visible = false

