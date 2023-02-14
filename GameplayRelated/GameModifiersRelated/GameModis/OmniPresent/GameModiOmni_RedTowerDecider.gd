extends "res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")
const ShopManager = preload("res://GameElementsRelated/ShopManager.gd")

signal randomizer_modifier_type_changed(arg_val)

const all_red_tower_ids : Array = [
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
	
	Towers.HEXTRIBUTE,
	Towers.BLOSSOM,
	Towers.ADEPT,
	Towers.REAPER,
	Towers.PROBE,
	Towers.CHARGE,
	Towers.TRANSMUTATOR,
	Towers.SHOCKER,
	Towers.STRIKER,
	Towers.REBOUND,
	# end of red towers
]

const all_default_set_one_towers : Array = [
	Towers.HEXTRIBUTE,
	Towers.BLOSSOM,
	Towers.ADEPT,
	Towers.REAPER,
	Towers.PROBE,
	Towers.CHARGE,
	Towers.TRANSMUTATOR,
	Towers.SHOCKER,
	Towers.STRIKER,
	Towers.REBOUND,
]

const red_tier_configuration_and_chance_weight_map : Dictionary = {
	[2, 2, 2, 2, 1, 1] : 100,
	
	# EX usage of how to add configs here:
	# [] : 33,
	# [] : 66,
	# [] : 100,
	#
	# makes it so that each has a roughly 33% chance of being taken.
}

#############

enum RandModifierType {
	RANDOMIZED = 0,
	SET_ONE = 1,
	
	#CUSTOM = -10
}


var randomizer_modifier_type : int = RandModifierType.RANDOMIZED setget set_randomizer_modifier_type 
var red_tower_randomizer_rng : RandomNumberGenerator

var shop_manager : ShopManager

#

func _init().(StoreOfGameModifiers.GameModiIds__RedTowerRandomizer, 
		BreakpointActivation.BEFORE_GAME_START, 
		"Red Tower Randomizer"):
	
	pass

#

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	shop_manager = game_elements.shop_manager
	red_tower_randomizer_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RED_TOWER_RANDOMIZER)
	
	#
	_clear_all_red_towers_pool_parameters()
	_add_random_red_towers_info_pool_parameters()

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	
	#
	_clear_all_red_towers_pool_parameters()
	_add_all_default_set_one_red_towers_into_pool_parameters()

#

func _clear_all_red_towers_pool_parameters():
	for id in all_red_tower_ids:
		shop_manager.remove_tower_id_from_blacklisted_towers_to_inventory(id)
		shop_manager.remove_tower_id_from_towers_not_initially_in_inventory(id)

func _add_all_default_set_one_red_towers_into_pool_parameters():
	for id in all_red_tower_ids:
		if !all_default_set_one_towers.has(id):
			shop_manager.add_tower_id_to_blacklisted_towers_to_inventory(id)
			shop_manager.add_tower_id_to_towers_not_initially_in_inventory(id)

#

func _add_random_red_towers_info_pool_parameters():
	var red_tier_config_copy : Array = _get_randomized_red_tier_configuration().duplicate(true)
	var tier_to_red_tower_ids_map : Dictionary = _get_all_tower_tier_to_red_tower_ids_map()
	
	for tier in tier_to_red_tower_ids_map.keys():
		var tower_ids = tier_to_red_tower_ids_map[tier]
		_enable_random_red_tower_count_in_arr_selection(red_tier_config_copy[tier - 1], tower_ids)


func _get_randomized_red_tier_configuration() -> Array:
	var i = red_tower_randomizer_rng.randi_range(1, 100)
	
	for red_tier_config in red_tier_configuration_and_chance_weight_map.keys():
		var weight = red_tier_configuration_and_chance_weight_map[red_tier_config]
		
		if i <= weight:
			return red_tier_config
	
	
	print("Error in getting randomized red tier config. Returned first one instead.")
	return red_tier_configuration_and_chance_weight_map.keys()[0]

func _get_all_tower_tier_to_red_tower_ids_map() -> Dictionary:
	var map : Dictionary = {
		1 : [],
		2 : [],
		3 : [],
		4 : [],
		5 : [],
		6 : [],
	}
	
	for id in all_red_tower_ids:
		var tower_tier = Towers.get_tower_tier_from_tower_id(id)
		map[tower_tier].append(id)
	
	return map


func _enable_random_red_tower_count_in_arr_selection(arg_count : int, arg_arr : Array):
	var all_red_towers_in_arr := arg_arr.duplicate()
	
	for i in arg_count:
		var rand_i = red_tower_randomizer_rng.randi_range(0, arg_arr.size() - 1)
		var tower_id = arg_arr[rand_i]
		
		# erasing tower id that will be enabled
		arg_arr.erase(tower_id)
	
	for id in all_red_towers_in_arr:
		if arg_arr.has(id):
			_blacklist_tower_id_from_shop_parameters(id)

func _blacklist_tower_id_from_shop_parameters(arg_id):
	shop_manager.add_tower_id_to_blacklisted_towers_to_inventory(arg_id)
	shop_manager.add_tower_id_to_towers_not_initially_in_inventory(arg_id)



###

func set_randomizer_modifier_type(arg_type):
	randomizer_modifier_type = arg_type
	
	emit_signal("randomizer_modifier_type_changed", arg_type)

