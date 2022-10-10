extends MarginContainer

const ShopManager = preload("res://GameElementsRelated/ShopManager.gd")
const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")

var shop_manager : ShopManager setget set_shop_manager
var level_manager : LevelManager setget set_level_manager

onready var tier01_label = $MarginContainer/MainContent/Tier01Container/Marginer/Tier01Label
onready var tier02_label = $MarginContainer/MainContent/Tier02Container/Marginer/Tier02Label
onready var tier03_label = $MarginContainer/MainContent/Tier03Container/Marginer/Tier03Label
onready var tier04_label = $MarginContainer/MainContent/Tier04Container/Marginer/Tier04Label
onready var tier05_label = $MarginContainer/MainContent/Tier05Container/Marginer/Tier05Label
onready var tier06_label = $MarginContainer/MainContent/Tier06Container/Marginer/Tier06Label

var labels_in_tier_order : Array = []

#

func _ready():
	labels_in_tier_order.append(tier01_label)
	labels_in_tier_order.append(tier02_label)
	labels_in_tier_order.append(tier03_label)
	labels_in_tier_order.append(tier04_label)
	labels_in_tier_order.append(tier05_label)
	labels_in_tier_order.append(tier06_label)

#

func set_shop_manager(arg_manager : ShopManager):
	shop_manager = arg_manager
	
	shop_manager.connect("on_effective_shop_odds_level_changed", self, "_on_effective_shop_level_odds_changed", [], CONNECT_PERSIST)
	_on_effective_shop_level_odds_changed(shop_manager.last_calculated_effective_shop_level_odds)

func set_level_manager(arg_manager : LevelManager):
	level_manager = arg_manager
	
	#level_manager.connect("on_current_level_changed", self, "_on_level_changed", [], CONNECT_PERSIST)
	#_on_level_changed(level_manager.current_level)

#

#func _on_level_changed(_new_level):
#	if shop_manager != null:
#		var probabilities : Array = shop_manager.get_shop_roll_chances_at_level()
#
#		for i in 6:
#			labels_in_tier_order[i].text = (str(probabilities[i]) + "%")


func _on_effective_shop_level_odds_changed(new_lvl_odds):
	if is_instance_valid(shop_manager):
		var probabilities : Array = shop_manager.get_shop_roll_chances_at_level()
		
		for i in 6:
			labels_in_tier_order[i].text = (str(probabilities[i]) + "%")

