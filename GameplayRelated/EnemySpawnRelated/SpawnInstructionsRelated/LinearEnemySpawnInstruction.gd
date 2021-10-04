extends "res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd"

const SingleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/SingleEnemySpawnInstruction.gd")


var enemy_id : int

var num_of_enemies : int
var seconds_per_enemy : float
var seconds_scale_deduct_per_enemy : float

const lowest_time_scale_amount : float = 0.05


func _init(arg_local_timepos : float, arg_num_of_enemies : int, arg_time_per_enemy : float, arg_time_reduction_scale_per_enemy : float, arg_enemy_id : int).(arg_local_timepos):
	enemy_id = arg_enemy_id
	num_of_enemies = arg_num_of_enemies
	seconds_per_enemy = arg_time_per_enemy
	seconds_scale_deduct_per_enemy = arg_time_reduction_scale_per_enemy


func _get_spawn_instructions():
	var curr_time_frame : float = local_timepos
	var bucket : Array = []
	var curr_time_space_scale : float = 1
	
	for i in num_of_enemies:
		bucket.append(SingleEnemySpawnInstruction.new(curr_time_frame, enemy_id))
		curr_time_frame += (seconds_per_enemy * curr_time_space_scale)
		curr_time_space_scale -= seconds_scale_deduct_per_enemy
		
		if curr_time_space_scale < lowest_time_scale_amount:
			curr_time_space_scale = lowest_time_scale_amount
	
	return bucket
