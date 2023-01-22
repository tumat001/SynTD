extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"

const Expert_FactionPassive = preload("res://EnemyRelated/EnemyFactionPassives/Type_Expert/Expert_FactionPassive.gd")

var _faction_passive

#

func get_instructions_for_stageround(uuid : String):
#	if uuid == "01":
#		return _get_instructions_for_0_1()
	
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



#func _get_instructions_for_0_1():
#	return [
#		MultipleEnemySpawnInstruction.new(0, 2, 1.5, EnemyConstants.Enemies.ENCHANTRESS),
#	]


########## 4-1
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
		MultipleEnemySpawnInstruction.new(0, 19, 1.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(18.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_4_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 1.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(18.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_4_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 1.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(18.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(31, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_4_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 1.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(18.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(31, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_4_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 19, 1.5, EnemyConstants.Enemies.BASIC),
		SingleEnemySpawnInstruction.new(3.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(9.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(14.5, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.HEALER),
		SingleEnemySpawnInstruction.new(18.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(19.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(21.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(31, EnemyConstants.Enemies.EXPERIENCED),
	]

################ 4-2
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
		MultipleEnemySpawnInstruction.new(0, 8, 7, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.25, 8, 7, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 2, 15, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(35, 2, 1, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_4_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 6.5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.25, 9, 6.5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 2, 15, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(35, 3, 1, EnemyConstants.Enemies.EXPERIENCED),
	]


func _get_instructions_for_4_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 6.2, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.25, 9, 6.2, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 2, 15, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(35, 3, 1, EnemyConstants.Enemies.EXPERIENCED),
	]


func _get_instructions_for_4_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 5.9, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.25, 9, 5.9, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 2, 15, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(35, 3, 1, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_4_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 5.8, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.25, 10, 5.8, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0, 3, 15, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(35, 3, 1, EnemyConstants.Enemies.EXPERIENCED),
	]

################### 4-3
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
		MultipleEnemySpawnInstruction.new(0, 9, 4.65, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 2, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(30, 1, 1, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 4.55, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 2, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(30, 2, 1, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 4.5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 2, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(30, 3, 1, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 4.25, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 2, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(30, 4, 1, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 4.25, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 3, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(30, 4, 1, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.CHARGE),
	]

################## 4-4
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
		MultipleEnemySpawnInstruction.new(0, 5, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(11, 5, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(24, 5, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(39, 6, 0.5, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(11, 6, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(24, 6, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(39, 7, 0.5, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(11, 6, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(24, 7, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(39, 8, 0.5, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(11, 6, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(24, 7, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(39, 9, 0.5, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_4_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(11, 6, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(24, 8, 0.75, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(39, 10, 0.5, EnemyConstants.Enemies.CHARGE),
	]

########## 5-1
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
		MultipleEnemySpawnInstruction.new(0, 5, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(2.25, 2, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		MultipleEnemySpawnInstruction.new(21, 5, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(24.75, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(25.5, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_5_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(2.25, 2, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		MultipleEnemySpawnInstruction.new(21, 6, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(24.75, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(25.5, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(26.25, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_5_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(2.25, 2, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		MultipleEnemySpawnInstruction.new(21, 6, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(24.75, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(25.5, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(26.25, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(27.75, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_5_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(2.25, 2, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		MultipleEnemySpawnInstruction.new(21, 8, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(24.75, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(25.5, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(26.25, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(27.75, EnemyConstants.Enemies.CHARGE),
	]

func _get_instructions_for_5_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(2.25, 2, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(10, 2, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		MultipleEnemySpawnInstruction.new(21, 8, 0.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(24.75, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(25.5, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(26.25, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(27.75, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(28.5, EnemyConstants.Enemies.CHARGE),
	]

################ 5-2
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
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(6, 9, 0.5, EnemyConstants.Enemies.ASSASSIN),
		
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FIEND),
	]

func _get_instructions_for_5_2__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(6, 9, 0.5, EnemyConstants.Enemies.ASSASSIN),
		
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(38, EnemyConstants.Enemies.FIEND),
	]

func _get_instructions_for_5_2__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(6, 9, 0.5, EnemyConstants.Enemies.ASSASSIN),
		
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(38, EnemyConstants.Enemies.FIEND),
		
		MultipleEnemySpawnInstruction.new(48, 3, 0.5, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_5_2__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(6, 9, 0.5, EnemyConstants.Enemies.ASSASSIN),
		
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(38, EnemyConstants.Enemies.FIEND),
		
		MultipleEnemySpawnInstruction.new(48, 6, 0.5, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_5_2__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(6, 9, 0.5, EnemyConstants.Enemies.ASSASSIN),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.FIEND),
		
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(38, EnemyConstants.Enemies.FIEND),
		
		MultipleEnemySpawnInstruction.new(48, 7, 0.5, EnemyConstants.Enemies.ASSASSIN),
	]

############ 5-3
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
		MultipleEnemySpawnInstruction.new(0, 6, 0.5, EnemyConstants.Enemies.EXPERIENCED),
		
		MultipleEnemySpawnInstruction.new(14, 14, 2.2, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 14, 2.2, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(44, 2, 1.3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(44.3, 2, 1.3, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_5_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.5, EnemyConstants.Enemies.EXPERIENCED),
		
		MultipleEnemySpawnInstruction.new(14, 14, 2.2, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 14, 2.2, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(44, 2, 1.3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(44.3, 2, 1.3, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_5_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 0.5, EnemyConstants.Enemies.EXPERIENCED),
		
		MultipleEnemySpawnInstruction.new(14, 14, 2.2, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 14, 2.2, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(44, 4, 1.3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(44.3, 4, 1.3, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_5_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 0.5, EnemyConstants.Enemies.EXPERIENCED),
		
		MultipleEnemySpawnInstruction.new(14, 14, 2.2, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 14, 2.2, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(44, 5, 1.3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(44.3, 5, 1.3, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_5_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 0.5, EnemyConstants.Enemies.EXPERIENCED),
		
		MultipleEnemySpawnInstruction.new(14, 14, 2.2, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(15, 14, 2.2, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(44, 6, 1.3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(44.3, 6, 1.3, EnemyConstants.Enemies.ASSASSIN),
	]

############## 5-4
func _get_instructions_for_5_4():
	if enemy_strength_value_to_use == 1:
		return _get_instructions_for_5_4__sv_1()
	elif enemy_strength_value_to_use == 2:
		return _get_instructions_for_5_4__sv_2()
	elif enemy_strength_value_to_use == 3:
		return _get_instructions_for_5_4__sv_3()
	elif enemy_strength_value_to_use == 4:
		return _get_instructions_for_5_4__sv_4()
	elif enemy_strength_value_to_use == 5:
		return _get_instructions_for_5_4__sv_5()


func _get_instructions_for_5_4__sv_1():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_5_4__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_5_4__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_5_4__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_5_4__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.GRANDMASTER),
	]

############## 6-1
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
		MultipleEnemySpawnInstruction.new(0, 20, 1.85, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11.25, EnemyConstants.Enemies.MAGUS),
		
		SingleEnemySpawnInstruction.new(26, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(36, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.8, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11.25, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(11.75, EnemyConstants.Enemies.EXPERIENCED),
		
		SingleEnemySpawnInstruction.new(26, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(36, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11.25, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(11.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		SingleEnemySpawnInstruction.new(26, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(34, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(36, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11.25, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(11.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		SingleEnemySpawnInstruction.new(26, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(34, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(36, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 20, 1.75, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(11.25, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(11.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(26, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(34, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(36, EnemyConstants.Enemies.ENCHANTRESS),
	]

############ 6-2
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
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(2, 5, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(18, 5, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_2__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(2, 6, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(16, 6, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_2__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(2, 7, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(16, 7, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_2__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(2, 8, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(16, 8, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_2__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(2, 6, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
		
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(16, 6, 0.75, EnemyConstants.Enemies.ENCHANTRESS),
	]

############ 6-3
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
		MultipleEnemySpawnInstruction.new(0, 14, 2.15, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(10, 3, 5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(20, 2, 2, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 2.05, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(10, 3, 5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(20, 3, 2, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 2, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(10, 4, 5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(20, 4, 2, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 17, 1.95, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(10, 4, 5, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(20, 5, 2, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_6_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 18, 1.85, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(10, 5, 4, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(20, 5, 2, EnemyConstants.Enemies.ENCHANTRESS),
	]


########### 6-4
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
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(4, 2, 6, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.MAGUS),
	]

func _get_instructions_for_6_4__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(4, 4, 5, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(20, 2, 1, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_6_4__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(4, 6, 4, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(20, 5, 1, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_6_4__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(4, 6, 3.5, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(20, 7, 0.75, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_6_4__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(4, 7, 3.25, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(20, 7, 0.75, EnemyConstants.Enemies.EXPERIENCED),
	]


################ 7-1
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
		MultipleEnemySpawnInstruction.new(0, 20, 1.8, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(0.5, 20, 1.8, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_7_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 22, 1.7, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(0.5, 22, 1.7, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.EXPERIENCED),
	]

func _get_instructions_for_7_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 23, 1.65, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(0.5, 23, 1.65, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_7_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 23, 1.6, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(0.5, 23, 1.6, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(45, 5, 1, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_7_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.55, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(0.5, 25, 1.55, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(35, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(45, 5, 1, EnemyConstants.Enemies.ASSASSIN),
	]

########### 7-2
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
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.FIEND),
		
		MultipleEnemySpawnInstruction.new(24, 4, 0.75, EnemyConstants.Enemies.FIEND),
	]

func _get_instructions_for_7_2__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.FIEND),
		
		MultipleEnemySpawnInstruction.new(24, 5, 0.75, EnemyConstants.Enemies.FIEND),
	]

func _get_instructions_for_7_2__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(9, 4, 1, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(24, 5, 0.75, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(38, 2, 1.5, EnemyConstants.Enemies.EXPERIENCED),
		
	]

func _get_instructions_for_7_2__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(9, 4, 1, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(24, 6, 0.75, EnemyConstants.Enemies.FIEND),
	]

func _get_instructions_for_7_2__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(9, 6, 1, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(24, 6, 0.75, EnemyConstants.Enemies.FIEND),
	]


#################### 7-3
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
		MultipleEnemySpawnInstruction.new(0, 35, 1.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new((1.35 * 5), 6, 2.6, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new((36 * 1.35), 4, 0.2, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_7_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 38, 1.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new((1.35 * 5), 7, 2.6, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new((39 * 1.35), 7, 0.2, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_7_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 38, 1.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new((1.35 * 5), 8, 2.6, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new((39 * 1.35), 9, 0.2, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_7_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 38, 1.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new((1.35 * 5), 8, 2.2, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new((19 * 1.35), 3, 0.2, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new((39 * 1.35), 9, 0.2, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_7_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 38, 1.3, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new((1.3 * 5), 9, 2.2, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new((19 * 1.3), 6, 0.2, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new((39 * 1.3), 9, 0.2, EnemyConstants.Enemies.ASSASSIN),
	]

#################### 7-4
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
		MultipleEnemySpawnInstruction.new(0, 25, 1.65, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.75, 6, 6.25, EnemyConstants.Enemies.MAGUS),
	]

func _get_instructions_for_7_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 28, 1.54, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.75, 7, 6.25, EnemyConstants.Enemies.MAGUS),
	]

func _get_instructions_for_7_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 31, 1.54, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.75, 8, 6.25, EnemyConstants.Enemies.MAGUS),
	]

func _get_instructions_for_7_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 32, 1.54, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.75, 9, 5, EnemyConstants.Enemies.MAGUS),
	]

func _get_instructions_for_7_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 34, 1.4, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.75, 10, 4, EnemyConstants.Enemies.MAGUS),
	]

################ 8-1
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
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 18, 2.2, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(1.6, 18, 2.2, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(8, 3, 13, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_8_1__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 20, 2, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(1.5, 20, 2, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(8, 3, 13, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_8_1__sv_3():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 22, 1.8, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(1.4, 22, 1.8, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(8, 3, 13, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_8_1__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 25, 1.6, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(1.3, 25, 1.6, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(8, 3, 12, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_8_1__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 27, 1.4, EnemyConstants.Enemies.ASSASSIN),
		MultipleEnemySpawnInstruction.new(1.3, 27, 1.4, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(8, 3, 12, EnemyConstants.Enemies.GRANDMASTER),
	]

################ 8-2
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
		MultipleEnemySpawnInstruction.new(0, 12, 2, EnemyConstants.Enemies.CHARGE),
		
		MultipleEnemySpawnInstruction.new(12, 8, 1, EnemyConstants.Enemies.ENCHANTRESS),
		
		LinearEnemySpawnInstruction.new(24, 6, 0.5, 0.060, EnemyConstants.Enemies.ASSASSIN, 0.15),
	]

func _get_instructions_for_8_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2, EnemyConstants.Enemies.CHARGE),
		
		MultipleEnemySpawnInstruction.new(12, 10, 1, EnemyConstants.Enemies.ENCHANTRESS),
		
		LinearEnemySpawnInstruction.new(24, 8, 0.5, 0.060, EnemyConstants.Enemies.ASSASSIN, 0.15),
	]

func _get_instructions_for_8_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2, EnemyConstants.Enemies.CHARGE),
		
		MultipleEnemySpawnInstruction.new(12, 12, 1, EnemyConstants.Enemies.ENCHANTRESS),
		LinearEnemySpawnInstruction.new(12, 4, 0.5, 0.060, EnemyConstants.Enemies.ASSASSIN, 0.15),
		
		LinearEnemySpawnInstruction.new(24, 8, 0.5, 0.060, EnemyConstants.Enemies.ASSASSIN, 0.15),
	]

func _get_instructions_for_8_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2, EnemyConstants.Enemies.CHARGE),
		
		MultipleEnemySpawnInstruction.new(12, 12, 1, EnemyConstants.Enemies.ENCHANTRESS),
		LinearEnemySpawnInstruction.new(12, 8, 0.5, 0.060, EnemyConstants.Enemies.ASSASSIN, 0.15),
		
		LinearEnemySpawnInstruction.new(24, 12, 0.5, 0.060, EnemyConstants.Enemies.ASSASSIN, 0.15),
	]

func _get_instructions_for_8_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2, EnemyConstants.Enemies.CHARGE),
		
		MultipleEnemySpawnInstruction.new(12, 14, 1, EnemyConstants.Enemies.ENCHANTRESS),
		LinearEnemySpawnInstruction.new(12, 12, 0.5, 0.060, EnemyConstants.Enemies.ASSASSIN, 0.15),
		
		LinearEnemySpawnInstruction.new(24, 15, 0.5, 0.060, EnemyConstants.Enemies.ASSASSIN, 0.15),
	]

####################### 8-3
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
		MultipleEnemySpawnInstruction.new(0, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(0.5, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(1, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_8_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(0.5, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(1, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(65.5, EnemyConstants.Enemies.ENCHANTRESS)
	]

func _get_instructions_for_8_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(0.5, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(1, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(65.5, EnemyConstants.Enemies.GRANDMASTER)
	]

func _get_instructions_for_8_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(0.5, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(1, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(49.5, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(65.5, EnemyConstants.Enemies.GRANDMASTER)
	]

func _get_instructions_for_8_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(0.5, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(1, 5, 16, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(49.5, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(65.5, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(66, EnemyConstants.Enemies.GRANDMASTER)
	]

######################## 8-4
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
		MultipleEnemySpawnInstruction.new(0, 24, 1.4, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 13, 2.7, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(1, 4, 10, EnemyConstants.Enemies.GRANDMASTER),
		
		MultipleEnemySpawnInstruction.new(15, 4, 0.5, EnemyConstants.Enemies.ASSASSIN),
		
		MultipleEnemySpawnInstruction.new(30, 3, 1.25, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_8_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 25, 1.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 13, 2.7, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(1, 4, 10, EnemyConstants.Enemies.GRANDMASTER),
		
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.FIEND),
		
		MultipleEnemySpawnInstruction.new(30, 3, 1.25, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_8_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 28, 1.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 15, 2.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(1, 4, 10, EnemyConstants.Enemies.GRANDMASTER),
		
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.FIEND),
		
		MultipleEnemySpawnInstruction.new(30, 3, 1.25, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_8_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 28, 1.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 15, 2.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(1, 4, 10, EnemyConstants.Enemies.GRANDMASTER),
		
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FIEND),
	]

func _get_instructions_for_8_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 28, 1.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 16, 2.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(1, 5, 8, EnemyConstants.Enemies.GRANDMASTER),
		
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FIEND),
	]

##################### 9-1
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
		MultipleEnemySpawnInstruction.new(0, 30, 3.1, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 30, 3.1, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(1, 30, 3.1, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.GRANDMASTER),
		
		MultipleEnemySpawnInstruction.new(42, 2, 1, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(48, 5, 0.25, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(54, 3, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(60, 1, 0.5, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(72, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(73, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_9_1__sv_2():
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

func _get_instructions_for_9_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 33, 2.9, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 33, 2.9, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(1, 33, 2.9, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.GRANDMASTER),
		
		MultipleEnemySpawnInstruction.new(42, 2, 1, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(48, 6, 0.25, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(54, 4, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(60, 1, 0.5, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(72, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(73, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_9_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 33, 2.9, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 33, 2.9, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(1, 33, 2.9, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.GRANDMASTER),
		
		MultipleEnemySpawnInstruction.new(42, 2, 1, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(48, 8, 0.25, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(54, 4, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(60, 2, 1.25, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(72, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(73, EnemyConstants.Enemies.GRANDMASTER),
	]

func _get_instructions_for_9_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 33, 2.9, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(0.5, 33, 2.9, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(1, 33, 2.9, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.ENCHANTRESS),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.GRANDMASTER),
		
		MultipleEnemySpawnInstruction.new(42, 2, 1, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(48, 8, 0.25, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(54, 6, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(60, 3, 1.25, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(72, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(73, EnemyConstants.Enemies.GRANDMASTER),
	]

######################## 9-2
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
		MultipleEnemySpawnInstruction.new(0, 16, 0.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 20, 0.25, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(21, 2, 0.5, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(23, 10, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(27, 10, 1, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_9_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 0.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 20, 0.25, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(21, 2, 0.5, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(23, 10, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(27, 10, 1, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_9_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 0.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 22, 0.25, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(21, 2, 0.5, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(23, 8, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(27, 8, 1, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_9_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 0.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 22, 0.25, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(21, 3, 0.5, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(23, 9, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(27, 9, 1, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_9_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 0.35, EnemyConstants.Enemies.EXPERIENCED),
		MultipleEnemySpawnInstruction.new(10, 22, 0.25, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.FIEND),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(21, 4, 0.5, EnemyConstants.Enemies.MAGUS),
		MultipleEnemySpawnInstruction.new(23, 10, 0.5, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(27, 10, 0.75, EnemyConstants.Enemies.ASSASSIN),
	]

################# 9-3
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
		MultipleEnemySpawnInstruction.new(0, 15, 4.6, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 23, 2.3, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(6, 2, 10, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(26, EnemyConstants.Enemies.ENCHANTRESS),
	]

func _get_instructions_for_9_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 4.5, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 26, 2.25, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(6, 3, 10, EnemyConstants.Enemies.MAGUS),
	]

func _get_instructions_for_9_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 4.3, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 26, 2.15, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(6, 3, 10, EnemyConstants.Enemies.MAGUS),
	]

func _get_instructions_for_9_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 4.2, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 26, 2.1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(6, 4, 8, EnemyConstants.Enemies.MAGUS),
	]

func _get_instructions_for_9_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 16, 3.85, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(1, 27, 2.1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(6, 5, 6, EnemyConstants.Enemies.MAGUS),
	]


################# 9-4
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
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		LinearEnemySpawnInstruction.new(0, 36, 1, 0.030, EnemyConstants.Enemies.ASSASSIN, 0.15),
		MultipleEnemySpawnInstruction.new(1, 5, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(8, 3, 2, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(9, 2, 2, EnemyConstants.Enemies.MAGUS),
		
		MultipleEnemySpawnInstruction.new(32, 22, 0.55, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(38, 4, 0.75, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(41, 9, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(46, 4, 1, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_9_4__sv_2():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		LinearEnemySpawnInstruction.new(0, 36, 1, 0.030, EnemyConstants.Enemies.ASSASSIN, 0.15),
		MultipleEnemySpawnInstruction.new(1, 5, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(8, 4, 2, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(9, 2, 2, EnemyConstants.Enemies.MAGUS),
		
		MultipleEnemySpawnInstruction.new(32, 22, 0.55, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(38, 4, 0.75, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(41, 9, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(46, 4, 1, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_9_4__sv_3():
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

func _get_instructions_for_9_4__sv_4():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		LinearEnemySpawnInstruction.new(0, 40, 1, 0.030, EnemyConstants.Enemies.ASSASSIN, 0.15),
		MultipleEnemySpawnInstruction.new(1, 8, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(8, 4, 2, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(9, 2, 2, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.GRANDMASTER),
		
		MultipleEnemySpawnInstruction.new(32, 25, 0.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.CHARGE),
		MultipleEnemySpawnInstruction.new(38, 4, 0.75, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(41, 10, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(46, 5, 1, EnemyConstants.Enemies.ASSASSIN),
	]

func _get_instructions_for_9_4__sv_5():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.FIEND),
		LinearEnemySpawnInstruction.new(0, 40, 1, 0.030, EnemyConstants.Enemies.ASSASSIN, 0.15),
		MultipleEnemySpawnInstruction.new(1, 8, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(8, 4, 2, EnemyConstants.Enemies.FIEND),
		MultipleEnemySpawnInstruction.new(9, 2, 2, EnemyConstants.Enemies.MAGUS),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.GRANDMASTER),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.GRANDMASTER),
		
		MultipleEnemySpawnInstruction.new(32, 25, 0.5, EnemyConstants.Enemies.EXPERIENCED),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.CHARGE),
		SingleEnemySpawnInstruction.new(35, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(38, 4, 0.75, EnemyConstants.Enemies.GRANDMASTER),
		MultipleEnemySpawnInstruction.new(41, 10, 1, EnemyConstants.Enemies.ENCHANTRESS),
		MultipleEnemySpawnInstruction.new(46, 5, 1, EnemyConstants.Enemies.ASSASSIN),
	]


################

func get_faction_passive():
	_faction_passive = Expert_FactionPassive.new()
	return _faction_passive

