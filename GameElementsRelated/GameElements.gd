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
var tower_inventory_bench
var tower_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	panel_buy_sell_level_roll = $BottomPanel/VBoxContainer/HBoxContainer/InnerBottomPanel/BuySellLevelRollPanel
	in_map_placables_manager = $MapManager/InMapPlacablesManager
	synergy_manager = $SynergyManager
	synergy_manager.left_panel = $LeftsidePanel
	inner_bottom_panel = $BottomPanel/VBoxContainer/HBoxContainer/InnerBottomPanel
	right_side_panel = $RightSidePanel
	tower_inventory_bench = $TowerInventoryBench
	tower_manager = $TowerManager
	
	tower_inventory_bench.tower_manager = tower_manager
	tower_manager.game_elements = self
	tower_manager.in_map_placables_manager = in_map_placables_manager
	
	tower_manager.tower_inventory_bench = tower_inventory_bench


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
	if !tower_inventory_bench.is_bench_full():
		tower_inventory_bench.insert_tower(tower_id)
