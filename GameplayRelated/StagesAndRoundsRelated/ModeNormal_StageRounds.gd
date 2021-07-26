extends "res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd"

const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")

var second_half_faction : int setget ,get_second_half_faction

func _init():
	stage_rounds = [
		_get_stageround_0_1(),
		_get_stageround_0_2(),
		_get_stageround_0_3(),
		_get_stageround_0_4(),
		_get_stageround_0_5(),
		_get_stageround_1_1(),
		_get_stageround_1_2(),
		_get_stageround_1_3(),
		_get_stageround_1_4(),
	]
	
	_decide_second_half_faction()


# second half faction

func _decide_second_half_faction():
	var factions = EnemyConstants.EnemyFactions.values().duplicate(false)
	factions.erase(EnemyConstants.EnemyFactions.BASIC)
	
	var faction_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SECOND_HALF_FACTION)
	var rand_num = faction_rng.randi_range(0, factions.size() - 1)
	
	second_half_faction = factions[rand_num]


func get_second_half_faction() -> int:
	return second_half_faction


# stagerounds

func _get_stageround_0_1():
	var stageround = StageRound.new(0, 1)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_0_2():
	var stageround = StageRound.new(0, 2)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_0_3():
	var stageround = StageRound.new(0, 3)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_0_4():
	var stageround = StageRound.new(0, 4)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_0_5():
	var stageround = StageRound.new(0, 5)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround

#

func _get_stageround_1_1():
	var stageround = StageRound.new(1, 1)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_1_2():
	var stageround = StageRound.new(1, 2)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_1_3():
	var stageround = StageRound.new(1, 3)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_1_4():
	var stageround = StageRound.new(1, 4)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround
