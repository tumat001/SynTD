extends MarginContainer


const Almanac_XTypeInfo_StatPanel = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/Almanac_XTypeInfoPanel/Shared/Almanac_XTypeInfoPanel_StatPanel/Almanac_XTypeInfoPanel_StatPanel.gd")
const Almanac_XTypeInfo_StatPanel_Scene = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/Almanac_XTypeInfoPanel/Shared/Almanac_XTypeInfoPanel_StatPanel/Almanac_XTypeInfoPanel_StatPanel.tscn")

const Almanac_XTypeInfo_MultiStatsData = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_XTypeInfo_MultiStatsData.gd")


#var almanac_item_list_entry_data : Almanac_ItemListEntry_Data

var x_type_info_multi_stats_data : Almanac_XTypeInfo_MultiStatsData
var x_type_info

onready var stats_container = $MarginContainer/ScrollContainer/StatsContainer

#



#

func update_display():
	var all_stats_panel = stats_container.get_children()
	
	var multi_stats_data_count = x_type_info_multi_stats_data.get_info_count()
	var stat_panel_count = all_stats_panel.size()
	var highest_count = stat_panel_count
	if stat_panel_count < multi_stats_data_count:
		highest_count = multi_stats_data_count
	
	var last_stat_panel : Almanac_XTypeInfo_StatPanel
	
	for i in highest_count:
		var stat_panel : Almanac_XTypeInfo_StatPanel
		
		if stat_panel_count > i:
			stat_panel = all_stats_panel[i]
			
			if multi_stats_data_count <= i:
				stat_panel.visible = false
			else:
				stat_panel.visible = true
			
			
		elif multi_stats_data_count > i:
			stat_panel = _constrcut_almanac_stat_panel()
		
		#stat_panel.set_show_bottom_border(false)
		last_stat_panel = stat_panel
		
		if multi_stats_data_count > i:
			var datas = x_type_info_multi_stats_data.get_x_type_infos_data_at_index(i)
			
			stat_panel.x_type_info = x_type_info
			stat_panel.x_type_info_name = datas[0]
			stat_panel.x_type_info_icon = datas[1]
			stat_panel.x_type_info__var_name_as_value = datas[2]
			stat_panel.x_type_info_descriptions = datas[3]
			
			stat_panel.x_type_info__var_value_conv_method_name = datas[4]
			stat_panel.x_type_info__var_value_conv_source = datas[5]
			
			stat_panel.x_type_info__descriptions_source_method_name = datas[6]
			stat_panel.x_type_info__descriptions_source_obj = datas[7]
			
			stat_panel.update_display()
	
	if last_stat_panel != null:
		pass
		#last_stat_panel.set_show_bottom_border(true)
	

func _constrcut_almanac_stat_panel():
	var panel = Almanac_XTypeInfo_StatPanel_Scene.instance()
	stats_container.add_child(panel)
	
	return panel



