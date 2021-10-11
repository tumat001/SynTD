extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")

#const tier_1_gold_income : int = 2
const tier_4_gold_income : int = 1

var gold_manager : GoldManager
var gold_income_per_round : int


func _apply_syn_to_game_elements(game_elements : GameElements, tier : int):
	if gold_manager == null:
		gold_manager = game_elements.gold_manager
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_give_gold_income"):
		game_elements.stage_round_manager.connect("round_ended", self, "_give_gold_income")
	
	#if tier == 1:
	#	gold_income_per_round = tier_1_gold_income
	#elif tier == 3 or tier == 2:
	gold_income_per_round = tier_4_gold_income
	
	._apply_syn_to_game_elements(game_elements, tier)


func _remove_syn_from_game_elements(game_elements : GameElements, tier : int):
	gold_manager = null
	
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_give_gold_income"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_give_gold_income")
	
	gold_income_per_round = 0
	
	._remove_syn_from_game_elements(game_elements, tier)

# gold income related

func _give_gold_income(current_stageround):
	gold_manager.increase_gold_by(gold_income_per_round, GoldManager.IncreaseGoldSource.TOWER_GOLD_INCOME)
