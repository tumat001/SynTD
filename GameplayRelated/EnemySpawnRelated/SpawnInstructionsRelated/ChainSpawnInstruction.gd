extends "res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd"


var instructions : Array = []


func _init(arg_local_timepos : float, arg_instructions : Array = []).(arg_local_timepos):
	instructions = arg_instructions

func _get_spawn_instructions():
	return instructions
