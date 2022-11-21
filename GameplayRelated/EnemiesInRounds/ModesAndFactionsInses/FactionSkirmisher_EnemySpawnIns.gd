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
	if uuid == "01":
		return _get_instructions_for_0_1()
	elif uuid == "02":
		return _get_instructions_for_0_2()
		
		
	elif uuid == "41":
		pass
	
	pass





func _get_instructions_for_0_1():
	return [
		#MultipleEnemySpawnInstruction.new(0, 2, 2, EnemyConstants.Enemies.BASIC, spawn_at_red_metadata),
		MultipleEnemySpawnInstruction.new(0, 1, 0.75, EnemyConstants.Enemies.FINISHER, spawn_at_red_metadata),
		#MultipleEnemySpawnInstruction.new(0, 1, 1, EnemyConstants.Enemies.WIZARD, spawn_at_blue_metadata),
		#MultipleEnemySpawnInstruction.new(0, 10, 1, EnemyConstants.Enemies.DASH),
	]

func _get_instructions_for_0_2():
	return [
		MultipleEnemySpawnInstruction.new(0, 2, 2, EnemyConstants.Enemies.BASIC, spawn_at_red_metadata),
	]



################

func get_faction_passive():
	_faction_passive = Skirmisher_FactionPassive.new()
	return _faction_passive

