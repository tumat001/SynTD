extends "res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd"


var enemy_id : int


func _init(arg_local_timepos : float, arg_enemy_id : int).(arg_local_timepos):
	enemy_id = arg_enemy_id

func _get_spawn_instructions():
	return enemy_id
