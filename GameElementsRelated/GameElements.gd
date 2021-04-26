extends Node

const BuySellLevelRollPanel = preload("res://GameHUDRelated/BuySellPanel/BuySellLevelRollPanel.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")

var panel_buy_sell_level_roll : BuySellLevelRollPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	panel_buy_sell_level_roll = $BottomPanel/VBoxContainer/HBoxContainer/BuySellLevelRollPanel
	$TowerInventoryBench.tower_manager = $TowerManager
	$TowerManager.tower_inventory_bench = $TowerInventoryBench


# From bottom panel
func _on_BuySellLevelRollPanel_level_down():
	pass # Replace with function body.


func _on_BuySellLevelRollPanel_level_up():
	pass # Replace with function body.


func _on_BuySellLevelRollPanel_reroll():
	# TODO REPLACE THIS SOON
	$BottomPanel/VBoxContainer/HBoxContainer/BuySellLevelRollPanel.update_new_rolled_towers([
		Towers.MONO,
		Towers.MONO,
		Towers.MONO,
		Towers.MONO,
		Towers.MONO
	])


func _on_BuySellLevelRollPanel_tower_bought(tower_id):
	if !$TowerInventoryBench.is_bench_full():
		$TowerInventoryBench.insert_tower(tower_id)

