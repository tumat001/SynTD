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

var all_buy_slots : Array
onready var buy_slot_01 = $HBoxContainer/BuySlotContainer/BuySlot01
onready var buy_slot_02 = $HBoxContainer/BuySlotContainer/BuySlot02
onready var buy_slot_03 = $HBoxContainer/BuySlotContainer/BuySlot03
onready var buy_slot_04 = $HBoxContainer/BuySlotContainer/BuySlot04
onready var buy_slot_05 = $HBoxContainer/BuySlotContainer/BuySlot05

onready var level_up_cost_label = $HBoxContainer/LevelRerollContainer/HBoxContainer/LevelUpPanel/HBoxContainer/MarginContainer2/LevelUpCostLabel
onready var reroll_cost_label = $HBoxContainer/LevelRerollContainer/RerollPanel/HBoxContainer/MarginContainer2/RerollCostLabel

var gold_manager : GoldManager
var relic_manager : RelicManager


# Called when the node enters the scene tree for the first time.
func _ready():
	all_buy_slots.append(buy_slot_01)
	all_buy_slots.append(buy_slot_02)
	all_buy_slots.append(buy_slot_03)
	all_buy_slots.append(buy_slot_04)
	all_buy_slots.append(buy_slot_05)


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

func update_level_up_gold_cost(new_cost : int):
	level_up_cost_label.text = str(new_cost)
	level_up_cost_label.add_color_override("font_color", gold_cost_color)

func update_reroll_gold_cost(new_cost : int):
	reroll_cost_label.text = str(new_cost)
	reroll_cost_label.add_color_override("font_color", gold_cost_color)


func update_level_up_relic_cost(new_cost : int):
	level_up_cost_label.text = str(new_cost)
	level_up_cost_label.add_color_override("font_color", relic_cost_color)

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
			tower_card._update_display_based_on_gold(current_gold)


#

func kill_all_tooltips_of_buycards():
	for buy_slot in all_buy_slots:
		buy_slot.kill_tooltip_of_tower_card()
	

