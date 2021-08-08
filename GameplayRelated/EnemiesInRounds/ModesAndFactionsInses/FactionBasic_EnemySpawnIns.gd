extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"


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
	elif uuid == "11":
		return _get_instructions_for_1_1()
	elif uuid == "12":
		return _get_instructions_for_1_2()
	elif uuid == "13":
		return _get_instructions_for_1_3()
	elif uuid == "14":
		return _get_instructions_for_1_4()
	elif uuid == "15":
		return _get_instructions_for_1_5()
		
	elif uuid == "21":
		return _get_instructions_for_2_1()
	elif uuid == "22":
		return _get_instructions_for_2_2()
	elif uuid == "23":
		return _get_instructions_for_2_3()
	elif uuid == "24":
		return _get_instructions_for_2_4()
	elif uuid == "25":
		return _get_instructions_for_2_5()
		
	elif uuid == "31":
		return _get_instructions_for_3_1()
	elif uuid == "32":
		return _get_instructions_for_3_2()
	elif uuid == "33":
		return _get_instructions_for_3_3()
	elif uuid == "34":
		return _get_instructions_for_3_4()
	elif uuid == "35":
		return _get_instructions_for_3_5()
	
	return null


func is_transition_time_in_stageround(uuid : String) -> bool:
	return uuid == "50"



func _get_instructions_for_0_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_0_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_0_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_0_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(2, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_0_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(2.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(4.0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(4.5, EnemyConstants.Enemies.PAIN),
	]


#

func _get_instructions_for_1_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(5.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(14.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN)
	]

func _get_instructions_for_1_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 3, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.HEALER)
	]

func _get_instructions_for_1_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 2, EnemyConstants.Enemies.BASIC),
	]


func _get_instructions_for_1_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(2, 8, 2, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.DASH),
	]


func _get_instructions_for_1_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(2, 4, 0.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.HEALER),
	]

#

func _get_instructions_for_2_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(13, 6, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(26, 7, 0.2, EnemyConstants.Enemies.BASIC),
	]


func _get_instructions_for_2_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_2_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.85, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 3, 10, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_2_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 3, 10, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(1, 3, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(12, 4, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(22, 5, 0.5, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_2_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 30, 1.75, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 2, 0.5, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(15, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(25, 1, 0.5, EnemyConstants.Enemies.BRUTE),
	]

#

func _get_instructions_for_3_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.5, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(10, 2, 8, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(10, 2, 8, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 8, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(15, 10, 1, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_3_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 1.8, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0.9, 15, 3.6, EnemyConstants.Enemies.PAIN),
	]

func _get_instructions_for_3_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 3, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.8, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0, 5, 6, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(14, 2, 0.5, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(28, 4, 0.5, EnemyConstants.Enemies.PAIN),
	]


