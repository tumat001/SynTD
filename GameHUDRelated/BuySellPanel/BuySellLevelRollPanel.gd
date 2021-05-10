extends MarginContainer

signal level_up
signal level_down
signal reroll
signal tower_bought(tower_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_RerollButton_pressed():
	emit_signal("reroll")

# Assuming that the array received is 5 in length
func update_new_rolled_towers(tower_ids_to_roll_to : Array):
	$HBoxContainer/BuySlotContainer/BuySlot01.roll_buy_card_to_tower_id(tower_ids_to_roll_to[0])
	$HBoxContainer/BuySlotContainer/BuySlot02.roll_buy_card_to_tower_id(tower_ids_to_roll_to[1])
	$HBoxContainer/BuySlotContainer/BuySlot03.roll_buy_card_to_tower_id(tower_ids_to_roll_to[2])
	$HBoxContainer/BuySlotContainer/BuySlot04.roll_buy_card_to_tower_id(tower_ids_to_roll_to[3])
	$HBoxContainer/BuySlotContainer/BuySlot05.roll_buy_card_to_tower_id(tower_ids_to_roll_to[4])

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


func _on_tower_bought(tower_id):
	emit_signal("tower_bought", tower_id)


#

func kill_all_tooltips_of_buycards():
	$HBoxContainer/BuySlotContainer/BuySlot01.kill_tooltip_of_tower_card()
	$HBoxContainer/BuySlotContainer/BuySlot02.kill_tooltip_of_tower_card()
	$HBoxContainer/BuySlotContainer/BuySlot03.kill_tooltip_of_tower_card()
	$HBoxContainer/BuySlotContainer/BuySlot04.kill_tooltip_of_tower_card()
	$HBoxContainer/BuySlotContainer/BuySlot05.kill_tooltip_of_tower_card()


