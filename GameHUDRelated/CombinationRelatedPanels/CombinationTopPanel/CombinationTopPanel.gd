extends MarginContainer

const TowerIconPanel = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.gd")
const TowerIconPanel_Scene = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.tscn")
const TowerTooltip = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.gd")
const TowerTooltipScene = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.tscn")


const CombinationEffect = preload("res://GameInfoRelated/CombinationRelated/CombinationEffect.gd")


onready var combination_more_details_button = $HBoxContainer/MiddleFill/MainContainer/HBoxContainer/CombinationMoreDetailsButton
onready var combination_icons_hbox = $HBoxContainer/MiddleFill/MainContainer/HBoxContainer/ComboTowerIconsPanel

var current_tooltip : TowerTooltip

var per_tier_index_position : Dictionary = {
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0,
	5 : 0,
	6 : 0,
}

#


func add_combination_effect(arg_combi_effect : CombinationEffect):
	var tower_icon_scene = TowerIconPanel_Scene.instance()
	tower_icon_scene.set_tower_type_info(arg_combi_effect.tower_type_info)
	
	var tower_tier : int = arg_combi_effect.tower_type_info.tower_tier
	
	combination_icons_hbox.add_child(tower_icon_scene)
	combination_icons_hbox.move_child(tower_icon_scene, per_tier_index_position[tower_tier])
	
	tower_icon_scene.set_button_interactable(true)
	
	tower_icon_scene.connect("on_mouse_hovered", self, "on_tower_icon_mouse_entered", [arg_combi_effect.tower_type_info, tower_icon_scene], CONNECT_PERSIST)
	tower_icon_scene.connect("on_mouse_hover_exited", self, "on_tower_icon_mouse_exited", [tower_icon_scene], CONNECT_PERSIST)
	#combination_icons_hbox.connect("mouse_exited", self, "on_tower_icon_mouse_exited", [], CONNECT_PERSIST)
	
	shift_index_based_on_inserted_combi_effect(tower_tier)
	

func shift_index_based_on_inserted_combi_effect(arg_tower_tier : int):
	for tier in per_tier_index_position.keys():
		if arg_tower_tier > tier:
			continue
		
		per_tier_index_position[tier] += 1


#

func on_tower_icon_mouse_entered(tower_type_info, combi_icon):
	_free_old_and_create_tooltip_for_tower(tower_type_info, combi_icon)

func _free_old_and_create_tooltip_for_tower(tower_type_info, combi_icon):
	if current_tooltip != null:
		current_tooltip.queue_free()
	
	current_tooltip = TowerTooltipScene.instance()
	current_tooltip.tower_info = tower_type_info
	current_tooltip.tooltip_owner = combi_icon
	
	get_tree().get_root().add_child(current_tooltip)

func on_tower_icon_mouse_exited(combi_icon):
	if current_tooltip != null:
		current_tooltip.queue_free()
		current_tooltip = null
