extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerInfoPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerInfoPanel.gd")
const RoundStatusPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStatusPanel.gd")
const RoundDamageStatsPanel = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/RoundDamageStatsPanel.gd")

enum Panels {
	ROUND,
	TOWER_INFO,
	ROUND_DAMAGE_STATS,
}

var panel_showing : int
var current_tower_showing : AbstractTower
var game_settings_manager setget set_game_settings_manager

onready var tower_info_panel : TowerInfoPanel = $TowerInfoPanel
onready var round_status_panel : RoundStatusPanel = $RoundStatusPanel
onready var round_damage_stats_panel : RoundDamageStatsPanel = $RoundDamageStatsPanel

#

func set_game_settings_manager(arg_manager):
	game_settings_manager = arg_manager
	
	round_status_panel.game_settings_manager = arg_manager

#

func _ready():
	show_round_panel()


func show_round_panel():
	# Tower Info
	tower_info_panel.set_visible(false)
	
	if is_instance_valid(current_tower_showing):
		if current_tower_showing.is_showing_ranges:
			current_tower_showing.toggle_module_ranges()
	current_tower_showing = null
	
	# Round
	round_status_panel.visible = true
	panel_showing = Panels.ROUND
	
	# Round damage stats
	#round_damage_stats_panel.visible = false


func show_tower_info_panel(tower : AbstractTower = null):
	# Round
	round_status_panel.visible = false
	
	# Tower Info
	tower_info_panel.set_visible(true)
	tower_info_panel.tower = tower
	tower_info_panel.update_display()
	current_tower_showing = tower
	
	if !tower.is_showing_ranges:
		tower.toggle_module_ranges()
	panel_showing = Panels.TOWER_INFO
	
	# Round damage stats
	#round_damage_stats_panel.visible = false


func show_round_damage_stats_panel():
	# Tower Info
	tower_info_panel.set_visible(false)
	
	if is_instance_valid(current_tower_showing):
		if current_tower_showing.is_showing_ranges:
			current_tower_showing.toggle_module_ranges()
	current_tower_showing = null
	
	# Round
	round_status_panel.visible = false
	
	# Round damage stats
	#round_damage_stats_panel.visible = true
	round_damage_stats_panel.show_multiple_tower_rdsp_only()
	
	#
	panel_showing = Panels.ROUND_DAMAGE_STATS


#

func show_default_panel():
	show_round_panel()


#

func get_heart_icon_global_pos_of_round_info_panel():
	return round_status_panel.get_heart_icon_global_pos()

