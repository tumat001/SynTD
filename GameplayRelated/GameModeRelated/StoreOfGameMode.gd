extends Node

const GameModeTypeInformation = preload("res://GameplayRelated/GameModeRelated/GameModeTypeInformation.gd")

const ModeNormal_StageRounds = preload("res://GameplayRelated/StagesAndRoundsRelated/CustomStagerounds/ModeNormal_StageRounds.gd")


enum Mode {
	STANDARD_EASY = 0,
	STANDARD_NORMAL = 1,
	
	
	#
	TUTORIAL_CHAPTER_01 = 10000,
	TUTORIAL_CHAPTER_02 = 10000,
	TUTORIAL_CHAPTER_03 = 10000,
	
}


static func get_mode_type_info_from_id(arg_id) -> GameModeTypeInformation:
	var info = GameModeTypeInformation.new()
	info.mode_id = arg_id
	
	if arg_id == Mode.STANDARD_EASY:
		
		info.mode_name = "Easy"
		return info
		
	elif arg_id == Mode.STANDARD_NORMAL:
		
		info.mode_name = "Normal"
		return info
		
	if arg_id == Mode.TUTORIAL_CHAPTER_01:
		
		info.mode_name = "Tutorial Chapter 01"
		info.game_modi_ids.append(StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_01)
		
		return info
		
	
	
	return null


#

static func get_stage_rounds_of_mode_from_id(arg_id):
	if arg_id == Mode.STANDARD_EASY:
		
		return null
		
	elif arg_id == Mode.STANDARD_NORMAL:
		
		return ModeNormal_StageRounds
		
	if arg_id == Mode.TUTORIAL_CHAPTER_01:
		
		return ModeNormal_StageRounds
		
	
	
	return null

#


func get_spawn_ins_of_faction__based_on_mode(arg_faction_id : int, arg_mode : int):
	var spawn_ins_of_faction_mode
	
	if arg_faction_id == EnemyConstants.EnemyFactions.EXPERT:
		if arg_mode == Mode.STANDARD_NORMAL:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionExpert_EnemySpawnIns.gd").new()
			
	elif arg_faction_id == EnemyConstants.EnemyFactions.FAITHFUL:
		if arg_mode == Mode.STANDARD_NORMAL:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionFaithful_EnemySpawnIns.gd").new()
		
	elif arg_faction_id == EnemyConstants.EnemyFactions.SKIRMISHERS:
		if arg_mode == Mode.STANDARD_NORMAL:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionSkirmisher_EnemySpawnIns.gd").new()
		
		
	elif arg_faction_id == EnemyConstants.EnemyFactions.BASIC:
		if arg_mode == Mode.STANDARD_NORMAL:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionBasic_EnemySpawnIns.gd").new()
		elif arg_mode == Mode.TUTORIAL_CHAPTER_01 or arg_mode == Mode.TUTORIAL_CHAPTER_02 or arg_mode == Mode.TUTORIAL_CHAPTER_03:
			spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionBasic_EnemySpawnIns.gd").new()
	
	
	return spawn_ins_of_faction_mode



