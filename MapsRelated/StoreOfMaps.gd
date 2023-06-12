extends Node

const BaseMap = preload("res://MapsRelated/BaseMap.gd")
const MapTypeInformation = preload("res://MapsRelated/MapTypeInformation.gd")

const Map_Glade_PreviewImage = preload("res://MapsRelated/MapList/Map_Glade/Glade_PreviewImage.png")

const Map_WIP_PreviewImage = preload("res://MapsRelated/MapList/TestMap/Map_WIP_ImagePreview.png")

#

class MapResourceVariationInfo:
	
	func _init(arg_range_module__circle_range_color,
			arg_in_map_placable__normal_texture,
			arg_in_map_placable__highlighted_texture):
		
		range_module__circle_range_color = arg_range_module__circle_range_color
		in_map_placable__normal_texture = arg_in_map_placable__normal_texture
		in_map_placable__highlighted_texture = arg_in_map_placable__highlighted_texture
	
	
	var range_module__circle_range_color : Color
	
	var in_map_placable__normal_texture : Texture
	var in_map_placable__highlighted_texture : Texture


const range_module__circle_range_color__standard : Color = Color(0.2, 0.2, 0.2, 0.14)
const range_module__circle_range_color__enchant : Color = Color(0.2, 0.2, 0.2, 0.25)
const range_module__circle_range_color__passage : Color = Color(0.2, 0.2, 0.2, 0.25)
const range_module__circle_range_color__mesa : Color = Color(0.2, 0.2, 0.2, 0.25)
const range_module__circle_range_color__rift : Color = Color(0.2, 0.2, 0.2, 0.30)
const range_module__circle_range_color__memories : Color = Color(0.2, 0.2, 0.2, 0.30)

const in_map_placable__normal_texture__standard : Texture = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapPlacable_Normal.png")
const in_map_placable__highlighted_texture__standard : Texture = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapPlacable_Glowing.png")

#

const SynTD_HeaderIDName = "SynTD_"

const MapsId_Glade = "%s%s" % [SynTD_HeaderIDName, "Glade"]

const MapsId_Riverside = "%s%s" % [SynTD_HeaderIDName, "Riverside"]
const MapsId_Ridged = "%s%s" % [SynTD_HeaderIDName, "Ridged"]
const MapsId_Mesa = "%s%s" % [SynTD_HeaderIDName, "Mesa"]
const MapsId_Passage = "%s%s" % [SynTD_HeaderIDName, "Passage"]
const MapsId_Enchant = "%s%s" % [SynTD_HeaderIDName, "Enchant"]
const MapsId_Rift = "%s%s" % [SynTD_HeaderIDName, "Rift"]
const MapsId_Memories = "%s%s" % [SynTD_HeaderIDName, "Memories"]

const MapsId_TutorialV02_01 = "%s%s" % [SynTD_HeaderIDName, "TutorialV02_01"]
const MapsId_TutorialV02_02 = "%s%s" % [SynTD_HeaderIDName, "TutorialV02_02"]



const all_syn_td_map_ids : Array = [
	MapsId_Glade,
	MapsId_Riverside,
	MapsId_Ridged,
	MapsId_Mesa,
	MapsId_Passage,
	MapsId_Enchant,
	MapsId_Rift,
	MapsId_Memories,
	
	MapsId_TutorialV02_01,
]

const all_tutorial_map_ids : Array = [
	MapsId_TutorialV02_01,
	MapsId_TutorialV02_02,
	
]

#

#enum MapsIds {
#	GLADE = -10,
#	# -1 is reserved.
#
#	RIVERSIDE = 0,
#	RIDGED = 1,
#	MESA = 2,
#	PASSAGE = 3,
#	ENCHANT = 4,
#}

# Maps appear at the order specified here. First in array is first in list.
const MapIdsAvailableFromMenu : Array = [
	#MapsIds.GLADE, # completely remove this soon
	MapsId_Riverside,
	
	MapsId_Ridged,
	
	MapsId_Enchant,
	MapsId_Rift,
	
	MapsId_Passage,
	
	MapsId_Mesa,
	
	MapsId_Memories,
]

# Can be used as the official list of all maps
const map_id_to_map_name_dict : Dictionary = {}
const map_name_to_map_id_dict : Dictionary = {}

const map_id_to_map_scene_name_dict : Dictionary = {}
const map_id_to__map_type_info_func_source_and_name : Dictionary = {}

const map_id_to_map_res_variation_info_dict : Dictionary = {}

#

var default_map_id_for_empty setget ,get_default_map_id_for_empty

#

func get_default_map_id_for_empty():
	if MapIdsAvailableFromMenu.size() > 0:
		return MapIdsAvailableFromMenu[0]
	else:
		return null

#

func _init():
	var glade_id = MapsId_Glade
	add_map(glade_id, "Glade",
			"res://MapsRelated/MapList/Map_Glade/Map_Glade.tscn",
			self,
			"_construct_map_type_info__map_glade",
			MapIdsAvailableFromMenu.has(glade_id),
			_construct_map_resource_variation_info__with_default_settings())
	
	##
	var riverside_id = MapsId_Riverside
	add_map(riverside_id, "Riverside",
			"res://MapsRelated/MapList/Map_Riverside/Map_Riverside.tscn",
			self,
			"_construct_map_type_info__map_riverside",
			MapIdsAvailableFromMenu.has(riverside_id),
			_construct_map_resource_variation_info__with_default_settings())
	
	##
	var ridged_id = MapsId_Ridged
	add_map(ridged_id, "Ridged",
			"res://MapsRelated/MapList/Map_Ridged/Map_Ridged.tscn",
			self,
			"_construct_map_type_info__map_ridged",
			MapIdsAvailableFromMenu.has(ridged_id),
			_construct_map_resource_variation_info__with_default_settings())
	
	##
	var res_var_info__mesa = MapResourceVariationInfo.new(
		range_module__circle_range_color__mesa,
		in_map_placable__normal_texture__standard,
		in_map_placable__highlighted_texture__standard
	)
	
	var mesa_id = MapsId_Mesa
	add_map(mesa_id, "Mesa",
			"res://MapsRelated/MapList/Map_Mesa/Map_Mesa.tscn",
			self,
			"_construct_map_type_info__map_mesa",
			MapIdsAvailableFromMenu.has(mesa_id),
			res_var_info__mesa)
	
	##
	var res_var_info__passage = MapResourceVariationInfo.new(
		range_module__circle_range_color__passage,
		in_map_placable__normal_texture__standard,
		in_map_placable__highlighted_texture__standard
	)
	
	var passage_id = MapsId_Passage
	add_map(passage_id, "Passage",
			"res://MapsRelated/MapList/Map_Passage/Map_Passage.tscn",
			self,
			"_construct_map_type_info__map_passage",
			MapIdsAvailableFromMenu.has(passage_id),
			res_var_info__passage)
	
	##
	var res_var_info__enchant = MapResourceVariationInfo.new(
		range_module__circle_range_color__passage,
		in_map_placable__normal_texture__standard,
		in_map_placable__highlighted_texture__standard
	)
	
	var enchant_id = MapsId_Enchant
	add_map(enchant_id, "Enchant",
			"res://MapsRelated/MapList/Map_Enchant/Map_Enchant.tscn",
			self,
			"_construct_map_type_info__map_enchant",
			MapIdsAvailableFromMenu.has(enchant_id),
			res_var_info__enchant)
	
	##
	var res_var_info__rift = MapResourceVariationInfo.new(
		range_module__circle_range_color__rift,
		in_map_placable__normal_texture__standard,
		in_map_placable__highlighted_texture__standard
	)
	
	var rift_id = MapsId_Rift
	add_map(rift_id, "Rift",
			"res://MapsRelated/MapList/Map_Rift/Map_Rift.tscn",
			self,
			"_construct_map_type_info__map_rift",
			MapIdsAvailableFromMenu.has(rift_id),
			res_var_info__rift)
	
	##
	var res_var_info__memories = MapResourceVariationInfo.new(
		range_module__circle_range_color__memories,
		in_map_placable__normal_texture__standard,
		in_map_placable__highlighted_texture__standard
	)
	
	var memories_id = MapsId_Memories
	add_map(memories_id, "Rift",
			"res://MapsRelated/MapList/Map_Memories/Map_Memories.tscn",
			self,
			"_construct_map_type_info__map_memories",
			MapIdsAvailableFromMenu.has(memories_id),
			res_var_info__memories)
	
	
	##
	
	

func _on_singleton_initialize():
	pass


#

static func get_map_from_map_id(id):
	if map_id_to_map_scene_name_dict.has(id):
		return load(map_id_to_map_scene_name_dict[id])
	else:
		return load(map_id_to_map_scene_name_dict[MapsId_Riverside])
	
#	if id == MapsId_Glade:
#		return load("res://MapsRelated/MapList/Map_Glade/Map_Glade.tscn")
#
#	elif id == MapsId_Riverside:
#		return load("res://MapsRelated/MapList/Map_Riverside/Map_Riverside.tscn")
#
#	elif id == MapsId_Ridged:
#		return load("res://MapsRelated/MapList/Map_Ridged/Map_Ridged.tscn")
#
#	elif id == MapsId_Mesa:
#		return load("res://MapsRelated/MapList/Map_Mesa/Map_Mesa.tscn")
#
#	elif id == MapsId_Passage:
#		return load("res://MapsRelated/MapList/Map_Passage/Map_Passage.tscn")
#
#	elif id == MapsId_Enchant:
#		return load("res://MapsRelated/MapList/Map_Enchant/Map_Enchant.tscn")
#
#	else:
#		return load("res://MapsRelated/MapList/Map_Riverside/Map_Riverside.tscn")


static func get_map_type_information_from_id(id):
	
	if map_id_to__map_type_info_func_source_and_name.has(id):
		var info = MapTypeInformation.new()
		info.map_id = id
		
		var func_source_and_name = map_id_to__map_type_info_func_source_and_name[id]
		func_source_and_name[0].call(func_source_and_name[1], info)
		
		return info
		
	else:
		return null

#

func _construct_map_type_info__map_glade(info : MapTypeInformation):
	info.map_name = "Glade"
	info.map_display_texture = Map_Glade_PreviewImage
	info.map_tier = 1
	#info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
	return info

func _construct_map_type_info__map_riverside(info : MapTypeInformation):
	info.map_name = "Riverside"
	info.map_display_texture = preload("res://MapsRelated/MapList/Map_Riverside/Map_Riverside_PreviewImage.png")
	info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
	info.map_tier = 1
	return info

func _construct_map_type_info__map_ridged(info : MapTypeInformation):
	info.map_name = "Ridged"
	info.map_display_texture = preload("res://MapsRelated/MapList/Map_Ridged/Map_Ridged_ImagePreview.png")
	info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
	info.map_tier = 2
	return info

func _construct_map_type_info__map_mesa(info : MapTypeInformation):
	info.map_name = "Mesa"
	info.map_display_texture = preload("res://MapsRelated/MapList/Map_Mesa/Map_Mesa_PreviewImage.png")
	info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
	info.map_tier = 5
	return info

func _construct_map_type_info__map_passage(info : MapTypeInformation):
	info.map_name = "Passage"
	info.map_display_texture = preload("res://MapsRelated/MapList/Map_Passage/Map_Passage_PreviewImage.png")
	info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
	info.map_tier = 4
	return info

func _construct_map_type_info__map_enchant(info : MapTypeInformation):
	info.map_name = "Enchant"
	info.map_display_texture = preload("res://MapsRelated/MapList/Map_Enchant/Map_Enchant_PreviewImage.png")
	info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
	info.map_tier = 3
	return info

func _construct_map_type_info__map_rift(info : MapTypeInformation):
	info.map_name = "Rift"
	info.map_display_texture = preload("res://MapsRelated/MapList/Map_Rift/Map_Rift_PreviewImage.png")
	info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_BEGINNER, StoreOfGameMode.Mode.STANDARD_EASY, StoreOfGameMode.Mode.STANDARD_NORMAL]
	info.map_tier = 3
	return info
	

func _construct_map_type_info__map_memories(info : MapTypeInformation):
	info.map_name = "Memories"
	info.map_display_texture #= todo preload("res://MapsRelated/MapList/Map_Rift/Map_Rift_PreviewImage.png")
	info.game_mode_ids_accessible_from_menu = [StoreOfGameMode.Mode.STANDARD_NORMAL]
	info.map_tier = 6
	return info
	

######

# must be done ON PreGameModifiers (BreakpointActivation.BEFORE_SINGLETONS_INIT). Not at any other time
func add_map(arg_map_id, arg_map_name, arg_scene_name, arg_map_type_info_func_source, arg_map_type_info_func_name, is_available_from_menu : bool,
		arg_map_res_variation_info : MapResourceVariationInfo):
	
	map_id_to_map_name_dict[arg_map_id] = arg_map_name
	map_name_to_map_id_dict[arg_map_name] = arg_map_id
	
	map_id_to_map_scene_name_dict[arg_map_id] = arg_scene_name
	map_id_to__map_type_info_func_source_and_name[arg_map_id] = [arg_map_type_info_func_source, arg_map_type_info_func_name]
	
	map_id_to_map_res_variation_info_dict[arg_map_id] = arg_map_res_variation_info
	
	set_map_is_available_from_menu(arg_map_id, is_available_from_menu)

# must be done ON PreGameModifiers (BreakpointActivation.BEFORE_SINGLETONS_INIT). Not at any other time
func set_map_is_available_from_menu(arg_map_id, arg_is_available):
	if arg_is_available and !MapIdsAvailableFromMenu.has(arg_map_id):
		MapIdsAvailableFromMenu.append(arg_map_id)
	elif !arg_is_available and MapIdsAvailableFromMenu.has(arg_map_id):
		MapIdsAvailableFromMenu.remove(arg_map_id)
	


###########

func _construct_map_resource_variation_info__with_default_settings():
	return MapResourceVariationInfo.new(
		range_module__circle_range_color__standard,
		in_map_placable__normal_texture__standard,
		in_map_placable__highlighted_texture__standard
	)

func get_map_resource_variation_info__range_module_range_color(arg_map_id):
	return map_id_to_map_res_variation_info_dict[arg_map_id].range_module__circle_range_color
	

func get_map_resource_variation_info__in_map_placable_normal(arg_map_id):
	return map_id_to_map_res_variation_info_dict[arg_map_id].in_map_placable__normal_texture
	

func get_map_resource_variation_info__in_map_placable_highlighted(arg_map_id):
	return map_id_to_map_res_variation_info_dict[arg_map_id].in_map_placable__highlighted_texture
	

