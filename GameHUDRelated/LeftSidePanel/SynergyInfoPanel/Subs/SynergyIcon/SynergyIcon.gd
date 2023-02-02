extends MarginContainer



# AS of now, only big is supported. Add map for small size to make it work
enum IconSize {
	BIG = 0,
	SMALL = 1
}

enum BorderType {
	BLACK = 0,
	WHITE = 1,
}

const icon_size_to_vector_size_map : Dictionary = {
	IconSize.BIG : Vector2(30, 30),
	IconSize.SMALL : Vector2(14, 14)
}

const border_type_to_border_img_map__big : Dictionary = {
	BorderType.BLACK : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Border_Black_Big.png"),
	BorderType.WHITE : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Border_White_Big.png"),
	
}


#var synergy_id_to_pic_map__big : Dictionary = {
#	TowerDominantColors.SynergyId.RED : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Red_30x30.png"),
#	TowerDominantColors.SynergyId.ORANGE : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Orange_30x30.png"),
#	TowerDominantColors.SynergyId.YELLOW : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Yellow_30x30.png"),
#	TowerDominantColors.SynergyId.GREEN : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Green_30x30.png"),
#	TowerDominantColors.SynergyId.BLUE : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Blue_30x30.png"),
#	TowerDominantColors.SynergyId.VIOLET : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Violet_30x30.png"),
#	TowerDominantColors.SynergyId.WHITE : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_White_30x30.png"),
#	TowerDominantColors.SynergyId.BLACK : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Black_30x30.png"),
#
#	TowerCompositionColors.SynergyId.BlueVG : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_BlueVG_30x30.png"),
#	TowerCompositionColors.SynergyId.GreenBY : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_GreenBY_30x30.png"),
#	TowerCompositionColors.SynergyId.OrangeBlue : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_OrangeBlue_30x30.png"),
#	TowerCompositionColors.SynergyId.OGV : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_OrangeGreenViolet_30x30.png"),
#	TowerCompositionColors.SynergyId.OrangeYR : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_OrangeYR_30x30.png"),
#	TowerCompositionColors.SynergyId.RedGreen : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_RedGreen_30x30.png"),
#	TowerCompositionColors.SynergyId.RedOV : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_RedOV_30x30.png"),
#	TowerCompositionColors.SynergyId.RYB : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_RedYellowBlue_30x30.png"),
#	TowerCompositionColors.SynergyId.VioletRB : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_VioletRB_30x30.png"),
#	TowerCompositionColors.SynergyId.YellowGO : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_YellowGO_30x30.png"),
#	TowerCompositionColors.SynergyId.YellowViolet : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Compo_YelVio_30x30.png"),
#
#}


#

var icon_size = IconSize.BIG setget set_icon_size
var synergy_id : int setget set_synergy_id
var border_type = BorderType.BLACK setget set_border_type

#

var _all_borders : Array = []

#

onready var left_border = $LeftBorder
onready var right_border = $RightBorder
onready var top_border = $TopBorder
onready var bottom_border = $BottomBorder

onready var icon_texture_rect = $Icon

#

func _ready():
	_all_borders.append(left_border)
	_all_borders.append(right_border)
	_all_borders.append(top_border)
	_all_borders.append(bottom_border)
	
	_update_display()

func _update_display():
	if is_inside_tree():
		rect_size = icon_size_to_vector_size_map[icon_size]
		
		if icon_size == IconSize.BIG:
			for border in _all_borders:
				border.texture = border_type_to_border_img_map__big[border_type]
			
			#icon_texture_rect.texture = synergy_id_to_pic_map__big[synergy_id]
			icon_texture_rect.texture = _get_synergy_pic_big_of_syn_id()

func _get_synergy_pic_big_of_syn_id():
	if TowerCompositionColors.synergy_id_to_syn_name_dictionary.has(synergy_id):
		return TowerCompositionColors.synergy_id_to_pic_map__big[synergy_id]
	elif TowerDominantColors.synergy_id_to_syn_name_dictionary.has(synergy_id):
		return TowerDominantColors.synergy_id_to_pic_map__big[synergy_id]
	


#

func set_icon_size(arg_size):
	icon_size = arg_size
	
	_update_display()

func set_border_type(arg_type):
	border_type = arg_type
	
	_update_display()

func set_synergy_id(arg_id):
	synergy_id = arg_id
	
	_update_display()


