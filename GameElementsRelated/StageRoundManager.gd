extends Node

const RoundStatusPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStatusPanel.gd")

const BaseMode_StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd")
const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")
const ModeNormal_StageRounds = preload("res://GameplayRelated/StagesAndRoundsRelated/ModeNormal_StageRounds.gd")

const BaseMode_EnemySpawnIns = preload("res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd")
const ModeNormal_EnemySpawnIns = preload("res://GameplayRelated/EnemiesInRounds/ModeNormal_EnemySpawnIns.gd")

const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")

const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")

enum Mode {
	NORMAL,
}


signal stage_round_changed(stage_num, round_num)
signal round_started(current_stageround)
signal round_ended(current_stageround)

signal life_lost_from_enemy_first_time_in_round(enemy)
signal life_lost_from_enemy(enemy)

signal end_of_round_gold_earned(gold)


var round_status_panel : RoundStatusPanel setget _set_round_status_panel
var stagerounds : BaseMode_StageRound
var current_stageround_index : int = -1
var current_stageround : StageRound
var spawn_ins_of_mode : BaseMode_EnemySpawnIns

var round_started : bool
var round_fast_forwarded : bool

var enemy_manager : EnemyManager setget _set_enemy_manager

# 

var lost_life_in_round : bool 


func set_game_mode_to_normal():
	set_game_mode(Mode.NORMAL)

func set_game_mode(mode : int):
	if mode == Mode.NORMAL:
		stagerounds = ModeNormal_StageRounds.new()
		spawn_ins_of_mode = ModeNormal_EnemySpawnIns.new()

#

func _set_round_status_panel(panel : RoundStatusPanel):
	round_status_panel = panel
	
	round_status_panel.connect("round_start_pressed", self, "start_round")


func _set_enemy_manager(manager : EnemyManager):
	enemy_manager = manager
	
	enemy_manager.connect("no_enemies_left", self, "end_round")
	enemy_manager.connect("enemy_escaped", self, "_life_lost_from_enemy")


# Round start related

func start_round():
	round_started = true
	
	_before_round_start()
	_at_round_start()
	_after_round_start()
	
	emit_signal("round_started", current_stageround)


func _before_round_start():
	lost_life_in_round = false

func _at_round_start():
	pass

func _after_round_start():
	var spawn_ins_in_stageround = spawn_ins_of_mode.get_instructions_for_stageround(current_stageround.id)
	enemy_manager.set_instructions_of_interpreter(spawn_ins_in_stageround)
	enemy_manager.enemy_first_damage = current_stageround.enemy_first_damage
	
	enemy_manager.start_run()


# Round end related

func end_round():
	round_started = false
	
	_before_round_end()
	_at_round_end()
	_after_round_end()
	
	emit_signal("round_ended", current_stageround)


func _before_round_end():
	current_stageround_index += 1
	current_stageround = stagerounds.stage_rounds[current_stageround_index]
	
	call_deferred("emit_signal", "end_of_round_gold_earned", current_stageround.end_of_round_gold, GoldManager.IncreaseGoldSource.END_OF_ROUND)


func _at_round_end():
	pass

func _after_round_end():
	enemy_manager.end_run()


# If lives lost

func _life_lost_from_enemy(enemy):
	emit_signal("life_lost_from_enemy", enemy)
	
	if !lost_life_in_round:
		emit_signal("life_lost_from_enemy_first_time_in_round", enemy)
	
	lost_life_in_round = true
