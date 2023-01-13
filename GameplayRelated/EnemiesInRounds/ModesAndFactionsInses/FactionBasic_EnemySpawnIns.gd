extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"


func get_instructions_for_stageround(uuid : String):
	if uuid == "01":
		#return null
		return _get_instructions_for_0_1()
	elif uuid == "02":
		return _get_instructions_for_0_2()
	elif uuid == "03":
		return _get_instructions_for_0_3()
		
	elif uuid == "11":
		return _get_instructions_for_1_1()
	elif uuid == "12":
		return _get_instructions_for_1_2()
	elif uuid == "13":
		return _get_instructions_for_1_3()
	elif uuid == "14":
		return _get_instructions_for_1_4()
		
	elif uuid == "21":
		return _get_instructions_for_2_1()
	elif uuid == "22":
		return _get_instructions_for_2_2()
	elif uuid == "23":
		return _get_instructions_for_2_3()
	elif uuid == "24":
		return _get_instructions_for_2_4()
		
	elif uuid == "31":
		return _get_instructions_for_3_1()
	elif uuid == "32":
		return _get_instructions_for_3_2()
	elif uuid == "33":
		return _get_instructions_for_3_3()
	elif uuid == "34":
		return _get_instructions_for_3_4()
	
	return null


func is_transition_time_in_stageround(uuid : String) -> bool:
	return uuid == "41"
	
	#return uuid == "01"  # to immediately transfer to other factions


func _get_instructions_for_0_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		
		#MultipleEnemySpawnInstruction.new(0, 10, 0.5, EnemyConstants.Enemies.BASIC),
		
		#SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC), 
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
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.BASIC),
	]


###############

# 1-1
func _get_instructions_for_1_1():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_1_1__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_1_1__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_1_1__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_1_1__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_1_1__sv_5()


func _get_instructions_for_1_1__sv_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(5.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(14.0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(18.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_1_1__sv_2(): # ORIGINAL 1-1
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

func _get_instructions_for_1_1__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(5.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(17.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_1_1__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(5.25, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(5.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(17.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(21.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_1_1__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(5.25, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(5.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.5, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(17.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(21.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(23.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.PAIN),
	]


################### 1-2
func _get_instructions_for_1_2():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_1_2__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_1_2__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_1_2__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_1_2__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_1_2__sv_5()

func _get_instructions_for_1_2__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 2.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.HEALER)
	]

func _get_instructions_for_1_2__sv_2(): # ORIGINAL
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 2.4, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.HEALER)
	]

func _get_instructions_for_1_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 2.4, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_1_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 2.4, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_1_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 2.3, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.BASIC),
	]

##################### 1-3

func _get_instructions_for_1_3():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_1_3__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_1_3__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_1_3__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_1_3__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_1_3__sv_5()

func _get_instructions_for_1_3__sv_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(3, 15, 1.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_1_3__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(2, 15, 1.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_1_3__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(2, 15, 1.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_1_3__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.PAIN),
		MultipleEnemySpawnInstruction.new(1.8, 15, 1.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_1_3__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.PAIN),
		MultipleEnemySpawnInstruction.new(1.8, 15, 1.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.DASH),
	]


#################### 1-4

func _get_instructions_for_1_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_1_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_1_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_1_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_1_4__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_1_4__sv_5()

func _get_instructions_for_1_4__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2.7, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(2, 3, 0.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(11.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(13.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(15.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_1_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2.7, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(2, 4, 0.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(11.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(12.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(13.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_1_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.7, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(2, 4, 0.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(11.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(12.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(13.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_1_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.7, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(2, 4, 0.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(11.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(12.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(13.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(29.0, EnemyConstants.Enemies.PAIN),
	]

func _get_instructions_for_1_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.7, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(2, 4, 0.6, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(11.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(12.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(13.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(14.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(29.0, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(29.25, EnemyConstants.Enemies.PAIN),
	]


########################## 2-1

func _get_instructions_for_2_1():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_2_1__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_2_1__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_2_1__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_2_1__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_2_1__sv_5()

func _get_instructions_for_2_1__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(15, 8, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(31, 10, 0.2, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_2_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(15, 9, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(31, 10, 0.2, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_2_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(13, 9, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(29, 10, 0.2, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_2_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(13, 10, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(29, 11, 0.2, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_2_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(13, 10, 0.2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(29, 12, 0.2, EnemyConstants.Enemies.BASIC),
	]

################# 2-2

func _get_instructions_for_2_2():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_2_2__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_2_2__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_2_2__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_2_2__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_2_2__sv_5()


func _get_instructions_for_2_2__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2.7, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 2, 15, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_2_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.6, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 2, 15, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.PAIN),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_2_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.6, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 2, 15, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_2_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.5, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 2, 15, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(35, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_2_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2.4, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 3, 10, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(35, EnemyConstants.Enemies.DASH),
	]

################ 2-3

func _get_instructions_for_2_3():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_2_3__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_2_3__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_2_3__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_2_3__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_2_3__sv_5()



func _get_instructions_for_2_3__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 3, 15, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(1, 1, 0.5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(1.5, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(17, 1, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(32, 1, 0.5, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_2_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 3, 15, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(1, 1, 0.5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(1.5, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(17, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(32, 2, 0.5, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_2_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 3, 15, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(1, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(17, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(32, 3, 0.5, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_2_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 3, 15, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(1, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(17, 3, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(32, 4, 0.5, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_2_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 3, 15, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(1, 3, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(17, 4, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(32, 4, 0.5, EnemyConstants.Enemies.HEALER),
	]


############## 2-4

func _get_instructions_for_2_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_2_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_2_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_2_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_2_4__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_2_4__sv_5()


func _get_instructions_for_2_4__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 1.9, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 2, 0.5, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(6.5, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(15, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(28, 1, 0.5, EnemyConstants.Enemies.BRUTE),
	]

func _get_instructions_for_2_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 1.85, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 3, 0.5, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(15, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(28, 1, 0.5, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_2_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 1.8, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 3, 0.5, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(15, 2, 0.5, EnemyConstants.Enemies.HEALER),
		MultipleEnemySpawnInstruction.new(27, 1, 0.5, EnemyConstants.Enemies.BRUTE),
	]

func _get_instructions_for_2_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 1.8, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 3, 0.5, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(15, 2, 0.5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.PAIN),
	]

func _get_instructions_for_2_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 1.8, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(5, 4, 0.5, EnemyConstants.Enemies.DASH),
		MultipleEnemySpawnInstruction.new(15, 3, 0.5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.PAIN),
	]

################## 3-1
func _get_instructions_for_3_1():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_3_1__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_3_1__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_3_1__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_3_1__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_3_1__sv_5()


func _get_instructions_for_3_1__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 1.55, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(10, 2, 8, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 1.55, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(10, 2, 8, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(10, 2, 8, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 1.55, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(10, 2, 8, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(10, 3, 8, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 1.45, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(10, 4, 6, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(10, 2, 8, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 1.45, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(10, 4, 6, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(10, 4, 6, EnemyConstants.Enemies.HEALER),
	]

################## 3-2
func _get_instructions_for_3_2():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_3_2__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_3_2__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_3_2__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_3_2__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_3_2__sv_5()


func _get_instructions_for_3_2__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 2.5, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0.15, 16, 2.5, EnemyConstants.Enemies.PAIN),
		
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_3_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 2.45, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0.15, 17, 2.45, EnemyConstants.Enemies.PAIN),
		
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_3_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 2.45, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0.15, 18, 2.45, EnemyConstants.Enemies.PAIN),
		
		MultipleEnemySpawnInstruction.new(22, 2, 0.35, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_3_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 2.45, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0.15, 18, 2.45, EnemyConstants.Enemies.PAIN),
		
		MultipleEnemySpawnInstruction.new(22, 4, 0.35, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_3_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 2.4, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0.15, 19, 2.4, EnemyConstants.Enemies.PAIN),
		
		MultipleEnemySpawnInstruction.new(22, 5, 0.35, EnemyConstants.Enemies.BASIC),
	]

############### 3-3
func _get_instructions_for_3_3():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_3_3__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_3_3__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_3_3__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_3_3__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_3_3__sv_5()


func _get_instructions_for_3_3__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 3.15, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.BASIC),
	]

func _get_instructions_for_3_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 3.15, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(20.5, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.HEALER),
	]

func _get_instructions_for_3_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3, EnemyConstants.Enemies.DASH),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.BRUTE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(20.5, EnemyConstants.Enemies.WIZARD),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.HEALER),
	]

################### 3-4

func _get_instructions_for_3_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_3_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_3_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_3_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_3_4__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_3_4__sv_5()



func _get_instructions_for_3_4__sv_1():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 2.15, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(6, 3, 6, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(18, 1, 1, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(38, 2, 0.5, EnemyConstants.Enemies.PAIN),
	]

func _get_instructions_for_3_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 22, 2.1, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0, 4, 6, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(18, 1, 1, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(38, 2, 0.5, EnemyConstants.Enemies.PAIN),
	]

func _get_instructions_for_3_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 24, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0, 5, 6, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(18, 1, 1, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(38, 2, 0.5, EnemyConstants.Enemies.PAIN),
	]

func _get_instructions_for_3_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 24, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0, 6, 6, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(18, 1, 1, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(38, 4, 0.5, EnemyConstants.Enemies.PAIN),
	]

func _get_instructions_for_3_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 24, 2, EnemyConstants.Enemies.BASIC),
		MultipleEnemySpawnInstruction.new(0, 7, 5, EnemyConstants.Enemies.WIZARD),
		MultipleEnemySpawnInstruction.new(18, 1, 1, EnemyConstants.Enemies.BRUTE),
		MultipleEnemySpawnInstruction.new(38, 5, 0.5, EnemyConstants.Enemies.PAIN),
	]
