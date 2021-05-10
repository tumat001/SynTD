extends Node

const BuySellLevelRollPanel = preload("res://GameHUDRelated/BuySellPanel/BuySellLevelRollPanel.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const InMapPlacablesManager = preload("res://GameElementsRelated/InMapPlacablesManager.gd")
const SynergyManager = preload("res://GameElementsRelated/SynergyManager.gd")
const InnerBottomPanel = preload("res://GameElementsRelated/InnerBottomPanel.gd")
const RightSidePanel = preload("res://GameHUDRelated/RightSidePanel/RightSidePanel.gd")


var panel_buy_sell_level_roll : BuySellLevelRollPanel
var in_map_placables_manager : InMapPlacablesManager
var synergy_manager : SynergyManager
var inner_bottom_panel : InnerBottomPanel
var right_side_panel : RightSidePanel

# Called when the node enters the scene tree for the first time.
func _ready():
	panel_buy_sell_level_roll = $BottomPanel/VBoxContainer/HBoxContainer/InnerBottomPanel/BuySellLevelRollPanel
	in_map_placables_manager = $MapManager/InMapPlacablesManager
	synergy_manager = $SynergyManager
	synergy_manager.left_panel = $LeftsidePanel
	inner_bottom_panel = $BottomPanel/VBoxContainer/HBoxContainer/InnerBottomPanel
	right_side_panel = $RightSidePanel
	
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
	$BottomPanel/VBoxContainer/HBoxContainer/InnerBottomPanel/BuySellLevelRollPanel.update_new_rolled_towers([
		Towers.RAILGUN,
		Towers.SPRINKLER,
		Towers.SIMPLEX,
		Towers.SIMPLE_OBELISK,
		Towers.BERRY_BUSH
	])


func _on_BuySellLevelRollPanel_tower_bought(tower_id):
	if !$TowerInventoryBench.is_bench_full():
		$TowerInventoryBench.insert_tower(tower_id)
