extends MarginContainer


onready var green_single_path_selection_gui_01 = $MarginContainer/VBoxContainer/SinglePathSelectionGUIContainer/Green_SinglePathSelectionGUI_01
onready var green_single_path_selection_gui_02 = $MarginContainer/VBoxContainer/SinglePathSelectionGUIContainer/Green_SinglePathSelectionGUI_02
onready var green_single_path_selection_gui_03 = $MarginContainer/VBoxContainer/SinglePathSelectionGUIContainer/Green_SinglePathSelectionGUI_03
onready var green_single_path_selection_gui_04 = $MarginContainer/VBoxContainer/SinglePathSelectionGUIContainer/Green_SinglePathSelectionGUI_04

var _all_green_single_path_selection_guis : Array

var dom_syn_green

#

func _ready():
	_all_green_single_path_selection_guis.append(green_single_path_selection_gui_01)
	_all_green_single_path_selection_guis.append(green_single_path_selection_gui_02)
	_all_green_single_path_selection_guis.append(green_single_path_selection_gui_03)
	_all_green_single_path_selection_guis.append(green_single_path_selection_gui_04)
	
	for gui in _all_green_single_path_selection_guis:
		gui.visible = false

#

func set_paths(arg_paths : Array):
	var provided_paths_size : int = arg_paths.size()
	for i in _all_green_single_path_selection_guis.size():
		var single_path_selection_gui = _all_green_single_path_selection_guis[i]
		
		if i < provided_paths_size:
			
			single_path_selection_gui.set_green_path(arg_paths[i], dom_syn_green)
			single_path_selection_gui.visible = true
			
		else:
			single_path_selection_gui.visible = false


