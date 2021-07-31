extends MarginContainer


var game_elements
var gold_manager setget set_gold_manager
var relic_manager setget set_relic_manager
var shop_manager setget set_shop_manager
var level_manager setget set_level_manager

onready var gold_amount_label = $HBoxContainer/GoldPanel/MarginContainer3/MarginContainer2/GoldAmountLabel
onready var level_label = $HBoxContainer/LeftSide/LevelPanel/MarginContainer3/MarginContainer2/LevelLabel
onready var relic_label = $HBoxContainer/RelicPanel/MarginContainer3/MarginContainer2/RelicAmountLabel
onready var shop_percentage_stat_panel = $HBoxContainer/LeftSide/ShopPercentStatsPanel

onready var relic_panel = $HBoxContainer/RelicPanel

# setters

func set_gold_manager(arg_manager):
	gold_manager = arg_manager
	
	gold_manager.connect("current_gold_changed", self, "set_gold_amount_label", [], CONNECT_PERSIST)
	set_gold_amount_label(gold_manager.current_gold)

func set_relic_manager(arg_manager):
	relic_manager = arg_manager
	
	relic_manager.connect("current_relic_count_changed", self, "set_relic_amount_label", [], CONNECT_PERSIST)
	set_relic_amount_label(relic_manager.current_relic_count)

func set_shop_manager(arg_manager):
	shop_manager = arg_manager
	shop_percentage_stat_panel.shop_manager = shop_manager

func set_level_manager(arg_manager):
	level_manager = arg_manager
	
	level_manager.connect("on_current_level_changed", self, "set_level_label", [], CONNECT_PERSIST)
	set_level_label(level_manager.current_level)
	shop_percentage_stat_panel.level_manager = level_manager


# updating of stuffs

func set_gold_amount_label(new_amount):
	gold_amount_label.text = str(new_amount)

func set_level_label(new_level):
	level_label.text = str(new_level)

func set_relic_amount_label(new_amount):
	relic_panel.visible = new_amount != 0
	relic_label.text = str(new_amount)
