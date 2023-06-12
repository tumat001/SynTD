extends "res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd"

const ModeNormal_StageRounds = preload("res://GameplayRelated/StagesAndRoundsRelated/CustomStagerounds/ModeNormal_StageRounds.gd")



var _basis_stagerounds : ModeNormal_StageRounds

var first_half_faction : int setget ,get_first_half_faction
var second_half_faction : int setget ,get_second_half_faction

func _init():
	_basis_stagerounds = ModeNormal_StageRounds.new()
	
	#
	
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
		
		_get_stageround_10_1(),
		_get_stageround_10_2(),
		_get_stageround_10_3(),
		_get_stageround_10_4(),
		
		
	]
	
	set_early_mid_late_breakpoints()
	
	_decide_first_half_faction()
	_decide_second_half_faction()
	
	#
	_post_init()


# second half faction

func _decide_second_half_faction():
	var second_half_factions = EnemyConstants.second_half_faction_id_pool.duplicate(true)
	
	var faction_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SECOND_HALF_FACTION)
	var rand_num = faction_rng.randi_range(0, second_half_factions.size() - 1)
	
	second_half_faction = second_half_factions[rand_num]


func get_second_half_faction() -> int:
	return second_half_faction


# first half factin

func _decide_first_half_faction():
	var first_half_factions = EnemyConstants.first_half_faction_id_pool.duplicate(true)
	
	var faction_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SECOND_HALF_FACTION)
	var rand_num = faction_rng.randi_range(0, first_half_factions.size() - 1)
	
	first_half_faction = first_half_factions[rand_num]

func get_first_half_faction() -> int:
	return first_half_faction


# set stageround game breakpoints

func set_early_mid_late_breakpoints():
	early_game_stageround_id_start_exclusive = "03"
	early_game_stageround_id_exclusive = "51"
	mid_game_stageround_id_exclusive = "91"
	last_round_end_game_stageround_id_exclusive = stage_rounds[stage_rounds.size() - 1].id
	first_round_of_game_stageround_id_exclusive = stage_rounds[0].id



# stagerounds

func _get_stageround_0_1():
	return _basis_stagerounds._get_stageround_0_1()

func _get_stageround_0_2():
	return _basis_stagerounds._get_stageround_0_2()

func _get_stageround_0_3():
	return _basis_stagerounds._get_stageround_0_3()


#

func _get_stageround_1_1():
	return _basis_stagerounds._get_stageround_1_1()

func _get_stageround_1_2():
	return _basis_stagerounds._get_stageround_1_2()

func _get_stageround_1_3():
	return _basis_stagerounds._get_stageround_1_3()

func _get_stageround_1_4():
	return _basis_stagerounds._get_stageround_1_4()


#

func _get_stageround_2_1():
	return _basis_stagerounds._get_stageround_2_1()

func _get_stageround_2_2():
	return _basis_stagerounds._get_stageround_2_2()

func _get_stageround_2_3():
	return _basis_stagerounds._get_stageround_2_3()

func _get_stageround_2_4():
	return _basis_stagerounds._get_stageround_2_4()

#

func _get_stageround_3_1():
	return _basis_stagerounds._get_stageround_3_1()

func _get_stageround_3_2():
	return _basis_stagerounds._get_stageround_3_2()

func _get_stageround_3_3():
	return _basis_stagerounds._get_stageround_3_3()

func _get_stageround_3_4():
	return _basis_stagerounds._get_stageround_3_4()


#

func _get_stageround_4_1():
	return _basis_stagerounds._get_stageround_4_1()

func _get_stageround_4_2():
	return _basis_stagerounds._get_stageround_4_2()

func _get_stageround_4_3():
	return _basis_stagerounds._get_stageround_4_3()

func _get_stageround_4_4():
	return _basis_stagerounds._get_stageround_4_4()


#

func _get_stageround_5_1():
	return _basis_stagerounds._get_stageround_5_1()

func _get_stageround_5_2():
	return _basis_stagerounds._get_stageround_5_2()

func _get_stageround_5_3():
	return _basis_stagerounds._get_stageround_5_3()

func _get_stageround_5_4():
	return _basis_stagerounds._get_stageround_5_4()


#

func _get_stageround_6_1():
	return _basis_stagerounds._get_stageround_6_1()

func _get_stageround_6_2():
	return _basis_stagerounds._get_stageround_6_2()

func _get_stageround_6_3():
	return _basis_stagerounds._get_stageround_6_3()

func _get_stageround_6_4():
	return _basis_stagerounds._get_stageround_6_4()


#

func _get_stageround_7_1():
	return _basis_stagerounds._get_stageround_7_1()

func _get_stageround_7_2():
	return _basis_stagerounds._get_stageround_7_2()

func _get_stageround_7_3():
	return _basis_stagerounds._get_stageround_7_3()

func _get_stageround_7_4():
	return _basis_stagerounds._get_stageround_7_4()


#

func _get_stageround_8_1():
	return _basis_stagerounds._get_stageround_8_1()

func _get_stageround_8_2():
	return _basis_stagerounds._get_stageround_8_2()

func _get_stageround_8_3():
	return _basis_stagerounds._get_stageround_8_3()

func _get_stageround_8_4():
	return _basis_stagerounds._get_stageround_8_4()


#


func _get_stageround_9_1():
	return _basis_stagerounds._get_stageround_9_1()

func _get_stageround_9_2():
	return _basis_stagerounds._get_stageround_9_2()

func _get_stageround_9_3():
	return _basis_stagerounds._get_stageround_9_3()

func _get_stageround_9_4():
	return _basis_stagerounds._get_stageround_9_4()


#

func _get_stageround_10_1():
	var stageround = StageRound.new(10, 1)
	stageround.end_of_round_gold = 6
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 10
	stageround.enemy_health_multiplier = 2
	
	return stageround

func _get_stageround_10_2():
	var stageround = StageRound.new(10, 2)
	stageround.end_of_round_gold = 6
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 10
	stageround.enemy_health_multiplier = 2
	
	return stageround

func _get_stageround_10_3():
	var stageround = StageRound.new(10, 3)
	stageround.end_of_round_gold = 6
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 10
	stageround.enemy_health_multiplier = 2
	
	return stageround

func _get_stageround_10_4():
	var stageround = StageRound.new(10, 4)
	stageround.end_of_round_gold = 6
	stageround.enemy_damage_multiplier = 1
	stageround.enemy_first_damage = 10
	stageround.enemy_health_multiplier = 2
	
	return stageround


