extends MarginContainer


class ConstructorParams:
	
	var recall_details_constr_params
	
	#
	
	var memory_icon_normal
	var memory_icon_hovered
	
	#
	


var recall_details_constr_params

var memory_icon_normal
var memory_icon_hovered

#

onready var memory_icon_normal_texture_rect = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/MemoryIcon
onready var memory_type_recall_details_panel = $MarginContainer/MarginContainer/VBoxContainer/Marginer/MemoryTypeRecallDetailsPanel

########

func set_prop_based_on_constructor(arg_constructor : ConstructorParams):
	recall_details_constr_params = arg_constructor.recall_details_constr_params
	
	memory_icon_normal = arg_constructor.memory_icon_normal
	memory_icon_hovered = arg_constructor.memory_icon_hovered
	
	if is_inside_tree():
		update_display()

#

func _ready():
	update_display()

func update_display():
	memory_icon_normal_texture_rect.texture = memory_icon_normal
	
	if recall_details_constr_params != null:
		memory_type_recall_details_panel.set_prop_based_on_constructor(recall_details_constr_params)

#
