extends Node

const BuySellLevelRollPanel = preload("res://GameHUDRelated/BuySellPanel/BuySellLevelRollPanel.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const InMapPlacablesManager = preload("res://GameElementsRelated/InMapPlacablesManager.gd")
const SynergyManager = preload("res://GameElementsRelated/SynergyManager.gd")

var panel_buy_sell_level_roll : BuySellLevelRollPanel
var in_map_placables_manager : InMapPlacablesManager
var synergy_manager : SynergyManager

# Called when the node enters the scene tree for the first time.
func _ready():
	panel_buy_sell_level_roll = $BottomPanel/VBoxContainer/HBoxContainer/BuySellLevelRollPanel
	in_map_placables_manager = $MapManager/InMapPlacablesManager
	synergy_manager = $SynergyManager
	synergy_manager.left_panel = $LeftsidePanel
	
	$TowerInventoryBench.tower_manager = $TowerManager
	$TowerManager.game_elements = self
	$TowerManager.in_map_placables_manager = in_map_placables_manager
	
	$TowerManager.tower_inventory_bench = $TowerInventoryBench


# From bottom panel
func _on_BuySellLevelRollPanel_level_down():
	pass


func _on_BuySellLevelRollPanel_level_up():
	pass


func _on_BuySellLevelRollPanel_reroll():
	# TODO REPLACE THIS SOON
	$BottomPanel/VBoxContainer/HBoxContainer/BuySellLevelRollPanel.update_new_rolled_towers([
		Towers.SPRINKLER,
		Towers.MONO,
		Towers.MONO,
		Towers.SIMPLE_OBELISK,
		Towers.BERRY_BUSH
	])


func _on_BuySellLevelRollPanel_tower_bought(tower_id):
	if !$TowerInventoryBench.is_bench_full():
		$TowerInventoryBench.insert_tower(tower_id)

