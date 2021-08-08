extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const BaseGreenPath = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd")

const SYN_INACTIVE : int = -1



var curr_tier : int
var game_elements


var _curr_tier_1_path : BaseGreenPath
var _curr_tier_2_path : BaseGreenPath
var _curr_tier_3_path : BaseGreenPath
var _curr_tier_4_path : BaseGreenPath


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	curr_tier = tier
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = SYN_INACTIVE
	
	._remove_syn_from_game_elements(arg_game_elements, tier)
