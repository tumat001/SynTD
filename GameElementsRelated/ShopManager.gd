extends Node

const Towers = preload("res://GameInfoRelated/Towers.gd")
const BuySellLevelRollPanel = preload("res://GameHUDRelated/BuySellPanel/BuySellLevelRollPanel.gd")
const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")


signal on_effective_shop_odds_level_changed(new_level)
signal on_cost_per_roll_changed(new_cost)
signal can_roll_changed(can_roll)
signal shop_rolled_with_towers(arg_tower_ids)

const base_level_tier_roll_probabilities : Dictionary = {
	LevelManager.LEVEL_1 : [100, 0, 0, 0, 0, 0],
	LevelManager.LEVEL_2 : [90, 10, 0, 0, 0, 0],
	LevelManager.LEVEL_3 : [75, 25, 0, 0, 0, 0],
	LevelManager.LEVEL_4 : [55, 43, 2, 0, 0, 0],
	LevelManager.LEVEL_5 : [45, 35, 20, 0, 0, 0],
	LevelManager.LEVEL_6 : [23, 40, 35, 2, 0, 0],
	LevelManager.LEVEL_7 : [22, 30, 40, 7, 1, 0],
	LevelManager.LEVEL_8 : [15, 20, 33, 30, 2, 0],
	LevelManager.LEVEL_9 : [10, 15, 20, 35, 20, 0],
	LevelManager.LEVEL_10 : [5, 10, 10, 25, 25, 25],
	
	# Reachable by red syn -- prestige
	LevelManager.LEVEL_11 : [3, 5, 5, 15, 40, 32], 
	LevelManager.LEVEL_12 : [0, 0, 2, 13, 50, 35],
}

#

const base_tower_tier_stock : Dictionary = {
	1 : 18, # 20
	2 : 15, # 17
	3 : 10, # 11
	4 : 9,
	5 : 8,
	6 : 2 # 2 for exclusivity, x for combination. Decide what's best
}

# When a tower should have a different initial stock amount
const tower_stock_amount_exceptions : Dictionary = {
	#ex: Towers.HERO : 1
}

# When a tower should not appear in shop nor replenish stock (by selling)
const blacklisted_towers_to_inventory : Array = [
	Towers.FRUIT_TREE_FRUIT,
	
	Towers.LES_SEMIS,
	Towers.HEALING_SYMBOL,
	Towers.NIGHTWATCHER,
	Towers.VARIANCE_VESSEL,
	Towers.YELVIO_RIFT_AXIS,
	Towers.DUNED,
	
	#red towers
	Towers.OUTREACH, #6
	Towers.SOPHIST, #5
	Towers.TRUDGE, #4
	Towers.WYVERN, #4
	Towers.ENERVATE, #3
	Towers.FULGURANT, #3
	Towers.SOLITAR, #2
	Towers.BLAST, #2
	Towers.TRAPPER, #1
	
#	Towers.HEXTRIBUTE,
#	Towers.BLOSSOM,
#	Towers.ADEPT,
#	Towers.REAPER,
#	Towers.PROBE,
#	Towers.CHARGE,
#	Towers.TRANSMUTATOR,
#	Towers.SHOCKER,
#	Towers.STRIKER,
#	Towers.REBOUND,
	# end of red towers
	
]

const towers_not_initially_in_inventory : Array = [
	Towers.FRUIT_TREE_FRUIT,
	
	# Green special towers
	Towers.SE_PROPAGER,
	Towers.L_ASSAUT,
	Towers.LA_CHASSEUR,
	Towers.LA_NATURE,
	
	Towers.LES_SEMIS,
	Towers.HEALING_SYMBOL,
	Towers.NIGHTWATCHER,
	Towers.VARIANCE_VESSEL,
	Towers.YELVIO_RIFT_AXIS,
	Towers.DUNED,
	
	# red towers
	Towers.OUTREACH, #6
	Towers.SOPHIST, #5
	Towers.TRUDGE, #4
	Towers.WYVERN, #4
	Towers.ENERVATE, #3
	Towers.FULGURANT, #3
	Towers.SOLITAR, #2
	Towers.BLAST, #2
	Towers.TRAPPER, #1
	
#	Towers.HEXTRIBUTE,
#	Towers.BLOSSOM,
#	Towers.ADEPT,
#	Towers.REAPER,
#	Towers.PROBE,
#	Towers.CHARGE,
#	Towers.TRANSMUTATOR,
#	Towers.SHOCKER,
#	Towers.STRIKER,
#	Towers.REBOUND,
	# end of red towers
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


#

enum TowersPerShopModifiers {
	BASE_AMOUNT = 0,
	
	SYN_GREEN__HORTICULTURIST = 1,
	SYN_RED__PRESTIGE = 2,
	
	TUTORIAL = 1000,
}

enum ShopLevelOddsModifiers {
	SYN_RED__PRESTIGE = 1,
}


var _flat_towers_per_shop_id_to_amount_map : Dictionary = {}
var last_calculated_towers_per_shop : int
const max_towers_per_shop : int = 6

var _flat_shop_level_odd_modi_id_to_modi_map : Dictionary = {}
var last_calculated_shop_level_odd_modi : int
var last_calculated_effective_shop_level_odds : int

# clauses

enum CanRefreshShopClauses {
	TUTORIAL_DISABLE = 1000
}
var can_refresh_shop_clauses : ConditionalClauses
var last_calculated_can_refresh_shop : bool


enum CanRefreshShopAtRoundEndClauses {
	TUTORIAL_DISABLE = 1000
}
var can_refresh_shop_at_round_end_clauses : ConditionalClauses
var last_calculated_can_refresh_shop_at_round_end : bool


# setters

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end_game_start_aware", [], CONNECT_PERSIST)

func set_level_manager(arg_manager):
	level_manager = arg_manager
	
	level_manager.connect("on_current_level_changed", self, "_on_current_player_level_changed", [], CONNECT_PERSIST)

func set_tower_manager(arg_manager):
	tower_manager = arg_manager
	
	tower_manager.connect("tower_being_sold", self, "_on_tower_being_sold", [], CONNECT_PERSIST)
	tower_manager.connect("tower_being_absorbed_as_ingredient", self, "_on_tower_being_absorbed", [], CONNECT_PERSIST)

func set_gold_manager(arg_manager : GoldManager):
	gold_manager = arg_manager
	
	gold_manager.connect("current_gold_changed", self, "_emit_can_roll_changed", [], CONNECT_PERSIST)
	_update_last_calculated_can_refresh_shop()

func set_cost_per_roll(new_cost):
	current_cost_per_roll = new_cost
	
	_emit_can_roll_changed(-1)
	emit_signal("on_cost_per_roll_changed", new_cost)

#

func _ready():
	can_refresh_shop_clauses = ConditionalClauses.new()
	can_refresh_shop_clauses.connect("clause_inserted", self, "_on_can_refresh_shop_clauses_inserted_or_removed", [], CONNECT_PERSIST)
	can_refresh_shop_clauses.connect("clause_removed", self, "_on_can_refresh_shop_clauses_inserted_or_removed", [], CONNECT_PERSIST)
	
	can_refresh_shop_at_round_end_clauses = ConditionalClauses.new()
	can_refresh_shop_at_round_end_clauses.connect("clause_inserted", self, "_on_can_refresh_shop_at_round_end_clauses_inserted_or_removed", [], CONNECT_PERSIST)
	can_refresh_shop_at_round_end_clauses.connect("clause_removed", self, "_on_can_refresh_shop_at_round_end_clauses_inserted_or_removed", [], CONNECT_PERSIST)
	
	_update_last_calculated_effective_shop_level(true)
	_update_last_calculated_can_refresh_shop_at_round_end()


func finalize_towers_in_shop():
	for tower_id in Towers.TowerTiersMap.keys():
		if !towers_not_initially_in_inventory.has(tower_id):
			add_tower_to_inventory(tower_id, Towers.TowerTiersMap[tower_id])
	
	_update_tier_has_tower_map()


func add_tower_to_inventory(tower_id : int, tower_tier : int):
	if !current_tower_stock_inventory.has(tower_id):
		if tower_stock_amount_exceptions.has(tower_id):
			current_tower_stock_inventory[tower_id] = tower_stock_amount_exceptions[tower_id]
		else:
			current_tower_stock_inventory[tower_id] = base_tower_tier_stock[tower_tier]
	
	if !tier_tower_map.has(tower_id):
		tier_tower_map[tower_tier].append(tower_id)

func remove_tower_from_inventory(tower_id : int):
	if current_tower_stock_inventory.has(tower_id):
		current_tower_stock_inventory.erase(tower_id)
	
	if tier_tower_map.has(tower_id):
		tier_tower_map[Towers.TowerTiersMap[tower_id]].erase(tower_id)

# on round end

func _on_round_end_game_start_aware(curr_stageround, is_game_start):
	if last_calculated_can_refresh_shop_at_round_end:
		call_deferred("roll_towers_in_shop")


# towers per refresh

func add_towers_per_refresh_amount_modifier(id : int, amount : int):
	_flat_towers_per_shop_id_to_amount_map[id] = amount
	
	_set_final_towers_per_refresh(_calculate_final_towers_per_refresh())
	
func remove_towers_per_refresh_amount_modifier(id : int):
	_flat_towers_per_shop_id_to_amount_map.erase(id)
	
	_set_final_towers_per_refresh(_calculate_final_towers_per_refresh())


func _calculate_final_towers_per_refresh() -> int:
	var amount = 0
	
	for x in _flat_towers_per_shop_id_to_amount_map.values():
		amount += x
	
	if amount > max_towers_per_shop:
		amount = max_towers_per_shop
	
	return amount

func _set_final_towers_per_refresh(arg_new_val : int):
	last_calculated_towers_per_shop = arg_new_val


# shop odds related

func add_shop_level_odds_modi(id : int, amount : int):
	_flat_shop_level_odd_modi_id_to_modi_map[id] = amount
	
	_set_shop_level_odds_modifier(_calculate_shop_level_odds_modifier())
	
	_update_last_calculated_effective_shop_level()
	emit_signal("on_effective_shop_odds_level_changed", last_calculated_effective_shop_level_odds)


func remove_shop_level_odds_modi_id(id : int):
	_flat_shop_level_odd_modi_id_to_modi_map.erase(id)
	
	_set_shop_level_odds_modifier(_calculate_shop_level_odds_modifier())
	
	_update_last_calculated_effective_shop_level()
	emit_signal("on_effective_shop_odds_level_changed", last_calculated_effective_shop_level_odds)


func _calculate_shop_level_odds_modifier() -> int:
	var amount = 0
	
	for x in _flat_shop_level_odd_modi_id_to_modi_map.values():
		amount += x
	
	return amount

func _set_shop_level_odds_modifier(amount : int):
	last_calculated_shop_level_odd_modi = amount



func _on_current_player_level_changed(arg_new_level):
	_update_last_calculated_effective_shop_level(true)

func _update_last_calculated_effective_shop_level(_emit_change_signal : bool = false):
	last_calculated_effective_shop_level_odds = _calculate_last_calculated_effective_shop_level()
	if _emit_change_signal:
		emit_signal("on_effective_shop_odds_level_changed", last_calculated_effective_shop_level_odds)

func _calculate_last_calculated_effective_shop_level() -> int:
	var level = 1
	
	if level_manager != null:
		level = level_manager.current_level
	
	return level + last_calculated_shop_level_odd_modi


# roll related

func _emit_can_roll_changed(_new_val):
	#emit_signal("can_roll_changed", if_can_roll())
	_update_last_calculated_can_refresh_shop()


func roll_towers_in_shop_with_cost(level_of_roll : int = last_calculated_effective_shop_level_odds, arg_cost : int = current_cost_per_roll):
	if if_can_roll():
		roll_towers_in_shop(level_of_roll)
		gold_manager.decrease_gold_by(arg_cost, GoldManager.DecreaseGoldSource.SHOP_ROLL)
		

func if_can_roll() -> bool:
	if can_refresh_shop_clauses.is_passed:
		return gold_manager.current_gold >= current_cost_per_roll 
	
	return false

func roll_towers_in_shop(level_of_roll : int = last_calculated_effective_shop_level_odds):
	for tower_id in buy_sell_level_roll_panel.get_all_unbought_tower_ids():
		_add_stock_to_tower_id(tower_id, 1)
	
	var tower_ids : Array = []
	for i in last_calculated_towers_per_shop:
		tower_ids.append(_determine_tower_id_to_be_rolled_from_level_of_roll(level_of_roll))
	
	roll_towers_in_shop__specific_ids(tower_ids)

func roll_towers_in_shop__specific_ids(arg_tower_ids):
	buy_sell_level_roll_panel.update_new_rolled_towers(arg_tower_ids)
	emit_signal("shop_rolled_with_towers", arg_tower_ids)


func _determine_tower_id_to_be_rolled_from_level_of_roll(level_of_roll : int) -> int:
	var tier = _determine_tier_to_be_rolled(level_of_roll)
	return _determine_tower_id_to_be_rolled_from_tier(tier)

func _determine_tower_id_to_be_rolled_from_tier(arg_tier : int):
	var tower_id_to_roll : int = -1
	
	if arg_tier != -1:
		var tower_ids_in_tier : Array = tier_tower_map[arg_tier].duplicate()
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

func get_shop_roll_chances_at_level(current_level : int = last_calculated_effective_shop_level_odds):
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
		if current_tower_stock_inventory.has(tower_id):
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

# get random tower related

func create_random_tower_at_bench(arg_tier : int, arg_is_tower_bought : bool = false): # returns the created tower
	var rand_tower_id = _get_random_tower_id_with_stock_in_shop(arg_tier)
	return game_elements.tower_inventory_bench.insert_tower_from_last(rand_tower_id, arg_is_tower_bought)

func _get_random_tower_id_with_stock_in_shop(arg_tier : int):
	return _determine_tower_id_to_be_rolled_from_tier(arg_tier)
#	var tower_ids_in_tier : Array = tier_tower_map[arg_tier].duplicate()
#	_remove_tower_ids_with_no_available_inventory_from_array(tower_ids_in_tier)
#
#	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TOWER_DECIDER)
#	var rng_i = rng.randi_range(0, tower_ids_in_tier.size() - 1)
#
#	return tower_ids_in_tier[rng_i]


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
				if current_tower_stock_inventory.has(tower_id):
					var stock = current_tower_stock_inventory[tower_id]
					if stock > 0:
						tier_has_stock = true
						break
			
			tier_has_tower_map[tier] = tier_has_stock

#

func get_tower_tier_odds_at_player_level(arg_tower_tier, arg_player_level) -> float:
	var roll_prob = base_level_tier_roll_probabilities[arg_player_level]
	return roll_prob[arg_tower_tier - 1]


##

func _on_can_refresh_shop_clauses_inserted_or_removed(arg_clause):
	_update_last_calculated_can_refresh_shop()

func _update_last_calculated_can_refresh_shop():
	last_calculated_can_refresh_shop = if_can_roll()
	
	emit_signal("can_roll_changed", last_calculated_can_refresh_shop)


func _on_can_refresh_shop_at_round_end_clauses_inserted_or_removed(arg_clause):
	_update_last_calculated_can_refresh_shop_at_round_end()

func _update_last_calculated_can_refresh_shop_at_round_end():
	last_calculated_can_refresh_shop_at_round_end = can_refresh_shop_at_round_end_clauses.is_passed


### Manipulation of stock. May be used by game modifiers

func add_tower_id_to_blacklisted_towers_to_inventory(arg_id):
	if !blacklisted_towers_to_inventory.has(arg_id):
		blacklisted_towers_to_inventory.append(arg_id)

func remove_tower_id_from_blacklisted_towers_to_inventory(arg_id):
	blacklisted_towers_to_inventory.erase(arg_id)



func add_tower_id_to_towers_not_initially_in_inventory(arg_id):
	if !towers_not_initially_in_inventory.has(arg_id):
		towers_not_initially_in_inventory.append(arg_id)

func remove_tower_id_from_towers_not_initially_in_inventory(arg_id):
	towers_not_initially_in_inventory.erase(arg_id)


