extends MarginContainer

const SingleTowerRoundDamageStatsPanel = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/SingleTowerRoundDamageStatsPanel.gd")
const SingleTowerRoundDamageStatsPanel_Scene = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/SingleTowerRoundDamageStatsPanel.tscn")


signal on_tower_in_single_panel_left_clicked(tower)
#signal calculated_total_damage_of_all_towers(arg_total_val, arg_pure_val, arg_ele_val, arg_phy_val)

const seconds_per_update : float = 0.2

var update_timer : Timer


var tower_manager setget set_tower_manager
var stage_round_manager setget set_stage_round_manager

onready var single_tower_stats_panel_container = $SingleTowerStatsPanelContainer

#

func _ready():
	update_timer = Timer.new()
	update_timer.connect("timeout", self, "_on_update_timer_expired", [], CONNECT_PERSIST)
	update_timer.one_shot = true
	
	add_child(update_timer)


#

func set_tower_manager(arg_manager):
	tower_manager = arg_manager
	
	tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_on_tower_placed_in_map", [], CONNECT_PERSIST)

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
	stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)

func set_game_result_manager(arg_manager):
	
	arg_manager.connect("game_result_decided", self, "_on_game_result_decided", [], CONNECT_PERSIST)


#

func _on_tower_placed_in_map(tower):
	if stage_round_manager.round_started:
		_attempt_create_single_stat_panel_for_tower(tower)

#

func _on_round_start(curr_stageround):
	for single_stat_panel in single_tower_stats_panel_container.get_children():
		if !is_instance_valid(single_stat_panel._tower) or (!single_stat_panel._tower.is_current_placable_in_map() and !single_stat_panel._tower.is_tower_hidden) or single_stat_panel._tower.is_queued_for_deletion(): #or single_stat_panel._tower.displayable_in_damage_stats_panel:
			single_stat_panel.queue_free()
	
	yield(get_tree(), "idle_frame")
	
	for tower in tower_manager.get_all_in_map_and_hidden_towers_except_in_queue_free():
		if !tower.is_queued_for_deletion():
			_attempt_create_single_stat_panel_for_tower(tower)
	
	update_timer.paused = false
	_update_display_of_all_single_damage_stats()


func _attempt_create_single_stat_panel_for_tower(tower):
	var is_tower_already_tracked : bool = false
	
	for single_stat_panel in single_tower_stats_panel_container.get_children():
		if single_stat_panel._tower == tower:
			is_tower_already_tracked = true
			return
	
	if !is_tower_already_tracked:
		var single_stat_panel = SingleTowerRoundDamageStatsPanel_Scene.instance()
		single_stat_panel.set_tower(tower)
		single_stat_panel.connect("on_left_clicked", self, "_on_single_stat_panel_left_clicked", [], CONNECT_PERSIST)
		single_tower_stats_panel_container.add_child(single_stat_panel)
		

#

func _on_round_end(curr_stageround):
	_pause_and_update_and_emit_calculations()

func _on_game_result_decided():
	_pause_and_update_and_emit_calculations()

func _pause_and_update_and_emit_calculations():
	update_timer.paused = true
	_update_display_of_all_single_damage_stats()
	
	#prompt_calculation_of_total_damage_of_all_towers()



#func prompt_calculation_of_total_damage_of_all_towers():
#	var total_damages = _get_calculated_total_damages_of_all_panels()
#	emit_signal("calculated_total_damage_of_all_towers", total_damages[0], total_damages[1], total_damages[2], total_damages[3])


#

func _on_update_timer_expired():
	_update_display_of_all_single_damage_stats()


func _update_display_of_all_single_damage_stats():
	update_timer.start(seconds_per_update)
	
	var stat_panels = single_tower_stats_panel_container.get_children()
	var highest_damage : float = 1
	
	for single_stat_panel in stat_panels:
		if single_stat_panel.in_round_total_dmg > highest_damage:
			highest_damage = single_stat_panel.in_round_total_dmg
	
	for single_stat_panel in stat_panels:
		single_stat_panel.update_display(highest_damage)


#

func _on_single_stat_panel_left_clicked(arg_tower, panel):
	emit_signal("on_tower_in_single_panel_left_clicked", arg_tower)

#####

func get_calculated_total_damages_of_all_panels() -> Array:
	var total_damage : float = 0
	var total_pure_damage : float = 0
	var total_ele_damage : float = 0
	var total_phy_damage : float = 0
	
	for single_stat_panel in single_tower_stats_panel_container.get_children():
		total_damage += single_stat_panel.in_round_total_dmg
		total_pure_damage += single_stat_panel.in_round_pure_dmg
		total_ele_damage += single_stat_panel.in_round_ele_dmg
		total_phy_damage += single_stat_panel.in_round_phy_dmg
	
	return [total_damage, total_pure_damage, total_ele_damage, total_phy_damage]
