extends "res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd"

const Skirmisher_FactionPassive = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Skirmisher_FactionPassive.gd")


var _faction_passive

var spawn_at_blue_metadata : Dictionary = {
	StoreOfEnemyMetadataIdsFromIns.SKIRMISHER_SPAWN_AT_PATH_TYPE : Skirmisher_FactionPassive.PathType.BLUE_PATH
}

var spawn_at_red_metadata : Dictionary = {
	StoreOfEnemyMetadataIdsFromIns.SKIRMISHER_SPAWN_AT_PATH_TYPE : Skirmisher_FactionPassive.PathType.RED_PATH
}


func get_instructions_for_stageround(uuid : String):
#	if uuid == "01":
#		return _get_instructions_for_0_1()
#	elif uuid == "02":
#		return _get_instructions_for_0_2()
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
	
	
	pass


#func _get_instructions_for_0_1():
#	return [
#		#MultipleEnemySpawnInstruction.new(0, 4, 0.5, EnemyConstants.Enemies.BASIC, spawn_at_red_metadata),
#		#MultipleEnemySpawnInstruction.new(0, 1, 5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
#		#MultipleEnemySpawnInstruction.new(0, 1, 0.75, EnemyConstants.Enemies.BASIC, spawn_at_red_metadata),
#		#MultipleEnemySpawnInstruction.new(0, 1, 1, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
#		#MultipleEnemySpawnInstruction.new(0, 1, 1, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
#
#		MultipleEnemySpawnInstruction.new(0, 5, 2, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
#		#MultipleEnemySpawnInstruction.new(0, 1, 1, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
#	]
#
#
#
#func _get_instructions_for_0_2():
#	return [
#		MultipleEnemySpawnInstruction.new(0, 3, 2, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
#		#MultipleEnemySpawnInstruction.new(0, 1, 2, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
#		#MultipleEnemySpawnInstruction.new(0, 1, 2, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
#	]



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
		MultipleEnemySpawnInstruction.new(0, 9, 2, EnemyConstants.Enemies.BASIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(4, 5, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
	]

func _get_instructions_for_4_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 2, EnemyConstants.Enemies.BASIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(4, 6, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 2, EnemyConstants.Enemies.BASIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(4, 6, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 2, EnemyConstants.Enemies.BASIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(4, 6, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 1.8, EnemyConstants.Enemies.BASIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(4, 8, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 2, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(4, 2, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 2, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(11.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(16, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(18.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(22, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 2, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(4, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 2, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(11.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(16, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(18.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(22, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 2, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(4, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(11.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(16, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(18.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(22, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(4, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(5.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(11.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(16, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(18.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(22, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(3.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(4, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(5.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(11.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		SingleEnemySpawnInstruction.new(15.66, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(16, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(18.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		SingleEnemySpawnInstruction.new(21.66, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(22, 3, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24.3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
	]

############# 4-3
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
		MultipleEnemySpawnInstruction.new(0, 10, 2.15, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 4, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(19.5, 2, 0.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 11, 2.15, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 4, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(19.5, 3, 0.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2.15, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 4, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(19.5, 4, 0.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 4, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(19.5, 5, 0.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 5, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(19.5, 6, 0.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 9, 3.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 3, 3, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(8, 3, 3, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 3, 3, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 4, 3, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2.8, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 3, 3, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 4, 3, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.7, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 4, 3, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 4, 3, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
	]

func _get_instructions_for_4_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.7, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(3, 4, 3, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 5, 3, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(9, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 12, 2.3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 5, 0.66, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
	]

func _get_instructions_for_5_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 6, 0.66, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
	]

func _get_instructions_for_5_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 8, 0.66, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
	]

func _get_instructions_for_5_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 10, 0.6, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
	]

func _get_instructions_for_5_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 13, 0.6, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 13, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(12, 3, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_5_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(12, 4, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_5_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(12, 4, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2.15, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(12, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2.15, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(3, 6, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(12, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 4, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(18, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 4, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(18, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 4, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(18, 6, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(24, 1, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(18, 6, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(24, 2, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(18, 9, 0.75, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(24, 2, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 12, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1, 3, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 5, 3, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 2, 5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1, 4, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 6, 3, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 2, 5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1, 4, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 6, 3, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(5, 3, 5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 6, 3, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(5, 3, 5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
	]

func _get_instructions_for_5_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2.3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1, 6, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 6, 3, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(5, 4, 5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 7, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(10, 5, 1.75, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(20, 6, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(26, 5, 2.5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
	]

func _get_instructions_for_6_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(10, 6, 1.75, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(20, 6, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(26, 5, 2.5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
	]

func _get_instructions_for_6_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(10, 6, 1.75, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(20, 7, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(26, 6, 2.5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
	]

func _get_instructions_for_6_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(10, 6, 1.75, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(20, 8, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(26, 6, 2.5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
	]

func _get_instructions_for_6_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(10, 6, 1.75, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(20, 8, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(22, 8, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 3, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(15, 3, 2, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(7, 3, 3.5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 4, 3, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_6_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 4, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(15, 3, 2, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(7, 4, 3.5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 4, 3, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_6_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 4, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(15, 4, 2, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(7, 4, 3.5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 5, 3, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_6_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 5, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(15, 4, 2, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(7, 5, 3.5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 5, 3, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_6_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 5, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(15, 4, 2, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(7, 6, 3.5, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8, 7, 2.5, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 6, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(0.5, 5, 4, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8.6, 4, 0.66, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(14, 3, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(15, 6, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(18.5, 5, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 3, 1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
	]

func _get_instructions_for_6_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(0.5, 6, 4, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8.6, 4, 0.66, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(14, 3, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(15, 6, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(18.5, 6, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 3, 1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
	]

func _get_instructions_for_6_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(0.5, 6, 4, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8.6, 4, 0.66, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(14, 3, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(15, 7, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(18.5, 6, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 3, 1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
	]

func _get_instructions_for_6_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(0.5, 6, 4, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8.6, 4, 0.66, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(14, 3, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(14, 7, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(17.5, 6, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(29, 4, 1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
	]

func _get_instructions_for_6_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(0.5, 6, 4, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(8.6, 4, 0.66, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(14, 3, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
		MultipleEnemySpawnInstruction.new(14, 7, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(17.5, 6, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(29, 4, 1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
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
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 4, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(26, 5, 1.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 9, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 3, 8, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 3, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(34, 3, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_6_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 5, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(26, 5, 1.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 3, 8, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 3, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(34, 3, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_6_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 5, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(26, 6, 1.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 3, 8, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 4, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(34, 3, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_6_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 5, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(26, 6, 1.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 8, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 4, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(34, 3, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_6_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 3.5, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 6, 2, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(26, 6, 1.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 8, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 5, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(31, 5, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
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
		MultipleEnemySpawnInstruction.new(0, 6, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 6, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(14, 4, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(21, 4, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 3, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(25, 2, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 6, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(14, 5, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(21, 5, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 3, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(25, 2, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 6, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(14, 5, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(21, 5, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 4, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(25, 3, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 6, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 6, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(14, 5, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(21, 5, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 5, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(25, 3, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]


func _get_instructions_for_7_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 0.9, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 7, 0.9, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(14, 6, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(21, 5, 1.1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(28, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 10, 3, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 5, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(25, 3, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
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
		MultipleEnemySpawnInstruction.new(0, 12, 2.75, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 3, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(22, 3, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(2, 8, 3.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 3, 3.25, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2.75, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 3, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(22, 4, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(2, 8, 3.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 3, 3.25, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2.75, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 4, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(22, 4, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(2, 8, 3.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 3.25, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 12, 2.75, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 5, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(22, 5, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(2, 8, 3.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 3.25, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 13, 2.75, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 5, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(22, 5, 0.7, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(2, 8, 3.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 3.25, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
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
		LinearEnemySpawnInstruction.new(0, 24, 1.25, 0.075, EnemyConstants.Enemies.RUFFIAN, 0.5, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(0, 5, 3.5, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12.5, 5, 1, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 3, 2.75, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
	]

func _get_instructions_for_7_3__sv_2():
	return [
		LinearEnemySpawnInstruction.new(0, 26, 1.25, 0.075, EnemyConstants.Enemies.RUFFIAN, 0.5, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(0, 6, 3.5, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12.5, 5, 1, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 3, 2.75, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_3__sv_3():
	return [
		LinearEnemySpawnInstruction.new(0, 27, 1.25, 0.075, EnemyConstants.Enemies.RUFFIAN, 0.5, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(0, 6, 2.5, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12.5, 6, 1, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 3, 2.75, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_3__sv_4():
	return [
		LinearEnemySpawnInstruction.new(0, 28, 1.25, 0.075, EnemyConstants.Enemies.RUFFIAN, 0.5, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(0, 7, 2.5, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12.5, 6, 1, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 3, 2.75, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_7_3__sv_5():
	return [
		LinearEnemySpawnInstruction.new(0, 28, 1.25, 0.075, EnemyConstants.Enemies.RUFFIAN, 0.5, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(0, 10, 2, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12.5, 6, 1, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 7, 4, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 3, 2.75, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		
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
		MultipleEnemySpawnInstruction.new(0, 14, 2.275, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 3, 6, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 4, 4, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(3.2, 7, 3.2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1.6, 4, 3.2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_7_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.2, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 3, 6, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 4, 4, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 8, 3.2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1.6, 5, 3.2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_7_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2.15, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 3, 6, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 5, 4, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 8, 3.2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1.6, 5, 3.2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_7_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2.15, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 3, 6, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 5, 4, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(13.5, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 8, 3.2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1.6, 6, 3.2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_7_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2.15, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 3, 6, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(7, 6, 3.5, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(13.5, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(14.5, 2, 1, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 8, 3.2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(1.6, 6, 3.2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 7, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 7, 0.33, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 16, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4.5, 9, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 5, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_8_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 7, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 8, 0.33, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 17, 1.9, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4.5, 9, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 5, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_8_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 8, 0.33, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 17, 1.9, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4.5, 9, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 6, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_8_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 9, 0.33, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 17, 1.9, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4.5, 9, 2, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 7, 2, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_8_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 8, 0.33, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 9, 0.33, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 17, 1.9, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4.5, 11, 1.8, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(21, 9, 1.8, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 15, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 3, 2.5, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 3, 2.5, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 16, 1.8, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6.5, 3, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 4, 6, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_8_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 3, 2.5, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 4, 2.5, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 17, 1.75, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6.5, 4, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 4, 6, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
	]

func _get_instructions_for_8_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 4, 2.5, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 4, 2.5, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 17, 1.7, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6.5, 4, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 5, 5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
	]

func _get_instructions_for_8_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 4, 2, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 2, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 18, 1.65, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6.5, 5, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 5, 5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
	]

func _get_instructions_for_8_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 3.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 4, 2, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 2, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 18, 1.65, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(3.5, 6, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(3.5, 7, 3.85, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 8, 4, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(2, 8, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 6, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(23, 5, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(31, 4, 0.33, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_8_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 4, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(2, 8, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 6, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(23, 6, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(31, 4, 0.33, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_8_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 4, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(2, 9, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 7, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(23, 6, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(31, 4, 0.33, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_8_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 4, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(2, 9, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 7, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(23, 7, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(31, 4, 0.33, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
	]

func _get_instructions_for_8_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 9, 4, EnemyConstants.Enemies.PROXIMITY, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(2, 9, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(10, 8, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(23, 8, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(27, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(29, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(31, 4, 0.33, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(10, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		
		MultipleEnemySpawnInstruction.new(0, 20, 1.85, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10.5, 3, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(15.5, 3, 1.5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(22.5, 2, 1.5, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(26.5, 3, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		
	]

func _get_instructions_for_8_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(10, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		
		MultipleEnemySpawnInstruction.new(0, 20, 1.85, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10.5, 3, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(15.5, 3, 1.5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(22.5, 3, 1.5, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(26.5, 3, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		
	]

func _get_instructions_for_8_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(10, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		
		MultipleEnemySpawnInstruction.new(0, 20, 1.85, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10.5, 4, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(15.5, 3, 1.5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(22.5, 3, 1.5, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(26.5, 3, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		
	]

func _get_instructions_for_8_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(10, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		
		MultipleEnemySpawnInstruction.new(0, 20, 1.85, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10.5, 4, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(15.5, 4, 1.5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(22.5, 3, 1.5, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(26.5, 4, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
	]

func _get_instructions_for_8_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(10, 4, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 1, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 20, 1.85, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10.5, 5, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(14, 6, 1.5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(22.5, 4, 1.5, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(26.5, 4, 1.5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 20, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(1, 2, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 4, 3, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 3, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(27, 2, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new((2 / 2), 20, 2, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 2, 4, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 3, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_1__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 21, 1.9, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(1, 2, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 4, 3, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 4, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(27, 2, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new((1.9 / 2), 21, 1.9, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 2, 4, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 3, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_1__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 21, 1.8, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(1, 2, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 5, 3, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 4, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(27, 2, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new((1.8 / 2), 21, 1.8, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 2, 4, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 4, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 3, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_1__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 22, 1.7, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(1, 2, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 5, 3, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 5, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(27, 2, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new((1.7 / 2), 22, 1.7, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 2, 4, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 5, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 3, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_1__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 22, 1.7, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(1, 3, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(9, 6, 3, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 5, 3, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(27, 2, 4, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new((1.7 / 2), 22, 1.7, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(2, 3, 4, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(4, 6, 4, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 5, 1, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 3, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		
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
		MultipleEnemySpawnInstruction.new((25 * 0.05), 25, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 5, 0.05, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(18, 7, 0.05, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(35, 25, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 25, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 5, 0.05, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(18, 7, 0.05, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new((25 * 0.05) + 35, 25, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
	]

func _get_instructions_for_9_2__sv_2():
	return [
		MultipleEnemySpawnInstruction.new((26 * 0.05), 26, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 5, 0.05, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(18, 8, 0.05, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(35, 26, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 26, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 5, 0.05, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(18, 7, 0.05, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new((26 * 0.05) + 35, 26, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
	]

func _get_instructions_for_9_2__sv_3():
	return [
		MultipleEnemySpawnInstruction.new((26 * 0.05), 26, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 5, 0.05, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(18, 9, 0.05, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(35, 26, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		
		MultipleEnemySpawnInstruction.new(0, 26, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 6, 0.05, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(18, 7, 0.05, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new((26 * 0.05) + 35, 26, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_2__sv_4():
	return [
		MultipleEnemySpawnInstruction.new((27 * 0.05), 27, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 6, 0.05, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(18, 9, 0.05, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(35, 27, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 27, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 6, 0.05, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(18, 8, 0.05, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new((27 * 0.05) + 35, 27, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_2__sv_5():
	return [
		MultipleEnemySpawnInstruction.new((28 * 0.05), 28, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 6, 0.05, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(18, 9, 0.05, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(35, 28, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 28, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(6, 6, 0.05, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(18, 10, 0.05, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new((28 * 0.05) + 35, 28, 0.05, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
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
		MultipleEnemySpawnInstruction.new(0, 14, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 15, 1.1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 6, 3.3, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(16, 4, 3, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		LinearEnemySpawnInstruction.new(0, 24, 1.75, 0.050, EnemyConstants.Enemies.RUFFIAN, 0.2, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 4, 3, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 5, 2.2, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
	]

func _get_instructions_for_9_3__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 16, 1.1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 6, 3.3, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(16, 4, 3, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		LinearEnemySpawnInstruction.new(0, 24, 1.75, 0.050, EnemyConstants.Enemies.RUFFIAN, 0.2, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 5, 3, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 5, 2.2, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
	]

func _get_instructions_for_9_3__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 14, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 18, 1.1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 6, 3.3, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(16, 4, 3, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		LinearEnemySpawnInstruction.new(0, 25, 1.75, 0.050, EnemyConstants.Enemies.RUFFIAN, 0.2, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 5, 3, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 5, 2.2, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
	]

func _get_instructions_for_9_3__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 18, 1.1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 6, 3.3, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(16, 4, 3, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		LinearEnemySpawnInstruction.new(0, 25, 1.75, 0.050, EnemyConstants.Enemies.RUFFIAN, 0.2, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 5, 3, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 6, 2.2, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_3__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 15, 2.5, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 18, 1.1, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 6, 3.3, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(12, 5, 3, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		LinearEnemySpawnInstruction.new(0, 30, 1.75, 0.050, EnemyConstants.Enemies.RUFFIAN, 0.2, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(5, 6, 3, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(16, 6, 2.2, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		
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
		MultipleEnemySpawnInstruction.new(0, 21, 2.35, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 8, 2.25, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 8, 2.25, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 5, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 5, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(25, 6, 1, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 21, 2.35, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(3, 5, 7, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 6, 6, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(20, 5, 5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(35, 6, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_4__sv_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 21, 2.30, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 9, 2.25, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 9, 2.25, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 5, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 5, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(25, 6, 1, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 21, 2.30, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(3, 5, 7, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 6, 6, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(20, 6, 5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(35, 6, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_4__sv_3():
	return [
		MultipleEnemySpawnInstruction.new(0, 22, 2.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 9, 2.25, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 9, 2.25, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 5, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 5, 5, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(25, 6, 1, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 22, 2.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(3, 5, 7, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 6, 6, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(20, 7, 5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(35, 6, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_4__sv_4():
	return [
		MultipleEnemySpawnInstruction.new(0, 22, 2.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 9, 2.25, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 9, 2.25, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 5, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 6, 5, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(25, 6, 1, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 22, 2.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(3, 5, 7, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 6, 6, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(20, 7, 5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(35, 8, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

func _get_instructions_for_9_4__sv_5():
	return [
		MultipleEnemySpawnInstruction.new(0, 22, 2.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(5, 10, 2.25, EnemyConstants.Enemies.SMOKE, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(6, 10, 2.25, EnemyConstants.Enemies.RALLIER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 4, 5, EnemyConstants.Enemies.ASCENDER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(20, 7, 4, EnemyConstants.Enemies.BLESSER, spawn_at_blue_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_blue_metadata),
		MultipleEnemySpawnInstruction.new(25, 7, 1, EnemyConstants.Enemies.COSMIC, spawn_at_blue_metadata),
		
		MultipleEnemySpawnInstruction.new(0, 22, 2.25, EnemyConstants.Enemies.RUFFIAN, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(3, 6, 6, EnemyConstants.Enemies.TOSSER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(10, 7, 5, EnemyConstants.Enemies.ARTILLERY, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(20, 7, 5, EnemyConstants.Enemies.BLASTER, spawn_at_red_metadata),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.HOMERUNNER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(30, 5, 3, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(33, 10, 1, EnemyConstants.Enemies.DANSEUR, spawn_at_red_metadata),
		
	]

################

func get_faction_passive():
	_faction_passive = Skirmisher_FactionPassive.new()
	return _faction_passive

