extends Node

#const BaseFactionPassive = preload("res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd")

const SpawnInstructionInterpreter = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionInterpreter.gd")
const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")
const HealthManager = preload("res://GameElementsRelated/HealthManager.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")

const ENEMY_GROUP_TAG : String = "Enemies"


signal no_enemies_left
signal before_enemy_spawned(enemy)
signal enemy_spawned(enemy)

signal enemy_escaped(enemy)
signal first_enemy_escaped(enemy, first_damage)

var health_manager : HealthManager
var game_elements

var spawn_instruction_interpreter : SpawnInstructionInterpreter setget set_interpreter
var spawn_paths : Array setget set_spawn_paths
var _spawn_path_index_to_take = 0


var _is_interpreter_done_spawning : bool

var _is_running : bool

#

var enemy_damage_multiplier : float
var enemy_health_multiplier : float
var _enemy_first_damage_applied : bool
var enemy_first_damage : float

var enemy_count_in_round : int

#

func _ready():
	set_interpreter(SpawnInstructionInterpreter.new())


# Setting related

func set_interpreter(interpreter : SpawnInstructionInterpreter):
	spawn_instruction_interpreter = interpreter
	spawn_instruction_interpreter.connect("no_enemies_to_spawn_left", self,"_interpreter_done_spawning")
	spawn_instruction_interpreter.connect("spawn_enemy", self, "spawn_enemy")


func set_spawn_paths(paths : Array):
	spawn_paths = []
	
	for path in paths:
		path.connect("on_enemy_death", self, "_on_enemy_death")
		path.connect("on_enemy_reached_end", self, "_enemy_reached_end")
		spawn_paths.append(path)


func set_instructions_of_interpreter(inses : Array):
	_is_interpreter_done_spawning = false
	var count = spawn_instruction_interpreter.set_instructions(inses)
	enemy_count_in_round = count

func append_instructions_to_interpreter(inses : Array):
	_is_interpreter_done_spawning = false
	var count = spawn_instruction_interpreter.set_instructions(inses)
	enemy_count_in_round += count


# Spawning related

func start_run():
	_is_running = true


func end_run():
	spawn_instruction_interpreter.reset_time()
	reset_path_index()
	_is_running = false
	_enemy_first_damage_applied = false

func reset_path_index():
	_spawn_path_index_to_take = 0


func _process(delta):
	if _is_running:
		spawn_instruction_interpreter.time_passed(delta)



func spawn_enemy(enemy_id):
	var enemy_instance : AbstractEnemy = EnemyConstants.get_enemy_scene(enemy_id).instance()
	
	# Enemy set properties
	enemy_instance.base_health *= enemy_health_multiplier
	enemy_instance.base_player_damage *= enemy_damage_multiplier
	enemy_instance.z_index = ZIndexStore.ENEMIES
	
	
	# Enemy add to group
	enemy_instance.add_to_group(ENEMY_GROUP_TAG)
	
	# Path related
	var path = _pick_path_and_switch_index_to_next()
	emit_signal("before_enemy_spawned", enemy_instance)
	path.add_child(enemy_instance)
	
	call_deferred("emit_signal", "enemy_spawned", enemy_instance)


func _pick_path_and_switch_index_to_next() -> EnemyPath:
	var path = spawn_paths[_spawn_path_index_to_take]
	
	_spawn_path_index_to_take += 1
	if _spawn_path_index_to_take >= spawn_paths.size():
		_spawn_path_index_to_take = 0
	
	return path


# Round over detectors

func _interpreter_done_spawning():
	_is_interpreter_done_spawning = true
	
	_check_if_no_enemies_left()

func _on_enemy_death(enemy : AbstractEnemy):
	if _is_interpreter_done_spawning:
		_check_if_no_enemies_left()

func _check_if_no_enemies_left():
	if !get_tree().has_group(ENEMY_GROUP_TAG):
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


# Queries

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



# Faction passive related

func apply_faction_passive(passive):
	if passive != null:
		passive._apply_faction_to_game_elements(game_elements)

func remove_faction_passive(passive):
	if passive != null:
		passive._remove_faction_from_game_elements(game_elements)
