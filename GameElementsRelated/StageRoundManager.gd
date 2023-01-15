extends Node

const RoundStatusPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStatusPanel.gd")

const BaseMode_StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd")
const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")

#const ModeNormal_StageRounds = preload("res://GameplayRelated/StagesAndRoundsRelated/ModeNormal_StageRounds.gd")
#const FactionBasic_EnemySpawnIns = preload("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionBasic_EnemySpawnIns.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const BaseMode_EnemySpawnIns = preload("res://GameplayRelated/EnemiesInRounds/BaseMode_EnemySpawnIns.gd")

const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")

const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")



signal stage_rounds_set(arg_stagerounds)
#signal stage_round_changed(stage_num, round_num)
signal before_round_starts(current_stageround)
signal round_started(current_stageround) # incomming/current round

signal before_round_ends_game_start_aware(current_stageround, is_game_start)
signal before_round_ends(current_stageround) # new incomming round
signal round_ended_game_start_aware(current_stageround, is_game_start)
signal round_ended(current_stageround) # new incomming round

signal life_lost_from_enemy_first_time_in_round(enemy)
signal life_lost_from_enemy(enemy)

signal end_of_stagerounds()

signal last_calculated_block_start_of_round_changed(arg_val)
signal last_calculated_block_end_of_round_changed(arg_val)


const gold_gain_on_win : int = 1

var round_status_panel : RoundStatusPanel setget _set_round_status_panel
var game_mode : int
var stagerounds : BaseMode_StageRound
var current_stageround_index : int = -1
var current_stageround : StageRound
var spawn_ins_of_faction_mode : BaseMode_EnemySpawnIns

var stageround_total_count : int

var round_started : bool
#var round_fast_forwarded : bool

var enemy_manager : EnemyManager setget _set_enemy_manager
var gold_manager : GoldManager

# 

var current_round_lost : bool
var life_lost_to_enemy_in_round : bool

var can_gain_streak : bool
var current_win_streak : int
var current_lose_streak : int

#

enum BlockStartRoundClauseIds {
	MAP_MANAGER__ENEMY_PATH_CURVE_DEFER = 1   # when the enemy path curve is prevented from chaning (due to other operations that must be completed first).
	
}

var block_start_round_conditional_clauses : ConditionalClauses
var last_calculated_block_start_of_round : bool


enum BlockEndRoundClauseIds {
	ENEMIES_PRESENT_IN_MAP = 1
	PLAYER_HEALTH_DMG_PROJ_IN_FLIGHT = 2
}
# dont access this var normally. use provided methods instead
var _block_end_round_conditional_clauses : ConditionalClauses
var last_calculated_block_end_of_round : bool


#

func _init():
	block_start_round_conditional_clauses = ConditionalClauses.new()
	block_start_round_conditional_clauses.connect("clause_inserted", self, "_on_block_start_round_conditional_clauses_updated", [], CONNECT_PERSIST)
	block_start_round_conditional_clauses.connect("clause_removed", self, "_on_block_start_round_conditional_clauses_updated", [], CONNECT_PERSIST)
	
	_update_last_calculated_block_start_round()
	
	
	_block_end_round_conditional_clauses = ConditionalClauses.new()
	
	_update_last_calculated_block_end_round(false)

#

func set_game_mode_to_normal():
	set_game_mode(StoreOfGameMode.Mode.STANDARD_NORMAL)

func set_game_mode(mode : int):
	game_mode = mode
	
	#if mode == StoreOfGameMode.Mode.STANDARD_NORMAL:
	stagerounds = StoreOfGameMode.get_stage_rounds_of_mode_from_id(mode).new() #ModeNormal_StageRounds.new()
	_replace_current_spawn_ins_to_second_half(stagerounds.get_first_half_faction())
		#spawn_ins_of_faction_mode = StoreOfGameMode.get_spawn_ins_of_faction__based_on_mode(stagerounds.get_first_half_faction(), mode)
	
	stageround_total_count = stagerounds.stage_rounds.size()
	
	emit_signal("stage_rounds_set", stagerounds)

#

func _set_round_status_panel(panel : RoundStatusPanel):
	round_status_panel = panel
	
	round_status_panel.connect("round_start_pressed", self, "start_round", [], CONNECT_PERSIST)


func _set_enemy_manager(manager : EnemyManager):
	enemy_manager = manager
	
	#enemy_manager.connect("no_enemies_left", self, "end_round", [], CONNECT_DEFERRED | CONNECT_PERSIST)
	enemy_manager.connect("no_enemies_left", self, "_on_no_enemies_left", [], CONNECT_DEFERRED | CONNECT_PERSIST)
	enemy_manager.connect("enemy_escaped", self, "_life_lost_from_enemy", [], CONNECT_PERSIST)


# Round start related

func start_round():
	round_started = true
	
	emit_signal("before_round_starts", current_stageround)
	
	_before_round_start()
	_at_round_start()
	_after_round_start()
	
	emit_signal("round_started", current_stageround)


func _before_round_start():
	current_round_lost = false
	life_lost_to_enemy_in_round = false

func _at_round_start():
	pass

func _after_round_start():
	add_clause_to_block_end_round_conditional_clauses(BlockEndRoundClauseIds.ENEMIES_PRESENT_IN_MAP)
	enemy_manager.start_run()
	


# Round end related

func end_round(from_game_start : bool = false):
	round_started = false
	
	var is_end_of_stageround = _before_round_end(from_game_start)
	if !is_end_of_stageround:
		_at_round_end()
		_after_round_end()
		
		# streak related
		if !from_game_start and can_gain_streak:
			if current_round_lost:
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
			var gold = gold_manager.get_total_income_for_the_round()
			if !current_round_lost:
				gold += gold_gain_on_win
			
			gold_manager.increase_gold_by(gold, GoldManager.IncreaseGoldSource.END_OF_ROUND)
		
		
		# spawn inses related
		var spawn_ins_in_stageround
		enemy_manager.randomize_current_strength_val__following_conditions()
		
		
		if !spawn_ins_of_faction_mode.is_transition_time_in_stageround(current_stageround.id):
			
			spawn_ins_of_faction_mode.enemy_strength_value_to_use = enemy_manager.get_current_strength_value()
			spawn_ins_in_stageround = spawn_ins_of_faction_mode.get_instructions_for_stageround(current_stageround.id)
		else:
			_replace_current_spawn_ins_to_second_half(stagerounds.get_second_half_faction())
			
			spawn_ins_of_faction_mode.enemy_strength_value_to_use = enemy_manager.get_current_strength_value()
			spawn_ins_in_stageround = spawn_ins_of_faction_mode.get_instructions_for_stageround(current_stageround.id)
			enemy_manager.apply_faction_passive(spawn_ins_of_faction_mode.get_faction_passive())
		
		
		enemy_manager.set_instructions_of_interpreter(spawn_ins_in_stageround)
		enemy_manager.enemy_first_damage = current_stageround.enemy_first_damage
		enemy_manager.base_enemy_health_multiplier__from_stagerounds = current_stageround.enemy_health_multiplier
		enemy_manager.enemy_damage_multiplier = current_stageround.enemy_damage_multiplier
		
		can_gain_streak = current_stageround.can_gain_streak
		
		emit_signal("round_ended_game_start_aware", current_stageround, from_game_start)
		emit_signal("round_ended", current_stageround)
		
		
	else: # end of stagerounds. end the game.
		emit_signal("end_of_stagerounds")


func _before_round_end(arg_from_game_start):
	current_stageround_index += 1
	
	if stagerounds.stage_rounds.size() > current_stageround_index:
		current_stageround = stagerounds.stage_rounds[current_stageround_index]
		emit_signal("before_round_ends_game_start_aware", current_stageround, arg_from_game_start)
		emit_signal("before_round_ends", current_stageround)
		return false
	else:
		return true


func _at_round_end():
	pass

func _after_round_end():
	enemy_manager.end_run()
	
	#call_deferred("emit_signal", "end_of_round_gold_earned", current_stageround.end_of_round_gold, GoldManager.IncreaseGoldSource.END_OF_ROUND)



# If lives lost

func _life_lost_from_enemy(enemy):
	emit_signal("life_lost_from_enemy", enemy)
	
	if !life_lost_to_enemy_in_round:
		emit_signal("life_lost_from_enemy_first_time_in_round", enemy)
		life_lost_to_enemy_in_round = true
	
	current_round_lost = true

func set_current_round_to_lost():
	current_round_lost = true


# Enemy faction spawn ins related

func _replace_current_spawn_ins_to_second_half(new_faction_id : int):
	spawn_ins_of_faction_mode = StoreOfGameMode.get_spawn_ins_of_faction__based_on_mode(new_faction_id, game_mode)
#	if new_faction_id == EnemyConstants.EnemyFactions.EXPERT:
#		spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionExpert_EnemySpawnIns.gd").new()
#	elif new_faction_id == EnemyConstants.EnemyFactions.FAITHFUL:
#		spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionFaithful_EnemySpawnIns.gd").new()
#	elif new_faction_id == EnemyConstants.EnemyFactions.SKIRMISHERS:
#		spawn_ins_of_faction_mode = load("res://GameplayRelated/EnemiesInRounds/ModesAndFactionsInses/FactionSkirmisher_EnemySpawnIns.gd").new()


## round query

func get_number_of_rounds_before_stageround_id_reached(arg_target_stageround_id):
	return stagerounds.get_number_of_rounds_from_x_to_y__using_ids(current_stageround.id, arg_target_stageround_id)
	

#

func _on_no_enemies_left():
	remove_clause_to_block_end_round_conditional_clauses(BlockEndRoundClauseIds.ENEMIES_PRESENT_IN_MAP, true)


###########################

func _on_block_start_round_conditional_clauses_updated(arg_clause_id):
	_update_last_calculated_block_start_round()

func _update_last_calculated_block_start_round():
	last_calculated_block_start_of_round = !block_start_round_conditional_clauses.is_passed
	emit_signal("last_calculated_block_start_of_round_changed", last_calculated_block_start_of_round)



func add_clause_to_block_end_round_conditional_clauses(arg_clause_id):
	_block_end_round_conditional_clauses.attempt_insert_clause(arg_clause_id)
	_update_last_calculated_block_end_round(false)

func remove_clause_to_block_end_round_conditional_clauses(arg_clause_id, attempt_end_round : bool):
	_block_end_round_conditional_clauses.remove_clause(arg_clause_id)
	_update_last_calculated_block_end_round(attempt_end_round)


func _update_last_calculated_block_end_round(attempt_end_round : bool):
	last_calculated_block_end_of_round = !_block_end_round_conditional_clauses.is_passed
	emit_signal("last_calculated_block_end_of_round_changed", last_calculated_block_start_of_round)
	
	if !last_calculated_block_end_of_round and attempt_end_round:
		end_round()
