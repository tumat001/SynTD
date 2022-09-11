extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"


func get_instructions_for_stageround(uuid : String):
	if uuid == "01":
		return _get_instructions_for_0_1()
	elif uuid == "02":
		return _get_instructions_for_0_2()
	elif uuid == "03":
		return _get_instructions_for_0_3()
		
	return null


func is_transition_time_in_stageround(uuid : String) -> bool:
	return uuid == "41"
	
	#return uuid == "01"  # to transfer to other factions



func _get_instructions_for_0_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(5.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(14.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(17.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_0_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(5.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(14.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(17.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_0_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.BASIC),
	]

