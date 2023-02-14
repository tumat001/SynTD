extends "res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd"


const enemy_health_multiplier : float = 0.70
const bonus_gold_at_round_end : int = 1

func _init().(StoreOfGameModifiers.GameModiIds__BeginnerDifficulty, 
		BreakpointActivation.BEFORE_GAME_START, "Beginner Difficulty Modifiers"):
	
	pass

#

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	
	game_elements.enemy_manager.add_enemy_health_multiplier_percent_amount(game_elements.EnemyManager.EnemyHealthMultipliersSourceIds.GAME_MODI_DIFFICULTY_GENERIC_TAG, enemy_health_multiplier)
	game_elements.stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end__game_start_aware", [], CONNECT_PERSIST)

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	
	game_elements.enemy_manager.remove_enemy_health_multiplier_percent_amount(game_elements.EnemyManager.EnemyHealthMultipliersSourceIds.GAME_MODI_DIFFICULTY_GENERIC_TAG)
	game_elements.stage_round_manager.disconnect("round_ended_game_start_aware", self, "_on_round_end__game_start_aware")

#

func _on_round_end__game_start_aware(current_stageround, from_game_start):
	if !from_game_start:
		game_elements.gold_manager.increase_gold_by(bonus_gold_at_round_end, game_elements.GoldManager.IncreaseGoldSource.GAME_MODIFIER)

