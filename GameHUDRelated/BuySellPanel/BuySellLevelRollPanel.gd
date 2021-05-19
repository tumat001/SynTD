extends MarginContainer

const TowerBuyCard = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCard.gd")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")

const Towers = preload("res://GameInfoRelated/Towers.gd")

signal level_up
signal level_down
signal reroll
signal tower_bought(tower_id)


var all_buy_slots : Array
onready var buy_slot_01 = $HBoxContainer/BuySlotContainer/BuySlot01
onready var buy_slot_02 = $HBoxContainer/BuySlotContainer/BuySlot02
onready var buy_slot_03 = $HBoxContainer/BuySlotContainer/BuySlot03
onready var buy_slot_04 = $HBoxContainer/BuySlotContainer/BuySlot04
onready var buy_slot_05 = $HBoxContainer/BuySlotContainer/BuySlot05

var gold_manager : GoldManager

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
	$HBoxContainer/BuySlotContainer/BuySlot01.roll_buy_card_to_tower_id(tower_ids_to_roll_to[0])
	$HBoxContainer/BuySlotContainer/BuySlot02.roll_buy_card_to_tower_id(tower_ids_to_roll_to[1])
	$HBoxContainer/BuySlotContainer/BuySlot03.roll_buy_card_to_tower_id(tower_ids_to_roll_to[2])
	$HBoxContainer/BuySlotContainer/BuySlot04.roll_buy_card_to_tower_id(tower_ids_to_roll_to[3])
	$HBoxContainer/BuySlotContainer/BuySlot05.roll_buy_card_to_tower_id(tower_ids_to_roll_to[4])
	
	_update_tower_cards_buyability_based_on_gold(gold_manager.current_gold)

func update_level_up_cost(new_cost : int):
	$HBoxContainer/LevelRerollContainer/HBoxContainer/LevelUpPanel/HBoxContainer/MarginContainer2/LevelUpCostLabel.text = str(new_cost)

func update_level_down_cost(new_cost : int):
	$HBoxContainer/LevelRerollContainer/HBoxContainer/LevelDownPanel/HBoxContainer/MarginContainer2/LevelDownCostLabel.text = str(new_cost)

func update_reroll_cost(new_cost : int):
	$HBoxContainer/LevelRerollContainer/RerollPanel/HBoxContainer/MarginContainer2/RerollCostLabel.text = str(new_cost)

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
	

