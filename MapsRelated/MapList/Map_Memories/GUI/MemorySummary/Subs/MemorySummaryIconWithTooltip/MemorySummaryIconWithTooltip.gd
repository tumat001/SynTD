extends MarginContainer

const MemoryTypeDetailsTooltip = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySummary/Subs/MemoryTypeDetailsTooltiip/MemoryTypeDetailsTooltip.gd")
const MemoryTypeDetailsTooltip_Scene = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySummary/Subs/MemoryTypeDetailsTooltiip/MemoryTypeDetailsTooltip.tscn")


var tooltip : MemoryTypeDetailsTooltip

var recall_type_panel_constr_param setget set_recall_type_panel_constr_param

var tooltip_owner


var _is_mouse_inside : bool

#

onready var icon_texture_rect = $IconTextureRect

##

func set_recall_type_panel_constr_param(arg_param):
	recall_type_panel_constr_param = arg_param
	
	if is_inside_tree():
		_update_icon_texture()

func _ready():
	_update_icon_texture()
	


#

func _update_icon_texture():
	if recall_type_panel_constr_param != null:
		if _is_mouse_inside:
			icon_texture_rect.texture = recall_type_panel_constr_param.memory_icon_hovered
			
		else:
			icon_texture_rect.texture = recall_type_panel_constr_param.memory_icon_normal
			
	
	

#

func _construct_tooltip__destroy_curr_if_exisiting():
	if is_instance_valid(tooltip):
		tooltip.queue_free()
		
	
	##
	
	tooltip = MemoryTypeDetailsTooltip_Scene.instance()
	
	tooltip_owner.add_child(tooltip)
	tooltip.set_tooltip_owner(self)
	tooltip.recall_details_constr_param = recall_type_panel_constr_param.recall_details_constr_params
	



###########

func _on_MemorySummaryIconWithTooltip_mouse_entered():
	_construct_tooltip__destroy_curr_if_exisiting()
	
	_is_mouse_inside = true
	_update_icon_texture()

func _on_MemorySummaryIconWithTooltip_mouse_exited():
	_is_mouse_inside = false
	_update_icon_texture()
	

func _on_MemorySummaryIconWithTooltip_visibility_changed():
	if !visible:
		_is_mouse_inside = false
		_update_icon_texture()
	
