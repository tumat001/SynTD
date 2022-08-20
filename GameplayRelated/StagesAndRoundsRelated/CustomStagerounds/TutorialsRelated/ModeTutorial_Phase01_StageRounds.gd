extends "res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd"



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
		
	]
	

func get_first_half_faction() -> int:
	return EnemyConstants.EnemyFactions.BASIC



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
