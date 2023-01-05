
const AbstractSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd")
const SingleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/SingleEnemySpawnInstruction.gd")
const ChainSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/ChainSpawnInstruction.gd")
const MultipleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/MultipleEnemySpawnInstruction.gd")
const LinearEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/LinearEnemySpawnInstruction.gd")

signal spawn_enemy(enemy_id, ins_enemy_metadata_map)
signal no_enemies_to_spawn_left

var _current_time : float

var _instructions_near_exe : Array
var _instructions_far_from_exe : Array
const _instruction_exe_time : float = 5.0 #for segragation
const _instruction_exe_time_allowance : float = -1.0
var _instruction_current_exe_time : float

var highest_timepos_of_instructions : float

# Time related


func time_passed(delta : float):
	_current_time += delta
	_instruction_current_exe_time += delta
	
	if _instruction_current_exe_time >= _instruction_exe_time:
		_instruction_current_exe_time -= _instruction_exe_time
		_segragate_instructions_to_near_or_far_from_exe()
	
	_signal_enemy_id_ins_below_timepos(_current_time)


func reset_time():
	_current_time = 0
	_instruction_current_exe_time = _instruction_exe_time


# Instructions related

# Returns the number of enemies (number of single ins)
func set_instructions(inses : Array) -> int:
	var _ins_and_highest_timepos = _get_interpreted_spawn_instructions(inses)
	
	_instructions_far_from_exe = _ins_and_highest_timepos[0]
	var enemy_count : int = _instructions_far_from_exe.size()
	
	_instructions_near_exe = []
	_segragate_instructions_to_near_or_far_from_exe()
	
	
	highest_timepos_of_instructions = _ins_and_highest_timepos[1]
	
	return enemy_count

func append_instructions(inses : Array) -> int:
	var _ins_and_highest_timepos = _get_interpreted_spawn_instructions(inses)
	var bucket = _ins_and_highest_timepos[0]
	
	for ins in bucket:
		_instructions_far_from_exe.append(ins)
	
	var enemy_count : int = _instructions_far_from_exe.size()
	
	_segragate_instructions_to_near_or_far_from_exe()
	
	
	highest_timepos_of_instructions = _ins_and_highest_timepos[1]
	
	
	return enemy_count
	#return bucket.size()


# Gives an array with:
# 1) All instructions found into a series of SingleEnemySpawnInstructions.
# 2) The timepos of the last instruction
func _get_interpreted_spawn_instructions(inses : Array) -> Array:
	var bucket : Array = []
	var highest_timepos : float = 0
	
	for ins in inses:
		if ins is SingleEnemySpawnInstruction:
			bucket.append(ins)
			if ins.local_timepos > highest_timepos:
				highest_timepos = ins.local_timepos
			
		elif ins is ChainSpawnInstruction:
			var timepos = ins.local_timepos
			for inner_ins in _get_interpreted_spawn_instructions(ins.instructions):
				inner_ins.local_timepos += timepos
				bucket.append(inner_ins)
				
				if inner_ins.local_timepos > highest_timepos:
					highest_timepos = inner_ins.local_timepos
			
		elif ins is MultipleEnemySpawnInstruction or ins is LinearEnemySpawnInstruction:
			for single_ins in ins._get_spawn_instructions():
				bucket.append(single_ins)
				if single_ins.local_timepos > highest_timepos:
					highest_timepos = single_ins.local_timepos
		
		
	
	return [bucket, highest_timepos]


func _segragate_instructions_to_near_or_far_from_exe():
	var bucket : Array = []
	
	for ins in _instructions_far_from_exe:
		var delay_from_now : float = (ins.local_timepos - _current_time) + _instruction_exe_time_allowance
		
		if delay_from_now <= _instruction_exe_time:
			bucket.append(ins)
	
	for ins in bucket:
		_instructions_far_from_exe.erase(ins)
		_instructions_near_exe.append(ins)


# Spawn related

func _signal_enemy_id_ins_below_timepos(timepos : float):
	for ins in _instructions_near_exe:
		if ins.local_timepos <= timepos:
			#call_deferred("emit_signal", "spawn_enemy", ins.enemy_id)
			emit_signal("spawn_enemy", ins.enemy_id, ins.enemy_metadata_map)
			_instructions_near_exe.erase(ins)
	
	
	if _instructions_near_exe.size() == 0 and _instructions_far_from_exe.size() == 0:
		call_deferred("emit_signal", "no_enemies_to_spawn_left")

