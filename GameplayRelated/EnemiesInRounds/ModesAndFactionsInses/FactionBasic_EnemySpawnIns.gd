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
	return uuid == "41"



func _get_instructions_for_0_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(0.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BASIC),
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
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(17.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_1_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 2.4, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.HEALER)
	]

func _get_instructions_for_1_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 1.75, EnemyConstants.Enemies.BASIC),
	]


func _get_instructions_for_1_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(2, 16, 1.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.DASH),
	]


func _get_instructions_for_1_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.7, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(2, 4, 0.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(11.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(12.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(13.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.HEALER),
	]

#

func _get_instructions_for_2_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(15, 9, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(31, 10, 0.2, EnemyConstants.Enemies.BASIC),
	]


func _get_instructions_for_2_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_2_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 2.1, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 3, 10, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_2_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 3, 15, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(1, 1, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(17, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(32, 3, 0.5, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_2_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 1.9, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 3, 0.5, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(15, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(25, 1, 0.5, EnemyConstants.Enemies.BRUTE),
	]

#

func _get_instructions_for_3_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.6, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(10, 2, 8, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(10, 2, 8, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 8, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(15, 5, 0.2, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_3_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 2.5, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0.15, 18, 2.5, EnemyConstants.Enemies.PAIN),
	]

func _get_instructions_for_3_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 24, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0, 6, 6, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(18, 1, 1, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(38, 4, 0.5, EnemyConstants.Enemies.PAIN),
	]


