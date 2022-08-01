extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"


var _faction_passive

func get_instructions_for_stageround(uuid : String):
#	if uuid == "01":
#		return _get_instructions_for_0_1()
#	elif uuid == "02":
#		return _get_instructions_for_0_2()
#	elif uuid == "03":
#		return _get_instructions_for_0_3()
#	elif uuid == "04":
#		return _get_instructions_for_0_4()
#	elif uuid == "05":
#		return _get_instructions_for_0_5()
#
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


# TEST

func _get_instructions_for_0_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 1, 1, EnemyConstants.Enemies.DVARAPALA),
	]

#func _get_instructions_for_0_2():
#	return [
#		MultipleEnemySpawnInstruction.new(0, 4, 8, EnemyConstants.Enemies.SEER),
#		MultipleEnemySpawnInstruction.new(1, 4, 8, EnemyConstants.Enemies.PRIEST),
#	]
#
#func _get_instructions_for_0_3():
#	return [
#		MultipleEnemySpawnInstruction.new(0, 4, 6, EnemyConstants.Enemies.BELIEVER),
#	]
#
#func _get_instructions_for_0_4():
#	return [
#		MultipleEnemySpawnInstruction.new(0, 4, 6, EnemyConstants.Enemies.BELIEVER),
#	]
#
#func _get_instructions_for_0_5():
#	return [
#		MultipleEnemySpawnInstruction.new(0, 4, 5, EnemyConstants.Enemies.BELIEVER),
#		SingleEnemySpawnInstruction.new(2, EnemyConstants.Enemies.BELIEVER)
#	]

#

func _get_instructions_for_4_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(4, 6, 4, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 5, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_4_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 5, 6, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8.5, 3, 0.5, EnemyConstants.Enemies.BELIEVER),
	]


#

func _get_instructions_for_5_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 3, 8, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]


func _get_instructions_for_5_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(13, 6, 3, EnemyConstants.Enemies.PRIEST)
	]

func _get_instructions_for_5_3():
	return [
		LinearEnemySpawnInstruction.new(0, 25, 3, 0.02, EnemyConstants.Enemies.BELIEVER, 0.25),
	]

func _get_instructions_for_5_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 6.5, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3.25, 7, 6.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(8, 5, 1, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]


#


func _get_instructions_for_6_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.75, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(12, 5, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(14.5, 5, 3, EnemyConstants.Enemies.PRIEST)
	]

func _get_instructions_for_6_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3, 3, 9, EnemyConstants.Enemies.DVARAPALA),
	]

func _get_instructions_for_6_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(4, 4, 2.5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_6_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 6, 4, EnemyConstants.Enemies.SEER),
	]


#

func _get_instructions_for_7_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 3, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 1, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(20, 2, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(40, 3, 1.5, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_7_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 7, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(7.5, 6, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 3, 5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		MultipleEnemySpawnInstruction.new(24, 5, 1, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_7_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 1, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7.5, 8, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 4, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_7_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 3, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7.5, 3, 9, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.PROVIDENCE),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.PROVIDENCE),
	]


#

func _get_instructions_for_8_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1.25, 15, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2.5, 4, 6, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
	]

func _get_instructions_for_8_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1, 12, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 4, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_8_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.1, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7, 25, 0.4, EnemyConstants.Enemies.BELIEVER)
	]


func _get_instructions_for_8_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 18, 4, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(1, 18, 4, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(2, 9, 8, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(9, 5, 6, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
	]

#


func _get_instructions_for_9_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(1, 12, 4, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 12, 4, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(3, 5, 8, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(13, 6, 0.5, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_9_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 10, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 5, 8, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
	]


func _get_instructions_for_9_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 10, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 4, 10, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		
		LinearEnemySpawnInstruction.new(18, 15, 0.5, 0.030, EnemyConstants.Enemies.BELIEVER, 0.1),
	]

func _get_instructions_for_9_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.25, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 2, 20, EnemyConstants.Enemies.DVARAPALA),
		
		MultipleEnemySpawnInstruction.new(11, 12, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(12, 12, 2.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(13, 5, 4, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(18, 5, 4, EnemyConstants.Enemies.PROVIDENCE)
	]


#

func get_faction_passive():
	_faction_passive = preload("res://EnemyRelated/EnemyFactionPassives/Type_Faithful/Faithful_FactionPassive.gd").new()
	return _faction_passive