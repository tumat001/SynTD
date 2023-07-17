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

const GenStats_SmallButton = preload("res://GameHUDRelated/StatsPanel/SmallButtonRelated/GenStats_SmallButton.gd")



signal stage_rounds_set(arg_stagerounds)
#signal stage_round_changed(stage_num, round_num)
signal before_round_starts(current_stageround)
signal round_started(current_stageround) # incomming/current round

signal before_round_ends_game_start_aware(current_stageround, is_game_start)
signal before_round_ends(current_stageround) # new incomming round
signal round_ended_game_start_aware(current_stageround, is_game_start)
signal round_ended(current_stageround) # new incomming round

signal round_ended__for_streak_panel_glow_purposes(arg_is_win, arg_steak_amount, arg_is_max_reached, arg_is_streak_broken, arg_is_streak_broken_magnitude_max)


signal life_lost_from_enemy_first_time_in_round(enemy)
signal life_lost_from_enemy(enemy)

signal end_of_stagerounds()

signal last_calculated_block_start_of_round_changed(arg_val)
signal last_calculated_block_end_of_round_changed(arg_val)





const gold_gain_on_win : int = 1

var round_status_panel : RoundStatusPanel setget _set_round_status_panel
var game_mode : int
var stagerounds : BaseMode_StageRound setget set_stagerounds
var current_stageround_index : int = -1
var current_stageround : StageRound
var spawn_ins_of_faction_mode : BaseMode_EnemySpawnIns

var stageround_total_count : int

var round_started : bool
#var round_fast_forwarded : bool

var enemy_manager : EnemyManager setget _set_enemy_manager
var gold_manager : GoldManager
var game_elements setget set_game_elements

# 

var current_round_lost : bool
var life_lost_to_enemy_in_round : bool

var can_gain_streak : bool
var current_win_streak : int
var current_lose_streak : int

#

enum BlockStartRoundClauseIds {
	MAP_MANAGER__ENEMY_PATH_CURVE_DEFER = 1   # when the enemy path curve is prevented from chaning (due to other operations that must be completed first).
	
	
	MAP_MEMORIES__IS_IN_SAC_OR_RECALL = 10,
	MAP_MEMORIES__REMOVING_ENEMY_DREAMER_DRAW_PARAMS = 11,
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



enum BlockSurrenderableRoundClauseIds {
	GAME_NOT_STARTED = 0,
	ROUND_NOT_STARTED = 1,
	ENEMIES_NOT_DONE_SPAWNING = 2,
	NO_ENEMIES_LEFT = 3,
	
	GAME_ENDED = 4,
	GAME_RESULT_DECIDED = 5,
}
var block_surrenderable_round_conditional_clauses : ConditionalClauses
var last_calculated_is_round_surrenderable : bool

var GSSB__surrender : GenStats_SmallButton


var _is_in_prompt_for_surrender : bool

const SURRENDER_PROMPT_DESCRIPTION = [
	["Do you want to surrender this round?", []],
]

#

func _init():
	block_start_round_conditional_clauses = ConditionalClauses.new()
	block_start_round_conditional_clauses.connect("clause_inserted", self, "_on_block_start_round_conditional_clauses_updated", [], CONNECT_PERSIST)
	block_start_round_conditional_clauses.connect("clause_removed", self, "_on_block_start_round_conditional_clauses_updated", [], CONNECT_PERSIST)
	_update_last_calculated_block_start_round()
	
	#
	_block_end_round_conditional_clauses = ConditionalClauses.new()
	_update_last_calculated_block_end_round(false)
	
	#
	block_surrenderable_round_conditional_clauses = ConditionalClauses.new()
	block_surrenderable_round_conditional_clauses.connect("clause_inserted", self, "_on_block_surrenderable_round_conditional_clauses_updated", [], CONNECT_PERSIST)
	block_surrenderable_round_conditional_clauses.connect("clause_removed", self, "_on_block_surrenderable_round_conditional_clauses_updated", [], CONNECT_PERSIST)
	#_update_is_round_surrenderable()
	block_surrenderable_round_conditional_clauses.attempt_insert_clause(BlockSurrenderableRoundClauseIds.GAME_NOT_STARTED)
	

#

func set_game_mode_to_normal():
	set_game_mode(StoreOfGameMode.Mode.STANDARD_NORMAL)

func set_game_mode(mode : int):
	game_mode = mode
	
	#if mode == StoreOfGameMode.Mode.STANDARD_NORMAL:
	
	if stagerounds == null:
		#stagerounds = StoreOfGameMode.get_stage_rounds_of_mode_from_id(mode).new() #ModeNormal_StageRounds.new()
		set_stagerounds(StoreOfGameMode.get_stage_rounds_of_mode_from_id(mode).new())
	
	#_replace_current_spawn_ins_to_second_half(stagerounds.get_first_half_faction())
		#spawn_ins_of_faction_mode = StoreOfGameMode.get_spawn_ins_of_faction__based_on_mode(stagerounds.get_first_half_faction(), mode)
	
	#stageround_total_count = stagerounds.stage_rounds.size()
	
	#emit_signal("stage_rounds_set", stagerounds)

func set_stagerounds(arg_stage_rounds):
	stagerounds = arg_stage_rounds
	
	_replace_current_spawn_ins_to_second_half(stagerounds.get_first_half_faction())
	
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

func set_game_elements(arg_elements):
	game_elements = arg_elements
	
	game_elements.connect("before_game_start", self, "_on_game_ele_before_game_start", [], CONNECT_ONESHOT)


func _on_game_ele_before_game_start():
	_initialize_surrenderable_configs_and_props()



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
	
	cancel_surrender_prompt__if_currently_in_prompt()
	
	var is_end_of_stageround = _before_round_end(from_game_start)
	if !is_end_of_stageround:
		_at_round_end()
		_after_round_end()
		
		# streak related
		var old_win_streak = current_win_streak
		var old_lose_streak = current_lose_streak
		var old_can_gain_streak = can_gain_streak
		
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
		
		if old_can_gain_streak:
			_calc_for_emit_round_ended__for_streak_panel_glow_purposes(old_lose_streak, old_win_streak, !current_round_lost)
		
		
		
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


#

func _on_block_surrenderable_round_conditional_clauses_updated(_arg_val):
	_update_is_round_surrenderable()

func _update_is_round_surrenderable():
	var old_val = last_calculated_is_round_surrenderable
	last_calculated_is_round_surrenderable = block_surrenderable_round_conditional_clauses.is_passed
	
	if is_instance_valid(GSSB__surrender) and (old_val != last_calculated_is_round_surrenderable):
		GSSB__surrender.update_is_visible_based_on_conditions()


func _initialize_surrenderable_configs_and_props():
	var surrender_button_constr_param := GenStats_SmallButton.ConstructorParams.new()
	surrender_button_constr_param.show_descs = false
	
	surrender_button_constr_param.image_normal = preload("res://GameHUDRelated/StatsPanel/Assets/GSSB_SmallButtonAssets/SurrenderButton_Normal.png")
	surrender_button_constr_param.image_hovered = preload("res://GameHUDRelated/StatsPanel/Assets/GSSB_SmallButtonAssets/SurrenderButton_Highlighted.png")
	
	surrender_button_constr_param.condition_visible__func_source = self
	surrender_button_constr_param.condition_visible__func_name = "_is_GSSB_visibile__surrender_button"
	#surrender_button_constr_param.condition_visible__func_param
	
	surrender_button_constr_param.on_click__func_source = self
	surrender_button_constr_param.on_click__func_name = "_on_click__surrender_button"
	
	GSSB__surrender = game_elements.general_stats_panel.construct_small_button_using_cons_params(surrender_button_constr_param)
	
	#
	
	game_elements.connect("after_all_game_init_finished", self, "_on_GE_after_all_game_init_finished", [], CONNECT_ONESHOT)
	connect("round_ended_game_start_aware", self, "_on_round_ended__visiblity_of_surrender_button__game_start_aware", [], CONNECT_PERSIST)
	connect("round_started", self, "_on_round_started__visibility_of_surrender_button", [], CONNECT_PERSIST)
	connect("end_of_stagerounds", self, "_on_end_of_stageround__for_vis_of_surrender_button", [], CONNECT_PERSIST)
	game_elements.enemy_manager.connect("interpreter_done_spawning__no_ins_left", self, "_on_enemy_manager_interpreter_done_spawning__no_ins_left", [], CONNECT_PERSIST)
	game_elements.enemy_manager.connect("no_enemies_left", self, "_on_enemy_manager__no_enemies_left", [], CONNECT_PERSIST)
	game_elements.game_result_manager.connect("game_result_decided", self, "_on_game_result_decided__for_vis_of_surrender_button")

func _is_GSSB_visibile__surrender_button(arg_params):
	return last_calculated_is_round_surrenderable



func _on_GE_after_all_game_init_finished():
	block_surrenderable_round_conditional_clauses.remove_clause(BlockSurrenderableRoundClauseIds.GAME_NOT_STARTED)

func _on_round_ended__visiblity_of_surrender_button__game_start_aware(current_stageround, is_game_start):
	block_surrenderable_round_conditional_clauses.attempt_insert_clause(BlockSurrenderableRoundClauseIds.ROUND_NOT_STARTED)

func _on_round_started__visibility_of_surrender_button(arg_stageround):
	block_surrenderable_round_conditional_clauses.attempt_insert_clause(BlockSurrenderableRoundClauseIds.ENEMIES_NOT_DONE_SPAWNING)
	block_surrenderable_round_conditional_clauses.remove_clause(BlockSurrenderableRoundClauseIds.ROUND_NOT_STARTED)
	block_surrenderable_round_conditional_clauses.remove_clause(BlockSurrenderableRoundClauseIds.NO_ENEMIES_LEFT)

func _on_enemy_manager_interpreter_done_spawning__no_ins_left():
	block_surrenderable_round_conditional_clauses.remove_clause(BlockSurrenderableRoundClauseIds.ENEMIES_NOT_DONE_SPAWNING)
	

func _on_end_of_stageround__for_vis_of_surrender_button():
	block_surrenderable_round_conditional_clauses.attempt_insert_clause(BlockSurrenderableRoundClauseIds.GAME_ENDED)

func _on_game_result_decided__for_vis_of_surrender_button():
	block_surrenderable_round_conditional_clauses.attempt_insert_clause(BlockSurrenderableRoundClauseIds.GAME_RESULT_DECIDED)


func _on_enemy_manager__no_enemies_left():
	block_surrenderable_round_conditional_clauses.attempt_insert_clause(BlockSurrenderableRoundClauseIds.NO_ENEMIES_LEFT)
	
	cancel_surrender_prompt__if_currently_in_prompt()



func _on_click__surrender_button():
	if GameSettingsManager.surrender_prompt_option_mode == GameSettingsManager.SurrenderPromptOption.PROMPT:
		_is_in_prompt_for_surrender = true
		game_elements.input_prompt_manager.prompt_yes_no_dialog(self, "_on_surrender_prompt__yes_no_dialog_prompt_canceled", SURRENDER_PROMPT_DESCRIPTION, self, "_on_surrender_prompt__yes_selected", "_on_surrender_prompt__no_selected", true)
	else:
		enemy_manager.surrender_round__make_all_enemies_escape()
	


func _on_surrender_prompt__yes_no_dialog_prompt_canceled():
	_is_in_prompt_for_surrender = false

func _on_surrender_prompt__yes_selected():
	enemy_manager.surrender_round__make_all_enemies_escape()
	_is_in_prompt_for_surrender = false

func _on_surrender_prompt__no_selected():
	_is_in_prompt_for_surrender = false


func cancel_surrender_prompt__if_currently_in_prompt():
	if _is_in_prompt_for_surrender:
		game_elements.input_prompt_manager.cancel_selection()


#######

func _calc_for_emit_round_ended__for_streak_panel_glow_purposes(arg_old_lose_streak, arg_old_win_streak, arg_is_win):
	#arg_is_win, arg_steak_amount, arg_is_max_reached, arg_is_streak_broken, arg_streak_broken_magnitude, arg_is_streak_broken_magnitude_max
	
	var streak_amount
	var is_max_reached : bool
	var is_streak_broken : bool
	var streak_broken_magnitude : float = -1
	var is_streak_broken_magnitude_max : bool = false
	if arg_is_win:
		streak_amount = arg_old_win_streak
		is_max_reached = current_win_streak == GoldManager.highest_win_streak
		is_streak_broken = (arg_old_lose_streak >= GoldManager.lowest_lose_streak)
		if is_streak_broken:
			streak_broken_magnitude = arg_old_lose_streak
			is_streak_broken_magnitude_max = arg_old_lose_streak == GoldManager.highest_lose_streak
		
	else:
		streak_amount = arg_old_lose_streak
		is_max_reached = current_lose_streak == GoldManager.highest_lose_streak
		is_streak_broken = (arg_old_win_streak >= GoldManager.lowest_win_streak)
		
		if is_streak_broken:
			streak_broken_magnitude = arg_old_win_streak
			is_streak_broken_magnitude_max = arg_old_win_streak == GoldManager.highest_win_streak
		
	
	emit_signal("round_ended__for_streak_panel_glow_purposes", arg_is_win, streak_amount, is_max_reached, is_streak_broken, streak_broken_magnitude, is_streak_broken_magnitude_max)


