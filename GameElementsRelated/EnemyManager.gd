extends Node

#const BaseFactionPassive = preload("res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd")

const SpawnInstructionInterpreter = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionInterpreter.gd")
const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")
const HealthManager = preload("res://GameElementsRelated/HealthManager.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")

const ENEMY_GROUP_TAG : String = "Enemies"
const ENEMY_BLOCKING_NEXT_ROUND_ADVANCE_TAG : String = "EnemiesBlockingNextRoundAdvanceTag"


signal no_enemies_left

signal before_enemy_stats_are_set(enemy)
signal before_enemy_spawned(enemy)
signal before_enemy_is_added_to_path(enemy, path)
signal enemy_spawned(enemy)

signal enemy_escaped(enemy)
signal first_enemy_escaped(enemy, first_damage)

signal round_time_passed(delta, current_timepos)

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
var spawn_paths : Array = [] setget set_spawn_paths
var _spawn_path_index_to_take = 0
var current_path_to_spawn_pattern : int = PathToSpawnPattern.NO_CHANGE

var _spawning_paused : bool = false
var _spawn_pause_timer : Timer

var _is_interpreter_done_spawning : bool

var _is_running : bool


#

var enemy_damage_multiplier : float
var enemy_health_multiplier : float
var _enemy_first_damage_applied : bool
var enemy_first_damage : float

#

var enemy_count_in_round : int
var current_enemy_spawned_from_ins_count : int

var highest_enemy_spawn_timepos_in_round : float
var current_spawn_timepos_in_round : float


#

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end", [], CONNECT_PERSIST)

func set_map_manager(arg_manager):
	map_manager = arg_manager
	
	if map_manager.base_map != null:
		#map_manager.base_map.connect("on_all_enemy_paths_changed", self, "_on_base_map_paths_changed", [], CONNECT_PERSIST)
		map_manager.base_map.connect("on_enemy_path_added", self, "_on_base_map_path_added", [], CONNECT_PERSIST)
		map_manager.base_map.connect("on_enemy_path_removed", self, "_on_base_map_path_removed", [], CONNECT_PERSIST)

#

func _ready():
	set_interpreter(SpawnInstructionInterpreter.new())
	
	_spawn_pause_timer = Timer.new()
	_spawn_pause_timer.one_shot = true
	_spawn_pause_timer.connect("timeout", self, "_pause_timer_timeout", [], CONNECT_PERSIST)
	add_child(_spawn_pause_timer)

# Setting related

func set_interpreter(interpreter : SpawnInstructionInterpreter):
	spawn_instruction_interpreter = interpreter
	spawn_instruction_interpreter.connect("no_enemies_to_spawn_left", self,"_interpreter_done_spawning", [], CONNECT_PERSIST)
	spawn_instruction_interpreter.connect("spawn_enemy", self, "_signal_spawn_enemy_from_interpreter", [], CONNECT_PERSIST)


func _signal_spawn_enemy_from_interpreter(enemy_id : int, ins_enemy_metadata_map):
	spawn_enemy(enemy_id, _get_path_based_on_current_index(), true, ins_enemy_metadata_map)

func set_spawn_paths(paths : Array):
	remove_all_spawn_paths()
	
	for path in paths:
		add_spawn_path(path)

func add_spawn_path(path):
	if !spawn_paths.has(path):
		if !path.is_connected("on_enemy_death", self, "_on_enemy_death"):
			path.connect("on_enemy_death", self, "_on_enemy_death", [], CONNECT_PERSIST)
			path.connect("on_enemy_reached_end", self, "_enemy_reached_end", [], CONNECT_PERSIST)
		
		spawn_paths.append(path)


func remove_all_spawn_paths():
	var to_remove : Array = []
	
	for path in spawn_paths:
		to_remove.append(path)
	
	for path in to_remove:
		remove_spawn_path(path)

func remove_spawn_path(path):
	if spawn_paths.has(path):
		if path.is_connected("on_enemy_death", self, "_on_enemy_death"):
			path.disconnect("on_enemy_death", self, "_on_enemy_death")
			path.disconnect("on_enemy_reached_end", self, "_enemy_reached_end")
		
		spawn_paths.erase(path)


func set_instructions_of_interpreter(inses : Array):
	_is_interpreter_done_spawning = false
	var count = spawn_instruction_interpreter.set_instructions(inses)
	enemy_count_in_round = count
	highest_enemy_spawn_timepos_in_round = spawn_instruction_interpreter.highest_timepos_of_instructions

func append_instructions_to_interpreter(inses : Array):
	_is_interpreter_done_spawning = false
	var count = spawn_instruction_interpreter.set_instructions(inses)
	enemy_count_in_round += count
	highest_enemy_spawn_timepos_in_round = spawn_instruction_interpreter.highest_timepos_of_instructions

# Spawning related

func start_run():
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

func reset_path_index():
	_spawn_path_index_to_take = 0


func kill_all_enemies():
	for enemy in get_all_enemies():
		enemy.queue_free()


#

func _process(delta):
	if _is_running and !_spawning_paused:
		spawn_instruction_interpreter.time_passed(delta)
		
		current_spawn_timepos_in_round = spawn_instruction_interpreter._current_time
		emit_signal("round_time_passed", delta, current_spawn_timepos_in_round)


func spawn_enemy(enemy_id : int, arg_path : EnemyPath = _get_path_based_on_current_index(), is_from_ins_interpreter : bool = false, ins_enemy_metadata_map = null):
	var enemy_instance : AbstractEnemy = EnemyConstants.get_enemy_scene(enemy_id).instance()
	spawn_enemy_instance(enemy_instance, arg_path, is_from_ins_interpreter, ins_enemy_metadata_map)


func spawn_enemy_instance(enemy_instance, arg_path : EnemyPath = _get_path_based_on_current_index(), is_from_ins_interpreter : bool = false, ins_enemy_metadata_map = null):
	enemy_instance.enemy_spawn_metadata_from_ins = ins_enemy_metadata_map
	
	# Enemy set stats
	emit_signal("before_enemy_stats_are_set", enemy_instance)
	
	if enemy_instance.respect_stage_round_health_scale:
		enemy_instance.base_health *= enemy_health_multiplier
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
	
	emit_signal("before_enemy_spawned", enemy_instance)
	
	emit_signal("before_enemy_is_added_to_path", enemy_instance, path)
	if enemy_instance.get_parent() == null:
		path.add_child(enemy_instance)
	
	emit_signal("enemy_spawned", enemy_instance)


func _get_path_based_on_current_index() -> EnemyPath:
	return spawn_paths[_spawn_path_index_to_take]


# Round over detectors

func _interpreter_done_spawning():
	_is_interpreter_done_spawning = true
	
	_check_if_no_enemies_left()

func _on_enemy_death(enemy : AbstractEnemy):
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
	
	health_manager.decrease_health_by(total_damage, HealthManager.DecreaseHealthSource.ENEMY)
	
	emit_signal("enemy_escaped", enemy)
	enemy.queue_free()



# Enemy Queries

func get_all_enemies() -> Array:
	return get_tree().get_nodes_in_group(ENEMY_GROUP_TAG)

func get_all_targetable_enemies() -> Array:
	var enemies = get_all_enemies()
	
	Targeting.filter_untargetable_enemies(enemies, false)
	
	return enemies

func get_all_targetable_and_invisible_enemies() -> Array:
	var enemies = get_all_enemies()
	
	Targeting.filter_untargetable_enemies(enemies, true)
	
	return enemies


func get_path_of_enemy(arg_enemy) -> EnemyPath:
	for path in spawn_paths:
		if path.get_children().has(arg_enemy):
			return path
	
	return null


# Faction passive related

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

func _switch_path_index_to_next():
	_spawn_path_index_to_take += 1
	if _spawn_path_index_to_take >= spawn_paths.size():
		_spawn_path_index_to_take = 0


func _on_round_end(stage_round, is_game_start):
	if !is_game_start:
		if current_path_to_spawn_pattern == PathToSpawnPattern.SWITCH_PER_ROUND_END:
			_switch_path_index_to_next()


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
	return _spawn_path_index_to_take

