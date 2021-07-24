extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"

const SingleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/SingleEnemySpawnInstruction.gd")
const AbstractSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd")
const ChainSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/ChainSpawnInstruction.gd")

const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")

func get_instructions_for_stageround(uuid : String):
	if uuid == "01":
		return _get_instructions_for_0_1()
	elif uuid == "02":
		return _get_instructions_for_0_2()
	elif uuid == "03":
		return _get_instructions_for_0_3()
	elif uuid == "04":
		return _get_instructions_for_0_4()
	elif uuid == "05":
		return _get_instructions_for_0_5()
	elif uuid == "06":
		return _get_instructions_for_1_1()



func _get_instructions_for_0_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(2, EnemyConstants.Enemies.WIZARD)
	]

func _get_instructions_for_0_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(7.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_0_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(7.5, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_0_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(7.5, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_0_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(7.5, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.BRUTE),
	]

func _get_instructions_for_1_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC)
	]
