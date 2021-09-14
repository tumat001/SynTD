extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"


var _faction_passive

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
		
	elif uuid == "61":
		return _get_instructions_for_6_1()
	elif uuid == "62":
		return _get_instructions_for_6_2()
	elif uuid == "63":
		return _get_instructions_for_6_3()
	elif uuid == "64":
		return _get_instructions_for_6_4()
	elif uuid == "65":
		return _get_instructions_for_6_5()
		
	elif uuid == "71":
		return _get_instructions_for_7_1()
	elif uuid == "72":
		return _get_instructions_for_7_2()
	elif uuid == "73":
		return _get_instructions_for_7_3()
	elif uuid == "74":
		return _get_instructions_for_7_4()
	elif uuid == "75":
		return _get_instructions_for_7_5()
		
	elif uuid == "81":
		return _get_instructions_for_8_1()
	elif uuid == "82":
		return _get_instructions_for_8_2()
	elif uuid == "83":
		return _get_instructions_for_8_3()
	elif uuid == "84":
		return _get_instructions_for_8_4()
	elif uuid == "85":
		return _get_instructions_for_8_5()
		
	elif uuid == "91":
		return _get_instructions_for_9_1()
	elif uuid == "92":
		return _get_instructions_for_9_2()
	elif uuid == "93":
		return _get_instructions_for_9_3()
	
	
	return null


# TEST

func _get_instructions_for_0_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 2, EnemyConstants.Enemies.CROSS_BEARER),
		MultipleEnemySpawnInstruction.new(1, 20, 2, EnemyConstants.Enemies.PRIEST),
	]

func _get_instructions_for_0_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 6, EnemyConstants.Enemies.SACRIFICER),
	]

func _get_instructions_for_0_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 6, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_0_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 6, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_0_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 5, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(2, EnemyConstants.Enemies.BELIEVER)
	]

#

func _get_instructions_for_4_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 3, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(1.5, 4, 6, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 5, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(2, EnemyConstants.Enemies.BELIEVER)
	]

func _get_instructions_for_4_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(10, 5, 4, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_4():
	return [
		
	]

func _get_instructions_for_4_5():
	return [

	]


#

func _get_instructions_for_5_1():
	return [

	]

func _get_instructions_for_5_2():
	return [

	]

func _get_instructions_for_5_3():
	return [

	]

func _get_instructions_for_5_4():
	return [

	]

func _get_instructions_for_5_5():
	return [

	]


#

func _get_instructions_for_6_1():
	return [

	]

func _get_instructions_for_6_2():
	return [

	]

func _get_instructions_for_6_3():
	return [

	]

func _get_instructions_for_6_4():
	return [

	]

func _get_instructions_for_6_5():
	return [

	]


#

func _get_instructions_for_7_1():
	return [

	]

func _get_instructions_for_7_2():
	return [

	]

func _get_instructions_for_7_3():
	return [

	]

func _get_instructions_for_7_4():
	return [

	]

func _get_instructions_for_7_5():
	return [

	]


#

func _get_instructions_for_8_1():
	return [

	]

func _get_instructions_for_8_2():
	return [

	]

func _get_instructions_for_8_3():
	return [

	]

func _get_instructions_for_8_4():
	return [

	]

func _get_instructions_for_8_5():
	return [

	]

#


func _get_instructions_for_9_1():
	return [

	]

func _get_instructions_for_9_2():
	return [
		
	]

func _get_instructions_for_9_3():
	return [
		
	]


#

func get_faction_passive():
	_faction_passive = preload("res://EnemyRelated/EnemyFactionPassives/Type_Faithful/Faithful_FactionPassive.gd").new()
	return _faction_passive
