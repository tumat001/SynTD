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


#func _get_instructions_for_0_1():
#	return [
#		MultipleEnemySpawnInstruction.new(0, 1, 10, EnemyConstants.Enemies.CROSS_BEARER),
#	]
#
#func _get_instructions_for_0_2():
#	return [
#		MultipleEnemySpawnInstruction.new(0, 7, 2, EnemyConstants.Enemies.SEER),
#	]
#
#func _get_instructions_for_0_3():
#	return [
#		MultipleEnemySpawnInstruction.new(0, 4, 6, EnemyConstants.Enemies.BELIEVER),
#	]

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

############### 4-1
func _get_instructions_for_4_1():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_4_1__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_4_1__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_4_1__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_4_1__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_4_1__sv_5()


func _get_instructions_for_4_1__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(4, 5, 4, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(4, 6, 4, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 11, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(4, 6, 4, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(4, 7, 4, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 1.8, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(4, 8, 3.5, EnemyConstants.Enemies.BELIEVER),
	]


############## 4-2
func _get_instructions_for_4_2():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_4_2__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_4_2__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_4_2__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_4_2__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_4_2__sv_5()


func _get_instructions_for_4_2__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 6, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_4_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 5, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_4_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 4.75, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_4_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 4.25, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_4_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 4, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

############# 4-3 DEITY ROUND
func _get_instructions_for_4_3():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_4_3__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_4_3__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_4_3__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_4_3__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_4_3__sv_5()


func _get_instructions_for_4_3__sv_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 4, 6, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4.5, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_3__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 5, 6, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4.5, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_3__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 6, 6, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4.5, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_3__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 7, 6, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4.5, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_3__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 8, 5, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(4.5, EnemyConstants.Enemies.BELIEVER),
		
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.BELIEVER),
	]

################# 4-4
func _get_instructions_for_4_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_4_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_4_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_4_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_4_4__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_4_4__sv_5()


func _get_instructions_for_4_4__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8.5, 2, 0.5, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8.5, 3, 0.5, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8.5, 4, 0.5, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8.5, 3, 0.5, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_4_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8.5, 4, 0.5, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.BELIEVER),
	]

################ 5-1
func _get_instructions_for_5_1():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_5_1__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_5_1__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_5_1__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_5_1__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_5_1__sv_5()


func _get_instructions_for_5_1__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 2, 8, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_5_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 3, 8, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_5_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 3, 8, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_5_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 3, 8, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(12.5, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_5_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 3, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 4, 6, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(12.5, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.CROSS_BEARER)
	]

############## 5-2 DEITY ROUND
func _get_instructions_for_5_2():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_5_2__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_5_2__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_5_2__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_5_2__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_5_2__sv_5()


func _get_instructions_for_5_2__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(13, 7, 3, EnemyConstants.Enemies.PRIEST)
	]

func _get_instructions_for_5_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(13, 6, 3, EnemyConstants.Enemies.PRIEST)
	]

func _get_instructions_for_5_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(13, 7, 3, EnemyConstants.Enemies.PRIEST)
	]

func _get_instructions_for_5_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(13, 7, 3, EnemyConstants.Enemies.PRIEST),
		
		SingleEnemySpawnInstruction.new(38, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(40, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_5_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(13, 9, 3, EnemyConstants.Enemies.PRIEST),
		
		SingleEnemySpawnInstruction.new(38, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(40, EnemyConstants.Enemies.BELIEVER),
	]


############## 5-3
func _get_instructions_for_5_3():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_5_3__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_5_3__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_5_3__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_5_3__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_5_3__sv_5()


func _get_instructions_for_5_3__sv_1():
	return [
		LinearEnemySpawnInstruction.new(0, 21, 3, 0.02, EnemyConstants.Enemies.BELIEVER, 0.25),
	]

func _get_instructions_for_5_3__sv_2():
	return [
		LinearEnemySpawnInstruction.new(0, 23, 3, 0.02, EnemyConstants.Enemies.BELIEVER, 0.25),
	]

func _get_instructions_for_5_3__sv_3():
	return [
		LinearEnemySpawnInstruction.new(0, 25, 3, 0.02, EnemyConstants.Enemies.BELIEVER, 0.25),
	]

func _get_instructions_for_5_3__sv_4():
	return [
		LinearEnemySpawnInstruction.new(0, 27, 3, 0.02, EnemyConstants.Enemies.BELIEVER, 0.25),
	]

func _get_instructions_for_5_3__sv_5():
	return [
		LinearEnemySpawnInstruction.new(0, 31, 3, 0.02, EnemyConstants.Enemies.BELIEVER, 0.25),
	]

############### 5-4
func _get_instructions_for_5_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_5_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_5_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_5_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_5_4__sv_4()

func _get_instructions_for_5_4__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 7, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3.25, 5, 6.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(8, 4, 1, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_5_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 7, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3.25, 6, 6.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(8, 5, 1, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_5_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 6.5, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3.25, 7, 6.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(8, 5, 1, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_5_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 6, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3.25, 7, 6.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(8, 6, 1, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_5_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 6, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3.25, 9, 5.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(8, 7, 1, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]

################ 6-1 DEITY ROUND
func _get_instructions_for_6_1():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_6_1__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_6_1__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_6_1__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_6_1__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_6_1__sv_5()


func _get_instructions_for_6_1__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 0.75, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(12, 5, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(14.5, 4, 3, EnemyConstants.Enemies.PRIEST)
	]

func _get_instructions_for_6_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.75, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(12, 5, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(14.5, 5, 3, EnemyConstants.Enemies.PRIEST)
	]

func _get_instructions_for_6_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.75, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(12, 6, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(14.5, 6, 3, EnemyConstants.Enemies.PRIEST)
	]

func _get_instructions_for_6_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.75, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(12, 7, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(14.5, 7, 3, EnemyConstants.Enemies.PRIEST),
	]

func _get_instructions_for_6_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.75, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(12, 9, 2.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(14.5, 9, 2.5, EnemyConstants.Enemies.PRIEST),
		
	]


################## 6-2
func _get_instructions_for_6_2():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_6_2__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_6_2__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_6_2__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_6_2__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_6_2__sv_5()


func _get_instructions_for_6_2__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 3.2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3, 2, 9, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(21, 2, 9, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_6_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 3.2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3, 3, 9, EnemyConstants.Enemies.DVARAPALA),
	]

func _get_instructions_for_6_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3, 3, 9, EnemyConstants.Enemies.DVARAPALA),
	]

func _get_instructions_for_6_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 2.9, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3, 3, 9, EnemyConstants.Enemies.DVARAPALA),
	]

func _get_instructions_for_6_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 2.9, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(3, 4, 7, EnemyConstants.Enemies.DVARAPALA),
	]

############## 6-3
func _get_instructions_for_6_3():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_6_3__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_6_3__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_6_3__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_6_3__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_6_3__sv_5()


func _get_instructions_for_6_3__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.1, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(4, 4, 2.5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_6_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(4, 4, 2.5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_6_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(4, 5, 2.5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER)
	]

func _get_instructions_for_6_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 1.9, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(4, 5, 2.5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.BELIEVER)
	]

func _get_instructions_for_6_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 1.8, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(2, 7, 2, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.BELIEVER)
	]


############## 6-4 DEITY ROUND
func _get_instructions_for_6_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_6_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_6_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_6_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_6_4__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_6_4__sv_5()


func _get_instructions_for_6_4__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 5, 4, EnemyConstants.Enemies.SEER),
	]

func _get_instructions_for_6_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 2, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 6, 4, EnemyConstants.Enemies.SEER),
	]

func _get_instructions_for_6_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 1.92, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 7, 4, EnemyConstants.Enemies.SEER),
	]

func _get_instructions_for_6_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 21, 1.85, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 7, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.SEER),
	]

func _get_instructions_for_6_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 1.75, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(4, 9, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.SEER),
	]

############# 7-1
func _get_instructions_for_7_1():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_7_1__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_7_1__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_7_1__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_7_1__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_7_1__sv_5()


func _get_instructions_for_7_1__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 3.1, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 1, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(21, 2, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(42, 2, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(45, 2, 1.5, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_7_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 3.05, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 1, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(21, 2, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(42, 3, 1.5, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_7_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 3, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 1, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(20, 2, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(40, 3, 1.5, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_7_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 2.95, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 2, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(20, 2, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(40, 3, 1.5, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_7_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 2.95, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 3, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(20, 3, 1.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(40, 3, 1.5, EnemyConstants.Enemies.DVARAPALA)
	]


################## 7-2
func _get_instructions_for_7_2():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_7_2__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_7_2__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_7_2__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_7_2__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_7_2__sv_5()


func _get_instructions_for_7_2__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 7.5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(7.5, 4, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 2, 5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		MultipleEnemySpawnInstruction.new(28, 4, 1, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_7_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 7, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(7.5, 4, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 2, 5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		MultipleEnemySpawnInstruction.new(24, 4, 1, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_7_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 7, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(7.5, 6, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 3, 5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		MultipleEnemySpawnInstruction.new(24, 5, 1, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_7_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 7, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(7.5, 8, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 5, 5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		MultipleEnemySpawnInstruction.new(24, 7, 1, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_7_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 6, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(7.5, 8, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 7, 5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		MultipleEnemySpawnInstruction.new(24, 7, 1, EnemyConstants.Enemies.BELIEVER),
	]

##################### 7-3 DEITY ROUND
func _get_instructions_for_7_3():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_7_3__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_7_3__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_7_3__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_7_3__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_7_3__sv_5()


func _get_instructions_for_7_3__sv_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(7.5, 5, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 3, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(34, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_7_3__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(6, 2, 1, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7.5, 6, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 4, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(34, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_7_3__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(6, 2, 1, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7.5, 8, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 4, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_7_3__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(6, 4, 1, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7.5, 8, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 5, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_7_3__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(6, 4, 1, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7.5, 8, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(8.5, 6, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.DVARAPALA)
	]


###################### 7-4
func _get_instructions_for_7_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_7_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_7_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_7_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_7_4__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_7_4__sv_5()


func _get_instructions_for_7_4__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7.5, 3, 9, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.PROVIDENCE),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.PROVIDENCE),
	]

func _get_instructions_for_7_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 3, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7.5, 3, 9, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.PROVIDENCE),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.PROVIDENCE),
	]

func _get_instructions_for_7_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 3, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(7.5, 3, 9, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.PROVIDENCE),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.PROVIDENCE),
	]

func _get_instructions_for_7_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.9, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(7.5, 3, 9, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.PROVIDENCE),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.PROVIDENCE),
	]

func _get_instructions_for_7_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.9, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(7.5, 3, 9, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.PROVIDENCE),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.PROVIDENCE),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.PROVIDENCE),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.PROVIDENCE),
	]

##################### 8-1
func _get_instructions_for_8_1():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_8_1__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_8_1__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_8_1__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_8_1__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_8_1__sv_5()


func _get_instructions_for_8_1__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.1, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1.25, 14, 2.1, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2.5, 4, 6.2, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
	]

func _get_instructions_for_8_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1.25, 15, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2.5, 4, 6, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
	]

func _get_instructions_for_8_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 1.9, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1.25, 17, 1.9, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2.5, 5, 5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
	]

func _get_instructions_for_8_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.75, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1.25, 20, 1.75, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2.5, 6, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
	]

func _get_instructions_for_8_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 23, 1.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1.25, 23, 1.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2.5, 8, 3, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
	]


################# 8-2 DEITY ROUND
func _get_instructions_for_8_2():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_8_2__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_8_2__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_8_2__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_8_2__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_8_2__sv_5()


func _get_instructions_for_8_2__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 2, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1, 10, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 4, 5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_8_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 11, 2, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1, 11, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 4, 5, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_8_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1, 12, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 5, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_8_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1, 14, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 5, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.BELIEVER),
	]

func _get_instructions_for_8_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 2, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(1, 17, 2, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 6, 4, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BELIEVER),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.BELIEVER),
	]


################ 8-3
func _get_instructions_for_8_3():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_8_3__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_8_3__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_8_3__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_8_3__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_8_3__sv_5()

func _get_instructions_for_8_3__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 24, 1.14, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7, 24, 0.415, EnemyConstants.Enemies.BELIEVER)
	]

func _get_instructions_for_8_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.12, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7, 25, 0.41, EnemyConstants.Enemies.BELIEVER)
	]

func _get_instructions_for_8_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.1, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(7, 25, 0.4, EnemyConstants.Enemies.BELIEVER)
	]

func _get_instructions_for_8_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 26, 1.085, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 26, 0.35, EnemyConstants.Enemies.BELIEVER)
	]

func _get_instructions_for_8_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 30, 1.055, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 30, 0.35, EnemyConstants.Enemies.BELIEVER)
	]


################# 8-4
func _get_instructions_for_8_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_8_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_8_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_8_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_8_4__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_8_4__sv_5()


func _get_instructions_for_8_4__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 3.75, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 13, 3.75, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(1, 13, 3.75, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(2, 5, 8, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(9, 4, 6, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.CROSS_BEARER),
	]

func _get_instructions_for_8_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 3.75, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 13, 3.75, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(1, 13, 3.75, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(2, 5, 8, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(9, 5, 6, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.CROSS_BEARER),
	]

func _get_instructions_for_8_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 3.5, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 14, 3.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(1, 14, 3.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(2, 5, 8, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(9, 5, 6, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.CROSS_BEARER),
	]

func _get_instructions_for_8_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 3.25, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 16, 3.25, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(1, 16, 3.25, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(2, 5, 8, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(9, 5, 6, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.CROSS_BEARER),
	]

func _get_instructions_for_8_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 3.25, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(0, 16, 3.25, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(1, 16, 3.25, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(2, 5, 8, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(4, 7, 5, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.CROSS_BEARER),
	]

#################### 9-1 DEITY ROUND
func _get_instructions_for_9_1():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_9_1__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_9_1__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_9_1__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_9_1__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_9_1__sv_5()


func _get_instructions_for_9_1__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(1, 12, 4, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 12, 4, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(3, 4, 8, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(13, 3, 0.5, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_9_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(1, 13, 4, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 13, 4, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(3, 4, 8, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(13, 6, 0.5, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_9_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(1, 13, 4, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 13, 4, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(3, 4, 8, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(13, 6, 0.5, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.DVARAPALA)
	]

func _get_instructions_for_9_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(1, 13, 4, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 13, 4, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(3, 5, 8, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(13, 7, 0.5, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.DVARAPALA),
	]

func _get_instructions_for_9_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 4, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(1, 14, 4, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(2, 14, 4, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(3, 6, 7, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(13, 7, 0.5, EnemyConstants.Enemies.PRIEST),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.DVARAPALA),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.DVARAPALA),
	]


############### 9-2
func _get_instructions_for_9_2():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_9_2__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_9_2__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_9_2__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_9_2__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_9_2__sv_5()


func _get_instructions_for_9_2__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 10, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 5, 8, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
	]

func _get_instructions_for_9_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 8, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 5, 8, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
	]

func _get_instructions_for_9_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 6.67, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 5, 8, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
	]

func _get_instructions_for_9_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 5.71, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 5, 8, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
	]

func _get_instructions_for_9_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 5, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 7, 6, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
	]


################## 9-3
func _get_instructions_for_9_3():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_9_3__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_9_3__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_9_3__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_9_3__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_9_3__sv_5()


func _get_instructions_for_9_3__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 10, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 4, 10, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		
		LinearEnemySpawnInstruction.new(18, 15, 0.5, 0.030, EnemyConstants.Enemies.BELIEVER, 0.1),
	]

func _get_instructions_for_9_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 10, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 4, 10, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		
		LinearEnemySpawnInstruction.new(18, 15, 0.5, 0.030, EnemyConstants.Enemies.BELIEVER, 0.1),
	]

func _get_instructions_for_9_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 10, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 4, 10, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		
		LinearEnemySpawnInstruction.new(18, 20, 0.5, 0.030, EnemyConstants.Enemies.BELIEVER, 0.1),
	]

func _get_instructions_for_9_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 10, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 5, 8, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		
		LinearEnemySpawnInstruction.new(18, 20, 0.5, 0.030, EnemyConstants.Enemies.BELIEVER, 0.1),
	]

func _get_instructions_for_9_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 4, 10, EnemyConstants.Enemies.DVARAPALA),
		MultipleEnemySpawnInstruction.new(1, 5, 8, EnemyConstants.Enemies.PROVIDENCE),
		MultipleEnemySpawnInstruction.new(2, 14, 3, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(3, 14, 3, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(4, 7, 6, EnemyConstants.Enemies.SEER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.CROSS_BEARER),
		
		LinearEnemySpawnInstruction.new(18, 35, 0.4, 0.040, EnemyConstants.Enemies.BELIEVER, 0.075),
	]


#################### 9-4 DEITY ROUND
func _get_instructions_for_9_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_9_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_9_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_9_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_9_4__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_9_4__sv_5()


func _get_instructions_for_9_4__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.25, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 2, 20, EnemyConstants.Enemies.DVARAPALA),
		
		MultipleEnemySpawnInstruction.new(11, 11, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(12, 11, 2.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(13, 5, 4, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(22, 4, 4, EnemyConstants.Enemies.PROVIDENCE)
	]

func _get_instructions_for_9_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 23, 1.25, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 2, 20, EnemyConstants.Enemies.DVARAPALA),
		
		MultipleEnemySpawnInstruction.new(11, 12, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(12, 12, 2.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(13, 5, 4, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(22, 4, 4, EnemyConstants.Enemies.PROVIDENCE)
	]

func _get_instructions_for_9_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.25, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 2, 20, EnemyConstants.Enemies.DVARAPALA),
		
		MultipleEnemySpawnInstruction.new(11, 13, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(12, 13, 2.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(13, 5, 4, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(18, 5, 4, EnemyConstants.Enemies.PROVIDENCE)
	]


func _get_instructions_for_9_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.25, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 2, 20, EnemyConstants.Enemies.DVARAPALA),
		
		MultipleEnemySpawnInstruction.new(11, 14, 2.5, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(12, 14, 2.5, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(13, 6, 4, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(14, 6, 4, EnemyConstants.Enemies.PROVIDENCE)
	]

func _get_instructions_for_9_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.25, EnemyConstants.Enemies.BELIEVER),
		MultipleEnemySpawnInstruction.new(8, 3, 14, EnemyConstants.Enemies.DVARAPALA),
		
		MultipleEnemySpawnInstruction.new(11, 16, 2.25, EnemyConstants.Enemies.PRIEST),
		MultipleEnemySpawnInstruction.new(12, 16, 2.25, EnemyConstants.Enemies.SACRIFICER),
		MultipleEnemySpawnInstruction.new(13, 6, 4, EnemyConstants.Enemies.SEER),
		MultipleEnemySpawnInstruction.new(10, 8, 4, EnemyConstants.Enemies.PROVIDENCE)
	]


#

func get_faction_passive():
	_faction_passive = preload("res://EnemyRelated/EnemyFactionPassives/Type_Faithful/Faithful_FactionPassive.gd").new()
	return _faction_passive
