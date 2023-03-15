extends Node

const BaseMap = preload("res://MapsRelated/BaseMap.gd")
const TerrainFuncs = preload("res://GameInfoRelated/TerrainRelated/TerrainFuncs.gd")


signal all_enemy_paths_of_base_map_changed(arg_paths, arg_base_map)

signal base_map_last_calculated_any_enemy_path_is_curve_deferred_changed(arg_val)

#

enum SortOrder {
	FARTHEST,
	CLOSEST,
	
	RANDOM,
}

enum PlacableState {
	OCCUPIED,
	UNOCCUPIED,
	ANY,
}

enum RangeState {
	IN_RANGE,
	OUT_OF_RANGE,
	ANY,
}


#

var chosen_map_id setget set_chosen_map_id

var base_map : BaseMap

var stage_round_manager setget set_stage_round_manager

var fov_node : Node2D setget set_fov_node

#

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	_on_base_map_last_calculated_any_enemy_path_is_curve_deferred_changed(null) # param does not matter

func set_fov_node(arg_node):
	fov_node = arg_node

#

func set_chosen_map_id(arg_id):
	chosen_map_id = arg_id
	
	_assign_map_from_store_of_maps()
	
#	for child in get_children():
#		if child is BaseMap:
#			base_map = child
#			break

func _assign_map_from_store_of_maps():
	var chosen_map = StoreOfMaps.get_map_from_map_id(chosen_map_id).instance()
	chosen_map.map_id = chosen_map_id
	
	add_child(chosen_map)
	base_map = chosen_map
	
	#
	
	base_map.connect("on_all_enemy_paths_changed", self, "_on_all_enemy_paths_changed", [], CONNECT_PERSIST)


#

func make_base_map_apply_changes_to_game_elements(arg_game_elements):
	base_map._apply_map_specific_changes_to_game_elements(arg_game_elements)

#


func make_all_placables_glow():
	base_map.make_all_placables_glow()

func make_all_placables_not_glow():
	base_map.make_all_placables_not_glow()

func make_all_placables_with_towers_glow():
	base_map.make_all_placables_with_towers_glow()

func make_all_placables_with_no_towers_glow():
	base_map.make_all_placables_with_no_towers_glow()


func make_all_placables_with_tower_colors_glow(tower_colors : Array):
	base_map.make_all_placables_with_tower_colors_glow(tower_colors)


# hidden related

func make_all_placables_hidden():
	base_map.make_all_placables_hidden()

func make_all_placables_not_hidden():
	base_map.make_all_placables_not_hidden()


# Enemy Path Related


func get_random_enemy_path(arg_paths_to_choose_from : Array = base_map._all_enemy_paths):
	return base_map.get_random_enemy_path(arg_paths_to_choose_from)
	


func get_path_point_closest_to_point(arg_coord : Vector2, paths_to_inspect : Array = base_map._all_enemy_paths) -> Vector2:
	return base_map.get_path_point_closest_to_point(arg_coord, paths_to_inspect)

func get_average_exit_position_of_all_paths():
	return base_map.get_average_exit_position_of_all_paths()

#

func get_all_placables(): #in map
	return base_map.all_in_map_placables

func get_all_placables__copy():
	return base_map.get_all_placables__copy()

func get_all_placables_in_range_from_mouse(radius : float, 
		placable_state : int = PlacableState.ANY, sort_order : int = SortOrder.CLOSEST) -> Array:
	
	var mouse_pos = get_viewport().get_mouse_position()
	return get_all_placables_in_range(mouse_pos, radius, placable_state, sort_order)

func get_all_placables_in_range(center_pos : Vector2, radius : float, 
		placable_state : int = PlacableState.ANY, sort_order : int = SortOrder.CLOSEST) -> Array:
	
	return get_all_placables_based_on_targeting_params(center_pos, radius, placable_state, sort_order)

func get_all_placables_out_of_range(center_pos : Vector2, radius : float, 
		placable_state : int = PlacableState.ANY, sort_order : int = SortOrder.CLOSEST) -> Array:
	
	return get_all_placables_based_on_targeting_params(center_pos, radius, placable_state, sort_order, RangeState.OUT_OF_RANGE)



func get_all_placables_based_on_targeting_params(center_pos : Vector2, radius : float, 
		placable_state : int = PlacableState.ANY, sort_order : int = SortOrder.CLOSEST,
		range_state : int = RangeState.IN_RANGE) -> Array:
	
	var bucket := []
	
	var placable_to_distance_array := []
	var all_placables = base_map.all_in_map_placables
	for placable in all_placables:
		
		var distance = center_pos.distance_to(placable.global_position)
		if (range_state == RangeState.IN_RANGE and radius < distance):
			continue
		elif (range_state == RangeState.OUT_OF_RANGE and radius > distance):
			continue
		
		#
		
		if placable_state == PlacableState.OCCUPIED:
			if is_instance_valid(placable.tower_occupying) or !placable.last_calculated_can_be_occupied:
				continue
		elif placable_state == PlacableState.UNOCCUPIED:
			#if placable.tower_occupying != null:
			if !placable.last_calculated_can_be_occupied:
				continue
		
		placable_to_distance_array.append([placable, distance])
	
	#
	
	if sort_order == SortOrder.FARTHEST:
		placable_to_distance_array.sort_custom(CustomSorter, "sort_placable_by_farthest")
	elif sort_order == SortOrder.CLOSEST:
		placable_to_distance_array.sort_custom(CustomSorter, "sort_placable_by_closest")
	elif sort_order == SortOrder.RANDOM:
		placable_to_distance_array = _find_random_distinct_placables(placable_to_distance_array, placable_to_distance_array.size())
	
	#
	
	for placable_to_distance in placable_to_distance_array:
		bucket.append(placable_to_distance[0])
	
	#
	
	return bucket


class CustomSorter:
	
	static func sort_placable_by_farthest(a, b):
		return a[1] > b[1]
	
	
	static func sort_placable_by_closest(a, b):
		return a[1] < b[1]
	


static func _find_random_distinct_placables(placables : Array, count : int):
	var copy : Array = placables.duplicate(false)
	
	if count >= placables.size():
		return copy
	
	var bucket : Array = []
	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TARGETING)
	
	for i in count:
		if i >= copy.size():
			return bucket
		
		var rand_index = rng.randi_range(0, copy.size() - 1)
		bucket.append(copy[rand_index])
		copy.remove(rand_index)
	
	return bucket


######### LOS related - USE DURING PHYSICS PROCESS ONLY #########

func is_line_of_sight_unobstructed(arg_source_pos : Vector2, arg_dest_pos : Vector2, arg_source_layer : int):
	var all_terrains = get_all_terrains_obstructing_los__except_in_queue_free(arg_source_layer)
	
	var space_state = fov_node.get_world_2d().direct_space_state
	var result : Dictionary = space_state.intersect_ray(arg_source_pos, arg_dest_pos, all_terrains, CollidableSourceAndDest.terrain_layer, false, true)
	
	return result.size() == 0


func get_all_terrains_obstructing_los__except_in_queue_free(arg_layer : int):
	var bucket = []
	for terrain in get_all_terrains():
		if is_instance_valid(terrain) and !terrain.is_queued_for_deletion() and TerrainFuncs.is_layer_in_sight_to(terrain.terrain_layer, arg_layer):
			bucket.append(terrain)
	
	return bucket

func get_all_terrains_within_terrain_layer__except_in_queue_free(arg_max_layer_incl : int, arg_min_layer_incl : int = -1):
	var bucket = []
	for terrain in get_all_terrains():
		if is_instance_valid(terrain) and !terrain.is_queued_for_deletion() and TerrainFuncs.is_layer_between_layers_min_and_max_incl(terrain.terrain_layer, arg_min_layer_incl, arg_max_layer_incl):
			bucket.append(terrain)
	
	return bucket

func get_all_terrains():
	return base_map.get_all_terrains()

######

func _on_all_enemy_paths_changed(arg_all_paths):
	emit_signal("all_enemy_paths_of_base_map_changed", base_map, arg_all_paths)


func _on_base_map_last_calculated_any_enemy_path_is_curve_deferred_changed(_arg_val): #val is unused here
	if base_map.last_calculated_any_path_is_curve_deferred:
		stage_round_manager.block_start_round_conditional_clauses.attempt_insert_clause(stage_round_manager.BlockStartRoundClauseIds.MAP_MANAGER__ENEMY_PATH_CURVE_DEFER)
	else:
		stage_round_manager.block_start_round_conditional_clauses.remove_clause(stage_round_manager.BlockStartRoundClauseIds.MAP_MANAGER__ENEMY_PATH_CURVE_DEFER)
	
	emit_signal("base_map_last_calculated_any_enemy_path_is_curve_deferred_changed", base_map.last_calculated_any_path_is_curve_deferred)



