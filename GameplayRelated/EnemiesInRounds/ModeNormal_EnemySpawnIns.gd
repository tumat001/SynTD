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
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.TEST_ENEMY),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.TEST_ENEMY),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.TEST_ENEMY),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.TEST_ENEMY),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.TEST_ENEMY),
	]

func _get_instructions_for_0_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.TEST_ENEMY),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.TEST_ENEMY),
	]

func _get_instructions_for_0_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.TEST_ENEMY),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.TEST_ENEMY),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.TEST_ENEMY),
	]

func _get_instructions_for_0_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.TEST_ENEMY),
	]

func _get_instructions_for_0_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.TEST_ENEMY),
	]

func _get_instructions_for_1_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.TEST_ENEMY),
	]
