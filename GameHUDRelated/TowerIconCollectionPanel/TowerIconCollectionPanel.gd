extends MarginContainer

const TowerIconPanel = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.gd")
const TowerIconPanel_Scene = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.tscn")
const TowerTooltip = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.gd")
const TowerTooltipScene = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.tscn")

const CombinationEffect = preload("res://GameInfoRelated/CombinationRelated/CombinationEffect.gd")


onready var box_container = $BoxContainer

var combination_effect_to_tower_icon_scene_map : Dictionary
var current_tooltip

var per_tier_index_position : Dictionary = {
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0,
	5 : 0,
	6 : 0,
}


func add_combination_effect(arg_combi_effect : CombinationEffect):
	if !combination_effect_to_tower_icon_scene_map.has(arg_combi_effect):
		var tower_icon_scene = TowerIconPanel_Scene.instance()
		tower_icon_scene.set_tower_type_info(arg_combi_effect.tower_type_info)
		
		var tower_tier : int = arg_combi_effect.tower_type_info.tower_tier
		
		box_container.add_child(tower_icon_scene)
		box_container.move_child(tower_icon_scene, per_tier_index_position[tower_tier])
		
		tower_icon_scene.set_button_interactable(true)
		
		tower_icon_scene.connect("on_mouse_hovered", self, "on_tower_icon_mouse_entered", [arg_combi_effect.tower_type_info, tower_icon_scene], CONNECT_PERSIST)
		tower_icon_scene.connect("on_mouse_hover_exited", self, "on_tower_icon_mouse_exited", [tower_icon_scene], CONNECT_PERSIST)
		#combination_icons_hbox.connect("mouse_exited", self, "on_tower_icon_mouse_exited", [], CONNECT_PERSIST)
		
		shift_index_based_on_inserted_combi_effect(tower_tier)
		
		#
		
		combination_effect_to_tower_icon_scene_map[arg_combi_effect] = tower_icon_scene

func shift_index_based_on_inserted_combi_effect(arg_tower_tier : int):
	for tier in per_tier_index_position.keys():
		if arg_tower_tier > tier:
			continue
		
		per_tier_index_position[tier] += 1

#

func remove_combination_effect(arg_combi_effect : CombinationEffect):
	if combination_effect_to_tower_icon_scene_map.has(arg_combi_effect):
		var icon_scene = combination_effect_to_tower_icon_scene_map[arg_combi_effect]
		
		if is_instance_valid(icon_scene):
			icon_scene.queue_free()
		
		
		var tower_tier : int = arg_combi_effect.tower_type_info.tower_tier
		
		shift_index_based_on_removed_combi_effect(tower_tier)
		
		combination_effect_to_tower_icon_scene_map.erase(arg_combi_effect)

func shift_index_based_on_removed_combi_effect(arg_tower_tier : int):
	for tier in per_tier_index_position.keys():
		if arg_tower_tier > tier:
			continue
		
		per_tier_index_position[tier] -= 1
 
#

func remove_all_combination_effects():
	for icon in combination_effect_to_tower_icon_scene_map.values():
		icon.queue_free()
	
	combination_effect_to_tower_icon_scene_map.clear()
	reset_shift_index()

func reset_shift_index():
	for tier in per_tier_index_position.keys():
		per_tier_index_position[tier] = 0

#

func set_combination_effect_array(arg_combi_array : Array):
	for combi_effect in arg_combi_array:
		if !combination_effect_to_tower_icon_scene_map.has(combi_effect):
			add_combination_effect(combi_effect)
	
	for combi_effect in combination_effect_to_tower_icon_scene_map.keys():
		if !arg_combi_array.has(combi_effect):
			remove_combination_effect(combi_effect)

#

func on_tower_icon_mouse_entered(tower_type_info, combi_icon):
	_free_old_and_create_tooltip_for_tower(tower_type_info, combi_icon)

func _free_old_and_create_tooltip_for_tower(tower_type_info, combi_icon):
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
	
	current_tooltip = TowerTooltipScene.instance()
	current_tooltip.tower_info = tower_type_info
	current_tooltip.tooltip_owner = combi_icon
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(current_tooltip)

func on_tower_icon_mouse_exited(combi_icon):
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
		current_tooltip = null

##


