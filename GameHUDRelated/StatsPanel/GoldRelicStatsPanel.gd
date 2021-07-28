extends MarginContainer


var game_elements
var gold_manager setget set_gold_manager
var relic_manager setget set_relic_manager
var shop_manager setget set_shop_manager
var level_manager setget set_level_manager

onready var gold_amount_label = $GoldPanel/MarginContainer3/MarginContainer2/GoldAmountLabel

# setters

func set_gold_manager(arg_manager):
	gold_manager = arg_manager
	
	gold_manager.connect("current_gold_changed", self, "set_gold_amount_label", [], CONNECT_PERSIST)
	set_gold_amount_label(gold_manager.current_gold)

func set_relic_manager(arg_manager):
	relic_manager = arg_manager

func set_shop_manager(arg_manager):
	shop_manager = arg_manager

func set_level_manager(arg_manager):
	level_manager = arg_manager



# updating of stuffs

func set_gold_amount_label(new_amount):
	gold_amount_label.text = str(new_amount)

func set_relic_amount_label(new_amount):
	pass
