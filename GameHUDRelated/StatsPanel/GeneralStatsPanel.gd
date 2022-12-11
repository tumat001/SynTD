extends MarginContainer

const BaseTooltip = preload("res://GameHUDRelated/Tooltips/BaseTooltip.gd")
const GoldIncomeTooltip = preload("res://GameHUDRelated/StatsPanel/GoldIncomeTooltip.gd")
const GoldIncomeTooltip_Scene = preload("res://GameHUDRelated/StatsPanel/GoldIncomeTooltip.tscn")


var game_elements
var gold_manager setget set_gold_manager
var relic_manager setget set_relic_manager
var shop_manager setget set_shop_manager
var level_manager setget set_level_manager
var stage_round_manager setget set_stage_round_manager
var right_side_panel setget set_right_side_panel


onready var gold_amount_label = $HBoxContainer/Middle/GoldPanel/MarginContainer3/HBoxContainer/MarginContainer2/GoldAmountLabel
onready var gold_button = $HBoxContainer/Middle/GoldPanel/GoldButton

onready var streak_panel = $HBoxContainer/Middle/StreakPanel

onready var level_label = $HBoxContainer/LeftSide/LevelPanel/MarginContainer3/MarginContainer2/LevelLabel
onready var relic_label = $HBoxContainer/Right/RelicPanel/MarginContainer3/HBoxContainer/MarginContainer2/RelicAmountLabel
onready var shop_percentage_stat_panel = $HBoxContainer/LeftSide/ShopPercentStatsPanel

onready var relic_panel = $HBoxContainer/Right/RelicPanel
onready var round_damage_stats_button = $HBoxContainer/Right/RoundDamageStatsButton

onready var relic_general_store_button = $HBoxContainer/Right/RelicGeneralStoreButton

# setters

func set_gold_manager(arg_manager):
	gold_manager = arg_manager
	
	gold_manager.connect("current_gold_changed", self, "set_gold_amount_label", [], CONNECT_PERSIST)
	set_gold_amount_label(gold_manager.current_gold)

func set_relic_manager(arg_manager):
	relic_manager = arg_manager
	
	relic_manager.connect("current_relic_count_changed", self, "_on_current_relic_amount_changed", [], CONNECT_PERSIST)
	_on_current_relic_amount_changed(relic_manager.current_relic_count)
	#set_relic_amount_label(relic_manager.current_relic_count)

func set_shop_manager(arg_manager):
	shop_manager = arg_manager
	shop_percentage_stat_panel.shop_manager = shop_manager

func set_level_manager(arg_manager):
	level_manager = arg_manager
	
	level_manager.connect("on_current_level_changed", self, "set_level_label", [], CONNECT_PERSIST)
	set_level_label(level_manager.current_level)
	shop_percentage_stat_panel.level_manager = level_manager

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	streak_panel.stage_round_manager = stage_round_manager

func set_right_side_panel(arg_panel):
	right_side_panel = arg_panel
	
	round_damage_stats_button.right_side_panel = right_side_panel


# updating of stuffs

func set_gold_amount_label(new_amount):
	gold_amount_label.text = str(new_amount)

func set_level_label(new_level):
	level_label.text = str(new_level)


func _on_current_relic_amount_changed(arg_new_amount):
	set_relic_amount_label(arg_new_amount)
	set_relic_general_store_button_visibility(arg_new_amount)

func set_relic_amount_label(new_amount):
	relic_panel.visible = new_amount != 0
	relic_label.text = str(new_amount)

func set_relic_general_store_button_visibility(arg_relic_amount):
	relic_general_store_button.visible = relic_manager._has_received_at_least_one_relic and arg_relic_amount <= 0


# gold income tooltip


func _on_GoldButton_about_tooltip_construction_requested():
	var tooltip = GoldIncomeTooltip_Scene.instance()
	tooltip.gold_manager = gold_manager
	
	gold_button.display_requested_about_tooltip(tooltip)



###


func _on_RelicGeneralStoreButton_pressed_mouse_event(event):
	relic_manager.show_whole_screen_relic_general_store_panel()


