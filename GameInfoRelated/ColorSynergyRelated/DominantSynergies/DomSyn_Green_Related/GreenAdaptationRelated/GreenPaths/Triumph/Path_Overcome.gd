extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"


const path_name = "Overcome"
const path_descs = [
	"All green towers change their attack’s damage type based on the enemy’s armor and toughness.",
	"Additionally, gain 5 armor and toughness pierce."
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/BlueOrangeFruit_Icon.png")

#

func _init().(path_name, path_descs, path_small_icon):
	pass

#

func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	._apply_path_tier_to_game_elements(tier, arg_game_elements)

func _remove_path_from_game_elements(tier : int, arg_game_elements : GameElements):
	._remove_path_from_game_elements(tier, arg_game_elements)
