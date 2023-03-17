extends "res://MapsRelated/BaseMap.gd"




var game_elements

var top_right_pos : Vector2
var bot_left_pos : Vector2


const rift_color__for_speed := Color(16/255.0, 8/255.0, 68/255.0, 0.2)
const rift_color__for_invis := Color(16/255.0, 8/255.0, 68/255.0, 0.7)

class RiftProperties:
	
	var speed_amount : float = 20.0
	var speed_duration : float = -1
	
	var invis_duration : float = -1
	
	
	var rift_width__for_speed : int
	var rift_width__for_invis : int


var stage_num_to_rift_properties_map : Dictionary = {}


#

func _ready():
	pass

#

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	game_elements = arg_game_elements
	
	##
	
	_configure_rift_poses_and_properties()


func _configure_rift_poses_and_properties():
	var top_left_pos = game_elements.get_top_left_coordinates_of_playable_map()
	var bot_right_pos = game_elements.get_bot_right_coordinates_of_playable_map()
	
	top_right_pos = Vector2(bot_right_pos.x, top_left_pos.y)
	bot_left_pos = Vector2(top_left_pos.x, bot_right_pos.y)
	
	#######
	
	var rift_properties_01 = RiftProperties.new()
	rift_properties_01.rift_width__for_speed = 10
	rift_properties_01.rift_width__for_invis = 0
	stage_num_to_rift_properties_map["01"] = rift_properties_01
	
	var rift_properties_11 = RiftProperties.new()
	rift_properties_11.rift_width__for_speed = 20
	rift_properties_11.rift_width__for_invis = 0
	stage_num_to_rift_properties_map["11"] = rift_properties_11
	
	var rift_properties_21 = RiftProperties.new()
	rift_properties_21.rift_width__for_speed = 30
	rift_properties_21.rift_width__for_invis = 0
	stage_num_to_rift_properties_map["21"] = rift_properties_21
	
	var rift_properties_31 = RiftProperties.new()
	rift_properties_31.rift_width__for_speed = 40
	rift_properties_31.rift_width__for_invis = 0
	stage_num_to_rift_properties_map["31"] = rift_properties_31
	
	var rift_properties_41 = RiftProperties.new()
	rift_properties_41.rift_width__for_speed = 50
	rift_properties_41.rift_width__for_invis = 0
	stage_num_to_rift_properties_map["41"] = rift_properties_41
	
	var rift_properties_51 = RiftProperties.new()
	rift_properties_51.rift_width__for_speed = 60
	rift_properties_51.rift_width__for_invis = 30
	stage_num_to_rift_properties_map["51"] = rift_properties_51
	
	var rift_properties_61 = RiftProperties.new()
	rift_properties_61.rift_width__for_speed = 70
	rift_properties_61.rift_width__for_invis = 40
	stage_num_to_rift_properties_map["61"] = rift_properties_61
	
	var rift_properties_71 = RiftProperties.new()
	rift_properties_71.rift_width__for_speed = 80
	rift_properties_71.rift_width__for_invis = 50
	stage_num_to_rift_properties_map["71"] = rift_properties_71
	
	var rift_properties_81 = RiftProperties.new()
	rift_properties_81.rift_width__for_speed = 90
	rift_properties_81.rift_width__for_invis = 60
	stage_num_to_rift_properties_map["81"] = rift_properties_81
	
	var rift_properties_91 = RiftProperties.new()
	rift_properties_91.rift_width__for_speed = 100
	rift_properties_91.rift_width__for_invis = 70
	stage_num_to_rift_properties_map["91"] = rift_properties_91
	


