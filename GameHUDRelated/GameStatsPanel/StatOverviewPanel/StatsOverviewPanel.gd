extends MarginContainer

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
const BaseTowerSpecificTooltip_GreenHeader_Pic = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip_HeaderBackground_Green.png")
const CustomButtonGroup = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/ButtonGroup.gd")

const HeartIcon = preload("res://GameHUDRelated/GameStatsPanel/shared/Assets/PlayerHealthHeart_20x20.png")
const GoldIcon = preload("res://GameHUDRelated/GameStatsPanel/shared/Assets/GoldIcon_20x20.png")

signal done_with_setup()

enum StatAtGraphShown {
	HEALTH = 1,
	GOLD = 2,
}


var _current_stat_shown_at_graph : int

var _stat_overview
var _game_stats_manager

var is_done_with_setup : bool = false
var _setup_thread
var _setup_thread_constructed : bool = false

var _current_tooltip : BaseTowerSpecificTooltip

var button_group : CustomButtonGroup

#

onready var stageround_linegraph = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/StageRoundLineGraphPanel
onready var stageround_linegraph_label = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/GraphLabel
onready var stageround_linegraph_icon = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/GraphIcon

onready var stat_health_button = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/MarginContainer/VBoxContainer/Stat_HealthButton
onready var stat_gold_button = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/MarginContainer/VBoxContainer/Stat_GoldButton

onready var tier_related_stats_panel = $VBoxContainer/MarginContainer/HBoxContainer2/TierRelatedStatsPanel
onready var game_end_stats_panel = $VBoxContainer/MarginContainer/HBoxContainer2/GameEndStatsPanel

#

func set_stat_overview__and_update(arg_game_stat_manager, arg_stat_overview):
	_game_stats_manager = arg_game_stat_manager
	_stat_overview = arg_stat_overview
	
	#_update_displays__threaded(null)
	if !_setup_thread_constructed:
		_setup_thread = Thread.new()
		_setup_thread_constructed = true
		_setup_thread.start(self, "_update_displays__threaded")


func _update_displays__threaded(arg_userdata):
	#_update_displays()
	stat_health_button.set_is_toggle_mode_on(true)
	
	tier_related_stats_panel.stat_overview = _stat_overview
	tier_related_stats_panel.update_display()
	
	game_end_stats_panel.stat_overview = _stat_overview
	game_end_stats_panel.update_display()
	
	is_done_with_setup = true
	emit_signal("done_with_setup")

func _update_displays():
	if _current_stat_shown_at_graph == StatAtGraphShown.HEALTH:
		_update_stage_round_graph__show_health()
	elif _current_stat_shown_at_graph == StatAtGraphShown.GOLD:
		_update_stage_round_graph__show_gold()


## line graph related

func _update_stage_round_graph__show_health():
	stageround_linegraph_label.text = _game_stats_manager.health_graph_name
	stageround_linegraph.set_stage_rounds_col_label_to_point_val_map({_game_stats_manager.health_line_label_of_col : _game_stats_manager.health_line_color}, _stat_overview.stage_round_data_points, _stat_overview.total_data_points_count, _stat_overview.highest_player_health_amount)
	stageround_linegraph_icon.texture = HeartIcon

func _update_stage_round_graph__show_gold():
	stageround_linegraph_label.text = _game_stats_manager.gold_graph_name
	stageround_linegraph.set_stage_rounds_col_label_to_point_val_map({_game_stats_manager.gold_line_label_of_col : _game_stats_manager.gold_line_color}, _stat_overview.stage_round_data_points, _stat_overview.total_data_points_count, _stat_overview.highest_player_gold_amount)
	stageround_linegraph_icon.texture = GoldIcon


func _on_linegraph_point_hovered(key, val, other_data, sprite_node):
	if !is_instance_valid(_current_tooltip):
		_current_tooltip = BaseTowerSpecificTooltip_Scene.instance()
		_current_tooltip.descriptions = _get_descriptions_for_tooltip(key, val, other_data)
		_current_tooltip.custom_header_texture = BaseTowerSpecificTooltip_GreenHeader_Pic
		_current_tooltip.visible = true
		_current_tooltip.tooltip_owner = sprite_node
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_current_tooltip)
		_current_tooltip.update_display()
	else:
		_current_tooltip.queue_free()
		_current_tooltip = null

func _on_linegraph_point_unhovered(key, val, other_data, sprite_node):
	if is_instance_valid(_current_tooltip) and !_current_tooltip.is_queued_for_deletion():
		_current_tooltip.queue_free()
		_current_tooltip = null


func _get_descriptions_for_tooltip(key, val, other_data):
	if _current_stat_shown_at_graph == StatAtGraphShown.HEALTH:
		return [
			"Stageround: %s" % other_data[1],
			"Health: %s" % val
		]
		
	elif _current_stat_shown_at_graph == StatAtGraphShown.GOLD:
		return [
			"Stageround: %s" % other_data[1],
			"Gold: %s" % val
		]


#

func _ready():
	stageround_linegraph.connect("point_on_graph_hovered", self, "_on_linegraph_point_hovered", [], CONNECT_PERSIST)
	stageround_linegraph.connect("point_on_graph_unhovered", self, "_on_linegraph_point_unhovered", [], CONNECT_PERSIST)
	
	button_group = CustomButtonGroup.new()
	stat_health_button.configure_self_with_button_group(button_group)
	stat_gold_button.configure_self_with_button_group(button_group)


func _exit_tree():
	if _setup_thread != null:
		_setup_thread.wait_to_finish()



########

func set_current_stat_shown_at_graph(arg_stat):
	var old_stat = _current_stat_shown_at_graph
	_current_stat_shown_at_graph = arg_stat
	
	if old_stat != _current_stat_shown_at_graph:
		_update_displays()



func _on_Stat_HealthButton_toggle_mode_changed(val):
	if val:
		set_current_stat_shown_at_graph(StatAtGraphShown.HEALTH)


func _on_Stat_GoldButton_toggle_mode_changed(val):
	if val:
		set_current_stat_shown_at_graph(StatAtGraphShown.GOLD)

