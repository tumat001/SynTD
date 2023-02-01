extends Node

#const BaseFactionPassive = preload("res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd")

const SpawnInstructionInterpreter = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionInterpreter.gd")
const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")
const HealthManager = preload("res://GameElementsRelated/HealthManager.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const ConditionalClauses= preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const EnemySVGenerator = preload("res://EnemyRelated/EnemyStrengthValuesRelated/EnemySVGenerator.gd")
const EnemyPathsArray = preload("res://MiscRelated/DataCollectionRelated/EnemyPathsArray.gd")

const ENEMY_GROUP_TAG : String = "Enemies"
const ENEMY_BLOCKING_NEXT_ROUND_ADVANCE_TAG : String = "EnemiesBlockingNextRoundAdvanceTag"


signal no_enemies_left()

signal before_enemy_stats_are_set(enemy)
signal before_enemy_spawned(enemy)
signal before_enemy_is_added_to_path(enemy, path)
signal enemy_spawned(enemy)
signal on_enemy_spawned_and_finished_ready_prep(enemy)

signal enemy_escaped(enemy)
signal first_enemy_escaped(enemy, first_damage)
signal enemy_escaped_dealing_x_damage(enemy, damage)
signal enemy_killed_by_damage_and_no_more_revives(dmg_instance_report, enemy)

signal round_time_passed(delta, current_timepos)

signal number_of_enemies_remaining_changed(arg_val)
signal last_enemy_standing(arg_enemy)
signal last_enemy_standing_killed_by_damage(damage_instance_report, enemy)
signal last_enemy_standing_killed_by_damage_no_revives(damage_instance_report, enemy)
signal last_enemy_standing_current_health_changed(arg_health_val, arg_enemy) # called when last standing, and when health has changed
signal on_enemy_queue_freed(arg_enemy)

#
signal enemy_strength_value_changed(arg_val)

signal sv_flat_value_modi_map__average_moving_changed(arg_val)
signal sv_flat_value_modi_map__non_average_moving_changed(arg_val)


signal path_to_spawn_pattern_changed(arg_new_val)

signal enemy_effect_apply_on_spawn_cleared()

# special query requests
# DO NOT CONNECT TO THESE manually. Use special methods
signal requested__get_next_targetable_enemy(arg_enemy)
signal requested__get_next_targetable_enemy__cancelled()

# end of special query requests


enum PathToSpawnPattern {
	NO_CHANGE = 0,
	SWITCH_PER_SPAWN = 1,
	SWITCH_PER_ROUND_END = 2,
}



var health_manager : HealthManager
var stage_round_manager setget set_stage_round_manager
var map_manager setget set_map_manager
var game_elements

var spawn_instruction_interpreter : SpawnInstructionInterpreter setget set_interpreter
var _enemy_paths_array : EnemyPathsArray
#var spawn_paths : Array = [] setget set_spawn_paths
#var _active_spawn_path_to_path_index_map : Dictionary = {}
#var _spawn_path_index_to_take : int = 0
#var _active_spawn_path_index_to_take : int = 0
var current_path_to_spawn_pattern : int = PathToSpawnPattern.NO_CHANGE setget set_current_path_to_spawn_pattern

var custom_path_pattern_assignment_method : String
var custom_path_pattern_source_obj : Object


var _spawning_paused : bool = false
var _spawn_pause_timer : Timer

var _is_interpreter_done_spawning : bool

var _is_running : bool


# effects

var _effects_to_apply_on_spawn__regular : Dictionary   # clears itself on round end
var _effects_to_apply_on_spawn__time_reduced_by_process : Dictionary

#

var enemy_damage_multiplier : float
var enemy_first_damage : float

var _enemy_first_damage_applied : bool


enum EnemyHealthMultipliersSourceIds {
	GAME_MODI_DIFFICULTY_GENERIC_TAG = 1,
}

var base_enemy_health_multiplier__from_stagerounds : float
var _enemy_health_multiplier_id_to_percent_amount : Dictionary
var last_calculated_enemy_health_multiplier : float

#

var enemy_count_in_round : int # from instruction
var current_enemy_spawned_from_ins_count : int
var _last_standing_enemy

var highest_enemy_spawn_timepos_in_round : float
var current_spawn_timepos_in_round : float

#

var _enemy_sv_generator : EnemySVGenerator
var _stageround_id_to_sv_history_map : Dictionary = {}
var _current_sv_total : float
var _current_sv_average : float
var _base_strength_value_before_modis : float
var _current_strength_value : int #setget set_current_strength_value

enum GenerateEnemySVClauseIds {
	FACTION_PASSIVE__CULTIST = 1
}
var generate_enemy_sv_on_round_end_clauses : ConditionalClauses
var last_calculate_generate_enemy_sv_on_round_end : bool

#

enum SVModiferIds {
	DOM_SYN_RED__ORANGE_IDENTITY = 1
	DOM_SYN_RED__BLUE_IDENTITY = 2
	DOM_SYN_RED__VIOLET_IDENTITY = 3
}

var _sv_id_to_flat_value_modi_map__average_moving : Dictionary = {}
var last_calculated_sv_flat_value_modi_map__average_moving : int

var _sv_id_to_flat_value_modi_map__non_average_moving : Dictionary = {}
var last_calculated_sv_flat_value_modi_map__non_average_moving : int

var _applied_sv_on_round_on_no_calc_gen_enemy_sv : bool  # used in conjunction with last_calculate_generate_enemy_sv_on_round_end
var _applied_sv_modi_during_round : bool

# sv val limiters/boundaries for final result, not for sv genertor internal vals
const highest_final_sv : int = 5
const lowest_final_sv : int = 1

# special query request

var _requested__get_next_targetable_enemy : bool = false
var _all_enemies_in_request__get_next_targetable_enemy : Array

#


func add_enemy_health_multiplier_percent_amount(arg_id : int, arg_amount : float):
	_enemy_health_multiplier_id_to_percent_amount[arg_id] = arg_amount
	_calculate_final_enemy_health_multiplier()

func remove_enemy_health_multiplier_percent_amount(arg_id : int):
	_enemy_health_multiplier_id_to_percent_amount.erase(arg_id)
	_calculate_final_enemy_health_multiplier()

func _calculate_final_enemy_health_multiplier():
	var amount = base_enemy_health_multiplier__from_stagerounds
	for perc_amount in _enemy_health_multiplier_id_to_percent_amount.values():
		amount *= perc_amount
	
	last_calculated_enemy_health_multiplier = amount



#

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end", [], CONNECT_PERSIST)
	
	
	###
	_enemy_sv_generator = EnemySVGenerator.new()
	_current_sv_average = _enemy_sv_generator.middle_sv_value
	_current_sv_total = 0
	
	
	# TEST
#	print("-----------------------")
#	var val_count : Dictionary = {1 : 0, 2 : 0, 3 : 0, 4 : 0}
#	for i in 36:
#		var val = _generate_sv_and_move_average(i, 36)[0]
#		val_count[val] += 1
#		print("val: %s, curr_ave: %s, curr_total: %s" % [str(val), str(_current_sv_average), str(_current_sv_total)])
#		print("")
#	print(val_count)

func set_map_manager(arg_manager):
	map_manager = arg_manager
	
	if is_instance_valid(map_manager.base_map):
		#map_manager.base_map.connect("on_all_enemy_paths_changed", self, "_on_base_map_paths_changed", [], CONNECT_PERSIST)
		map_manager.base_map.connect("on_enemy_path_added", self, "_on_base_map_path_added", [], CONNECT_PERSIST)
		map_manager.base_map.connect("on_enemy_path_removed", self, "_on_base_map_path_removed", [], CONNECT_PERSIST)
		
		

#

func _ready():
	_enemy_paths_array = EnemyPathsArray.new()
	
	set_interpreter(SpawnInstructionInterpreter.new())
	
	_spawn_pause_timer = Timer.new()
	_spawn_pause_timer.one_shot = true
	_spawn_pause_timer.connect("timeout", self, "_pause_timer_timeout", [], CONNECT_PERSIST)
	add_child(_spawn_pause_timer)
	
	#
	
	connect("enemy_spawned", self, "_on_enemy_spawned", [], CONNECT_PERSIST)
	connect("on_enemy_queue_freed", self, "_on_enemy_queue_freed", [], CONNECT_PERSIST)
	
	#
	
	generate_enemy_sv_on_round_end_clauses = ConditionalClauses.new()
	generate_enemy_sv_on_round_end_clauses.connect("clause_inserted", self, "_generate_enemy_sv_on_round_end_clause_ins_or_rem", [], CONNECT_PERSIST)
	generate_enemy_sv_on_round_end_clauses.connect("clause_removed", self, "_generate_enemy_sv_on_round_end_clause_ins_or_rem", [], CONNECT_PERSIST)
	_update_last_calculate_generate_enemy_sv_on_round_end()

# Setting related

func set_interpreter(interpreter : SpawnInstructionInterpreter):
	spawn_instruction_interpreter = interpreter
	spawn_instruction_interpreter.connect("no_enemies_to_spawn_left", self,"_interpreter_done_spawning", [], CONNECT_PERSIST)
	spawn_instruction_interpreter.connect("spawn_enemy", self, "_signal_spawn_enemy_from_interpreter", [], CONNECT_PERSIST)


func _signal_spawn_enemy_from_interpreter(enemy_id : int, ins_enemy_metadata_map):
	var spawned_from_ins : bool = true
	if ins_enemy_metadata_map != null and ins_enemy_metadata_map.has(StoreOfEnemyMetadataIdsFromIns.NOT_SPAWNED_FROM_INS):
		spawned_from_ins = false
	
	spawn_enemy(enemy_id, _get_path_based_on_current_index(), spawned_from_ins, ins_enemy_metadata_map)

func set_spawn_paths(paths : Array):
	_enemy_paths_array.remove_all_enemy_spawn_paths()
	
	for path in paths:
		add_spawn_path(path)
		#_enemy_paths_array.add_enemy_spawn_path(path)
#	remove_all_spawn_paths()
#
#	for path in paths:
#		add_spawn_path(path)

func add_spawn_path(path):
	if !_enemy_paths_array.has_enemy_spawn_path(path):
		_enemy_paths_array.add_enemy_spawn_path(path)
		
		if !path.is_connected("on_enemy_death", self, "_on_enemy_death"):
			path.connect("on_enemy_death", self, "_on_enemy_death", [], CONNECT_PERSIST)
			path.connect("on_enemy_reached_end", self, "_enemy_reached_end", [], CONNECT_PERSIST)

#	if !spawn_paths.has(path):
#		if !path.is_connected("on_enemy_death", self, "_on_enemy_death"):
#			path.connect("on_enemy_death", self, "_on_enemy_death", [], CONNECT_PERSIST)
#			path.connect("on_enemy_reached_end", self, "_enemy_reached_end", [], CONNECT_PERSIST)
#			#path.connect("is_used_and_active_changed", self, "_on_path_is_used_and_active_changed", [path], CONNECT_PERSIST)
#
#
#		spawn_paths.append(path)
#
#		if path.is_used_and_active:
#			_active_spawn_path_to_path_index_map[path] = spawn_paths.size() - 1


func remove_all_spawn_paths():
	var to_remove : Array = []
	
	for path in _enemy_paths_array.get_spawn_paths__not_copy():
		to_remove.append(path)
	
	for path in to_remove:
		remove_spawn_path(path)

func remove_spawn_path(path):
	var removed = _enemy_paths_array.remove_enemy_spawn_path(path)
	
	if removed:
		if path.is_connected("on_enemy_death", self, "_on_enemy_death"):
			path.disconnect("on_enemy_death", self, "_on_enemy_death")
			path.disconnect("on_enemy_reached_end", self, "_enemy_reached_end")

#			path.disconnect("is_used_and_active_changed", self, "_on_path_is_used_and_active_changed")
#
#		spawn_paths.erase(path)
#		_active_spawn_path_to_path_index_map.erase(path)


func set_instructions_of_interpreter(inses : Array):
	_is_interpreter_done_spawning = false
	var count = spawn_instruction_interpreter.set_instructions(inses)
	enemy_count_in_round = count
	highest_enemy_spawn_timepos_in_round = spawn_instruction_interpreter.highest_timepos_of_instructions

func append_instructions_to_interpreter(inses : Array):
	_is_interpreter_done_spawning = false
	#var count = spawn_instruction_interpreter.set_instructions(inses)
	var count = spawn_instruction_interpreter.append_instructions(inses)
	enemy_count_in_round += count
	highest_enemy_spawn_timepos_in_round = spawn_instruction_interpreter.highest_timepos_of_instructions

# Spawning related

func start_run():
	_calculate_final_enemy_health_multiplier()
	_is_running = true


func end_run():
	spawn_instruction_interpreter.reset_time()
	reset_path_index()
	
	kill_all_enemies()
	
	_is_running = false
	_enemy_first_damage_applied = false
	
	current_enemy_spawned_from_ins_count = 0
	current_spawn_timepos_in_round = 0
	highest_enemy_spawn_timepos_in_round = 0
	
	emit_signal("requested__get_next_targetable_enemy__cancelled")

func reset_path_index():
	_enemy_paths_array.reset_path_indices()
	#_spawn_path_index_to_take = 0
	#_active_spawn_path_index_to_take = 0


func kill_all_enemies():
	for enemy in get_all_enemies():
		enemy.queue_free()


#

func _process(delta):
	if _is_running and !_spawning_paused:
		spawn_instruction_interpreter.time_passed(delta)
		
		current_spawn_timepos_in_round = spawn_instruction_interpreter._current_time
		
		_process__for_effect_apply(delta)
		
		#
		emit_signal("round_time_passed", delta, current_spawn_timepos_in_round)


func spawn_enemy(enemy_id : int, arg_path : EnemyPath = _get_path_based_on_current_index(), is_from_ins_interpreter : bool = false, ins_enemy_metadata_map = null) -> AbstractEnemy:
	var enemy_instance : AbstractEnemy = EnemyConstants.get_enemy_scene(enemy_id).instance()
	spawn_enemy_instance(enemy_instance, arg_path, is_from_ins_interpreter, ins_enemy_metadata_map)
	return enemy_instance

func spawn_enemy_instance(enemy_instance, arg_path : EnemyPath = _get_path_based_on_current_index(), is_from_ins_interpreter : bool = false, ins_enemy_metadata_map = null):
	enemy_instance.enemy_spawn_metadata_from_ins = ins_enemy_metadata_map
	
	# Enemy set stats
	emit_signal("before_enemy_stats_are_set", enemy_instance)
	
	if enemy_instance.respect_stage_round_health_scale:
		enemy_instance.base_health *= last_calculated_enemy_health_multiplier
	enemy_instance.base_player_damage *= enemy_damage_multiplier
	enemy_instance.z_index = ZIndexStore.ENEMIES
	
	
	# Enemy add to group
	enemy_instance.add_to_group(ENEMY_GROUP_TAG)
	if enemy_instance.blocks_from_round_ending:
		enemy_instance.add_to_group(ENEMY_BLOCKING_NEXT_ROUND_ADVANCE_TAG)
	
	enemy_instance.game_elements = game_elements
	enemy_instance.enemy_manager = self
	
	# Path related
	var path : EnemyPath = arg_path
	if is_from_ins_interpreter:
		if current_path_to_spawn_pattern == PathToSpawnPattern.SWITCH_PER_SPAWN:
			_switch_path_index_to_next() #to alternate between lanes per spawn
		current_enemy_spawned_from_ins_count += 1
	
	
	enemy_instance.connect("on_finished_ready_prep", self, "_on_enemy_finished_ready_prep", [enemy_instance], CONNECT_ONESHOT)
	enemy_instance.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_by_damage_with_no_more_revives")
	
	emit_signal("before_enemy_spawned", enemy_instance)
	emit_signal("before_enemy_is_added_to_path", enemy_instance, path)
	if !is_instance_valid(enemy_instance.get_parent()):
		path.add_child(enemy_instance)
	
	emit_signal("enemy_spawned", enemy_instance)


func _on_enemy_finished_ready_prep(arg_enemy):
	emit_signal("on_enemy_spawned_and_finished_ready_prep", arg_enemy)

func _on_enemy_killed_by_damage_with_no_more_revives(arg_dmg_instance_report, enemy):
	emit_signal("enemy_killed_by_damage_and_no_more_revives", arg_dmg_instance_report, enemy)


#

func _get_path_based_on_current_index() -> EnemyPath:
	if custom_path_pattern_source_obj != null:
		var path = custom_path_pattern_source_obj.call("custom_path_pattern_assignment_method", [])
		return path
		
	else:
		return _enemy_paths_array.get_path_based_on_current_index()
#		return spawn_paths[_spawn_path_index_to_take]

# Round over detectors

func _interpreter_done_spawning():
	_is_interpreter_done_spawning = true
	
	_check_if_no_enemies_left()

func _on_enemy_death(enemy : AbstractEnemy):
	emit_signal("on_enemy_queue_freed", enemy)
	
	if _is_interpreter_done_spawning and enemy.blocks_from_round_ending:
		_check_if_no_enemies_left()

func _check_if_no_enemies_left():
	if !get_tree().has_group(ENEMY_BLOCKING_NEXT_ROUND_ADVANCE_TAG):
		end_run()
		emit_signal("no_enemies_left")


# Enemy leaving / health related

func _enemy_reached_end(enemy : AbstractEnemy):
	var total_damage = enemy.calculate_final_player_damage()
	
	if !_enemy_first_damage_applied:
		_enemy_first_damage_applied = true
		total_damage += enemy_first_damage
		
		emit_signal("first_enemy_escaped", enemy, enemy_first_damage)
	
	#health_manager.decrease_health_by(total_damage, HealthManager.DecreaseHealthSource.ENEMY, enemy.current_path.path_end_global_pos)
	health_manager.decrease_health_by__using_player_dmg_particle(total_damage, HealthManager.DecreaseHealthSource.ENEMY, enemy.current_path.path_end_global_pos)
	
	emit_signal("enemy_escaped", enemy)
	emit_signal("enemy_escaped_dealing_x_damage", enemy, total_damage)
	enemy.queue_free()



# Enemy Queries

func get_all_enemies() -> Array:
	var enemies = get_tree().get_nodes_in_group(ENEMY_GROUP_TAG)
	var bucket = []
	
	for enemy in enemies:
		if is_instance_valid(enemy) and !enemy.is_queued_for_deletion():
			bucket.append(enemy)
	
	return bucket

func get_all_targetable_enemies(arg_include_invis : bool = false) -> Array:
	var enemies = get_all_enemies()
	
	Targeting.filter_untargetable_enemies(enemies, arg_include_invis)
	
	return enemies

func get_all_targetable_and_invisible_enemies() -> Array:
	var enemies = get_all_enemies()
	
	Targeting.filter_untargetable_enemies(enemies, true)
	
	return enemies


func get_random_targetable_enemies(arg_num_of_enemies : int, arg_pos_of_reference : Vector2 = Vector2(0, 0), arg_include_invis : bool = false):
	return Targeting.enemies_to_target(get_all_enemies(), Targeting.RANDOM, arg_num_of_enemies, arg_pos_of_reference, arg_include_invis)


func get_path_of_enemy(arg_enemy) -> EnemyPath:
	return _enemy_paths_array.get_path_of_enemy(arg_enemy)
#	for path in spawn_paths:
#		if path.get_children().has(arg_enemy):
#			return path
#
#	return null

#

func get_all_targetable_enemy_positions(arg_include_invis : bool = false):
	var bucket := []
	for enemy in get_all_targetable_enemies(arg_include_invis):
		bucket.append(enemy.global_position)
	
	return bucket

func get_all_targetable_enemy_positions_excluding(arg_blacklist : Array, arg_include_invis : bool = false):
	var bucket := []
	for enemy in get_all_targetable_enemies(arg_include_invis):
		if !arg_blacklist.has(enemy):
			bucket.append(enemy.global_position)
	
	return bucket

# result removes the arg_enemy from the initial params
func get_enemy_count_within_distance_of_enemy(arg_enemy, arg_radius, arg_include_invis : bool = true):
	return get_enemies_within_distance_of_enemy(arg_enemy, arg_radius, arg_include_invis).size()

func get_enemies_within_distance_of_enemy(arg_enemy, arg_radius, arg_include_invis : bool = true):
	var enemies = get_all_targetable_enemies(arg_include_invis)
	
	return Targeting.get_targets__based_on_range_from_center_as_circle(enemies, Targeting.CLOSE, enemies.size(), arg_enemy.global_position, arg_radius, Targeting.TargetingRangeState.IN_RANGE, arg_include_invis)


# enemy count related

func get_percent_of_enemies_spawned_to_total_from_ins():
	if enemy_count_in_round != 0:
		return float(current_enemy_spawned_from_ins_count) / enemy_count_in_round
	else:
		return 0.0


# special enemy queries

func request__get_next_targetable_enemy(arg_obj_source : Object, arg_obj_method_for_signal : String, arg_obj_method_for_signal_cancel : String):
	if !is_connected("requested__get_next_targetable_enemy", arg_obj_source, arg_obj_method_for_signal):
		connect("requested__get_next_targetable_enemy", arg_obj_source, arg_obj_method_for_signal)
	
	if !is_connected("requested__get_next_targetable_enemy__cancelled", arg_obj_source, arg_obj_method_for_signal_cancel):
		connect("requested__get_next_targetable_enemy__cancelled", arg_obj_source, arg_obj_method_for_signal_cancel)
	
	_monitor_all_valid_enemies_for_targetability_change()

func disconnect_request_get_next_targetable_enemy(arg_obj_source : Object, arg_obj_method_for_signal : String, arg_obj_method_for_signal_cancel : String):
	if is_connected("requested__get_next_targetable_enemy", arg_obj_source, arg_obj_method_for_signal):
		disconnect("requested__get_next_targetable_enemy", arg_obj_source, arg_obj_method_for_signal)
	
	if is_connected("requested__get_next_targetable_enemy__cancelled", arg_obj_source, arg_obj_method_for_signal_cancel):
		disconnect("requested__get_next_targetable_enemy__cancelled", arg_obj_source, arg_obj_method_for_signal_cancel)



func _monitor_all_valid_enemies_for_targetability_change():
	if !_requested__get_next_targetable_enemy:
		_requested__get_next_targetable_enemy = true
		
		for enemy in get_all_enemies():
			_connect_enemy_for_targetability_change__for_request(enemy)
			_all_enemies_in_request__get_next_targetable_enemy.append(enemy)
		
		connect("on_enemy_spawned_and_finished_ready_prep", self, "_on_enemy_finished_ready_prep__for_request__get_next_targetable_enemy", [], CONNECT_PERSIST)

func _connect_enemy_for_targetability_change__for_request(arg_enemy):
	if !arg_enemy.is_connected("last_calculated_is_untargetable_changed", self, "_on_enemy_untargetability_changed__for_request"):
		arg_enemy.connect("last_calculated_is_untargetable_changed", self, "_on_enemy_untargetability_changed__for_request", [arg_enemy])

func _on_enemy_untargetability_changed__for_request(arg_is_untargetable, arg_enemy):
	if !arg_is_untargetable:
		_requested__get_next_targetable_enemy = false
		disconnect("on_enemy_spawned_and_finished_ready_prep", self, "_on_enemy_finished_ready_prep__for_request__get_next_targetable_enemy")
		
		for enemy in _all_enemies_in_request__get_next_targetable_enemy:
			if is_instance_valid(enemy):
				_disconnect_enemy_for_targetability_change__for_request(enemy)
		_all_enemies_in_request__get_next_targetable_enemy.clear()
		
		#
		emit_signal("requested__get_next_targetable_enemy", arg_enemy)


func _disconnect_enemy_for_targetability_change__for_request(arg_enemy):
	if arg_enemy.is_connected("last_calculated_is_untargetable_changed", self, "_on_enemy_untargetability_changed__for_request"):
		arg_enemy.disconnect("last_calculated_is_untargetable_changed", self, "_on_enemy_untargetability_changed__for_request")


func _on_enemy_finished_ready_prep__for_request__get_next_targetable_enemy(arg_enemy):
	if !arg_enemy.last_calculated_is_untargetable:
		_on_enemy_untargetability_changed__for_request(arg_enemy.last_calculated_is_untargetable, arg_enemy)
	else:
		_connect_enemy_for_targetability_change__for_request(arg_enemy)
		_all_enemies_in_request__get_next_targetable_enemy.append(arg_enemy)


############# Faction passive related

func apply_faction_passive(passive):
	if passive != null:
		passive._apply_faction_to_game_elements(game_elements)

func remove_faction_passive(passive):
	if passive != null:
		passive._remove_faction_from_game_elements(game_elements)


#

func pause_spawning(arg_duration : float = -1):
	_spawning_paused = true
	
	if arg_duration > 0 and _spawn_pause_timer.time_left < arg_duration:
		_spawn_pause_timer.start(arg_duration)


func unpause_spawning():
	_spawning_paused = false


func _pause_timer_timeout():
	unpause_spawning()


# Spawn path related

func set_current_path_to_spawn_pattern(arg_pattern):
	current_path_to_spawn_pattern = arg_pattern
	
	emit_signal("path_to_spawn_pattern_changed", arg_pattern)

func get_spawn_path_index_to_take() -> int:
	return _enemy_paths_array.get_spawn_path_index_to_take()
	#return _spawn_path_index_to_take


func _switch_path_index_to_next():
	_enemy_paths_array.switch_path_index_to_next()
#	_active_spawn_path_index_to_take += 1
#
#	if _active_spawn_path_index_to_take >= _active_spawn_path_to_path_index_map.values().size() - 1:
#		_active_spawn_path_index_to_take = 0
#
#	_spawn_path_index_to_take = _active_spawn_path_to_path_index_map.values()[_active_spawn_path_index_to_take]
#	#############
#	#print("spawn index to take: %s" % _spawn_path_index_to_take)
#	_spawn_path_index_to_take += 1
#
#	if _spawn_path_index_to_take >= spawn_paths.size():
#		_spawn_path_index_to_take = 0

#func _switch_path_index_to_previous():
#	_active_spawn_path_index_to_take -= 1
#
#	if _active_spawn_path_index_to_take < 0:
#		_active_spawn_path_index_to_take = _active_spawn_path_to_path_index_map.values()[_active_spawn_path_to_path_index_map.size() - 1]
#
#	_spawn_path_index_to_take = _active_spawn_path_to_path_index_map.values()[_active_spawn_path_index_to_take]



func _on_round_end(stage_round, is_game_start):
	if !is_game_start:
		if current_path_to_spawn_pattern == PathToSpawnPattern.SWITCH_PER_ROUND_END:
			_switch_path_index_to_next()
	
	_on_round_end__for_effect_apply()
	
	if _applied_sv_modi_during_round:
		update__current_strength_value()


#func _on_base_map_paths_changed(new_all_paths):
#	set_spawn_paths(new_all_paths)
#
#	if spawn_paths.size() > _spawn_path_index_to_take + 1:
#		_spawn_path_index_to_take = 0

func _on_base_map_path_added(new_path):
	add_spawn_path(new_path)

func _on_base_map_path_removed(removed_path):
	remove_spawn_path(removed_path)


func get_spawn_path_to_take_index() -> int:
	return _enemy_paths_array.get_spawn_path_index_to_take()
#	return _spawn_path_index_to_take


######### path properties change

#func _on_path_is_used_and_active_changed(arg_val, arg_path):
#	if arg_val:
#		if !_active_spawn_path_to_path_index_map.has(arg_path):
#			_active_spawn_path_to_path_index_map[arg_path] = spawn_paths.size() - 1
#
#	else:
#		_active_spawn_path_to_path_index_map.erase(arg_path)


## enemy count

func get_current_enemy_count_in_map():
	return get_all_enemies().size()

# a count of enemies that are not spawned, and those that are still alive
func get_number_of_enemies_remaining():
	var not_spawned_enemies = enemy_count_in_round - current_enemy_spawned_from_ins_count
	var curr_enemy_count = get_current_enemy_count_in_map()
	
	return not_spawned_enemies + curr_enemy_count


func _on_enemy_queue_freed(arg_enemy):
	_emit_number_of_enemies_remaining()

func _on_enemy_spawned(arg_enemy):
	_on_enemy_spawned__for_effect_apply(arg_enemy)
	_emit_number_of_enemies_remaining()

func _emit_number_of_enemies_remaining():
	var num_of_ene_remaining = get_number_of_enemies_remaining()
	emit_signal("number_of_enemies_remaining_changed", num_of_ene_remaining)
	
	if num_of_ene_remaining == 1:
		_emit_last_enemy_standing()

func _emit_last_enemy_standing():
	var enemies = get_all_enemies()
	
	if enemies.size() > 0:
		var last_enemy = enemies[0]
		_last_standing_enemy = last_enemy
		
		if !last_enemy.is_connected("on_killed_by_damage", self, "_on_last_enemy_standing_killed_by_damage"):
			last_enemy.connect("on_killed_by_damage", self, "_on_last_enemy_standing_killed_by_damage")
			last_enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_last_enemy_standing_killed_by_damage_no_revives")
			last_enemy.connect("on_current_health_changed", self, "_on_last_enemy_standing_current_health_changed", [last_enemy])
			
		emit_signal("last_enemy_standing", last_enemy)
		emit_signal("last_enemy_standing_current_health_changed", last_enemy.current_health, last_enemy)

func _on_last_enemy_standing_killed_by_damage(damage_instance_report, enemy):
	emit_signal("last_enemy_standing_killed_by_damage", damage_instance_report, enemy)

func _on_last_enemy_standing_killed_by_damage_no_revives(damage_instance_report, enemy):
	emit_signal("last_enemy_standing_killed_by_damage_no_revives", damage_instance_report, enemy)

func _on_last_enemy_standing_current_health_changed(current_health, arg_enemy):
	emit_signal("last_enemy_standing_current_health_changed", current_health, arg_enemy)



func get_last_standing_enemy():
	if !is_instance_valid(_last_standing_enemy) or _last_standing_enemy.is_queued_for_deletion():
		return null
	
	return _last_standing_enemy 


############# SV VALUES RELATED ############

func randomize_current_strength_val__following_conditions():
	if stage_round_manager.current_stageround != null and stage_round_manager.current_stageround.induce_enemy_strength_value_change:
		if last_calculate_generate_enemy_sv_on_round_end:
			randomize__current_strength_value()
			_applied_sv_on_round_on_no_calc_gen_enemy_sv = false
			
		elif !_applied_sv_on_round_on_no_calc_gen_enemy_sv:
			_applied_sv_on_round_on_no_calc_gen_enemy_sv = true
			
			update__current_strength_value()

func _generate_sv_and_move_average(var curr_count = stage_round_manager.current_stageround_index, var max_count = stage_round_manager.stageround_total_count) -> Array:
	var val = _enemy_sv_generator.generate_strength_value(_current_sv_average, curr_count, max_count)
	var orig_val = val
	
	val = _get_added_sv_val_to_val__limit_to_boundaries(last_calculated_sv_flat_value_modi_map__average_moving, val)
	_add_sv_to_stageround_to_sv_history(val, curr_count)
	val = _get_added_sv_val_to_val__limit_to_boundaries(last_calculated_sv_flat_value_modi_map__non_average_moving, val)
	
	return [val, orig_val]

func _add_sv_to_stageround_to_sv_history(arg_sv_val, arg_stageround_id = stage_round_manager.current_stageround.id):
	_stageround_id_to_sv_history_map[arg_stageround_id] = arg_sv_val
	
	_current_sv_total += arg_sv_val
	_current_sv_average = _current_sv_total / _stageround_id_to_sv_history_map.size()

#

func randomize__current_strength_value():
	var vals = _generate_sv_and_move_average()
	_base_strength_value_before_modis = vals[1]
	set_current_strength_value(vals[0])

func set_current_strength_value(arg_val):
	_current_strength_value = arg_val
	emit_signal("enemy_strength_value_changed", _current_strength_value)

func update__current_strength_value():
	var val = _base_strength_value_before_modis
	val = _get_added_sv_val_to_val__limit_to_boundaries(last_calculated_sv_flat_value_modi_map__average_moving, val)
	val = _get_added_sv_val_to_val__limit_to_boundaries(last_calculated_sv_flat_value_modi_map__non_average_moving, val)
	
	if stage_round_manager.current_stageround.induce_enemy_strength_value_change:
		set_current_strength_value(val)

func get_current_strength_value() -> int:
	return _current_strength_value

#

func _get_added_sv_val_to_val__limit_to_boundaries(arg_val, arg_val_2):
	var total = arg_val + arg_val_2
	if total > highest_final_sv:
		total = highest_final_sv
	
	if total < lowest_final_sv:
		total = lowest_final_sv
	
	return total

func _generate_enemy_sv_on_round_end_clause_ins_or_rem(arg_clause_id):
	_update_last_calculate_generate_enemy_sv_on_round_end()

func _update_last_calculate_generate_enemy_sv_on_round_end():
	last_calculate_generate_enemy_sv_on_round_end = generate_enemy_sv_on_round_end_clauses.is_passed


## sv val modification related

func add_sv_flat_value_modi_map__average_moving(arg_id, arg_val : int):
	_sv_id_to_flat_value_modi_map__average_moving[arg_id] = arg_val
	_update_sv_flat_value_modi_map__average_moving()
	
	_update_current_sv__considering_round_started()

func remove_sv_flat_value_modi_map__average_moving(arg_id):
	_sv_id_to_flat_value_modi_map__average_moving.erase(arg_id)
	_update_sv_flat_value_modi_map__average_moving()
	
	_update_current_sv__considering_round_started()


func _update_current_sv__considering_round_started():
	if stage_round_manager.round_started:
		_applied_sv_modi_during_round = true
	else:
		update__current_strength_value()

func _update_sv_flat_value_modi_map__average_moving():
	var total = 0
	for val in _sv_id_to_flat_value_modi_map__average_moving.values():
		total += val
	
	last_calculated_sv_flat_value_modi_map__average_moving = total
	emit_signal("sv_flat_value_modi_map__average_moving_changed")

#

func add_sv_flat_value_modi_map__non_average_moving(arg_id, arg_val : int):
	_sv_id_to_flat_value_modi_map__non_average_moving[arg_id] = arg_val
	_update_sv_flat_value_modi_map__non_average_moving()
	
	_update_current_sv__considering_round_started()

func remove_sv_flat_value_modi_map__non_average_moving(arg_id):
	_sv_id_to_flat_value_modi_map__non_average_moving.erase(arg_id)
	_update_sv_flat_value_modi_map__non_average_moving()
	
	_update_current_sv__considering_round_started()


func _update_sv_flat_value_modi_map__non_average_moving():
	var total = 0
	for val in _sv_id_to_flat_value_modi_map__non_average_moving.values():
		total += val
	
	last_calculated_sv_flat_value_modi_map__non_average_moving = total
	emit_signal("sv_flat_value_modi_map__non_average_moving_changed")


################### EFFECTS RELATED

func add_effect_to_apply_on_enemy_spawn__regular(arg_effect):
	_effects_to_apply_on_spawn__regular[arg_effect.effect_uuid] = arg_effect

func add_effect_to_apply_on_enemy_spawn__time_reduced_by_process(arg_effect):
	_effects_to_apply_on_spawn__time_reduced_by_process[arg_effect.effect_uuid] = arg_effect


func _on_enemy_spawned__for_effect_apply(arg_enemy):
	for effect in _effects_to_apply_on_spawn__regular.values():
		arg_enemy._add_effect(effect)
	
	for effect in _effects_to_apply_on_spawn__time_reduced_by_process.values():
		arg_enemy._add_effect(effect)

func _on_round_end__for_effect_apply():
	_effects_to_apply_on_spawn__regular.clear()
	_effects_to_apply_on_spawn__time_reduced_by_process.clear()
	
	emit_signal("enemy_effect_apply_on_spawn_cleared")

func _process__for_effect_apply(delta):
	var to_remove : Array = []
	for effect in _effects_to_apply_on_spawn__time_reduced_by_process.values():
		if effect.is_timebound:
			effect.time_in_seconds -= delta
			
			if effect.time_in_seconds <= 0:
				to_remove.append(effect.effect_uuid)
	
	for effect_uuid in to_remove:
		_effects_to_apply_on_spawn__time_reduced_by_process.erase(effect_uuid)


