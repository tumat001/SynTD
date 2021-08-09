extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const Green_WholeScreenGUI = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Green_WholeScreenGUI.gd")
const Green_WholeScreenGUI_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Green_WholeScreenGUI.tscn")
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
const Path_Piercing = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Bloom/Path_Piercing.gd")

const Path_QuickRoot = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Foundation/Path_QuickRoot.gd")
const Path_DeepRoot = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Foundation/Path_DeepRoot.gd")


const SYN_INACTIVE : int = -1



var curr_tier : int
var game_elements


var _curr_tier_1_layer : BaseGreenLayer # beyond
var _curr_tier_2_layer : BaseGreenLayer # triumph
var _curr_tier_3_layer : BaseGreenLayer # bloom
var _curr_tier_4_layer : BaseGreenLayer # foundation

var green_whole_screen_gui : Green_WholeScreenGUI
var green_syn_interactable_icon : Green_SynInteractableIcon


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if _curr_tier_1_layer == null: # initialize
		_initialize_layer_1()
		_initialize_layer_2()
		_initialize_layer_3()
		_initialize_layer_4()
	
	if green_syn_interactable_icon == null:
		_initialize_syn_interactable_icon()
	
	if green_whole_screen_gui == null:
		_initialize_wholescreen_gui()
	
	curr_tier = tier
	
	
	
	._apply_syn_to_game_elements(arg_game_elements, tier)

#

func _initialize_layer_1():
	var path_offering = Path_Offering.new()
	var path_blessing = Path_Blessing.new()
	
	_curr_tier_1_layer = BaseGreenLayer.new(1, 1, "Beyond", self, [path_offering, path_blessing])

func _initialize_layer_2():
	var path_undying = Path_Undying.new()
	var path_overcome = Path_Overcome.new()
	var path_resilience = Path_Resilience.new()
	
	_curr_tier_2_layer = BaseGreenLayer.new(2, 1, "Truimph", self, [path_undying, path_overcome, path_resilience])

func _initialize_layer_3():
	var path_piercing = Path_Piercing.new()
	var path_haste = Path_Haste.new()
	
	_curr_tier_3_layer = BaseGreenLayer.new(3, 1, "Bloom", self, [path_piercing, path_haste])

func _initialize_layer_4():
	var path_quick_root = Path_QuickRoot.new()
	var path_deep_root = Path_DeepRoot.new()
	
	_curr_tier_4_layer = BaseGreenLayer.new(4, 1, "Foundation", self, [path_quick_root, path_deep_root])


func _initialize_syn_interactable_icon():
	green_syn_interactable_icon = Green_SynInteractableIcon_Scene.instance()
	green_syn_interactable_icon.connect("on_request_open_green_panel", self, "_on_request_open_green_panel", [], CONNECT_PERSIST)
	game_elements.synergy_interactable_panel.add_synergy_interactable(green_syn_interactable_icon)

func _initialize_wholescreen_gui():
	green_whole_screen_gui = Green_WholeScreenGUI_Scene.instance()
	green_whole_screen_gui.set_domsyn_green(self)

#

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = SYN_INACTIVE
	
	._remove_syn_from_game_elements(arg_game_elements, tier)

#

func _on_request_open_green_panel():
	game_elements.whole_screen_gui.show_control(green_whole_screen_gui)
