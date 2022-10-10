extends Node

const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")


signal stat_overview_construction_finished()

var stage_round_manager setget set_stage_round_manager
var tower_manager setget set_tower_manager
var combination_manager setget set_combination_manager
var game_result_manager setget set_game_result_manager
var game_elements setget set_game_elements
var synergy_manager setget set_synergy_manager

var stageround_id_to_stat_sample_map : Dictionary = {}
var _current_stat_sample : StatSample

var stat_overview : StatOverview
var is_stat_overview_construction_finished : bool = false

#

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end_game_start_aware", [], CONNECT_PERSIST)
	stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
	stage_round_manager.connect("before_round_ends_game_start_aware", self, "_on_before_round_ends_game_start_aware", [], CONNECT_PERSIST)

func set_tower_manager(arg_manager):
	tower_manager = arg_manager
	
	_start_tower_absorbed_listen()

func set_combination_manager(arg_manager):
	combination_manager = arg_manager
	
	_start_tower_combined_listen()

func set_game_result_manager(arg_manager):
	game_result_manager = arg_manager
	
	game_result_manager.connect("game_result_decided", self, "_on_game_result_decided", [], CONNECT_PERSIST)

func set_game_elements(arg_elements):
	game_elements = arg_elements

func set_synergy_manager(arg_manager):
	synergy_manager = arg_manager

func set_multiple_tower_damage_stats_container(arg_stats_container):
	arg_stats_container.connect("calculated_total_damage_of_all_towers", self, "_on_calculated_total_damage_of_all_towers")

#####

func _on_round_start(arg_stageround):
	_take_stat_sample__start_of_round()


func _on_before_round_ends_game_start_aware(arg_staground, arg_is_game_start):
	if !arg_is_game_start:
		_take_stat_sample__before_end_of_round()

func _on_round_end_game_start_aware(arg_stageround, arg_is_game_start):
	if !arg_is_game_start:
		_take_stat_sample__end_of_round()
	
	_start_new_stat_sample()

func _on_game_result_decided():
	_take_stat_sample__end_of_round()
	
	call_deferred("_construct_stat_overview")


### START / TAKE STAT SAMPLE

func _start_new_stat_sample():
	_current_stat_sample = StatSample.new()
	_current_stat_sample.stage_num = stage_round_manager.current_stageround.stage_num
	_current_stat_sample.round_num = stage_round_manager.current_stageround.round_num
	_current_stat_sample.stageround_id = stage_round_manager.current_stageround.stageround_id
	
	_start_tower_sold_listen()

func _take_stat_sample__start_of_round():
	_current_stat_sample.tower_ids_active_at_round_start = _get_all_active_tower_ids()
	
	_current_stat_sample.gold_amount_at_start = game_elements.gold_manager.current_gold
	_current_stat_sample.player_health_at_start = game_elements.health_manager.current_health
	_current_stat_sample.player_level_at_start = game_elements.level_manager.current_level
	
	_set_curr_stat_sample_with_syn_info()
	
	_end_tower_sold_listen()
	#


func _take_stat_sample__before_end_of_round():
	_set_curr_stat_sample__with_THD_and_damages()
	
	_current_stat_sample.is_round_won = !stage_round_manager.current_round_lost
	


func _take_stat_sample__end_of_round():
	_current_stat_sample.win_streak = stage_round_manager.current_win_streak
	_current_stat_sample.lose_steak = stage_round_manager.current_lose_streak
	
	_current_stat_sample.player_health_at_end = game_elements.health_manager.current_health
	
	# Store _curr_sample.
	stageround_id_to_stat_sample_map[stage_round_manager.current_stageround.id] = _current_stat_sample


class StatSample:
	var stage_num : int  # update at round end
	var round_num : int  # update at round end
	var stageround_id : String
	
	var tower_ids_active_at_round_start : Array = []
	var tower_ids_sold_during_intermission : Array = []
	
	var tower_ids_absorbed : Array = []
	var tower_ids_combined : Array = []
	
	# top and below should be the same order to work as intended
	var synergy_dom_ids_active_at_round_start : Array = []
	var synergy_dom_tiers_active_at_round_start : Array = []
	
	var synergy_compo_ids_active_at_round_start : Array = []
	var synergy_compo_tiers_active_at_round_start : Array = []
	
	
	var is_round_won : bool
	var win_streak : int
	var lose_steak : int
	
	var gold_amount_at_start : int
	var player_level_at_start : int
	var player_health_at_start : float
	var player_health_at_end : float
	
	var tower_id_with_highest_dmg : int
	var THD_in_round_total_damage_dealt : float
	var THD_in_round_pure_damage_dealt : float
	var THD_in_round_elemental_damage_dealt : float
	var THD_in_round_physical_damage_dealt : float
	
	var round_total_damage_dealt : float
	var round_pure_damage_dealt : float
	var round_elemental_damage_dealt : float
	var round_physical_damage_dealt : float
	
	#var enemy_strength_val : int      #soon
	
	static func _custom_sort_descending(a, b):
		return a > b


######### UTILS

# ACTIVE TOWERS
func _get_all_active_tower_ids():
	var bucket = []
	var all_active_towers = tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in all_active_towers:
		bucket.append(tower.tower_id)
	
	bucket.sort_custom(StatSample, "_custom_sort_descending")
	return bucket

# TOWER SOLD
func _start_tower_sold_listen():
	if !tower_manager.is_connected("tower_being_sold", self, "_on_tower_sold"):
		tower_manager.connect("tower_being_sold", self ,"_on_tower_sold", [], CONNECT_PERSIST)

func _end_tower_sold_listen():
	if tower_manager.is_connected("tower_being_sold", self, "_on_tower_sold"):
		tower_manager.disconnect("tower_being_sold", self, "_on_tower_sold")

func _on_tower_sold(arg_sellback_gold, arg_tower):
	if !arg_tower.is_a_summoned_tower:
		_current_stat_sample.tower_ids_sold_during_intermission.append(arg_tower.tower_id)

# TOWER AS ING
func _start_tower_absorbed_listen():
	if !tower_manager.is_connected("tower_being_absorbed_as_ingredient", self, "_on_tower_absorbed_as_ing"):
		tower_manager.connect("tower_being_absorbed_as_ingredient", self, "_on_tower_absorbed_as_ing", [], CONNECT_PERSIST)

func _end_tower_absorbed_listen():
	if tower_manager.is_connected("tower_being_absorbed_as_ingredient", self, "_on_tower_absorbed_as_ing"):
		tower_manager.disconnect("tower_being_absorbed_as_ingredient", self, "_on_tower_absorbed_as_ing")

func _on_tower_absorbed_as_ing(arg_tower):
	if _current_stat_sample != null:
		_current_stat_sample.tower_ids_absorbed.append(arg_tower.tower_id)

# TOWER COMBINED

func _start_tower_combined_listen():
	if !combination_manager.is_connected("on_combination_effect_added", self, "_on_tower_id_combined"):
		combination_manager.connect("on_combination_effect_added", self, "_on_tower_id_combined", [], CONNECT_PERSIST)

func _end_tower_combined_listen():
	if combination_manager.is_connected("on_combination_effect_added", self, "_on_tower_id_combined"):
		combination_manager.disconnect("on_combination_effect_added", self, "_on_tower_id_combined")

func _on_tower_id_combined(arg_combi_tower_id):
	if _current_stat_sample != null:
		_current_stat_sample.tower_ids_combined.append(arg_combi_tower_id)

### DAMAGE RELATED

func _set_curr_stat_sample__with_THD_and_damages():
	var highest_dmging_tower = _get_highest_damaging_active_towers_sorted(1)
	
	if is_instance_valid(highest_dmging_tower):
		_current_stat_sample.tower_id_with_highest_dmg = highest_dmging_tower.tower_id
		_set_curr_stat_sample_with_total_damages_of_tower(highest_dmging_tower)

func _set_curr_stat_sample_with_total_damages_of_tower(arg_tower):
	_current_stat_sample.THD_in_round_total_damage_dealt = arg_tower.in_round_total_damage_dealt
	_current_stat_sample.THD_in_round_pure_damage_dealt = arg_tower.in_round_pure_damage_dealt
	_current_stat_sample.THD_in_round_elemental_damage_dealt = arg_tower.in_round_elemental_damage_dealt
	_current_stat_sample.THD_in_round_physical_damage_dealt = arg_tower.in_round_physical_damage_dealt

func _on_calculated_total_damage_of_all_towers(arg_total, arg_pure, arg_ele, arg_phy):
	if _current_stat_sample != null:
		_current_stat_sample.round_total_damage_dealt = arg_total
		_current_stat_sample.round_pure_damage_dealt = arg_pure
		_current_stat_sample.round_elemental_damage_dealt = arg_ele
		_current_stat_sample.round_physical_damage_dealt = arg_phy


# returns tower instance is arg_amount == 1, returns arr otherwise
func _get_highest_damaging_active_towers_sorted(arg_amount : int):
	var towers = tower_manager.get_all_active_towers_except_in_queue_free()
	var sorted_towers = Targeting.enemies_to_target(towers, Targeting.TOWERS_HIGHEST_IN_ROUND_DAMAGE, arg_amount, Vector2(0, 0))
	
	if arg_amount == 1 and sorted_towers.size() > 0:
		return sorted_towers[0]
	else:
		return sorted_towers


### SYN RELATED

func _set_curr_stat_sample_with_syn_info():
	var active_dom_reses = synergy_manager.active_dom_color_synergies_res
	var active_compo_reses = synergy_manager.active_compo_color_synergies_res
	
	for res in active_dom_reses:
		_current_stat_sample.synergy_dom_ids_active_at_round_start.append(res.synergy.synergy_id)
		_current_stat_sample.synergy_dom_tiers_active_at_round_start.append(res.towers_in_tier)
	
	for res in active_compo_reses:
		_current_stat_sample.synergy_compo_ids_active_at_round_start.append(res.synergy.synergy_id)
		_current_stat_sample.synergy_compo_tiers_active_at_round_start.append(res.towers_in_tier)


################## STAT OVERVIEW ############################

class StatOverview:
	
	const early_game_stageround_id_start_exclusive = "03"
	const early_game_stageround_id_exclusive = "51"
	const mid_game_stageround_id_exclusive = "91"
	const last_round_end_game_stageround_id_exclusive = "94"
	const first_round_of_game_stageround_id_exclusive = "01"
	
	#
	
	var synergy_dom_id_played_at_early_game : int
	var synergy_dom_id_played_at_mid_game : int
	var synergy_dom_id_played_at_end : int
	
	var synergy_compo_id_played_at_early_game : int
	var synergy_compo_id_played_at_mid_game : int
	var synergy_compo_id_played_at_end : int
	
	var highest_win_streak : int
	var highest_lose_streak : int
	
	var final_player_level : int
	var final_gold_amount : int
	var final_player_health : int
	
	var final_combination_count : int
	var final_ing_absorb_count : int
	
	var stageround_lost_most_health : String
	var highest_health_amount_lost : float
	
	var total_damage_dealt : float
	var total_pure_damage_dealt : float
	var total_elemental_damage_dealt : float
	var total_physical_damage_dealt : float


func _construct_stat_overview():
	stat_overview = StatOverview.new()
	
	_configure_stat_overview__synergy_stats()
	
	
	#
	is_stat_overview_construction_finished = true
	emit_signal("stat_overview_construction_finished")


func _configure_stat_overview__synergy_stats():
	var prev_stageround_id : String
	
	var list_of_dom_syn_ids_played_in_early : Array = []
	var list_of_compo_syn_ids_played_in_early : Array = []
	var list_of_dom_syn_ids_played_in_mid : Array = []
	var list_of_compo_syn_ids_played_in_mid : Array = []
	var list_of_dom_syn_ids_played_at_end : Array = [] # end = last round
	var list_of_compo_syn_ids_played_at_end : Array = []
	var list_of_dom_syn_tiers_played_at_end : Array = []
	var list_of_compo_syn_tiers_played_at_end : Array = []
	
	var total_ing_absorbed : int
	var player_health_at_prev_end_round : float = game_elements.health_manager.starting_health
	var stageround_id_where_most_health_lost : String
	
	for stat_sample in stageround_id_to_stat_sample_map.values():
		# stage round ids dependend stats
		if StageRound.is_stageround_id_higher_than_second_param(StatOverview.early_game_stageround_id_exclusive, stat_sample.stageround_id):
			for id in stat_sample.synergy_dom_ids_active_at_round_start:
				list_of_dom_syn_ids_played_in_early.append(id)
			for id in stat_sample.synergy_compo_ids_active_at_round_start:
				list_of_compo_syn_ids_played_in_early.append(id)
			
		elif StageRound.is_stageround_id_higher_than_second_param(StatOverview.mid_game_stageround_id_exclusive, stat_sample.stageround_id):
			for id in stat_sample.synergy_dom_ids_active_at_round_start:
				list_of_dom_syn_ids_played_in_mid.append(id)
			for id in stat_sample.synergy_compo_ids_active_at_round_start:
				list_of_compo_syn_ids_played_in_mid.append(id)
			
		elif StageRound.is_stageround_id_equal_than_second_param(StatOverview.last_round_end_game_stageround_id_exclusive, stat_sample.stageround_id):
			for id in stat_sample.synergy_dom_ids_active_at_round_start:
				list_of_dom_syn_ids_played_at_end.append(id)
			for tier in stat_sample.synergy_dom_tiers_active_at_round_start:
				list_of_dom_syn_tiers_played_at_end.append(tier)
			
			for id in stat_sample.synergy_compo_ids_active_at_round_start:
				list_of_compo_syn_ids_played_at_end.append(id)
			for tier in stat_sample.synergy_compo_tiers_active_at_round_start:
				list_of_compo_syn_tiers_played_at_end.append(tier)
		
		
		if stat_sample.win_streak > stat_overview.highest_win_streak:
			stat_overview.highest_win_streak = stat_sample.win_streak
		
		if stat_sample.lose_streak > stat_overview.highest_lose_streak:
			stat_overview.highest_lose_streak = stat_sample.lose_streak
		
		var health_reduc_diff = player_health_at_prev_end_round - stat_sample.player_health_at_end 
		if health_reduc_diff > 0 and stat_overview.highest_health_amount_lost < health_reduc_diff:
			stat_overview.highest_health_amount_lost = health_reduc_diff
			stat_overview.stageround_lost_most_health = stat_sample.stageround_id
		
		total_ing_absorbed += stat_sample.tower_ids_absorbed.size()
		
		stat_overview.total_damage_dealt = stat_sample.round_total_damage_dealt
		stat_overview.total_pure_damage_dealt = stat_sample.round_pure_damage_dealt
		stat_overview.total_elemental_damage_dealt = stat_sample.round_elemental_damage_dealt
		stat_overview.total_physical_damage_dealt = stat_sample.round_physical_damage_dealt
		
		# KEEP AT BOTTOM
		player_health_at_prev_end_round = stat_sample.player_health_at_end
		prev_stageround_id = stat_sample.stageround_id
	
	#
	
	stat_overview.final_player_level = game_elements.level_manager.current_level
	stat_overview.final_player_health = game_elements.health_manager.current_health
	stat_overview.final_gold_amount = game_elements.gold_manager.current_gold
	stat_overview.final_combination_count = combination_manager.all_combination_id_to_effect_map.size()
	stat_overview.final_ing_absorb_count = total_ing_absorbed
	
	##########
	is_stat_overview_construction_finished = true
	emit_signal("stat_overview_construction_finished")


