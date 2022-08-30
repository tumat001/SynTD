extends Node

const GameModi_EasyDifficulty = preload("res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_EasyDifficulty.gd")


enum GameModiIds {
	
	EASY_DIFFICULTY = 1
	
	MODI_TUTORIAL_PHASE_01 = -10
	MODI_TUTORIAL_PHASE_02 = -11
	MODI_TUTORIAL_PHASE_03 = -12
	MODI_TUTORIAL_PHASE_04 = -13
	
}




static func get_game_modifier_from_id(arg_id):
	if arg_id == GameModiIds.MODI_TUTORIAL_PHASE_01:
		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase01.gd")
		return script.new()
	elif arg_id == GameModiIds.MODI_TUTORIAL_PHASE_02:
		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase02.gd")
		return script.new()
	elif arg_id == GameModiIds.MODI_TUTORIAL_PHASE_03:
		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase03.gd")
		return script.new()
	elif arg_id == GameModiIds.MODI_TUTORIAL_PHASE_04:
		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase04.gd")
		return script.new()
	elif arg_id == GameModiIds.EASY_DIFFICULTY:
		var script = GameModi_EasyDifficulty
		return script.new()
	
	return null

