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
		_get_stageround_1_5(),
		
		_get_stageround_2_1(),
		_get_stageround_2_2(),
		_get_stageround_2_3(),
		_get_stageround_2_4(),
		_get_stageround_2_5(),
		
		_get_stageround_3_1(),
		_get_stageround_3_2(),
		_get_stageround_3_3(),
		_get_stageround_3_4(),
		_get_stageround_3_5(),
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
	stageround.end_of_round_gold = 1
	stageround.enemy_damage_multiplier = 0.5
	stageround.enemy_health_multiplier = 0.30
	stageround.can_gain_streak = false
	
	return stageround

func _get_stageround_0_2():
	var stageround = StageRound.new(0, 2)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 0.5
	stageround.enemy_health_multiplier = 0.35
	stageround.can_gain_streak = false
	
	return stageround

func _get_stageround_0_3():
	var stageround = StageRound.new(0, 3)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 0.5
	stageround.enemy_health_multiplier = 0.40
	stageround.can_gain_streak = false
	
	return stageround

func _get_stageround_0_4():
	var stageround = StageRound.new(0, 4)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 0.5
	stageround.enemy_health_multiplier = 0.45
	stageround.can_gain_streak = false
	
	return stageround

func _get_stageround_0_5():
	var stageround = StageRound.new(0, 5)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 0.5
	stageround.enemy_health_multiplier = 0.45
	stageround.can_gain_streak = false
	
	return stageround

#

func _get_stageround_1_1():
	var stageround = StageRound.new(1, 1)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.5
	
	return stageround

func _get_stageround_1_2():
	var stageround = StageRound.new(1, 2)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.55
	
	return stageround

func _get_stageround_1_3():
	var stageround = StageRound.new(1, 3)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.55
	
	return stageround

func _get_stageround_1_4():
	var stageround = StageRound.new(1, 4)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.60
	
	return stageround


func _get_stageround_1_5():
	var stageround = StageRound.new(1, 5)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.65
	
	return stageround

#

func _get_stageround_2_1():
	var stageround = StageRound.new(2, 1)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.70
	
	return stageround

func _get_stageround_2_2():
	var stageround = StageRound.new(2, 2)
	stageround.end_of_round_gold = 4
	stageround.enemy_health_multiplier = 0.75
	
	return stageround

func _get_stageround_2_3():
	var stageround = StageRound.new(2, 3)
	stageround.end_of_round_gold = 4
	stageround.enemy_health_multiplier = 0.8
	
	return stageround

func _get_stageround_2_4():
	var stageround = StageRound.new(2, 4)
	stageround.end_of_round_gold = 4
	stageround.enemy_health_multiplier = 0.8
	
	return stageround

func _get_stageround_2_5():
	var stageround = StageRound.new(2, 5)
	stageround.end_of_round_gold = 4
	stageround.enemy_health_multiplier = 0.85
	
	return stageround

#

func _get_stageround_3_1():
	var stageround = StageRound.new(3, 1)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.85
	
	return stageround

func _get_stageround_3_2():
	var stageround = StageRound.new(3, 2)
	stageround.end_of_round_gold = 5
	stageround.enemy_health_multiplier = 0.9
	
	return stageround

func _get_stageround_3_3():
	var stageround = StageRound.new(3, 3)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.9
	
	return stageround

func _get_stageround_3_4():
	var stageround = StageRound.new(3, 4)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.95
	
	return stageround

func _get_stageround_3_5():
	var stageround = StageRound.new(3, 5)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.95
	
	return stageround
