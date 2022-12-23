extends Node

const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")
const StageRoundDataPoint = preload("res://GameHUDRelated/GameStatsPanel/shared/StageRoundDataPoint.gd")
const WholeScreenGameStatsPanel = preload("res://GameHUDRelated/GameStatsPanel/WholeScreenGameStatsPanel/WholeScreenGameStatsPanel.gd")
const WholeScreenGameStatsPanel_Scene = preload("res://GameHUDRelated/GameStatsPanel/WholeScreenGameStatsPanel/WholeScreenGameStatsPanel.tscn")
const WholeScreenGUI = preload("res://GameElementsRelated/WholeScreenGUI.gd")

const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")


signal stat_overview_construction_finished()


const compressed_stage_round_graph_points : Array = [
	"01",
	"10",
	"13",
	"22",
	"31",
	"34",
	"43",
	"52",
	"61",
	"64",
	"73",
	"82",
	"91",
	"94",
]
const health_line_label_of_col : String = "Health"
const health_line_color : Color = Color(46/255.0, 195/255.0, 24/255.0, 1)
const health_graph_name : String = "Player Health"

const gold_line_label_of_col : String = "Gold"
const gold_line_color : Color = Color(253/255.0, 192/255.0, 8/255.0, 1)
const gold_graph_name : String = "Gold"


#

var stage_round_manager setget set_stage_round_manager
var tower_manager setget set_tower_manager
var combination_manager setget set_combination_manager
var game_result_manager setget set_game_result_manager
var game_elements setget set_game_elements
var synergy_manager setget set_synergy_manager
var multiple_tower_damage_stats_container setget set_multiple_tower_damage_stats_container

var stageround_id_to_stat_sample_map : Dictionary = {}
var _current_stat_sample : StatSample

var stat_overview : StatOverview
var is_stat_overview_construction_finished : bool = false
var is_stat_overview_construction_create_failed : bool = false
var _stat_overview_thread_constructor : Thread

#

var whole_screen_gui : WholeScreenGUI

var whole_screen_game_stats_panel : WholeScreenGameStatsPanel

# queue related

var reservation_for_whole_screen_gui

#

func _ready():
	_initialize_queue_reservation()

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	#reservation_for_whole_screen_gui.on_removed_method




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
	#arg_stats_container.connect("calculated_total_damage_of_all_towers", self, "_on_calculated_total_damage_of_all_towers")
	multiple_tower_damage_stats_container = arg_stats_container

#####

func _on_round_start(arg_stageround):
	_take_stat_sample__start_of_round()


func _on_before_round_ends_game_start_aware(arg_staground, arg_is_game_start):
	if !arg_is_game_start:
		_take_stat_sample__before_end_of_round()

func _on_round_end_game_start_aware(arg_stageround, arg_is_game_start):
	#if !arg_is_game_start:
	#	_take_stat_sample__end_of_round()
	
	_start_new_stat_sample()

func _on_game_result_decided():
	#_take_stat_sample__end_of_round()
	_take_stat_sample__before_end_of_round()
	
	call_deferred("_construct_stat_overview")


### START / TAKE STAT SAMPLE

func _start_new_stat_sample():
	_current_stat_sample = StatSample.new()
	_current_stat_sample.stage_num = stage_round_manager.current_stageround.stage_num
	_current_stat_sample.round_num = stage_round_manager.current_stageround.round_num
	_current_stat_sample.stageround_id = stage_round_manager.current_stageround.id
	
	_start_tower_sold_listen()

func _take_stat_sample__start_of_round():
	#_current_stat_sample.tower_ids_active_at_round_start = _get_all_active_tower_ids()
	
	_current_stat_sample.gold_amount_at_start = game_elements.gold_manager.current_gold
	_current_stat_sample.player_health_at_start = game_elements.health_manager.current_health
	_current_stat_sample.player_level_at_start = game_elements.level_manager.current_level
	
	
	_end_tower_sold_listen()
	#


func _take_stat_sample__before_end_of_round():
	_set_curr_stat_sample__with_THD_and_damages()
	
	_current_stat_sample.is_round_won = !stage_round_manager.current_round_lost
	
	_current_stat_sample.win_streak = stage_round_manager.current_win_streak
	_current_stat_sample.lose_streak = stage_round_manager.current_lose_streak
	
	_current_stat_sample.player_health_at_end = game_elements.health_manager.current_health
	_current_stat_sample.gold_amount_at_end = game_elements.gold_manager.current_gold
	
	_current_stat_sample.tower_ids_active_at_round_end = _get_all_active_tower_ids()
	
	_calculate_total_damage_of_all_towers()
	
	_set_curr_stat_sample_with_syn_info()
	
	# Store _curr_sample.
	stageround_id_to_stat_sample_map[_current_stat_sample.stageround_id] = _current_stat_sample
	

#func _take_stat_sample__end_of_round():
#	pass


class StatSample:
	var stage_num : int  # update at round end
	var round_num : int  # update at round end
	var stageround_id : String
	
	#var tower_ids_active_at_round_start : Array = []
	var tower_ids_sold_during_intermission : Array = []
	var tower_ids_active_at_round_end : Array = []
	
	var tower_ids_absorbed : Array = []
	var tower_ids_combined : Array = []
	
	var tower_tiers_absorbed : Array = []
	var tower_tiers_combined : Array = []
	
	# top and below should be the same order to work as intended
	var synergy_dom_ids_active_at_round_start : Array = []
	var synergy_dom_tiers_active_at_round_start : Array = []
	
	var synergy_compo_ids_active_at_round_start : Array = []
	var synergy_compo_tiers_active_at_round_start : Array = []
	
	
	var is_round_won : bool
	var win_streak : int
	var lose_streak : int
	
	var gold_amount_at_start : int
	var player_level_at_start : int
	var player_health_at_start : float
	var player_health_at_end : float setget set_player_health_at_end
	var gold_amount_at_end : int
	
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
	
	
	func set_player_health_at_end(arg_val):
		if arg_val < 0:
			arg_val = 0
		
		player_health_at_end = arg_val
	
	#
	
	static func _custom_sort_descending(a, b):
		return a.tower_type_info.tower_tier > b.tower_type_info.tower_tier


######### UTILS

# ACTIVE TOWERS
func _get_all_active_tower_ids():
	var bucket = []
	var all_active_towers = tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in all_active_towers:
		if !tower.is_a_summoned_tower:
			bucket.append(tower)
	
	bucket.sort_custom(StatSample, "_custom_sort_descending")
	
	var return_bucket = []
	for tower in bucket:
		return_bucket.append(tower.tower_id)
	
	return return_bucket

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
		_current_stat_sample.tower_tiers_absorbed.append(arg_tower.tower_type_info.tower_tier)

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

func _calculate_total_damage_of_all_towers():
	var damages_arr = multiple_tower_damage_stats_container.get_calculated_total_damages_of_all_panels()
	
	if _current_stat_sample != null:
		_current_stat_sample.round_total_damage_dealt = damages_arr[0]
		_current_stat_sample.round_pure_damage_dealt = damages_arr[1]
		_current_stat_sample.round_elemental_damage_dealt = damages_arr[2]
		_current_stat_sample.round_physical_damage_dealt = damages_arr[3]


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
		_current_stat_sample.synergy_dom_tiers_active_at_round_start.append(res.synergy_tier)
	
	for res in active_compo_reses:
		_current_stat_sample.synergy_compo_ids_active_at_round_start.append(res.synergy.synergy_id)
		_current_stat_sample.synergy_compo_tiers_active_at_round_start.append(res.synergy_tier)


################## STAT OVERVIEW ############################

class StatOverview:
	
	func _init(arg_stagerounds = null):
		if arg_stagerounds != null:
			early_game_stageround_id_start_exclusive = arg_stagerounds.early_game_stageround_id_start_exclusive
			early_game_stageround_id_exclusive = arg_stagerounds.early_game_stageround_id_exclusive
			mid_game_stageround_id_exclusive = arg_stagerounds.mid_game_stageround_id_exclusive
			last_round_end_game_stageround_id_exclusive = arg_stagerounds.last_round_end_game_stageround_id_exclusive
			first_round_of_game_stageround_id_exclusive = arg_stagerounds.first_round_of_game_stageround_id_exclusive
	
	var early_game_stageround_id_start_exclusive = "03"
	var early_game_stageround_id_exclusive = "51"
	var mid_game_stageround_id_exclusive = "91"
	var last_round_end_game_stageround_id_exclusive = "94"
	var first_round_of_game_stageround_id_exclusive = "01"
	
	#
	
#	var synergy_dom_id_played_at_early_game : int
#	var synergy_dom_id_played_at_mid_game : int
#	var synergy_dom_id_played_at_end : int
#
#	var synergy_compo_id_played_at_early_game : int
#	var synergy_compo_id_played_at_mid_game : int
#	var synergy_compo_id_played_at_end : int
	
	var synergy_ids_and_tiers_played_at_end : Array
	var tower_ids_played_at_end : Array
	
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
	
	var highest_player_health_amount : float
	var highest_player_gold_amount : float
	
	var ing_tier_to_total_count_map : Dictionary
	var combi_tier_to_total_count_map : Dictionary
	
	#
	
	var stage_round_data_points : Array
	var total_data_points_count : int

func _construct_stat_overview():
	#_construct_stat_overview__method_for_thread(null)
	
	_stat_overview_thread_constructor = Thread.new()
	var stat = _stat_overview_thread_constructor.start(self, "_construct_stat_overview__method_for_thread")
	
	if stat == ERR_CANT_CREATE:
		is_stat_overview_construction_create_failed = true


func _construct_stat_overview__method_for_thread(arg_userdata):
	stat_overview = StatOverview.new(stage_round_manager.stagerounds)
	
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
	
	var ing_tier_to_total_count_map : Dictionary = {
		1 : 0,
		2 : 0,
		3 : 0,
		4 : 0,
		5 : 0,
		6 : 0,
	}
	var combi_tier_to_total_count_map : Dictionary = ing_tier_to_total_count_map.duplicate()
	
	var stage_round_data_points : Array = []
	var count = 0
	
	for stat_sample in stageround_id_to_stat_sample_map.values():
		# stage round ids dependend stats
		if StageRound.is_stageround_id_equal_than_second_param(stat_overview.last_round_end_game_stageround_id_exclusive, stat_sample.stageround_id) or stageround_id_to_stat_sample_map.size() == (count + 1):
			# At last stage round
			for id in stat_sample.synergy_dom_ids_active_at_round_start:
				list_of_dom_syn_ids_played_at_end.append(id)
			for tier in stat_sample.synergy_dom_tiers_active_at_round_start:
				list_of_dom_syn_tiers_played_at_end.append(tier)
			
			for id in stat_sample.synergy_compo_ids_active_at_round_start:
				list_of_compo_syn_ids_played_at_end.append(id)
			for tier in stat_sample.synergy_compo_tiers_active_at_round_start:
				list_of_compo_syn_tiers_played_at_end.append(tier)
			
			stat_overview.tower_ids_played_at_end = stat_sample.tower_ids_active_at_round_end
			
		elif StageRound.is_stageround_id_higher_than_second_param(stat_overview.early_game_stageround_id_exclusive, stat_sample.stageround_id):
			for id in stat_sample.synergy_dom_ids_active_at_round_start:
				list_of_dom_syn_ids_played_in_early.append(id)
			for id in stat_sample.synergy_compo_ids_active_at_round_start:
				list_of_compo_syn_ids_played_in_early.append(id)
			
		elif StageRound.is_stageround_id_higher_than_second_param(stat_overview.mid_game_stageround_id_exclusive, stat_sample.stageround_id):
			for id in stat_sample.synergy_dom_ids_active_at_round_start:
				list_of_dom_syn_ids_played_in_mid.append(id)
			for id in stat_sample.synergy_compo_ids_active_at_round_start:
				list_of_compo_syn_ids_played_in_mid.append(id)
			
		
		
		if stat_sample.win_streak > stat_overview.highest_win_streak:
			stat_overview.highest_win_streak = stat_sample.win_streak
		
		if stat_sample.lose_streak > stat_overview.highest_lose_streak:
			stat_overview.highest_lose_streak = stat_sample.lose_streak
		
		var health_reduc_diff = player_health_at_prev_end_round - stat_sample.player_health_at_end 
		if health_reduc_diff > 0 and stat_overview.highest_health_amount_lost < health_reduc_diff:
			stat_overview.highest_health_amount_lost = health_reduc_diff
			stat_overview.stageround_lost_most_health = stat_sample.stageround_id
		
		total_ing_absorbed += stat_sample.tower_ids_absorbed.size()
		
		stat_overview.total_damage_dealt += stat_sample.round_total_damage_dealt
		stat_overview.total_pure_damage_dealt += stat_sample.round_pure_damage_dealt
		stat_overview.total_elemental_damage_dealt += stat_sample.round_elemental_damage_dealt
		stat_overview.total_physical_damage_dealt += stat_sample.round_physical_damage_dealt
		
		#
		
		if stat_overview.highest_player_health_amount < stat_sample.player_health_at_end:
			stat_overview.highest_player_health_amount = stat_sample.player_health_at_end
		
		if stat_overview.highest_player_gold_amount < stat_sample.gold_amount_at_end:
			stat_overview.highest_player_gold_amount = stat_sample.gold_amount_at_end
		
		for tier in stat_sample.tower_tiers_absorbed:
			ing_tier_to_total_count_map[tier] += 1
		
		# KEET AT 2ND TO BOTTOM OF FOR LOOP
		
		var stage_round_data_point = StageRoundDataPoint.new()
		stage_round_data_point.stage_num = stat_sample.stage_num
		stage_round_data_point.round_num = stat_sample.round_num
		stage_round_data_point.line_label_to_val_maps = {
			health_line_label_of_col : { health_line_label_of_col : stat_sample.player_health_at_end },
			gold_line_label_of_col : { gold_line_label_of_col : stat_sample.gold_amount_at_end }
		}
		stage_round_data_points.append(stage_round_data_point)
		
		# KEEP AT BOTTOM OF FOR LOOP
		player_health_at_prev_end_round = stat_sample.player_health_at_end
		prev_stageround_id = stat_sample.stageround_id
		count += 1
	
	#
	
	stat_overview.final_player_level = game_elements.level_manager.current_level
	stat_overview.final_player_health = game_elements.health_manager.current_health
	stat_overview.final_gold_amount = game_elements.gold_manager.current_gold
	stat_overview.final_combination_count = combination_manager.all_combination_id_to_effect_map.size()
	stat_overview.final_ing_absorb_count = total_ing_absorbed
	stat_overview.stage_round_data_points = stage_round_data_points
	stat_overview.total_data_points_count = count
	
	#
	stat_overview.ing_tier_to_total_count_map = ing_tier_to_total_count_map
	
	for id in combination_manager.all_combination_id_to_effect_map.keys():
		var tier = Towers.get_tower_tier_from_tower_id(id)
		combi_tier_to_total_count_map[tier] += 1
	stat_overview.combi_tier_to_total_count_map = combi_tier_to_total_count_map
	
	#
	for i in list_of_dom_syn_ids_played_at_end.size():
		stat_overview.synergy_ids_and_tiers_played_at_end.append([list_of_dom_syn_ids_played_at_end[i], list_of_dom_syn_tiers_played_at_end[i]])
	for i in list_of_compo_syn_ids_played_at_end.size():
		stat_overview.synergy_ids_and_tiers_played_at_end.append([list_of_compo_syn_ids_played_at_end[i], list_of_compo_syn_tiers_played_at_end[i]])
	
	#
	
	########## KEEP AT BOTTOM FOR ALL #############
	is_stat_overview_construction_finished = true
	emit_signal("stat_overview_construction_finished")

###

# called from round speed and start panel
func show_game_stats_panel():
	if !is_instance_valid(whole_screen_game_stats_panel):
		whole_screen_game_stats_panel = WholeScreenGameStatsPanel_Scene.instance()
		whole_screen_game_stats_panel.game_stats_manager = self
		whole_screen_game_stats_panel.whole_screen_gui = whole_screen_gui
	
	whole_screen_game_stats_panel.visible = false
	#whole_screen_gui.show_control(whole_screen_game_stats_panel)
	whole_screen_gui.queue_control(whole_screen_game_stats_panel, reservation_for_whole_screen_gui)
	

func _on_queue_reservation_entertained():
	whole_screen_game_stats_panel.initialize_display()
	whole_screen_game_stats_panel.visible = true



####

func _exit_tree():
	if _stat_overview_thread_constructor != null:
		_stat_overview_thread_constructor.wait_to_finish()

