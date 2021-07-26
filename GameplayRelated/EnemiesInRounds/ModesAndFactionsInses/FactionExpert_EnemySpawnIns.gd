extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"


func get_instructions_for_stageround(uuid : String):
	if uuid == "51":
		return _get_instructions_for_5_1()
	elif uuid == "52":
		return _get_instructions_for_5_2()
	elif uuid == "53":
		return _get_instructions_for_5_3()
	elif uuid == "54":
		return _get_instructions_for_5_4()
	elif uuid == "55":
		return _get_instructions_for_5_5()
	elif uuid == "61":
		return _get_instructions_for_6_1()
	
	return null



func _get_instructions_for_5_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_5_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_5_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_5_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_5_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
	]

func _get_instructions_for_6_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAGUS)
	]

