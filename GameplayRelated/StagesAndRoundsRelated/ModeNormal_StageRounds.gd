extends "res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd"

#const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")

var second_half_faction : int setget ,get_second_half_faction

func _init():
	stage_rounds = [
		_get_stageround_0_1(),
		_get_stageround_0_2(),
		_get_stageround_0_3(),
		
		_get_stageround_1_1(),
		_get_stageround_1_2(),
		_get_stageround_1_3(),
		_get_stageround_1_4(),
		
		_get_stageround_2_1(),
		_get_stageround_2_2(),
		_get_stageround_2_3(),
		_get_stageround_2_4(),
		
		_get_stageround_3_1(),
		_get_stageround_3_2(),
		_get_stageround_3_3(),
		_get_stageround_3_4(),
		
		_get_stageround_4_1(),
		_get_stageround_4_2(),
		_get_stageround_4_3(),
		_get_stageround_4_4(),
		
		_get_stageround_5_1(),
		_get_stageround_5_2(),
		_get_stageround_5_3(),
		_get_stageround_5_4(),
		
		_get_stageround_6_1(),
		_get_stageround_6_2(),
		_get_stageround_6_3(),
		_get_stageround_6_4(),
		
		_get_stageround_7_1(),
		_get_stageround_7_2(),
		_get_stageround_7_3(),
		_get_stageround_7_4(),
		
		_get_stageround_8_1(),
		_get_stageround_8_2(),
		_get_stageround_8_3(),
		_get_stageround_8_4(),
		
		_get_stageround_9_1(),
		_get_stageround_9_2(),
		_get_stageround_9_3(),
		_get_stageround_9_4(),
	]
	
	_decide_second_half_faction()


# second half faction

func _decide_second_half_faction():
	var factions = EnemyConstants.faction_id_pool.duplicate(true) #EnemyConstants.EnemyFactions.values().duplicate(false)
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
	stageround.enemy_damage_multiplier = 0.5
	stageround.enemy_health_multiplier = 0.30
	stageround.enemy_first_damage = 0
	stageround.can_gain_streak = false
	
	return stageround

func _get_stageround_0_2():
	var stageround = StageRound.new(0, 2)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 0.5
	stageround.enemy_health_multiplier = 0.35
	stageround.enemy_first_damage = 0
	stageround.can_gain_streak = false
	
	return stageround

func _get_stageround_0_3():
	var stageround = StageRound.new(0, 3)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 0.5
	stageround.enemy_health_multiplier = 0.40
	stageround.enemy_first_damage = 0
	stageround.can_gain_streak = false
	
	return stageround


#

func _get_stageround_1_1():
	var stageround = StageRound.new(1, 1)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.65
	stageround.enemy_first_damage = 0
	
	return stageround

func _get_stageround_1_2():
	var stageround = StageRound.new(1, 2)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.65
	stageround.enemy_first_damage = 0
	
	return stageround

func _get_stageround_1_3():
	var stageround = StageRound.new(1, 3)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.65
	stageround.enemy_first_damage = 0
	
	return stageround

func _get_stageround_1_4():
	var stageround = StageRound.new(1, 4)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.65
	stageround.enemy_first_damage = 0
	
	return stageround


#

func _get_stageround_2_1():
	var stageround = StageRound.new(2, 1)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.70
	
	return stageround

func _get_stageround_2_2():
	var stageround = StageRound.new(2, 2)
	stageround.end_of_round_gold = 3
	stageround.enemy_health_multiplier = 0.75
	
	return stageround

func _get_stageround_2_3():
	var stageround = StageRound.new(2, 3)
	stageround.end_of_round_gold = 3
	stageround.enemy_health_multiplier = 0.8
	
	return stageround

func _get_stageround_2_4():
	var stageround = StageRound.new(2, 4)
	stageround.end_of_round_gold = 3
	stageround.enemy_health_multiplier = 0.8
	
	return stageround

#

func _get_stageround_3_1():
	var stageround = StageRound.new(3, 1)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.85
	stageround.enemy_first_damage = 1
	
	return stageround

func _get_stageround_3_2():
	var stageround = StageRound.new(3, 2)
	stageround.end_of_round_gold = 3
	stageround.enemy_health_multiplier = 0.9
	stageround.enemy_first_damage = 1
	
	return stageround

func _get_stageround_3_3():
	var stageround = StageRound.new(3, 3)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.9
	stageround.enemy_first_damage = 1
	
	return stageround

func _get_stageround_3_4():
	var stageround = StageRound.new(3, 4)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.95
	stageround.enemy_first_damage = 1
	
	return stageround


#

func _get_stageround_4_1():
	var stageround = StageRound.new(4, 1)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 1
	
	return stageround

func _get_stageround_4_2():
	var stageround = StageRound.new(4, 2)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 1
	
	return stageround

func _get_stageround_4_3():
	var stageround = StageRound.new(4, 3)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 1
	
	return stageround

func _get_stageround_4_4():
	var stageround = StageRound.new(4, 4)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 1
	
	return stageround


#

func _get_stageround_5_1():
	var stageround = StageRound.new(5, 1)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 2
	stageround.enemy_health_multiplier = 1.25
	
	return stageround

func _get_stageround_5_2():
	var stageround = StageRound.new(5, 2)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 2
	stageround.enemy_health_multiplier = 1.25
	
	return stageround

func _get_stageround_5_3():
	var stageround = StageRound.new(5, 3)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 2
	stageround.enemy_health_multiplier = 1.25
	
	return stageround

func _get_stageround_5_4():
	var stageround = StageRound.new(5, 4)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 2
	stageround.enemy_health_multiplier = 1.25
	
	return stageround



#

func _get_stageround_6_1():
	var stageround = StageRound.new(6, 1)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 3
	stageround.enemy_health_multiplier = 1.25
	
	return stageround

func _get_stageround_6_2():
	var stageround = StageRound.new(6, 2)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 3
	stageround.enemy_health_multiplier = 1.25
	
	return stageround

func _get_stageround_6_3():
	var stageround = StageRound.new(6, 3)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 3
	stageround.enemy_health_multiplier = 1.25
	
	return stageround

func _get_stageround_6_4():
	var stageround = StageRound.new(6, 4)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 3
	stageround.enemy_health_multiplier = 1.25
	
	return stageround


#

func _get_stageround_7_1():
	var stageround = StageRound.new(7, 1)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 4
	stageround.enemy_health_multiplier = 1.5
	
	return stageround

func _get_stageround_7_2():
	var stageround = StageRound.new(7, 2)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 4
	stageround.enemy_health_multiplier = 1.5
	
	return stageround

func _get_stageround_7_3():
	var stageround = StageRound.new(7, 3)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 4
	stageround.enemy_health_multiplier = 1.5
	
	return stageround

func _get_stageround_7_4():
	var stageround = StageRound.new(7, 4)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 4
	stageround.enemy_health_multiplier = 1.5
	
	return stageround


#

func _get_stageround_8_1():
	var stageround = StageRound.new(8, 1)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 5
	stageround.enemy_health_multiplier = 1.75
	
	return stageround

func _get_stageround_8_2():
	var stageround = StageRound.new(8, 2)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 5
	stageround.enemy_health_multiplier = 1.75
	
	return stageround

func _get_stageround_8_3():
	var stageround = StageRound.new(8, 3)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 5
	stageround.enemy_health_multiplier = 1.75
	
	return stageround

func _get_stageround_8_4():
	var stageround = StageRound.new(8, 4)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 5
	stageround.enemy_health_multiplier = 1.75
	
	return stageround


#


func _get_stageround_9_1():
	var stageround = StageRound.new(9, 1)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 8
	stageround.enemy_health_multiplier = 2
	
	return stageround

func _get_stageround_9_2():
	var stageround = StageRound.new(9, 2)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 8
	stageround.enemy_health_multiplier = 2
	
	return stageround

func _get_stageround_9_3():
	var stageround = StageRound.new(9, 3)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 8
	stageround.enemy_health_multiplier = 2
	
	return stageround

func _get_stageround_9_4():
	var stageround = StageRound.new(9, 4)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 8
	stageround.enemy_health_multiplier = 2
	
	return stageround
