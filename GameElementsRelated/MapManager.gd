extends Node

const BaseMap = preload("res://MapsRelated/BaseMap.gd")


var chosen_map_id : int

var base_map : BaseMap

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

