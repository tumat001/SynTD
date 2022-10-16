extends MarginContainer


onready var stats_overview_panel = $StatsOverviewPanel
onready var loading_stats_panel = $LoadingStatsPanel


var game_stats_manager setget set_game_stats_manager
var whole_screen_gui setget set_whole_screen_gui

var already_initialized : bool = false

#

func set_game_stats_manager(arg_manager):
	game_stats_manager = arg_manager

func set_whole_screen_gui(arg_gui):
	whole_screen_gui = arg_gui
	

#

func initialize_display():
	if game_stats_manager.is_stat_overview_construction_finished:
		if !already_initialized:
			_update_display()
			already_initialized = true
		
	else:
		if !game_stats_manager.is_connected("stat_overview_construction_finished", self, "update_display"):
			game_stats_manager.connect("stat_overview_construction_finished", self, "update_display", [], CONNECT_ONESHOT | CONNECT_DEFERRED)

func _update_display():
	stats_overview_panel.set_stat_overview__and_update(game_stats_manager, game_stats_manager.stat_overview)


#

func _ready():
	stats_overview_panel.connect("done_with_setup", self, "_on_stats_overview_panel__done_with_setup", [], CONNECT_PERSIST)
	
	loading_stats_panel.visible = true

func _on_stats_overview_panel__done_with_setup():
	loading_stats_panel.visible = false

#

func _on_BackButton_on_button_released_with_button_left():
	whole_screen_gui.hide_control(self)

