extends Node

const Towers = preload("res://GameInfoRelated/Towers.gd")
const BuySellLevelRollPanel = preload("res://GameHUDRelated/BuySellPanel/BuySellLevelRollPanel.gd")
const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")


signal on_cost_per_roll_changed(new_cost)
signal can_roll_changed(can_roll)

const base_level_tier_roll_probabilities : Dictionary = {
	LevelManager.LEVEL_1 : [100, 0, 0, 0, 0, 0],
	LevelManager.LEVEL_2 : [90, 10, 0, 0, 0, 0],
	LevelManager.LEVEL_3 : [80, 20, 0, 0, 0, 0],
	LevelManager.LEVEL_4 : [55, 43, 2, 0, 0, 0],
	LevelManager.LEVEL_5 : [45, 35, 20, 0, 0, 0],
	LevelManager.LEVEL_6 : [23, 40, 35, 2, 0, 0],
	LevelManager.LEVEL_7 : [15, 30, 45, 9, 1, 0],
	LevelManager.LEVEL_8 : [15, 20, 30, 33, 2, 0],
	LevelManager.LEVEL_9 : [10, 15, 20, 35, 20, 0],
	LevelManager.LEVEL_10 : [5, 10, 10, 25, 25, 25],
}

#

const base_tower_tier_stock : Dictionary = {
	1 : 20,
	2 : 18,
	3 : 16,
	4 : 10,
	5 : 8,
	6 : 4 # Originally 2, but is made to 4 for combination
}

# When a tower should have a different initial stock amount
const tower_stock_amount_exceptions : Dictionary = {
	#Towers.HERO : 1
}

# When a tower should not appear in shop nor replenish stock (by selling)
const blacklisted_towers_to_inventory : Array = [
	Towers.FRUIT_TREE_FRUIT,
	
	Towers.LES_SEMIS
]

const towers_not_initially_in_inventory : Array = [
	Towers.FRUIT_TREE_FRUIT,
	
	Towers.SE_PROPAGER,
	Towers.L_ASSAUT,
	Towers.LA_CHASSEUR,
	Towers.LA_NATURE,
	
	Towers.LES_SEMIS
]

# tower id to amount map
var current_tower_stock_inventory : Dictionary = {}
var tier_tower_map : Dictionary = {
	1 : [],
	2 : [],
	3 : [],
	4 : [],
	5 : [],
	6 : []
}

# if the tier has at least 1 tower
var tier_has_tower_map : Dictionary = {
	1 : false,
	2 : false,
	3 : false,
	4 : false,
	5 : false,
	6 : false,
}


#

var game_elements
var buy_sell_level_roll_panel : BuySellLevelRollPanel
var stage_round_manager setget set_stage_round_manager
var level_manager setget set_level_manager
var tower_manager setget set_tower_manager
var gold_manager : GoldManager setget set_gold_manager

var tier_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.TIER)
var roll_towers_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.ROLL_TOWERS)

var current_cost_per_roll : int = 2 setget set_cost_per_roll


# setters

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end_game_start_aware", [], CONNECT_PERSIST)

func set_level_manager(arg_manager):
	level_manager = arg_manager

func set_tower_manager(arg_manager):
	tower_manager = arg_manager
	
	tower_manager.connect("tower_being_sold", self, "_on_tower_being_sold", [], CONNECT_PERSIST)
	tower_manager.connect("tower_being_absorbed_as_ingredient", self, "_on_tower_being_absorbed", [], CONNECT_PERSIST)

func set_gold_manager(arg_manager : GoldManager):
	gold_manager = arg_manager
	
	gold_manager.connect("current_gold_changed", self, "_emit_can_roll_changed", [], CONNECT_PERSIST)


func set_cost_per_roll(new_cost):
	current_cost_per_roll = new_cost
	
	_emit_can_roll_changed(-1)
	emit_signal("on_cost_per_roll_changed", new_cost)

#

func _ready():
	for tower_id in Towers.TowerTiersMap.keys():
		if !towers_not_initially_in_inventory.has(tower_id):
			_add_tower_to_inventory(tower_id, Towers.TowerTiersMap[tower_id])
			_register_tower_to_tower_tier_map(tower_id, Towers.TowerTiersMap[tower_id])
	
	_update_tier_has_tower_map()


func _add_tower_to_inventory(tower_id : int, tower_tier : int):
	if tower_stock_amount_exceptions.has(tower_id):
		current_tower_stock_inventory[tower_id] = tower_stock_amount_exceptions[tower_id]
	else:
		current_tower_stock_inventory[tower_id] = base_tower_tier_stock[tower_tier]

func _register_tower_to_tower_tier_map(tower_id : int, tower_tier : int):
	tier_tower_map[tower_tier].append(tower_id)


# on round end

func _on_round_end_game_start_aware(curr_stageround, is_game_start):
	call_deferred("roll_towers_in_shop")


# roll related

func _emit_can_roll_changed(_new_val):
	emit_signal("can_roll_changed", if_can_roll())


func roll_towers_in_shop_with_cost(level_of_roll : int = level_manager.current_level, arg_cost : int = current_cost_per_roll):
	if if_can_roll():
		roll_towers_in_shop(level_of_roll)
		gold_manager.decrease_gold_by(arg_cost, GoldManager.DecreaseGoldSource.SHOP_ROLL)

func if_can_roll() -> bool:
	return gold_manager.current_gold >= current_cost_per_roll 


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
		_remove_stock_of_tower_id(tower_id_to_roll, 1)
	
	return tower_id_to_roll


func _determine_tier_to_be_rolled(level_of_roll : int) -> int:
	var tier_probabilities : Array = get_shop_roll_chances_at_level(level_of_roll)
	tier_probabilities = _get_effective_tier_probabilities(tier_probabilities)
	
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

func get_shop_roll_chances_at_level(current_level : int = level_manager.current_level):
	return base_level_tier_roll_probabilities[current_level]

func _get_effective_tier_probabilities(base_probabilities : Array):
	var final_probabilities : Array = []
	
	var carry_over_prob : float
	for i in range(0, base_probabilities.size()):
		var final_prob : float = 0
		
		if !_if_tower_in_tier_exists(i + 1):
			carry_over_prob += base_probabilities[i]
		else:
			final_prob = base_probabilities[i] + carry_over_prob
		
		final_probabilities.append(final_prob)
	
	if carry_over_prob > 0:
		for i in range(base_probabilities.size() - 2, -1, -1):
			if !_if_tower_in_tier_exists(i + 1):
				continue
			else:
				final_probabilities[i] += carry_over_prob
				break
	
	return final_probabilities


func _if_tower_in_tier_exists(tier : int) -> bool:
	return tier_has_tower_map[tier];



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
	if !blacklisted_towers_to_inventory.has(tower_id) and current_tower_stock_inventory.has(tower_id):
		current_tower_stock_inventory[tower_id] += amount
		_update_tier_has_tower_map_tower_id_affected(tower_id, true)


func _on_tower_being_sold(sellback, tower):
	var tower_id_being_sold = tower.tower_id
	var tower_ids_in_ingredients = tower.ingredients_absorbed.keys()
	
	_add_stock_to_tower_id(tower_id_being_sold, 1)
	for ids in tower_ids_in_ingredients:
		_add_stock_to_tower_id(ids, 1)

func _on_tower_being_absorbed(tower):
	var tower_ids_in_ingredients = tower.ingredients_absorbed.keys()
	
	for ids in tower_ids_in_ingredients:
		_add_stock_to_tower_id(ids, 1)


func _remove_stock_of_tower_id(tower_id : int, amount : int):
	current_tower_stock_inventory[tower_id] -= amount
	_update_tier_has_tower_map_tower_id_affected(tower_id, false)

# 

func _update_tier_has_tower_map_tower_id_affected(tower_id : int, is_add : bool):
	_update_tier_has_tower_map([_get_tier_of_tower_id(tower_id)], is_add)

func _get_tier_of_tower_id(tower_id) -> int:
	return Towers.TowerTiersMap[tower_id]


func _update_tier_has_tower_map(tiers : Array = tier_has_tower_map.keys(), is_add : bool = false):
	if is_add:
		for tier in tiers:
			tier_has_tower_map[tier] = true
		
	else:
		for tier in tiers:
			var tier_has_stock : bool = false
			
			for tower_id in Towers.TowerTiersMap.keys():
				var stock = current_tower_stock_inventory[tower_id]
				if stock > 0:
					tier_has_stock = true
					break
			
			tier_has_tower_map[tier] = tier_has_stock

