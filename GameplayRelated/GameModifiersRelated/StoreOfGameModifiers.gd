extends Node

const GameModi_EasyDifficulty = preload("res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_EasyDifficulty.gd")


enum GameModiIds {
	
	# STANDARD DIFFICULTY MODIFIERS (0)
	EASY_DIFFICULTY = 1
	BEGINNER_DIFFICULTY = 2
	
	
	# OTHER MODIFIERS (1000)
	
	
	# FRAGMENT MODIFIERS (10000)
	RED_TOWER_RANDOMIZER = 10000
	
	# TUTORIALS (-10)
	MODI_TUTORIAL_PHASE_01 = -10
	MODI_TUTORIAL_PHASE_01_01 = -11
	MODI_TUTORIAL_PHASE_02 = -13
	MODI_TUTORIAL_PHASE_03 = -14
	MODI_TUTORIAL_PHASE_04 = -15
	
	
	# CYDE STUFFS (-1000)
	CYDE__EXAMPLE_STAGE = -1000
	
	CYDE__COMMON_GAME_MODIFIERS = -1001
	
}


const game_modifier_id_to_script_name_map : Dictionary = {
	GameModiIds.EASY_DIFFICULTY : "res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_EasyDifficulty.gd",
	GameModiIds.BEGINNER_DIFFICULTY : "res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_BeginnerDifficulty.gd",
	
	GameModiIds.RED_TOWER_RANDOMIZER : "res://GameplayRelated/GameModifiersRelated/GameModis/OmniPresent/GameModiOmni_RedTowerDecider.gd",
	
	GameModiIds.MODI_TUTORIAL_PHASE_01 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase01.gd",
	GameModiIds.MODI_TUTORIAL_PHASE_01_01 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase01_01.gd",
	GameModiIds.MODI_TUTORIAL_PHASE_02 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase02.gd",
	GameModiIds.MODI_TUTORIAL_PHASE_03 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase03.gd",
	GameModiIds.MODI_TUTORIAL_PHASE_04 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase04.gd",
	
	
	GameModiIds.CYDE__EXAMPLE_STAGE : "res://CYDE_SPECIFIC_ONLY/DialogRelated/GameModifiers/DialogStageMasters/StageExample/Imp_DialogeSM_StageExample.gd"
	
}


static func get_game_modifier_from_id(arg_id):
	var script_name = game_modifier_id_to_script_name_map[arg_id]
	
	return load(script_name).new()
	

#	if arg_id == GameModiIds.RED_TOWER_RANDOMIZER:
#		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/OmniPresent/GameModiOmni_RedTowerDecider.gd")
#		return script.new()
#
#	elif arg_id == GameModiIds.EASY_DIFFICULTY:
#		var script = GameModi_EasyDifficulty
#		return script.new()
#	elif arg_id == GameModiIds.BEGINNER_DIFFICULTY:
#		var script = preload("res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_BeginnerDifficulty.gd")
#		return script.new()
#
#
#	elif arg_id == GameModiIds.MODI_TUTORIAL_PHASE_01:
#		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase01.gd")
#		return script.new()
#	elif arg_id == GameModiIds.MODI_TUTORIAL_PHASE_01_01:
#		var script = preload("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase01_01.gd")
#		return script.new()
#	elif arg_id == GameModiIds.MODI_TUTORIAL_PHASE_02:
#		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase02.gd")
#		return script.new()
#	elif arg_id == GameModiIds.MODI_TUTORIAL_PHASE_03:
#		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase03.gd")
#		return script.new()
#	elif arg_id == GameModiIds.MODI_TUTORIAL_PHASE_04:
#		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase04.gd")
#		return script.new()
#
#
#	return null

