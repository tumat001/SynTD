extends Node

const BaseMap = preload("res://MapsRelated/BaseMap.gd")

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


#

var chosen_map_id : int

var base_map : BaseMap

#

func _ready():
	_assign_map_from_store_of_maps()
	
	for child in get_children():
		if child is BaseMap:
			base_map = child
			break

#

func _assign_map_from_store_of_maps():
	var chosen_map = StoreOfMaps.get_map_from_map_id(chosen_map_id).instance()
	add_child(chosen_map)


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


#

func get_all_placables_in_range_from_mouse(radius : float, 
		placable_state : int = PlacableState.ANY, sort_order : int = SortOrder.CLOSEST) -> Array:
	
	var mouse_pos = get_viewport().get_mouse_position()
	return get_all_placables_in_range(mouse_pos, radius, placable_state, sort_order)

func get_all_placables_in_range(center_pos : Vector2, radius : float, 
		placable_state : int = PlacableState.ANY, sort_order : int = SortOrder.CLOSEST) -> Array:
	
	var bucket := []
	
	var placable_to_distance_array := []
	var all_placables = base_map.all_in_map_placables
	for placable in all_placables:
		var distance = center_pos.distance_to(placable.global_position)
		if (radius < distance):
			continue
		
		#
		
		if placable_state == PlacableState.OCCUPIED:
			if placable.tower_occupying == null:
				continue
		elif placable_state == PlacableState.UNOCCUPIED:
			if placable.tower_occupying != null:
				continue
		
		placable_to_distance_array.append([placable, distance])
	
	#
	
	if sort_order == SortOrder.FARTHEST:
		placable_to_distance_array.sort_custom(CustomSorter, "sort_placable_by_farthest")
	elif sort_order == SortOrder.CLOSEST:
		placable_to_distance_array.sort_custom(CustomSorter, "sort_placable_by_closest")
	elif sort_order == SortOrder.RANDOM:
		_find_random_distinct_placables(placable_to_distance_array, placable_to_distance_array.size())
	
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
