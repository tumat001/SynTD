extends "res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd"


var instructions : Array = []


func _init(arg_local_timepos : float, arg_instructions : Array = [], arg_enemy_metadata_map = null).(arg_local_timepos, arg_enemy_metadata_map):
	instructions = arg_instructions

func _get_spawn_instructions():
	return instructions
