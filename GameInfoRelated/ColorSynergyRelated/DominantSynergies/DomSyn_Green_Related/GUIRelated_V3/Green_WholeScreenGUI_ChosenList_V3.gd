extends MarginContainer


var domsyn_green setget set_domsyn_green

#

onready var chosen_path_guis_container = $VBox
onready var chosen_path_gui__tier_1 = $VBox/Green_ChosenPathGUI_Tier1
onready var chosen_path_gui__tier_2 = $VBox/Green_ChosenPathGUI_Tier2
onready var chosen_path_gui__tier_3 = $VBox/Green_ChosenPathGUI_Tier3
onready var chosen_path_gui__tier_4 = $VBox/Green_ChosenPathGUI_Tier4

var _all_chosen_path_guis : Array = []

#

func _ready():
	_all_chosen_path_guis.append(chosen_path_gui__tier_1)
	_all_chosen_path_guis.append(chosen_path_gui__tier_2)
	_all_chosen_path_guis.append(chosen_path_gui__tier_3)
	_all_chosen_path_guis.append(chosen_path_gui__tier_4)
	

func set_domsyn_green(arg_syn):
	domsyn_green = arg_syn
	
	for chosen_path_gui in _all_chosen_path_guis:
		chosen_path_gui.set_domsyn_green(domsyn_green)

func initialize_chosen_path_gui_layer_signals(arg_signals):
	for i in _all_chosen_path_guis.size():
		_all_chosen_path_guis[i].set_assigned_layer(arg_signals[i])


