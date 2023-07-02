extends MarginContainer

const TowerIconPanel = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.gd")
const TowerIconPanel_Scene = preload("res://GameHUDRelated/TowerIconPanel/TowerIconPanel.tscn")
const TowerTooltip = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.gd")
const TowerTooltipScene = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.tscn")

const CombinationEffect = preload("res://GameInfoRelated/CombinationRelated/CombinationEffect.gd")


onready var box_container = $BoxContainer

#var tower_type_info_id_to_tower_icon_scene_map : Dictionary
var tower_type_info_id_list : Array
var tower_icon_scene_list : Array

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
	add_tower_icon(arg_combi_effect.tower_type_info)

func add_tower_icon(arg_tower_type_info):
	#if !tower_type_info_id_to_tower_icon_scene_map.has(arg_tower_type_info.tower_type_id):
	
	var tower_icon_scene = TowerIconPanel_Scene.instance()
	tower_icon_scene.set_tower_type_info(arg_tower_type_info)
	
	var tower_tier : int = arg_tower_type_info.tower_tier
	
	box_container.add_child(tower_icon_scene)
	box_container.move_child(tower_icon_scene, per_tier_index_position[tower_tier])
	
	tower_icon_scene.set_button_interactable(true)
	
	tower_icon_scene.connect("on_mouse_hovered", self, "on_tower_icon_mouse_entered", [arg_tower_type_info, tower_icon_scene], CONNECT_PERSIST)
	tower_icon_scene.connect("on_mouse_hover_exited", self, "on_tower_icon_mouse_exited", [tower_icon_scene], CONNECT_PERSIST)
	#combination_icons_hbox.connect("mouse_exited", self, "on_tower_icon_mouse_exited", [], CONNECT_PERSIST)
	
	shift_index_based_on_inserted_tower_type_info(tower_tier)
	
	#
	
	#tower_type_info_id_to_tower_icon_scene_map[arg_tower_type_info.tower_type_id] = tower_icon_scene
	tower_type_info_id_list.append(arg_tower_type_info.tower_type_id)
	tower_icon_scene_list.append(tower_icon_scene)

func shift_index_based_on_inserted_tower_type_info(arg_tower_tier : int):
	for tier in per_tier_index_position.keys():
		if arg_tower_tier > tier:
			continue
		
		per_tier_index_position[tier] += 1

#

func remove_combination_effect(arg_combi_effect : CombinationEffect):
	remove_tower_type_info(arg_combi_effect.tower_type_info.tower_type_id)

func remove_tower_type_info(arg_id : int):
	#if tower_type_info_id_to_tower_icon_scene_map.has(arg_combi_effect):
	
	var index = tower_type_info_id_list.bsearch(arg_id)
	#var icon_scene = tower_type_info_id_to_tower_icon_scene_map[arg_combi_effect]
	var icon_scene = tower_icon_scene_list[index]
	
	if is_instance_valid(icon_scene):
		icon_scene.queue_free()
	
	
	var tower_tier : int = tower_type_info_id_list[index].tower_tier #arg_combi_effect.tower_type_info.tower_tier
	
	shift_index_based_on_removed_tower_type_info(tower_tier)
	
	#tower_type_info_id_to_tower_icon_scene_map.erase(arg_combi_effect)
	tower_type_info_id_list.remove(index)
	tower_icon_scene_list.remove(index)


func shift_index_based_on_removed_tower_type_info(arg_tower_tier : int):
	for tier in per_tier_index_position.keys():
		if arg_tower_tier > tier:
			continue
		
		per_tier_index_position[tier] -= 1
 
#

func remove_all_combination_effects():
	#for icon in tower_type_info_id_to_tower_icon_scene_map.values():
	#	icon.queue_free()
	for icon in tower_icon_scene_list:
		icon.queue_free()
	
	#tower_type_info_id_to_tower_icon_scene_map.clear()
	tower_icon_scene_list.clear()
	tower_type_info_id_list.clear()
	
	reset_shift_index()

func reset_shift_index():
	for tier in per_tier_index_position.keys():
		per_tier_index_position[tier] = 0

#

func set_combination_effect_array(arg_combi_array : Array):
	var type_info_list = []
	for combi in arg_combi_array:
		type_info_list.append(combi.tower_type_info)
	
	set_tower_icon_array__using_tower_type_infos(type_info_list)
	#for combi_effect in arg_combi_array:
	#	if !tower_type_info_id_to_tower_icon_scene_map.has(combi_effect):
	#		add_combination_effect(combi_effect)
	
	#for combi_effect in tower_type_info_id_to_tower_icon_scene_map.keys():
	#	if !arg_combi_array.has(combi_effect):
	#		remove_combination_effect(combi_effect)
	
	

func set_tower_icon_array__using_tower_type_infos(arg_tower_type_arr : Array):
	var tower_type_ids : Array = []
	
	for tower_type_info in arg_tower_type_arr:
		tower_type_ids.append(tower_type_info.tower_type_id)
		add_tower_icon(tower_type_info)
	
	#
	var tower_type_ids_to_remove : Array = []
	
	var i = 0
	for id in tower_type_info_id_list:
		if !tower_type_ids.has(id):
			#remove_tower_type_info(id)
			tower_type_ids_to_remove.append(id)   # to account for multiple instance of ids
			tower_type_ids.erase(id)
		
		i += 1
	
	for id in tower_type_ids_to_remove:
		remove_tower_type_info(id)
	


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


