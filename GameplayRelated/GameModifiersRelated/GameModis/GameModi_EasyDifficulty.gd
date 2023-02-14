extends "res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd"


const enemy_health_multiplier : float = 0.85

func _init().(StoreOfGameModifiers.GameModiIds__EasyDifficulty, 
		BreakpointActivation.BEFORE_GAME_START, "Easy Difficulty Modifiers"):
	
	pass

#

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	
	game_elements.enemy_manager.add_enemy_health_multiplier_percent_amount(game_elements.EnemyManager.EnemyHealthMultipliersSourceIds.GAME_MODI_DIFFICULTY_GENERIC_TAG, enemy_health_multiplier)


func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	
	game_elements.enemy_manager.remove_enemy_health_multiplier_percent_amount(game_elements.EnemyManager.EnemyHealthMultipliersSourceIds.GAME_MODI_DIFFICULTY_GENERIC_TAG)

#

