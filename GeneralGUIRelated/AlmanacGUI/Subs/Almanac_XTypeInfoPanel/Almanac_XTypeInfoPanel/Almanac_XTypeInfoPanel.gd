extends MarginContainer

const Almanac_ItemListEntry_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListEntry_Data.gd")
const Almanac_XTypeInfo_MultiStatsData = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_XTypeInfo_MultiStatsData.gd")

const SynergyTooltip = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynergyTooltip.gd")

#

var _almanac_item_list_entry_data
var _x_info_type

var _all_borders : Array = []
var _all_components : Array = []

#

onready var x_image = $Content/VBoxContainer/HBoxContainer/Almanac_XTypeInfo_XImage
onready var x_name = $Content/VBoxContainer/Almanac_XTypeInfo_XName
onready var x_multi_stat_panel = $Content/VBoxContainer/Almanac_XTypeInfo_MultiStatsPanel
onready var x_descriptions = $Content/VBoxContainer/Almanac_XTypeInfo_Descriptions

onready var tower_type__color_panel = $Content/VBoxContainer/HBoxContainer/Almanac_TowerTypeInfoPanel_ColorPanel
onready var tower_type__tier_and_ing_panel = $Content/VBoxContainer/HBoxContainer/Almanac_TowerTypeInfoPanel_TierAndIngPanel

onready var syn_type__tier_descriptions = $Content/VBoxContainer/Almanac_SynTypeInfo_TierDescriptions


onready var background = $Background
onready var top_border = $TopBorder
onready var left_border = $LeftBorder
onready var right_border = $RightBorder
onready var bottom_border = $BottomBorder

#

func _ready():
	_all_borders.append(top_border)
	_all_borders.append(left_border)
	_all_borders.append(right_border)
	_all_borders.append(bottom_border)
	
	_all_components.append(x_image)
	_all_components.append(x_name)
	_all_components.append(x_multi_stat_panel)
	_all_components.append(x_descriptions)
	_all_components.append(tower_type__color_panel)
	_all_components.append(tower_type__tier_and_ing_panel)
	_all_components.append(syn_type__tier_descriptions)

#

func set_properties(arg_item_list_entry : Almanac_ItemListEntry_Data,
		arg_x_type_info_multi_stats_data : Almanac_XTypeInfo_MultiStatsData):
	
	_x_info_type = arg_item_list_entry.get_x_type_info()
	
	x_image.almanac_item_list_entry_data = arg_item_list_entry
	x_image.update_display()
	
	x_name.x_name = _x_info_type.get_name__for_almanac_use()
	x_name.update_display()
	
	update_descriptions_panel()
	
	background.texture = arg_item_list_entry.right_side_panel__background_texture
	for border in _all_borders:
		border.texture = arg_item_list_entry.right_side_panel__border_texture
	
	##
	
	for compo in _all_components:
		compo.visible = false
	
	##
	
	var x_type_info_classification = arg_item_list_entry.get_x_type_info_classification()
	if x_type_info_classification == arg_item_list_entry.TypeInfoClassification.TOWER:
		_configure_self_on_type_info__tower(arg_item_list_entry, arg_x_type_info_multi_stats_data)
		
	elif x_type_info_classification == arg_item_list_entry.TypeInfoClassification.ENEMY:
		_configure_self_on_type_info__enemy(arg_x_type_info_multi_stats_data)
		
	elif x_type_info_classification == arg_item_list_entry.TypeInfoClassification.SYNERGY:
		_configure_self_on_type_info__synergy(arg_item_list_entry)
		
	elif x_type_info_classification == arg_item_list_entry.TypeInfoClassification.TEXT_TIDBIT:
		_configure_self_on_type_info__tidbit(arg_item_list_entry)

func update_descriptions_panel():
	x_descriptions.descriptions = GameSettingsManager.get_descriptions_to_use_based_on_x_type_info(_x_info_type, GameSettingsManager)
	x_descriptions.update_display()

##

func _configure_self_on_type_info__tower(arg_item_list_entry, arg_x_type_info_multi_stats_data):
	x_image.visible = true
	x_name.visible = true
	
	x_multi_stat_panel.visible = true
	x_multi_stat_panel.x_type_info = _x_info_type
	x_multi_stat_panel.x_type_info_multi_stats_data = arg_x_type_info_multi_stats_data
	x_multi_stat_panel.update_display()
	
	x_descriptions.visible = true
	
	tower_type__color_panel.visible = true
	tower_type__color_panel.color_ids = arg_item_list_entry.get_x_type_info().colors
	tower_type__color_panel.update_display()
	
	tower_type__tier_and_ing_panel.visible = true
	tower_type__tier_and_ing_panel.tower_type_info = arg_item_list_entry.get_x_type_info()
	tower_type__tier_and_ing_panel.update_display()

func _configure_self_on_type_info__enemy(arg_x_type_info_multi_stats_data):
	x_image.visible = true
	x_name.visible = true
	x_multi_stat_panel.visible = true
	x_multi_stat_panel.x_type_info = _x_info_type
	x_multi_stat_panel.x_type_info_multi_stats_data = arg_x_type_info_multi_stats_data
	x_multi_stat_panel.update_display()
	
	x_descriptions.visible = true
	

func _configure_self_on_type_info__synergy(arg_item_list_entry):
	x_image.visible = true
	x_name.visible = true
	x_descriptions.visible = true
	
	syn_type__tier_descriptions.visible = true
	syn_type__tier_descriptions.descriptions = SynergyTooltip.construct_tooltips_descs_for_curr_effects(_x_info_type, syn_type__tier_descriptions.desc_panel, true)#_x_info_type.synergy_effects_descriptions
	syn_type__tier_descriptions.update_display()

func _configure_self_on_type_info__tidbit(arg_item_list_entry):
	x_image.visible = true
	x_name.visible = true
	x_descriptions.visible = true
	

