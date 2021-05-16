extends "res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd"

func _init():
	stage_rounds = [
		_get_stageround_0_1(),
		_get_stageround_0_2(),
		_get_stageround_0_3(),
		_get_stageround_0_4(),
		_get_stageround_0_5(),
		_get_stageround_1_1(),
	]
	

func _get_stageround_0_1():
	var stageround = StageRound.new(0, 1)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_0_2():
	var stageround = StageRound.new(0, 2)
	stageround.end_of_round_gold = 3
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_0_3():
	var stageround = StageRound.new(0, 3)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_0_4():
	var stageround = StageRound.new(0, 4)
	stageround.end_of_round_gold = 4
	stageround.enemy_damage_multiplier = 1
	
	return stageround

func _get_stageround_0_5():
	var stageround = StageRound.new(0, 5)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	
	return stageround


func _get_stageround_1_1():
	var stageround = StageRound.new(1, 1)
	stageround.end_of_round_gold = 5
	stageround.enemy_damage_multiplier = 1
	
	return stageround
