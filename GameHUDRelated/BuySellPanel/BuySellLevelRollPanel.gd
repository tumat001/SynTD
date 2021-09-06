extends MarginContainer

const TowerBuyCard = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCard.gd")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const RelicManager = preload("res://GameElementsRelated/RelicManager.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")

const Towers = preload("res://GameInfoRelated/Towers.gd")

signal level_up
signal level_down
signal reroll
signal tower_bought(tower_id)

const gold_cost_color : Color = Color(253.0/255.0, 192.0/255.0, 8.0/255.0, 1)
const relic_cost_color : Color = Color(30.0/255.0, 217.0/255.0, 2.0/255.0, 1)

const cannot_press_button_color : Color = Color(0.5, 0.5, 0.5, 1)
const can_press_button_color : Color = Color(1, 1, 1, 1)

var all_buy_slots : Array
onready var buy_slot_01 = $HBoxContainer/BuySlotContainer/BuySlot01
onready var buy_slot_02 = $HBoxContainer/BuySlotContainer/BuySlot02
onready var buy_slot_03 = $HBoxContainer/BuySlotContainer/BuySlot03
onready var buy_slot_04 = $HBoxContainer/BuySlotContainer/BuySlot04
onready var buy_slot_05 = $HBoxContainer/BuySlotContainer/BuySlot05

onready var level_up_cost_label = $HBoxContainer/LevelRerollContainer/HBoxContainer/LevelUpPanel/HBoxContainer/MarginContainer2/LevelUpCostLabel
onready var reroll_cost_label = $HBoxContainer/LevelRerollContainer/RerollPanel/HBoxContainer/MarginContainer2/RerollCostLabel

onready var level_up_cost_currency_icon = $HBoxContainer/LevelRerollContainer/HBoxContainer/LevelUpPanel/HBoxContainer/MarginContainer3/LevelUpCurrencyIcon

onready var level_up_button = $HBoxContainer/LevelRerollContainer/HBoxContainer/LevelUpPanel/LevelUpButton
onready var reroll_button = $HBoxContainer/LevelRerollContainer/RerollPanel/RerollButton
onready var level_up_panel = $HBoxContainer/LevelRerollContainer/HBoxContainer/LevelUpPanel
onready var reroll_panel = $HBoxContainer/LevelRerollContainer/RerollPanel
onready var relic_buy_etc_panel = $HBoxContainer/RelicBuyEtcPanel

var gold_manager : GoldManager
var relic_manager : RelicManager setget set_relic_manager
var level_manager setget set_level_manager
var shop_manager setget set_shop_manager
var tower_manager setget set_tower_manager

var tower_inventory_bench setget set_tower_inventory_bench

#

func set_level_manager(arg_manager):
	level_manager = arg_manager
	
	level_manager.connect("on_current_level_up_cost_amount_changed", self, "_level_cost_currency_changed", [], CONNECT_PERSIST)
	level_manager.connect("on_current_level_up_cost_currency_changed", self, "_level_cost_currency_changed", [], CONNECT_PERSIST)
	level_manager.connect("on_can_level_up_changed", self, "_can_level_up_changed", [], CONNECT_PERSIST)
	level_manager.connect("on_current_level_changed", self, "_on_current_level_changed", [], CONNECT_PERSIST)
	
	_level_cost_currency_changed(level_manager.current_level_up_cost)
	_can_level_up_changed(level_manager.can_level_up())
	_on_current_level_changed(level_manager.current_level)


func set_shop_manager(arg_manager):
	shop_manager = arg_manager
	
	shop_manager.connect("on_cost_per_roll_changed", self, "update_reroll_gold_cost", [], CONNECT_PERSIST)
	shop_manager.connect("can_roll_changed", self, "_can_roll_changed", [], CONNECT_PERSIST)
	update_reroll_gold_cost(shop_manager.current_cost_per_roll)


func set_tower_manager(arg_manager):
	tower_manager = arg_manager
	
	relic_buy_etc_panel.tower_manager = arg_manager

func set_relic_manager(arg_manager):
	relic_manager = arg_manager
	
	relic_buy_etc_panel.relic_manager = arg_manager

func set_tower_inventory_bench(arg_bench):
	tower_inventory_bench = arg_bench
	
	for slot in all_buy_slots:
		slot.tower_inventory_bench = tower_inventory_bench


# Called when the node enters the scene tree for the first time.
func _ready():
	all_buy_slots.append(buy_slot_01)
	all_buy_slots.append(buy_slot_02)
	all_buy_slots.append(buy_slot_03)
	all_buy_slots.append(buy_slot_04)
	all_buy_slots.append(buy_slot_05)
	
	for slot in all_buy_slots:
		slot.tower_inventory_bench = tower_inventory_bench




func _on_RerollButton_pressed():
	emit_signal("reroll")

# Assuming that the array received is 5 in length
func update_new_rolled_towers(tower_ids_to_roll_to : Array):
	buy_slot_01.roll_buy_card_to_tower_id(tower_ids_to_roll_to[0])
	buy_slot_02.roll_buy_card_to_tower_id(tower_ids_to_roll_to[1])
	buy_slot_03.roll_buy_card_to_tower_id(tower_ids_to_roll_to[2])
	buy_slot_04.roll_buy_card_to_tower_id(tower_ids_to_roll_to[3])
	buy_slot_05.roll_buy_card_to_tower_id(tower_ids_to_roll_to[4])
	
	_update_tower_cards_buyability_based_on_gold(gold_manager.current_gold)

func get_all_unbought_tower_ids() -> Array:
	var ids : Array = []
	
	for slot in all_buy_slots:
		if slot.current_child != null:
			ids.append(slot.current_child.tower_information.tower_type_id)
	
	return ids

#

func _level_cost_currency_changed(_val):
	if level_manager.current_level_up_currency == level_manager.Currency.GOLD:
		update_level_up_gold_cost(level_manager.current_level_up_cost)
	elif level_manager.current_level_up_currency == level_manager.Currency.RELIC:
		update_level_up_relic_cost(level_manager.current_level_up_cost)



func update_level_up_gold_cost(new_cost : int):
	level_up_cost_label.text = str(new_cost)
	level_up_cost_label.add_color_override("font_color", gold_cost_color)
	level_up_cost_currency_icon.texture = level_manager.get_currency_icon(level_manager.Currency.GOLD)

func update_level_up_relic_cost(new_cost : int):
	level_up_cost_label.text = str(new_cost)
	level_up_cost_label.add_color_override("font_color", relic_cost_color)
	level_up_cost_currency_icon.texture = level_manager.get_currency_icon(level_manager.Currency.RELIC)



func update_reroll_gold_cost(new_cost : int):
	reroll_cost_label.text = str(new_cost)
	reroll_cost_label.add_color_override("font_color", gold_cost_color)

func update_reroll_relic_cost(new_cost : int):
	reroll_cost_label.text = str(new_cost)
	reroll_cost_label.add_color_override("font_color", relic_cost_color)

#

func _on_LevelDownButton_pressed():
	emit_signal("level_down")


func _on_LevelUpButton_pressed():
	emit_signal("level_up")


func _on_tower_bought(tower_type_info : TowerTypeInformation):
	gold_manager.decrease_gold_by(tower_type_info.tower_cost, GoldManager.DecreaseGoldSource.TOWER_BUY)
	emit_signal("tower_bought", tower_type_info.tower_type_id)


# Gold updating related

func _update_tower_cards_buyability_based_on_gold(current_gold : int):
	for buy_slot in all_buy_slots:
		var tower_card = buy_slot.current_child
		
		if tower_card != null and tower_card is TowerBuyCard:
			tower_card.current_gold = current_gold
			tower_card._update_can_buy_card()

#

func kill_all_tooltips_of_buycards():
	for buy_slot in all_buy_slots:
		buy_slot.kill_tooltip_of_tower_card()
	

# button state related

func _can_level_up_changed(can_level_up):
	if can_level_up:
		level_up_button.disabled = false
		level_up_panel.modulate = can_press_button_color
	else:
		level_up_button.disabled = true
		level_up_panel.modulate = cannot_press_button_color

func _can_roll_changed(can_roll):
	if can_roll:
		reroll_button.disabled = false
		reroll_panel.modulate = can_press_button_color
	else:
		reroll_button.disabled = true
		reroll_panel.modulate = cannot_press_button_color


func _on_current_level_changed(curr_level : int):
	if curr_level == level_manager.LEVEL_1:
		reroll_panel.visible = false
		level_up_panel.visible = false
	else:
		reroll_panel.visible = true
		level_up_panel.visible = true
	
