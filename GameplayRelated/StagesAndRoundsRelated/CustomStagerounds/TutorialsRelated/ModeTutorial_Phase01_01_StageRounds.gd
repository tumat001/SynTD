extends "res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd"



func _init():
	stage_rounds = [
		_get_stageround_0_1(),
		_get_stageround_0_2(),
		_get_stageround_0_3(),
		
	]
	
	set_early_mid_late_breakpoints()

func get_first_half_faction() -> int:
	return EnemyConstants.EnemyFactions.BASIC



# set stageround game breakpoints

func set_early_mid_late_breakpoints():
	early_game_stageround_id_start_exclusive = "03"
	early_game_stageround_id_exclusive = "03"
	mid_game_stageround_id_exclusive = "03"
	last_round_end_game_stageround_id_exclusive = stage_rounds[stage_rounds.size() - 1].id
	first_round_of_game_stageround_id_exclusive = stage_rounds[0].id


# stagerounds

func _get_stageround_0_1():
	var stageround = StageRound.new(0, 1)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.65
	stageround.enemy_first_damage = 0
	stageround.can_gain_streak = false
	
	return stageround

func _get_stageround_0_2():
	var stageround = StageRound.new(0, 2)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.65
	stageround.enemy_first_damage = 0
	stageround.can_gain_streak = false
	
	return stageround

func _get_stageround_0_3():
	var stageround = StageRound.new(0, 3)
	stageround.end_of_round_gold = 2
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_health_multiplier = 0.65
	stageround.enemy_first_damage = 0
	stageround.can_gain_streak = false
	
	return stageround


#
