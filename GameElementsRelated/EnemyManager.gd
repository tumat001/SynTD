extends Node

const SpawnInstructionInterpreter = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionInterpreter.gd")
const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")
const HealthManager = preload("res://GameElementsRelated/HealthManager.gd")

const ENEMY_GROUP_TAG : String = "Enemies"


signal no_enemies_left
signal enemy_spawned(enemy)
signal enemy_escaped(enemy)

var health_manager : HealthManager

var spawn_instruction_interpreter : SpawnInstructionInterpreter setget set_interpreter
var spawn_paths : Array setget set_spawn_paths
var _spawn_path_index_to_take = 0


var _is_interpreter_done_spawning : bool

var _is_running : bool

#

var enemy_damage_multiplier : float
var _enemy_first_damage_applied : bool
var enemy_first_damage : float


func _ready():
	set_interpreter(SpawnInstructionInterpreter.new())

# Setting related

func set_interpreter(interpreter : SpawnInstructionInterpreter):
	spawn_instruction_interpreter = interpreter
	spawn_instruction_interpreter.connect("no_enemies_to_spawn_left", self,"_interpreter_done_spawning")
	spawn_instruction_interpreter.connect("spawn_enemy", self, "_spawn_enemy")


func set_spawn_paths(paths : Array):
	spawn_paths = []
	
	for path in paths:
		path.connect("on_enemy_death", self, "_on_enemy_death")
		path.connect("on_enemy_reached_end", self, "_enemy_reached_end")
		spawn_paths.append(path)


func set_instructions_of_interpreter(inses : Array):
	_is_interpreter_done_spawning = false
	spawn_instruction_interpreter.set_instructions(inses)

func append_instructions_to_interpreter(inses : Array):
	_is_interpreter_done_spawning = false
	spawn_instruction_interpreter.set_instructions(inses)


# Spawning related


func start_run():
	_is_running = true


func end_run():
	spawn_instruction_interpreter.reset_time()
	reset_path_index()
	_is_running = false
	_enemy_first_damage_applied = false


func _process(delta):
	if _is_running:
		spawn_instruction_interpreter.time_passed(delta)



func reset_path_index():
	_spawn_path_index_to_take = 0


func _spawn_enemy(enemy_id):
	var enemy_instance : AbstractEnemy = EnemyConstants.get_enemy_scene(enemy_id).instance()
	
	# Enemy set properties
	enemy_instance.base_player_damage *= enemy_damage_multiplier
	enemy_instance.z_index = ZIndexStore.ENEMIES
	
	
	# Enemy add to group
	enemy_instance.add_to_group(ENEMY_GROUP_TAG)
	
	# Path related
	var path = _pick_path_and_switch_index_to_next()
	path.add_child(enemy_instance)
	
	call_deferred("emit_signal", "enemy_spawned", self)


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
	
	health_manager.decrease_health_by(total_damage, HealthManager.DecreaseHealthSource.ENEMY)
	
	emit_signal("enemy_escaped", self)
	enemy.queue_free()
