extends MarginContainer

signal on_path_selected(path)


var black_dom_syn setget set_black_dom_syn

onready var path_selection_panel = $VBoxContainer/Black_PathSelectionPanel
onready var selected_path_panel = $VBoxContainer/Black_SelectedPathPanel
onready var description_panel = $VBoxContainer/Black_DescriptionPanel

func set_black_dom_syn(arg_syn):
	black_dom_syn = arg_syn

func _ready():
	path_selection_panel.connect("on_path_selected", self, "_emit_on_path_selected", [], CONNECT_PERSIST)
	path_selection_panel.connect("on_path_hovered", self, "_on_path_hovered_from_selection_panel", [], CONNECT_PERSIST)
	
	description_panel.set_dom_syn_black(black_dom_syn)
	path_selection_panel.set_black_dom_syn(black_dom_syn)
	


#

func _emit_on_path_selected(arg_path):
	emit_signal("on_path_selected", arg_path)
	selected_path_panel.set_black_path(arg_path)

func _on_path_hovered_from_selection_panel(arg_path):
	description_panel.display_description_and_name_of_path(arg_path)


#

func update_display():
	if black_dom_syn.chosen_black_path == null:
		path_selection_panel.visible = true
		selected_path_panel.visible = false
		
		description_panel.display_description_and_name_of_path(null)
	else:
		path_selection_panel.visible = false
		selected_path_panel.visible = true
		
		description_panel.display_description_and_name_of_path(black_dom_syn.chosen_black_path)
	
#	if black_dom_syn.curr_tier > black_dom_syn.SYN_TIER_PATH_BASIC_LEVEL:
#		modulate.a = 0.4
#	else:
#		modulate.a = 1
