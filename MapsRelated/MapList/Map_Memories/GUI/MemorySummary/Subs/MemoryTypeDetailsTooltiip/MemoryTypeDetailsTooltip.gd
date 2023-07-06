extends "res://GameHUDRelated/Tooltips/BaseTooltip.gd"


onready var recall_details_panel = $MemoryTypeRecallDetailsPanel


var recall_details_constr_param setget set_recall_details_constr_param

#

func set_recall_details_constr_param(arg_param):
	recall_details_constr_param = arg_param
	
	if is_inside_tree():
		_update_recall_details_panel()


func _ready():
	recall_details_panel.can_show_warning = false
	
	_update_recall_details_panel()


func _update_recall_details_panel():
	if recall_details_constr_param != null:
		recall_details_panel.set_prop_based_on_constructor(recall_details_constr_param)


