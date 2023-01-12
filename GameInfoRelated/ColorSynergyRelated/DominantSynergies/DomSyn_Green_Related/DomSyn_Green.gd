extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

#const Green_WholeScreenGUI = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Green_WholeScreenGUI.gd")
#const Green_WholeScreenGUI_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Green_WholeScreenGUI.tscn")

#const Green_WholeScreenGUI_V2 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Green_WholeScreenGUI_V2.gd")
#const Green_WholeScreenGUI_V2_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Green_WholeScreenGUI_V2.tscn")

const Green_WholeScreenGUI_ChosenList_V3 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/Green_WholeScreenGUI_ChosenList_V3.gd")
const Green_WholeScreenGUI_ChosenList_V3_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/Green_WholeScreenGUI_ChosenList_V3.tscn")

const Green_WholeScreenGUI_MultipleSelection_V3 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/Green_WholeScreenGUI_MultipleSelection_V3.gd")
const Green_WholeScreenGUI_MultipleSelection_V3_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/Green_WholeScreenGUI_MultipleSelection_V3.tscn")


const Green_SynInteractableIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Green_SynInteractableIcon.gd")
const Green_SynInteractableIcon_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Green_SynInteractableIcon.tscn")

const BaseGreenPath = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd")
const BaseGreenLayer = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenLayer.gd")

const Path_Blessing = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Beyond/Path_Blessing.gd")
const Path_Offering = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Beyond/Path_Offering.gd")

const Path_Overcome = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Triumph/Path_Overcome.gd")
const Path_Resilience = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Triumph/Path_Resilience.gd")
const Path_Undying = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Triumph/Path_Undying.gd")

const Path_Haste = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Bloom/Path_Haste.gd")
#const Path_Piercing = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Bloom/Path_Piercing.gd")
const Path_Horticulturist = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Bloom/Path_Horticulturist.gd")

const Path_QuickRoot = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Foundation/Path_QuickRoot.gd")
const Path_DeepRoot = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Foundation/Path_DeepRoot.gd")


const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")

const SYN_INACTIVE : int = -1

#

signal activated_path_tier_1_changed(arg_path)
signal activated_path_tier_2_changed(arg_path)
signal activated_path_tier_3_changed(arg_path)
signal activated_path_tier_4_changed(arg_path)

const activated_path_tier_1_changed_signal_name = "activated_path_tier_1_changed"
const activated_path_tier_2_changed_signal_name = "activated_path_tier_2_changed"
const activated_path_tier_3_changed_signal_name = "activated_path_tier_3_changed"
const activated_path_tier_4_changed_signal_name = "activated_path_tier_4_changed"

#

var curr_tier : int
var game_elements


var _curr_tier_1_layer : BaseGreenLayer # beyond
var _curr_tier_2_layer : BaseGreenLayer # triumph
var _curr_tier_3_layer : BaseGreenLayer # bloom
var _curr_tier_4_layer : BaseGreenLayer # foundation

var _all_layers : Array = []

var green_whole_screen_chosen_list_gui : Green_WholeScreenGUI_ChosenList_V3
var green_syn_interactable_icon : Green_SynInteractableIcon

var green_whole_screen_multiple_selection_gui : Green_WholeScreenGUI_MultipleSelection_V3

var _is_path_choice_pending : bool = false
#var _layer_tier_choices_pending : Array = []

#

var curr_activated_path_in_tier_1_layer : BaseGreenPath setget set_curr_activated_path_in_tier_1_layer
var curr_activated_path_in_tier_2_layer : BaseGreenPath setget set_curr_activated_path_in_tier_2_layer
var curr_activated_path_in_tier_3_layer : BaseGreenPath setget set_curr_activated_path_in_tier_3_layer
var curr_activated_path_in_tier_4_layer : BaseGreenPath setget set_curr_activated_path_in_tier_4_layer

var _curr_activated_path_tier_1_func_name := "set_curr_activated_path_in_tier_1_layer"
var _curr_activated_path_tier_2_func_name := "set_curr_activated_path_in_tier_2_layer"
var _curr_activated_path_tier_3_func_name := "set_curr_activated_path_in_tier_3_layer"
var _curr_activated_path_tier_4_func_name := "set_curr_activated_path_in_tier_4_layer"

# queue related

var reservation_for_whole_screen_chosen_list_gui
var reservation_for_whole_screen_multiple_selection_gui


#

func _init():
	_initialize_queue_reservation()

func _initialize_queue_reservation():
	reservation_for_whole_screen_chosen_list_gui = AdvancedQueue.Reservation.new(self)
	reservation_for_whole_screen_chosen_list_gui.on_entertained_method = "_on_queue_reservation_entertained"
	#reservation_for_whole_screen_chosen_list_gui.on_removed_method
	
	reservation_for_whole_screen_multiple_selection_gui = AdvancedQueue.Reservation.new(self)
	#reservation_for_whole_screen_multiple_selection_gui.on_en


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if _curr_tier_1_layer == null: # initialize
		_initialize_layer_1()
		_initialize_layer_2()
		_initialize_layer_3()
		_initialize_layer_4()
		
		# order matters. top (first) to bottom (last) will be shown on the GUI 
		_all_layers.append(_curr_tier_1_layer)
		_all_layers.append(_curr_tier_2_layer)
		_all_layers.append(_curr_tier_3_layer)
		_all_layers.append(_curr_tier_4_layer)
	
	if !is_instance_valid(green_syn_interactable_icon):
		_initialize_syn_interactable_icon()
	
	if !is_instance_valid(green_whole_screen_chosen_list_gui):
		_initialize_wholescreen_chosen_list_gui()
		_initialize_wholescreen_multiple_selection_gui()
	
	curr_tier = tier
	
	
	
	._apply_syn_to_game_elements(arg_game_elements, tier)

#
# WHEN ADDING A 5TH option path in layer, 
# update Green_WholeScreenGUI_MultipleSelection_V3
func _initialize_layer_1():
	var path_offering = Path_Offering.new(1)
	var path_blessing = Path_Blessing.new(1)
	
	_curr_tier_1_layer = BaseGreenLayer.new(1, 1, "Beyond", self, [path_offering, path_blessing])
	
	_connect_signals_with_path(path_offering, _curr_activated_path_tier_1_func_name)
	_connect_signals_with_path(path_blessing, _curr_activated_path_tier_1_func_name)
	
	_connect_signals_with_layer(_curr_tier_1_layer)

func _initialize_layer_2():
	var path_undying = Path_Undying.new(2)
	var path_overcome = Path_Overcome.new(2)
	var path_resilience = Path_Resilience.new(2)
	
	_curr_tier_2_layer = BaseGreenLayer.new(2, 1, "Truimph", self, [path_undying, path_overcome, path_resilience])
	
	_connect_signals_with_path(path_undying, _curr_activated_path_tier_2_func_name)
	_connect_signals_with_path(path_overcome, _curr_activated_path_tier_2_func_name)
	_connect_signals_with_path(path_resilience, _curr_activated_path_tier_2_func_name)
	
	_connect_signals_with_layer(_curr_tier_2_layer)

func _initialize_layer_3():
	#var path_piercing = Path_Piercing.new(3)
	var path_horti = Path_Horticulturist.new(3)
	var path_haste = Path_Haste.new(3)
	
	_curr_tier_3_layer = BaseGreenLayer.new(3, 1, "Bloom", self, [path_horti, path_haste])
	
	_connect_signals_with_path(path_horti, _curr_activated_path_tier_3_func_name)
	_connect_signals_with_path(path_haste, _curr_activated_path_tier_3_func_name)
	
	_connect_signals_with_layer(_curr_tier_3_layer)

func _initialize_layer_4():
	var path_quick_root = Path_QuickRoot.new(4)
	var path_deep_root = Path_DeepRoot.new(4)
	
	_curr_tier_4_layer = BaseGreenLayer.new(4, 1, "Foundation", self, [path_quick_root, path_deep_root])
	
	_connect_signals_with_path(path_quick_root, _curr_activated_path_tier_4_func_name)
	_connect_signals_with_path(path_deep_root, _curr_activated_path_tier_4_func_name)
	
	_connect_signals_with_layer(_curr_tier_4_layer)

func _initialize_syn_interactable_icon():
	green_syn_interactable_icon = Green_SynInteractableIcon_Scene.instance()
	green_syn_interactable_icon.connect("on_request_open_green_panel", self, "_on_request_open_green_panel", [], CONNECT_PERSIST)
	game_elements.synergy_interactable_panel.add_synergy_interactable(green_syn_interactable_icon)

func _initialize_wholescreen_chosen_list_gui():
	green_whole_screen_chosen_list_gui = Green_WholeScreenGUI_ChosenList_V3_Scene.instance()
	
	game_elements.whole_screen_gui.add_control_but_dont_show(green_whole_screen_chosen_list_gui)
	
	green_whole_screen_chosen_list_gui.set_domsyn_green(self)
	green_whole_screen_chosen_list_gui.initialize_chosen_path_gui_layer_signals([
		activated_path_tier_1_changed_signal_name,
		activated_path_tier_2_changed_signal_name,
		activated_path_tier_3_changed_signal_name,
		activated_path_tier_4_changed_signal_name
	])



func _initialize_wholescreen_multiple_selection_gui():
	green_whole_screen_multiple_selection_gui = Green_WholeScreenGUI_MultipleSelection_V3_Scene.instance()
	green_whole_screen_multiple_selection_gui.dom_syn_green = self
	
	game_elements.whole_screen_gui.add_control_but_dont_show(green_whole_screen_multiple_selection_gui)


#

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = SYN_INACTIVE
	
	._remove_syn_from_game_elements(arg_game_elements, tier)

#

func _on_request_open_green_panel():
	#game_elements.whole_screen_gui.show_control(green_whole_screen_gui)
	if !_is_path_choice_pending:
		game_elements.whole_screen_gui.queue_control(green_whole_screen_chosen_list_gui, reservation_for_whole_screen_chosen_list_gui)
	else:
		game_elements.whole_screen_gui.queue_control(green_whole_screen_multiple_selection_gui, reservation_for_whole_screen_multiple_selection_gui, true, false)

func _on_queue_reservation_entertained():
	pass


#####

func _connect_signals_with_path(arg_path : BaseGreenPath, arg_func_setter_name):
	arg_path.connect("on_path_activated", self, arg_func_setter_name, [arg_path], CONNECT_PERSIST)
	
	

func _connect_signals_with_layer(arg_layer : BaseGreenLayer):
	arg_layer.connect("on_available_green_paths_changed", self, "_on_available_green_paths_changed_for_layer", [arg_layer], CONNECT_PERSIST)
	


#

func set_curr_activated_path_in_tier_1_layer(arg_path : BaseGreenPath):
	curr_activated_path_in_tier_1_layer = arg_path
	_is_path_choice_pending = false
	game_elements.whole_screen_gui.hide_control(green_whole_screen_multiple_selection_gui)
	emit_signal("activated_path_tier_1_changed", arg_path)
	

func set_curr_activated_path_in_tier_2_layer(arg_path : BaseGreenPath):
	curr_activated_path_in_tier_2_layer = arg_path
	_is_path_choice_pending = false
	game_elements.whole_screen_gui.hide_control(green_whole_screen_multiple_selection_gui)
	emit_signal("activated_path_tier_2_changed", arg_path)
	

func set_curr_activated_path_in_tier_3_layer(arg_path : BaseGreenPath):
	curr_activated_path_in_tier_3_layer = arg_path
	_is_path_choice_pending = false
	game_elements.whole_screen_gui.hide_control(green_whole_screen_multiple_selection_gui)
	emit_signal("activated_path_tier_3_changed", arg_path)
	

func set_curr_activated_path_in_tier_4_layer(arg_path : BaseGreenPath):
	curr_activated_path_in_tier_4_layer = arg_path
	_is_path_choice_pending = false
	game_elements.whole_screen_gui.hide_control(green_whole_screen_multiple_selection_gui)
	emit_signal("activated_path_tier_4_changed", arg_path)
	

#

func _on_available_green_paths_changed_for_layer(arg_paths, arg_layer):
	if arg_paths.size() > 0:
		_is_path_choice_pending = true
		
		
		green_whole_screen_multiple_selection_gui.set_paths(arg_paths)
		game_elements.whole_screen_gui.queue_control(green_whole_screen_multiple_selection_gui, reservation_for_whole_screen_multiple_selection_gui, true, false)
		
	else:
		pass
#		if _is_path_choice_pending:
#			if green_whole_screen_multiple_selection_gui.visible:
#				game_elements.whole_screen_gui.hide_control(green_whole_screen_multiple_selection_gui)
#
#			_is_path_choice_pending = false


