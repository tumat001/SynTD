extends Node

const BaseMap = preload("res://MapsRelated/BaseMap.gd")
const MapTypeInformation = preload("res://MapsRelated/MapTypeInformation.gd")

const Map_Glade_Scene = preload("res://MapsRelated/MapList/Map_Glade/Map_Glade.tscn")
const Map_Glade_PreviewImage = preload("res://MapsRelated/MapList/Map_Glade/Glade_PreviewImage.png")


enum MapsIds {
	GLADE = 0,
}

const MapIdsAvailableFromMenu : Array = [
	MapsIds.GLADE,
	
]



static func get_map_from_map_id(id : int):
	if id == MapsIds.GLADE:
		return Map_Glade_Scene
		
	else:
		return Map_Glade_Scene


static func get_map_type_information_from_id(id : int):
	var info = MapTypeInformation.new()
	info.map_id = id
	
	if id == MapsIds.GLADE:
		
		info.map_name = "Glade"
		info.map_display_texture = Map_Glade_PreviewImage
		info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
		return info
	
	return null

