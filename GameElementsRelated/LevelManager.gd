extends Node

const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const RelicManager = preload("res://GameElementsRelated/RelicManager.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const gold_currency_icon = preload("res://GameHUDRelated/BuySellPanel/GoldPic.png")
const relic_currency_icon = preload("res://GameHUDRelated/BuySellPanel/RelicPic.png")


signal on_current_level_up_cost_amount_changed(new_cost)
signal on_current_level_up_cost_currency_changed(new_currency)
signal on_current_level_changed(new_level)

signal on_can_level_up_changed(can_level_up)

enum {
	LEVEL_1 = 1,
	LEVEL_2 = 2,
	LEVEL_3 = 3,
	LEVEL_4 = 4,
	LEVEL_5 = 5,
	LEVEL_6 = 6,
	LEVEL_7 = 7,
	LEVEL_8 = 8,
	LEVEL_9 = 9,
	LEVEL_10 = 10,
	
	# Reachable by red syn (not the level itself tho, used by shop manager)
	LEVEL_11 = 11,
	LEVEL_12 = 12,
}

enum Currency {
	GOLD = 100,
	RELIC = 101,
}

const base_level_up_costs : Dictionary = {
	LEVEL_1 : [2, Currency.GOLD],
	LEVEL_2 : [2, Currency.GOLD],
	LEVEL_3 : [6, Currency.GOLD],
	LEVEL_4 : [18, Currency.GOLD],
	LEVEL_5 : [32, Currency.GOLD],
	LEVEL_6 : [42, Currency.GOLD],
	LEVEL_7 : [62, Currency.GOLD],
	LEVEL_8 : [84, Currency.GOLD],
	LEVEL_9 : [1, Currency.RELIC],
	LEVEL_10 : [0, Currency.GOLD],
}

const before_max_level : int = LEVEL_9
const max_level : int = LEVEL_10

var current_level : int setget set_current_level

#

#enum LevelUpCostModifiers {
#	NATURAL_PROGRESSION = 0, # per round, reduce level cost by x
#
#	SYN_RED__JEWELED_SWORD = 1,
#	SYN_RED__JEWELED_STAFF = 2,
#}
#
#var level_to_cost_modifier_map : Dictionary = {}


const base_level_up_gold_cost_reduction_per_round : int = 2 #Natural progression

var current_level_up_cost : int = 0 setget set_level_up_cost
var current_level_up_currency : int


#

var game_elements
var stage_round_manager setget set_stage_round_manager
var gold_manager : GoldManager setget set_gold_manager
var relic_manager : RelicManager setget set_relic_manager

# clauses

enum CanLevelUpClauses {
	TUTORIAL_DISABLE = 1000
}
var can_level_up_clauses : ConditionalClauses
var last_calculated_can_level_up : bool


# setters

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end_game_start_aware", [], CONNECT_PERSIST)

func set_gold_manager(arg_manager : GoldManager):
	gold_manager = arg_manager
	
	gold_manager.connect("current_gold_changed", self, "_gold_amount_changed", [], CONNECT_PERSIST)

func set_relic_manager(arg_manager : RelicManager):
	relic_manager = arg_manager
	
	relic_manager.connect("current_relic_count_changed", self, "_relic_count_changed", [], CONNECT_PERSIST)


#

func _ready():
	can_level_up_clauses = ConditionalClauses.new()
	can_level_up_clauses.connect("clause_inserted", self, "_on_can_level_up_cond_clause_inserted_or_removed", [], CONNECT_PERSIST)
	can_level_up_clauses.connect("clause_removed", self, "_on_can_level_up_cond_clause_inserted_or_removed", [], CONNECT_PERSIST)
	
	#
	set_current_level(LEVEL_1)


# on round end

func _on_round_end_game_start_aware(curr_stageround, is_game_start):
	if !is_game_start:
		reduce_level_up_gold_cost()


# level costs related

func reduce_level_up_gold_cost(amount : int = base_level_up_gold_cost_reduction_per_round):
	if _if_can_reduce_next_level_cost():
		set_level_up_cost(current_level_up_cost - amount)

func _if_can_reduce_next_level_cost():
	return !is_in_max_level() and current_level != before_max_level


func set_level_up_cost(val : int):
	current_level_up_cost = val
	emit_signal("on_current_level_up_cost_amount_changed", val)
	
	if val <= 0:
		level_up_with_spend_currency()

func set_level_up_cost_currency(curr : int):
	current_level_up_currency = curr
	
	emit_signal("on_current_level_up_cost_currency_changed", curr)


# level related

func is_in_max_level() -> bool:
	return current_level == max_level


func can_level_up():
	if can_level_up_clauses.is_passed:
		if !is_in_max_level():
			if current_level_up_currency == Currency.GOLD:
				return gold_manager.current_gold >= current_level_up_cost
			else: # RELIC
				return relic_manager.current_relic_count >= current_level_up_cost
	
	return false

func level_up_with_spend_currency():
	if can_level_up():
		if current_level_up_currency == Currency.GOLD:
			gold_manager.decrease_gold_by(current_level_up_cost, GoldManager.DecreaseGoldSource.LEVEL_UP)
		elif current_level_up_currency == Currency.RELIC:
			relic_manager.decrease_relic_count_by(current_level_up_cost, RelicManager.DecreaseRelicSource.LEVEL_UP)
		
		set_current_level(current_level + 1)




func set_current_level(new_level):
	if max_level >= new_level:
		current_level = new_level
		
		emit_signal("on_current_level_changed", new_level)
		
		set_level_up_cost(base_level_up_costs[current_level][0])
		set_level_up_cost_currency(base_level_up_costs[current_level][1])


func _gold_amount_changed(gold_amount):
	#emit_signal("on_can_level_up_changed", can_level_up())
	_update_if_can_level_up()

func _relic_count_changed(relic_amount):
	#emit_signal("on_can_level_up_changed", can_level_up())
	_update_if_can_level_up()


# used by some red syns
func get_level_after_current():
	if !is_in_max_level():
		return current_level + 1
	else:
		return max_level

# miscs

func get_currency_icon(currency : int) -> Texture:
	if currency == Currency.GOLD:
		return gold_currency_icon
	elif currency == Currency.RELIC:
		return relic_currency_icon
	
	return null

###

func _on_can_level_up_cond_clause_inserted_or_removed(arg_clause):
	_update_if_can_level_up()


func _update_if_can_level_up():
	last_calculated_can_level_up = can_level_up()
	emit_signal("on_can_level_up_changed", last_calculated_can_level_up)


#func can_level_up() -> bool:
#	if !is_in_max_level():
#		if current_level_up_currency == Currency.GOLD:
#			return gold_manager.current_gold >= current_level_up_cost
#		else: # RELIC
#			return relic_manager.current_relic_count >= current_level_up_cost
#
#	return false

