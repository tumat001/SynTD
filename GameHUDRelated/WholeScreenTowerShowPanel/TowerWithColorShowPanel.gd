extends MarginContainer

const ColorToTowerPanel = preload("res://GameHUDRelated/WholeScreenTowerShowPanel/Components/ColorToTowerPanel.gd")
const ColorToTowerPanel_Scene = preload("res://GameHUDRelated/WholeScreenTowerShowPanel/Components/ColorToTowerPanel.tscn")


var tower_manager
var game_settings_manager

onready var color_to_tower_panel_container = $MarginContainer/VBoxContainer/ColorToTowerPanelContainer


#

func show_towers_with_colors(tower_colors : Array):
	for child in color_to_tower_panel_container.get_children():
		child.queue_free()
	
	yield(get_tree(), "idle_frame")
	
	for color in tower_colors:
		var panel = _construct_color_to_tower_panel(color)
		color_to_tower_panel_container.add_child(panel)
		panel.update_display()


#

func _construct_color_to_tower_panel(tower_color : int) -> ColorToTowerPanel:
	var panel = ColorToTowerPanel_Scene.instance()
	panel.shop_manager = tower_manager.game_elements.shop_manager
	panel.active_towers = tower_manager.get_all_active_towers()
	panel.tower_color = tower_color
	panel.game_settings_manager = game_settings_manager
	
	return panel
