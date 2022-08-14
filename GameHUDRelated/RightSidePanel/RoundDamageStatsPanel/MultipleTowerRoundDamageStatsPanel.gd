extends MarginContainer

const SingleTowerRoundDamageStatsPanel = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/SingleTowerRoundDamageStatsPanel.gd")
const SingleTowerRoundDamageStatsPanel_Scene = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/SingleTowerRoundDamageStatsPanel.tscn")


signal on_tower_in_single_panel_left_clicked(tower)

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
	
#	connect("visibility_changed", self, "_visibility_changed", [], CONNECT_PERSIST)
#
#
#
#func _visibility_changed():
#	if visible:
#		_update_display_of_all_single_damage_stats()




#

func set_tower_manager(arg_manager):
	tower_manager = arg_manager
	
	tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_on_tower_placed_in_map", [], CONNECT_PERSIST)

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
	stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)

#

func _on_tower_placed_in_map(tower):
	if stage_round_manager.round_started:
		_attempt_create_single_stat_panel_for_tower(tower)

#

func _on_round_start(curr_stageround):
	for single_stat_panel in single_tower_stats_panel_container.get_children():
		if single_stat_panel._tower == null or !single_stat_panel._tower.is_current_placable_in_map():
			single_stat_panel.queue_free()
	
	yield(get_tree(), "idle_frame")
	
	for active_tower in tower_manager.get_all_in_map_towers():
		_attempt_create_single_stat_panel_for_tower(active_tower)
	
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
	update_timer.paused = true
	_update_display_of_all_single_damage_stats()


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
