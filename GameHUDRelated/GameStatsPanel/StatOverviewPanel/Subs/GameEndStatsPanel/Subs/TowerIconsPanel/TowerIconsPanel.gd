extends MarginContainer

const TowerIconPanel = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.gd")
const TowerIconPanel_Scene = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.tscn")


onready var hbox_container = $MarginContainer/HBoxContainer

func set_tower_ids_to_display(arg_ids):
	_clear_icons()
	
	for id in arg_ids:
		_construct_icon_panel_for_id(id)


func _clear_icons():
	for child in hbox_container.get_children():
		child.queue_free()

func _construct_icon_panel_for_id(arg_id):
	var type_info = Towers.get_tower_info(arg_id)
	
	if type_info != null:
		var icon = TowerIconPanel_Scene.instance()
		icon.tower_type_info = type_info
		
		hbox_container.add_child(icon)
	
