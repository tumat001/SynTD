extends Node

const RoundStatusPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStatusPanel.gd")

const BaseMode_StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd")
const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")
const ModeNormal_StageRounds = preload("res://GameplayRelated/StagesAndRoundsRelated/ModeNormal_StageRounds.gd")

const BaseMode_EnemySpawnIns = preload("res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd")

const FactionBasic_EnemySpawnIns = preload("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionBasic_EnemySpawnIns.gd")

const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")

const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")


enum Mode {
	NORMAL,
}


signal stage_round_changed(stage_num, round_num)
signal round_started(current_stageround)
signal round_ended(current_stageround)
signal round_ended_game_start_aware(current_stageround, is_game_start)

signal life_lost_from_enemy_first_time_in_round(enemy)
signal life_lost_from_enemy(enemy)


var round_status_panel : RoundStatusPanel setget _set_round_status_panel
var stagerounds : BaseMode_StageRound
var current_stageround_index : int = -1
var current_stageround : StageRound
var spawn_ins_of_faction_mode : BaseMode_EnemySpawnIns

var round_started : bool
var round_fast_forwarded : bool

var enemy_manager : EnemyManager setget _set_enemy_manager
var gold_manager : GoldManager

# 

var lost_life_in_round : bool

var can_gain_streak : bool
var current_win_streak : int
var current_lose_streak : int


func set_game_mode_to_normal():
	set_game_mode(Mode.NORMAL)

func set_game_mode(mode : int):
	if mode == Mode.NORMAL:
		stagerounds = ModeNormal_StageRounds.new()
		spawn_ins_of_faction_mode = FactionBasic_EnemySpawnIns.new()

#

func _set_round_status_panel(panel : RoundStatusPanel):
	round_status_panel = panel
	
	round_status_panel.connect("round_start_pressed", self, "start_round", [], CONNECT_PERSIST)


func _set_enemy_manager(manager : EnemyManager):
	enemy_manager = manager
	
	enemy_manager.connect("no_enemies_left", self, "end_round", [], CONNECT_DEFERRED | CONNECT_PERSIST)
	enemy_manager.connect("enemy_escaped", self, "_life_lost_from_enemy", [], CONNECT_PERSIST)


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
	enemy_manager.start_run()


# Round end related

func end_round(from_game_start : bool = false):
	round_started = false
	
	_before_round_end()
	_at_round_end()
	_after_round_end()
	
	# streak related
	if !from_game_start and can_gain_streak:
		if lost_life_in_round:
			current_win_streak = 0
			current_lose_streak += 1
		else:
			current_win_streak += 1
			current_lose_streak = 0
	
	
	# gold income related
	
	gold_manager.set_gold_income(GoldManager.GoldIncomeIds.ROUND_END, current_stageround.end_of_round_gold)
	if current_win_streak >= 1:
		var gold_from_streak = gold_manager.get_gold_amount_from_win_streak(current_win_streak)
		gold_manager.set_gold_income(GoldManager.GoldIncomeIds.WIN_STREAK, gold_from_streak)
		gold_manager.remove_gold_income(GoldManager.GoldIncomeIds.LOSE_STREAK)
		
	elif current_lose_streak >= 1:
		var gold_from_streak = gold_manager.get_gold_amount_from_lose_streak(current_lose_streak)
		gold_manager.set_gold_income(GoldManager.GoldIncomeIds.LOSE_STREAK, gold_from_streak)
		gold_manager.remove_gold_income(GoldManager.GoldIncomeIds.WIN_STREAK)
		
	else:
		gold_manager.remove_gold_income(GoldManager.GoldIncomeIds.LOSE_STREAK)
		gold_manager.remove_gold_income(GoldManager.GoldIncomeIds.WIN_STREAK)
	
	if !from_game_start:
		gold_manager.increase_gold_by(gold_manager.get_total_income_for_the_round(), GoldManager.IncreaseGoldSource.END_OF_ROUND)
	
	
	# spawn inses related
	var spawn_ins_in_stageround
	if !spawn_ins_of_faction_mode.is_transition_time_in_stageround(current_stageround.id):
		spawn_ins_in_stageround = spawn_ins_of_faction_mode.get_instructions_for_stageround(current_stageround.id)
	else:
		_replace_current_spawn_ins_to_second_half(stagerounds.get_second_half_faction())
		spawn_ins_in_stageround = spawn_ins_of_faction_mode.get_instructions_for_stageround(current_stageround.id)
	
	enemy_manager.set_instructions_of_interpreter(spawn_ins_in_stageround)
	enemy_manager.enemy_first_damage = current_stageround.enemy_first_damage
	enemy_manager.enemy_health_multiplier = current_stageround.enemy_health_multiplier
	enemy_manager.enemy_damage_multiplier = current_stageround.enemy_damage_multiplier
	enemy_manager.apply_faction_passive(spawn_ins_of_faction_mode.get_faction_passive())
	
	can_gain_streak = current_stageround.can_gain_streak
	
	emit_signal("round_ended_game_start_aware", current_stageround, from_game_start)
	emit_signal("round_ended", current_stageround)


func _before_round_end():
	current_stageround_index += 1
	current_stageround = stagerounds.stage_rounds[current_stageround_index]


func _at_round_end():
	pass

func _after_round_end():
	enemy_manager.end_run()
	
	#call_deferred("emit_signal", "end_of_round_gold_earned", current_stageround.end_of_round_gold, GoldManager.IncreaseGoldSource.END_OF_ROUND)



# If lives lost

func _life_lost_from_enemy(enemy):
	emit_signal("life_lost_from_enemy", enemy)
	
	if !lost_life_in_round:
		emit_signal("life_lost_from_enemy_first_time_in_round", enemy)
	
	lost_life_in_round = true


# Enemy faction spawn ins related

func _replace_current_spawn_ins_to_second_half(new_faction_id : int):
	if new_faction_id == EnemyConstants.EnemyFactions.EXPERT:
		spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionExpert_EnemySpawnIns.gd").new()


