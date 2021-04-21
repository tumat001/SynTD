extends Node

const BuySellLevelRollPanel = preload("res://GameHUDRelated/BuySellPanel/BuySellLevelRollPanel.gd")

var panel_buy_sell_level_roll : BuySellLevelRollPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	panel_buy_sell_level_roll = $BottomPanel/VBoxContainer/HBoxContainer/BuySellLevelRollPanel
	


# From bottom panel
func _on_BuySellLevelRollPanel_level_down():
	pass # Replace with function body.


func _on_BuySellLevelRollPanel_level_up():
	pass # Replace with function body.


func _on_BuySellLevelRollPanel_reroll():
	pass # Replace with function body.


func _on_BuySellLevelRollPanel_tower_bought(tower_id):
	pass
