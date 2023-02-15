extends Node

#const GameModi_EasyDifficulty = preload("res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_EasyDifficulty.gd")


const SynTD_HeaderIDName = "SynTD_"

const GameModiIds__EasyDifficulty = "%s%s" % [SynTD_HeaderIDName, "EasyDifficulty"]
const GameModiIds__BeginnerDifficulty = "%s%s" % [SynTD_HeaderIDName, "BeginnerDifficulty"]

const GameModiIds__RedTowerRandomizer = "%s%s" % [SynTD_HeaderIDName, "RedTowerRandomizer"]

const GameModiIds__ModiTutorialPhase_01 = "%s%s" % [SynTD_HeaderIDName, "ModiTutorialPhase_01"]
const GameModiIds__ModiTutorialPhase_01_01 = "%s%s" % [SynTD_HeaderIDName, "ModiTutorialPhase_01_01"]
const GameModiIds__ModiTutorialPhase_02 = "%s%s" % [SynTD_HeaderIDName, "ModiTutorialPhase_02"]
const GameModiIds__ModiTutorialPhase_03 = "%s%s" % [SynTD_HeaderIDName, "ModiTutorialPhase_03"]
const GameModiIds__ModiTutorialPhase_04 = "%s%s" % [SynTD_HeaderIDName, "ModiTutorialPhase_04"]


const CYDE_HeaderIdName = "Cyde_"

const GameModiIds__CYDE_Common_Modifiers = "%s%s" % [CYDE_HeaderIdName, "CommonModifiers"]
const GameModiIds__CYDE_ExampleStage = "%s%s" % [CYDE_HeaderIdName, "ExampleStage"]

#enum GameModiIds {
#
#	# STANDARD DIFFICULTY MODIFIERS (0)
#	EASY_DIFFICULTY = 1
#	BEGINNER_DIFFICULTY = 2
#
#
#	# OTHER MODIFIERS (1000)
#
#
#	# FRAGMENT MODIFIERS (10000)
#	RED_TOWER_RANDOMIZER = 10000
#
#	# TUTORIALS (-10)
#	MODI_TUTORIAL_PHASE_01 = -10
#	MODI_TUTORIAL_PHASE_01_01 = -11
#	MODI_TUTORIAL_PHASE_02 = -13
#	MODI_TUTORIAL_PHASE_03 = -14
#	MODI_TUTORIAL_PHASE_04 = -15
#
#
#	# CYDE STUFFS (-1000)
#	CYDE__EXAMPLE_STAGE = -1000
#
#	CYDE__COMMON_GAME_MODIFIERS = -1001
#}


const game_modifier_id_to_script_name_map : Dictionary = {
	GameModiIds__EasyDifficulty : "res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_EasyDifficulty.gd",
	GameModiIds__BeginnerDifficulty : "res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_BeginnerDifficulty.gd",
	
	GameModiIds__RedTowerRandomizer : "res://GameplayRelated/GameModifiersRelated/GameModis/OmniPresent/GameModiOmni_RedTowerDecider.gd",
	
	GameModiIds__ModiTutorialPhase_01 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase01.gd",
	GameModiIds__ModiTutorialPhase_01_01 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase01_01.gd",
	GameModiIds__ModiTutorialPhase_02 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase02.gd",
	GameModiIds__ModiTutorialPhase_03 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase03.gd",
	GameModiIds__ModiTutorialPhase_04 : "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase04.gd",
	
	
	GameModiIds__CYDE_Common_Modifiers : "res://CYDE_SPECIFIC_ONLY/DialogRelated/GameModifiers/CommonModifiers/Cyde_CommonModifiers.gd",
	GameModiIds__CYDE_ExampleStage : "res://CYDE_SPECIFIC_ONLY/DialogRelated/GameModifiers/DialogStageMasters/StageExample/Imp_DialogeSM_StageExample.gd"
	#GameModiIds.CYDE__EXAMPLE_STAGE : "res://CYDE_SPECIFIC_ONLY/DialogRelated/GameModifiers/DialogStageMasters/StageExample/Imp_DialogeSM_StageExample.gd"
}


static func get_game_modifier_from_id(arg_id):
	var script_name = game_modifier_id_to_script_name_map[arg_id]
	
	return load(script_name).new()



###

func _on_singleton_initialize():
	pass


func add_game_modifier(arg_modi_id, arg_modi_script_name):
	game_modifier_id_to_script_name_map[arg_modi_id] = arg_modi_script_name
	

