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
		
	elif uuid == "51":
		return _get_instructions_for_5_1()
	elif uuid == "52":
		return _get_instructions_for_5_2()
	elif uuid == "53":
		return _get_instructions_for_5_3()
	elif uuid == "54":
		return _get_instructions_for_5_4()
		
	elif uuid == "61":
		return _get_instructions_for_6_1()
	elif uuid == "62":
		return _get_instructions_for_6_2()
	elif uuid == "63":
		return _get_instructions_for_6_3()
	elif uuid == "64":
		return _get_instructions_for_6_4()
		
	elif uuid == "71":
		return _get_instructions_for_7_1()
	elif uuid == "72":
		return _get_instructions_for_7_2()
	elif uuid == "73":
		return _get_instructions_for_7_3()
	elif uuid == "74":
		return _get_instructions_for_7_4()
		
	elif uuid == "81":
		return _get_instructions_for_8_1()
	elif uuid == "82":
		return _get_instructions_for_8_2()
	elif uuid == "83":
		return _get_instructions_for_8_3()
	elif uuid == "84":
		return _get_instructions_for_8_4()
		
	elif uuid == "91":
		return _get_instructions_for_9_1()
	elif uuid == "92":
		return _get_instructions_for_9_2()
	elif uuid == "93":
		return _get_instructions_for_9_3()
	elif uuid == "94":
		return _get_instructions_for_9_4()
	
	return null



func _get_instructions_for_4_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 1.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(18.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_4_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 6.5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.25, 9, 6.5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 2, 15, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(35, 2, 1, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_4_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 4.5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 2, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(30, 3, 1, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(11, 6, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(24, 7, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(39, 9, 0.5, EnemyConstants.Enemies.CHARGE),
	]


#

func _get_instructions_for_5_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(2.25, 2, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		MultipleEnemySpawnInstruction.new(21, 7, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(24.75, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(25.5, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(26.25, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(27.75, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_5_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(6, 9, 0.5, EnemyConstants.Enemies.ASSASSIN),
		
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(38, EnemyConstants.Enemies.FIEND),
	]

func _get_instructions_for_5_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 0.5, EnemyConstants.Enemies.EXPERIENCED),
		
		MultipleEnemySpawnInstruction.new(14, 14, 2.2, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 14, 2.2, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(44, 4, 1.3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(44.3, 4, 1.3, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_5_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.EXPERIENCED),
	]


#

func _get_instructions_for_6_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11.25, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(11.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		SingleEnemySpawnInstruction.new(26, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(36, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(2, 7, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(16, 8, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 2, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(10, 4, 5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(20, 4, 2, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(4, 5, 5, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(20, 2, 1, EnemyConstants.Enemies.EXPERIENCED),
	]


#

func _get_instructions_for_7_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 22, 1.7, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(0.5, 22, 1.7, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_7_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.FIEND),
		
		MultipleEnemySpawnInstruction.new(24, 7, 0.75, EnemyConstants.Enemies.FIEND),
	]

func _get_instructions_for_7_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 38, 1.3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new((1.3 * 5), 8, 2.6, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new((39 * 1.3), 6, 0.2, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_7_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 31, 1.58, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.75, 8, 6.5, EnemyConstants.Enemies.MAGUS),
	]


#

func _get_instructions_for_8_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 22, 1.9, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(1.75, 22, 1.9, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(8, 3, 13, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_8_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2, EnemyConstants.Enemies.CHARGE),
		
		MultipleEnemySpawnInstruction.new(12, 10, 1, EnemyConstants.Enemies.ENCHANTRESS),
		
		LinearEnemySpawnInstruction.new(24, 8, 0.5, 0.060, EnemyConstants.Enemies.ASSASSIN, 0.15),
	]

func _get_instructions_for_8_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(0.5, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(1, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(65.5, EnemyConstants.Enemies.GRANDMASTER)
	]

func _get_instructions_for_8_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 30, 1.25, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 15, 2.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(1, 4, 10, EnemyConstants.Enemies.GRANDMASTER),
		
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.FIEND),
		
		MultipleEnemySpawnInstruction.new(30, 3, 1.25, EnemyConstants.Enemies.ASSASSIN),
	]

#

func _get_instructions_for_9_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 33, 3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 33, 3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(1, 33, 3, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.GRANDMASTER),
		
		MultipleEnemySpawnInstruction.new(42, 2, 1, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(48, 6, 0.25, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(54, 4, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(60, 1, 0.5, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(72, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(73, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_9_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 0.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 20, 0.25, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(21, 2, 0.5, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(23, 10, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(27, 10, 1, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_9_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 5, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 26, 2.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(6, 3, 10, EnemyConstants.Enemies.MAGUS),
	]

func _get_instructions_for_9_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		LinearEnemySpawnInstruction.new(0, 40, 1, 0.030, EnemyConstants.Enemies.ASSASSIN, 0.15),
		MultipleEnemySpawnInstruction.new(1, 8, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(8, 4, 2, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(9, 2, 2, EnemyConstants.Enemies.MAGUS),
		
		MultipleEnemySpawnInstruction.new(32, 25, 0.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(38, 4, 0.75, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(41, 10, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(46, 5, 1, EnemyConstants.Enemies.ASSASSIN),
	]


