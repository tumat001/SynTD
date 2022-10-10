extends MarginContainer

const TowerIconPanel = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.gd")
const TowerIconPanel_Scene = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.tscn")
const TowerTooltip = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.gd")
const TowerTooltipScene = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.tscn")

const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const tower_not_in_map_color := Color(0.55, 0.55, 0.55, 1)
const tower_in_map_color := Color(1.2, 1.2, 1.2, 1)

var tower_color : int
var active_towers : Array
var shop_manager
var game_settings_manager

onready var color_icon_trect = $HBoxContainer/ColorInfoPanel/VBoxContainer/ColorIcon
onready var color_name_label = $HBoxContainer/ColorInfoPanel/VBoxContainer/MarginContainer/ColorName

onready var tower_icons_container = $HBoxContainer/TowerIconsPanel/TowerIconsContainer

var current_tooltip : TowerTooltip

#

func update_display():
	if is_inside_tree():
		_update_color_info_display()
		_update_tower_icons_display()

#

func _update_color_info_display():
	color_icon_trect.texture = TowerColors.get_color_symbol_on_card(tower_color)
	color_name_label.text = TowerColors.get_color_name_on_card(tower_color)

#

func _update_tower_icons_display():
	for child in tower_icons_container.get_children():
		queue_free()
	
	var tower_ids_with_specified_color : Array = Towers.tower_color_to_tower_id_map[tower_color]
	
	for tower_id in tower_ids_with_specified_color:
		if shop_manager.current_tower_stock_inventory.has(tower_id):
			var type_info = Towers.tower_id_info_type_singleton_map[tower_id]
			
			var icon_panel = _construct_tower_icon_panel(type_info)
			icon_panel.modulate = tower_not_in_map_color
			for tower in active_towers:
				if tower.tower_id == type_info.tower_type_id:
					icon_panel.modulate = tower_in_map_color
					break
			
			tower_icons_container.add_child(icon_panel)
			
			icon_panel.set_button_interactable(true)



func _construct_tower_icon_panel(tower_type_info) -> TowerIconPanel:
	var tower_icon_panel : TowerIconPanel = TowerIconPanel_Scene.instance()
	tower_icon_panel.tower_type_info = tower_type_info
	
	tower_icon_panel.connect("on_mouse_hovered", self, "on_tower_icon_mouse_entered", [tower_type_info, tower_icon_panel], CONNECT_PERSIST)
	tower_icon_panel.connect("on_mouse_hover_exited", self, "on_tower_icon_mouse_exited", [tower_icon_panel], CONNECT_PERSIST)
	
	return tower_icon_panel

#


func on_tower_icon_mouse_entered(tower_type_info, combi_icon):
	_free_old_and_create_tooltip_for_tower(tower_type_info, combi_icon)

func _free_old_and_create_tooltip_for_tower(tower_type_info, combi_icon):
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
	
	current_tooltip = TowerTooltipScene.instance()
	current_tooltip.tower_info = tower_type_info
	current_tooltip.tooltip_owner = combi_icon
	current_tooltip.game_settings_manager = game_settings_manager
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(current_tooltip)

func on_tower_icon_mouse_exited(combi_icon):
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
		current_tooltip = null

