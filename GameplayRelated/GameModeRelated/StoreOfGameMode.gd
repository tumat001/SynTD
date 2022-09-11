extends Node

const GameModeTypeInformation = preload("res://GameplayRelated/GameModeRelated/GameModeTypeInformation.gd")

const ModeNormal_StageRounds = preload("res://GameplayRelated/StagesAndRoundsRelated/CustomStagerounds/ModeNormal_StageRounds.gd")
const ModeTutorial_01_01_StageRounds = preload("res://GameplayRelated/StagesAndRoundsRelated/CustomStagerounds/TutorialsRelated/ModeTutorial_Phase01_01_StageRounds.gd")

const GameModi_EasyDifficulty = preload("res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_EasyDifficulty.gd")
const GameModi_BeginnerDifficulty = preload("res://GameplayRelated/GameModifiersRelated/GameModis/GameModi_BeginnerDifficulty.gd")

enum Mode {
	STANDARD_BEGINNER = 0,
	STANDARD_EASY = 1,
	STANDARD_NORMAL = 2,
	
	
	
	#
	TUTORIAL_CHAPTER_01 = 10000,
	TUTORIAL_CHAPTER_01_01 = 10001,
	TUTORIAL_CHAPTER_02 = 10003,
	TUTORIAL_CHAPTER_03 = 10004,
	TUTORIAL_CHAPTER_04 = 10005,
	
}

#


static func get_mode_type_info_from_id(arg_id) -> GameModeTypeInformation:
	var info = GameModeTypeInformation.new()
	info.mode_id = arg_id
	
	if arg_id == Mode.STANDARD_EASY:
		
		info.mode_name = "Easy"
		info.mode_descriptions = [
			"Enemies have %s%% less health." % [str((1 - GameModi_EasyDifficulty.enemy_health_multiplier) * 100)]
		]
		info.game_modi_ids = [StoreOfGameModifiers.GameModiIds.EASY_DIFFICULTY]
		return info
		
		
	elif arg_id == Mode.STANDARD_BEGINNER:
		
		info.mode_name = "Beginner"
		info.mode_descriptions = [
			"Enemies have %s%% less health." % [str((1 - GameModi_BeginnerDifficulty.enemy_health_multiplier) * 100)],
			"Gain %s additional gold per end of round." % [str(GameModi_BeginnerDifficulty.bonus_gold_at_round_end)]
		]
		info.game_modi_ids = [StoreOfGameModifiers.GameModiIds.BEGINNER_DIFFICULTY]
		return info
		
		
	elif arg_id == Mode.STANDARD_NORMAL:
		
		info.mode_name = "Normal"
		info.mode_descriptions = [
			"The true experience."
		]
		return info
		
		
	elif arg_id == Mode.TUTORIAL_CHAPTER_01:
		
		info.mode_name = "Tutorial Chapter 1"
		info.game_modi_ids = [StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_01]
		
		return info
		
	elif arg_id == Mode.TUTORIAL_CHAPTER_01_01:
		
		info.mode_name = "Tutorial Chapter 1.5"
		info.game_modi_ids = [StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_01_01]
		
		return info
		
		
	elif arg_id == Mode.TUTORIAL_CHAPTER_02:
		
		info.mode_name = "Tutorial Chapter 2"
		info.game_modi_ids = [StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_02]
		
		return info
		
	elif arg_id == Mode.TUTORIAL_CHAPTER_03:
		
		info.mode_name = "Tutorial Chapter 3"
		info.game_modi_ids = [StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_03]
		
		return info
		
	elif arg_id == Mode.TUTORIAL_CHAPTER_04:
		info.mode_name = "Tutorial Chapter 4"
		info.game_modi_ids = [StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_04]
		
		return info
	
	
	return null


#

static func get_stage_rounds_of_mode_from_id(arg_id):
	if arg_id == Mode.STANDARD_EASY or arg_id == Mode.STANDARD_BEGINNER:
		
		return ModeNormal_StageRounds
		
	elif arg_id == Mode.STANDARD_NORMAL:
		
		return ModeNormal_StageRounds
		
	elif arg_id == Mode.TUTORIAL_CHAPTER_01 or arg_id == Mode.TUTORIAL_CHAPTER_02 or arg_id == Mode.TUTORIAL_CHAPTER_03 or arg_id == Mode.TUTORIAL_CHAPTER_04:
		
		return ModeNormal_StageRounds
		
	elif arg_id == Mode.TUTORIAL_CHAPTER_01_01:
		
		return ModeTutorial_01_01_StageRounds
	
	return null

#


func get_spawn_ins_of_faction__based_on_mode(arg_faction_id : int, arg_mode : int):
	var spawn_ins_of_faction_mode
	
	if arg_faction_id == EnemyConstants.EnemyFactions.EXPERT:
		if arg_mode == Mode.STANDARD_NORMAL or arg_mode == Mode.STANDARD_EASY or arg_mode == Mode.STANDARD_BEGINNER:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionExpert_EnemySpawnIns.gd").new()
			
	elif arg_faction_id == EnemyConstants.EnemyFactions.FAITHFUL:
		if arg_mode == Mode.STANDARD_NORMAL or arg_mode == Mode.STANDARD_EASY or arg_mode == Mode.STANDARD_BEGINNER:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionFaithful_EnemySpawnIns.gd").new()
		
	elif arg_faction_id == EnemyConstants.EnemyFactions.SKIRMISHERS:
		if arg_mode == Mode.STANDARD_NORMAL or arg_mode == Mode.STANDARD_EASY or arg_mode == Mode.STANDARD_BEGINNER:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionSkirmisher_EnemySpawnIns.gd").new()
		
		
	elif arg_faction_id == EnemyConstants.EnemyFactions.BASIC:
		if arg_mode == Mode.STANDARD_NORMAL or arg_mode == Mode.STANDARD_EASY or arg_mode == Mode.STANDARD_BEGINNER:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionBasic_EnemySpawnIns.gd").new()
			
		elif arg_mode == Mode.TUTORIAL_CHAPTER_01 or arg_mode == Mode.TUTORIAL_CHAPTER_02 or arg_mode == Mode.TUTORIAL_CHAPTER_03 or arg_mode == Mode.TUTORIAL_CHAPTER_04:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionBasic_EnemySpawnIns.gd").new()
			
		elif arg_mode == Mode.TUTORIAL_CHAPTER_01_01:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/Tutorial/FactionBasic_EnemySpawnIns_TutorialPhase01_01.gd").new()
	
	return spawn_ins_of_faction_mode



