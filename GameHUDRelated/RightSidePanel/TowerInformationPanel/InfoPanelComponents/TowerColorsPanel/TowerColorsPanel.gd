extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const SingleColorPanel_Scene = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerColorsPanel/SingleColorPanel.tscn")

var tower : AbstractTower

onready var single_color_panel_vbox = $VBoxContainer/BodyPanel/ScrollContainer/BodyMargin/SingleColorPanelVBox
onready var count_label = $VBoxContainer/MarginContainer/CountPanel/Marginer/CountLabel

func update_display():
	for child in single_color_panel_vbox.get_children():
		#single_color_panel_vbox.remove_child(child)
		child.queue_free()
	
	if is_instance_valid(tower):
		for color in tower._tower_colors:
			var color_panel = SingleColorPanel_Scene.instance()
			color_panel.color = color
			color_panel.update_display()
			
			single_color_panel_vbox.add_child(color_panel)
		
		count_label.text = str(tower._tower_colors.size())
		
	else:
		count_label.text = "0"

