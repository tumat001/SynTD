extends "res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd"

const SingleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/SingleEnemySpawnInstruction.gd")

var enemy_id : int

var num_of_enemies : int
var seconds_per_enemy : float


func _init(arg_local_timepos : float, arg_num_of_enemies : int, 
		arg_time_per_enemy : float, arg_enemy_id : int, arg_enemy_metadata_map = null).(arg_local_timepos, arg_enemy_metadata_map):
	enemy_id = arg_enemy_id
	num_of_enemies = arg_num_of_enemies
	seconds_per_enemy = arg_time_per_enemy


func _get_spawn_instructions():
	var curr_time_frame : float = local_timepos
	var bucket : Array = []
	
	for i in num_of_enemies:
		bucket.append(SingleEnemySpawnInstruction.new(curr_time_frame, enemy_id, enemy_metadata_map))
		curr_time_frame += seconds_per_enemy
	
	return bucket
