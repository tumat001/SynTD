extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"


func get_instructions_for_stageround(uuid : String):
	if uuid == "41":
		return _get_instructions_for_4_1()
	elif uuid == "42":
		return _get_instructions_for_4_2()
	elif uuid == "43":
		return _get_instructions_for_4_3()
	elif uuid == "44":
		return _get_instructions_for_4_4()
	elif uuid == "45":
		return _get_instructions_for_4_5()
		
	elif uuid == "51":
		return _get_instructions_for_5_1()
	elif uuid == "52":
		return _get_instructions_for_5_2()
	elif uuid == "53":
		return _get_instructions_for_5_3()
	elif uuid == "54":
		return _get_instructions_for_5_4()
	elif uuid == "55":
		return _get_instructions_for_5_5()
		
	
	return null



func _get_instructions_for_4_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(31, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_4_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(18.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_4_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.25, 10, 5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 2, 10, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_4_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3.5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 2, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(30, 2, 1, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(11, 6, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(24, 7, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(38, 8, 0.5, EnemyConstants.Enemies.CHARGE),
	]


#

func _get_instructions_for_5_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 3, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.ASSASSIN)
	]

func _get_instructions_for_5_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(2.25, 2, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		MultipleEnemySpawnInstruction.new(16, 4, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19.75, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(20.5, EnemyConstants.Enemies.ENCHANTRESS),
		
		MultipleEnemySpawnInstruction.new(35, 4, 0.75, EnemyConstants.Enemies.ENCHANTRESS)
	]

func _get_instructions_for_5_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(6, 5, 0.5, EnemyConstants.Enemies.ASSASSIN),
		
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(34, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_5_4():
	return [
		# CHANGE THIS LATER
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_5_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
	]

#

func _get_instructions_for_6_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAGUS)
	]

