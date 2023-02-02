extends MarginContainer


const Almanac_TowerTypeInfoPanel_SingleColorPanel = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/Almanac_XTypeInfoPanel/TowerSpecific/Almanac_TowerTypeInfoPanel_ColorPanel/SingleColorPanel/Almanac_TowerTypeInfoPanel_SingleColorPanel.tscn")

var color_ids : Array

onready var color_container = $MarginContainer/ColorContainer

#

func update_display():
	var curr_color_panels = color_container.get_children()
	
	var color_panel_count = color_container.get_child_count()
	var color_ids_count = color_ids.size()
	var highest_count = color_panel_count
	if color_panel_count < color_ids_count:
		highest_count = color_ids_count
	
	for i in highest_count:
		var color_panel
		
		if color_panel_count > i:
			color_panel = curr_color_panels[i]
			
			if color_ids_count <= i:
				color_panel.visible = false
			else:
				color_panel.visible = true
			
		elif color_ids_count > i:
			color_panel = _construct_color_panel()
			
		
		if color_ids_count > i:
			color_panel.color_id = color_ids[i]
			color_panel.update_display()


func _construct_color_panel():
	var panel = Almanac_TowerTypeInfoPanel_SingleColorPanel.instance()
	
	color_container.add_child(panel)
	
	return panel

#

