extends Node

const BaseMap = preload("res://MapsRelated/BaseMap.gd")
const MapTypeInformation = preload("res://MapsRelated/MapTypeInformation.gd")

const Map_Glade_Scene = preload("res://MapsRelated/MapList/Map_Glade/Map_Glade.tscn")
const Map_Glade_PreviewImage = preload("res://MapsRelated/MapList/Map_Glade/Glade_PreviewImage.png")

const Map_WIP_PreviewImage = preload("res://MapsRelated/MapList/TestMap/Map_WIP_ImagePreview.png")


enum MapsIds {
	GLADE = -10,
	# -1 is reserved.
	
	RIVERSIDE = 0,
	RIDGED = 1,
	MESA = 2,
	PASSAGE = 3,
}

const MapIdsAvailableFromMenu : Array = [
	#MapsIds.GLADE, # completely remove this soon
	MapsIds.RIVERSIDE,
	
	MapsIds.RIDGED,
	#MapsIds.MESA,  #todo enable again if FOV algo is improved/changed.
	MapsIds.PASSAGE,
]

const default_map_id_for_empty : int = MapsIds.RIVERSIDE


static func get_map_from_map_id(id : int):
	if id == MapsIds.GLADE:
		return Map_Glade_Scene
		
	elif id == MapsIds.RIVERSIDE:
		return load("res://MapsRelated/MapList/Map_Riverside/Map_Riverside.tscn")
		
	elif id == MapsIds.RIDGED:
		return load("res://MapsRelated/MapList/Map_Ridged/Map_Ridged.tscn")
		
	elif id == MapsIds.MESA:
		return load("res://MapsRelated/MapList/Map_Mesa/Map_Mesa.tscn")
		
	elif id == MapsIds.PASSAGE:
		return load("res://MapsRelated/MapList/Map_Passage/Map_Passage.tscn")
		
	else:
		return load("res://MapsRelated/MapList/Map_Riverside/Map_Riverside.tscn")


static func get_map_type_information_from_id(id : int):
	var info = MapTypeInformation.new()
	info.map_id = id
	
	if id == MapsIds.GLADE:
		
		info.map_name = "Glade"
		info.map_display_texture = Map_Glade_PreviewImage
		info.map_tier = 1
		#info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
		return info
		
	elif id == MapsIds.RIVERSIDE:
		
		info.map_name = "Riverside"
		info.map_display_texture = preload("res://MapsRelated/MapList/Map_Riverside/Map_Riverside_PreviewImage.png")
		info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
		info.map_tier = 1
		return info
		
	elif id == MapsIds.RIDGED:
		
		info.map_name = "Ridged"
		info.map_display_texture = preload("res://MapsRelated/MapList/Map_Ridged/Map_Ridged_ImagePreview.png")
		info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
		info.map_tier = 2
		return info
		
	elif id == MapsIds.MESA:
		
		info.map_name = "Mesa"
		info.map_display_texture = Map_WIP_PreviewImage #todo
		info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
		info.map_tier = 3
		return info
		
	elif id == MapsIds.PASSAGE:
		
		info.map_name = "Passage"
		info.map_display_texture = preload("res://MapsRelated/MapList/Map_Passage/Map_Passage_PreviewImage.png")
		info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
		info.map_tier = 3
		return info
		
	
	return null

