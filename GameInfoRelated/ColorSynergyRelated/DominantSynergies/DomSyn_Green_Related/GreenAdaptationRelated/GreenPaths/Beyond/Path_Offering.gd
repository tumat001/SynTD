extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"


const path_name = "Offering"
const path_descs = [
	"Gain additional 2 relics.",
	"Relics are not lost when the synergy tier is not met.",
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/Relic_Icon.png")

const relic_amount : int = 2

var _relics_given : bool = false

#

func _init(arg_tier).(path_name, path_descs, path_small_icon, arg_tier):
	pass

#

func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	if !_relics_given:
		_relics_given = true
		arg_game_elements.relic_manager.increase_relic_count_by(relic_amount, arg_game_elements.RelicManager.IncreaseRelicSource.SYNERGY)
	
	._apply_path_tier_to_game_elements(tier, arg_game_elements)

func _remove_path_from_game_elements(tier : int, arg_game_elements : GameElements):
	._remove_path_from_game_elements(tier, arg_game_elements)
