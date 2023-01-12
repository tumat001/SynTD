extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"

const HealthManager = preload("res://GameElementsRelated/HealthManager.gd")


const green_tier_requirement_inclusive : int = 2

const path_name = "Undying"
const path_descs = [
	"Gain 10 player health per round.",
	"Additionally, immediately gain 10 health."
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/FruitHeart_Icon.png")

const health_per_round_amount : int = 10
const health_one_time_give_amount : int = 10


var game_elements
var _given_one_time_heath : bool = false

#

func _init(arg_tier).(path_name, path_descs, path_small_icon, arg_tier):
	pass

#

func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if tier <= green_tier_requirement_inclusive:
		if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
			game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
		
		if !_given_one_time_heath:
			game_elements.health_manager.increase_health_by(health_one_time_give_amount, HealthManager.IncreaseHealthSource.SYNERGY)
			_given_one_time_heath = true
	
	._apply_path_tier_to_game_elements(tier, arg_game_elements)

func _remove_path_from_game_elements(tier : int, arg_game_elements : GameElements):
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	
	._remove_path_from_game_elements(tier, arg_game_elements)


#

func _on_round_end(curr_stageround):
	game_elements.health_manager.increase_health_by(health_per_round_amount, HealthManager.IncreaseHealthSource.SYNERGY)
