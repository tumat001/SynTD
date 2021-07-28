extends Node

const Towers = preload("res://GameInfoRelated/Towers.gd")
const BuySellLevelRollPanel = preload("res://GameHUDRelated/BuySellPanel/BuySellLevelRollPanel.gd")
const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")

const base_level_tier_roll_probabilities : Dictionary = {
	LevelManager.LEVEL_1 : [100, 0, 0, 0, 0, 0],
	LevelManager.LEVEL_2 : [90, 10, 0, 0, 0, 0],
	LevelManager.LEVEL_3 : [85, 15, 0, 0, 0, 0],
	LevelManager.LEVEL_4 : [65, 25, 10, 0, 0, 0],
	LevelManager.LEVEL_5 : [40, 40, 20, 0, 0, 0],
	LevelManager.LEVEL_6 : [25, 35, 40, 0, 0, 0],
	LevelManager.LEVEL_7 : [10, 35, 48, 7, 0, 0],
	LevelManager.LEVEL_8 : [10, 15, 40, 30, 5, 0],
	LevelManager.LEVEL_9 : [10, 10, 20, 40, 20, 0],
	LevelManager.LEVEL_10 : [5, 5, 5, 30, 30, 25],
}

#

const base_tower_tier_stock : Dictionary = {
	1 : 16,
	2 : 14,
	3 : 12,
	4 : 7,
	5 : 5,
	6 : 2
}

const tower_stock_amount_exceptions : Dictionary = {
	#Towers.HERO : 1
}

const blacklisted_towers_to_inventory : Array = [
	Towers.FRUIT_TREE_FRUIT
]


var current_tower_stock_inventory : Dictionary = {
	
}

var tier_tower_map : Dictionary = {
	1 : [],
	2 : [],
	3 : [],
	4 : [],
	5 : [],
	6 : []
}


#

var game_elements
var buy_sell_level_roll_panel : BuySellLevelRollPanel
var stage_round_manager setget set_stage_round_manager
var level_manager setget set_level_manager
var tower_manager setget set_tower_manager

var tier_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.TIER)
var roll_towers_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.ROLL_TOWERS)

# setters

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end_game_start_aware", [], CONNECT_PERSIST)

func set_level_manager(arg_manager):
	level_manager = arg_manager

func set_tower_manager(arg_manager):
	tower_manager = arg_manager
	
	tower_manager.connect("tower_being_sold", self, "_on_tower_being_sold", [], CONNECT_PERSIST)

#

func _ready():
	for tower_id in Towers.TowerTiersMap.keys():
		if !blacklisted_towers_to_inventory.has(tower_id):
			_add_tower_to_inventory(tower_id, Towers.TowerTiersMap[tower_id])
			_register_tower_to_tower_tier_map(tower_id, Towers.TowerTiersMap[tower_id])


func _add_tower_to_inventory(tower_id : int, tower_tier : int):
	if tower_stock_amount_exceptions.has(tower_id):
		current_tower_stock_inventory[tower_id] = tower_stock_amount_exceptions[tower_id]
	else:
		current_tower_stock_inventory[tower_id] = base_tower_tier_stock[tower_tier]

func _register_tower_to_tower_tier_map(tower_id : int, tower_tier : int):
	tier_tower_map[tower_tier].append(tower_id)


# on round end

func _on_round_end_game_start_aware(curr_stageround, is_game_start):
	roll_towers_in_shop()


# roll related

func roll_towers_in_shop(level_of_roll : int = level_manager.current_level):
	for tower_id in buy_sell_level_roll_panel.get_all_unbought_tower_ids():
		_add_stock_to_tower_id(tower_id, 1)
	
	var tower_ids : Array = []
	for i in 5:
		tower_ids.append(_determine_tower_id_to_be_rolled(level_of_roll))
	
	buy_sell_level_roll_panel.update_new_rolled_towers(tower_ids)


func _determine_tower_id_to_be_rolled(level_of_roll : int) -> int:
	var tier = _determine_tier_to_be_rolled(level_of_roll)
	var tower_id_to_roll : int = -1
	
	if tier != -1:
		var tower_ids_in_tier : Array = tier_tower_map[tier]
		_remove_tower_ids_with_no_available_inventory_from_array(tower_ids_in_tier)
		
		var tower_id_count_map : Dictionary = _get_tower_id_inventory_count_map(tower_ids_in_tier)
		var total_stock_count_of_towers : int = _get_total_inventory_count_of_towers(tower_id_count_map)
		var decided_tower_weight_rand : int = roll_towers_rng.randi_range(1, total_stock_count_of_towers)
		
		var accumu_weight : int
		for tower_id in tower_id_count_map.keys():
			accumu_weight += tower_id_count_map[tower_id]
			
			if accumu_weight >= decided_tower_weight_rand:
				tower_id_to_roll = tower_id
				break
	
	if tower_id_to_roll != -1:
		current_tower_stock_inventory[tower_id_to_roll] -= 1
	
	return tower_id_to_roll


func _determine_tier_to_be_rolled(level_of_roll : int) -> int:
	var tier_probabilities : Array = base_level_tier_roll_probabilities[level_of_roll]
	
	var decided_tier_weight_rand : int = tier_rng.randi_range(1, 100)
	
	var current_tier : int
	var accumu_weight : int
	for tier_weight in tier_probabilities:
		current_tier += 1
		accumu_weight += tier_weight
		
		if accumu_weight >= decided_tier_weight_rand:
			return current_tier
	
	# should not reach here
	return -1

func _remove_tower_ids_with_no_available_inventory_from_array(arg_tower_ids : Array):
	for tower_id in arg_tower_ids:
		var curr_inventory_amount : int = current_tower_stock_inventory[tower_id]
		if curr_inventory_amount <= 0:
			arg_tower_ids.erase(tower_id)


func _get_tower_id_inventory_count_map(arg_tower_ids : Array) -> Dictionary:
	var bucket : Dictionary = {}
	
	for tower_id in arg_tower_ids:
		bucket[tower_id] = current_tower_stock_inventory[tower_id]
	
	return bucket


func _get_total_inventory_count_of_towers(arg_tower_id_count_map : Dictionary) -> int:
	var total : int = 0
	
	for tower_count in arg_tower_id_count_map.values():
		total += tower_count
	
	return total


# tower stock related

func _add_stock_to_tower_id(tower_id : int, amount : int):
	if !blacklisted_towers_to_inventory.has(tower_id):
		current_tower_stock_inventory[tower_id] += amount


func _on_tower_being_sold(sellback, tower):
	var tower_id_being_sold = tower.tower_id
	var tower_ids_in_ingredients = tower.ingredients_absorbed.keys()
	
	_add_stock_to_tower_id(tower_id_being_sold, 1)
	for ids in tower_ids_in_ingredients:
		_add_stock_to_tower_id(ids, 1)


