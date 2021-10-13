extends Node

const BaseMap = preload("res://MapsRelated/BaseMap.gd")

const Map_Glade = preload("res://MapsRelated/MapList/Map_Glade/Map_Glade.tscn")


enum MapsIds {
	DEFAULT = 0
	
	GLADE = 0,
}


static func get_map_from_map_id(id : int):
	if id == MapsIds.GLADE:
		return Map_Glade
		
		
	else:
		return Map_Glade


