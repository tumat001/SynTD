extends MarginContainer

const Almanac_ItemListEntry_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListEntry_Data.gd")
const Almanac_XTypeInfo_MultiStatsData = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_XTypeInfo_MultiStatsData.gd")

#

var _almanac_item_list_entry_data
var _x_info_type

#

onready var x_image = $Content/VBoxContainer/Almanac_XTypeInfo_XImage
onready var x_name = $Content/VBoxContainer/Almanac_XTypeInfo_XName
onready var x_multi_stat_panel = $Content/VBoxContainer/Almanac_XTypeInfo_MultiStatsPanel
onready var x_descriptions = $Content/VBoxContainer/Almanac_XTypeInfo_Descriptions

#

func set_properties(arg_item_list_entry : Almanac_ItemListEntry_Data,
		arg_x_type_info_multi_stats_data : Almanac_XTypeInfo_MultiStatsData):
	
	_x_info_type = arg_item_list_entry.get_x_type_info()
	
	x_image.almanac_item_list_entry_data = arg_item_list_entry
	x_image.update_display()
	
	x_name.x_name = _x_info_type.get_name__for_almanac_use()
	x_name.update_display()
	
	x_multi_stat_panel.x_type_info = _x_info_type
	x_multi_stat_panel.x_type_info_multi_stats_data = arg_x_type_info_multi_stats_data
	x_multi_stat_panel.update_display()
	
	update_descriptions_panel()

func update_descriptions_panel():
	x_descriptions.descriptions = GameSettingsManager.get_descriptions_to_use_based_on_x_type_info(_x_info_type, GameSettingsManager)
	x_descriptions.update_display()

