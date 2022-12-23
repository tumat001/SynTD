extends Node

enum IncreaseGoldSource {
	
	END_OF_ROUND,
	ENEMY_KILLED, #By effects/ingredient effects
	TOWER_SELLBACK,
	TOWER_EFFECT_RESET,
	SYNERGY,
	TOWER_GOLD_INCOME,
	START_OF_GAME,
	
	GAME_MODIFIER,
	
	MAP_SPECIFIC_BEHAVIOR,
}

enum DecreaseGoldSource {
	
	TOWER_BUY,
	TOWER_USE,
	LEVEL_UP,
	SHOP_ROLL,
	SYNERGY,
	
}

enum GoldIncomeIds {
	ROUND_END,
	INTEREST,
	WIN_STREAK,
	LOSE_STREAK,
}

# ORDER MATTERS HERE
const total_gold_interest_with_income_intervals : Dictionary = {
	#70 : 6,
	50 : 5,
	40 : 4,
	30 : 3,
	20 : 2,
	10 : 1,
}

const win_streak_income_map : Dictionary = {
	2 : 1,
	3 : 1,
	4 : 2,
	5 : 2,
	6 : 3,
	#7 : 3,
	#8 : 4,
}
# highest win streak in the income map
const highest_win_streak : int = 6


const lose_streak_income_map : Dictionary = {
	2 : 1,
	3 : 2,
	4 : 2,
	5 : 3,
	6 : 4,
	#7 : 5,
}
# highest lose streak in the income map
const highest_lose_streak : int = 6


signal current_gold_changed(current_gold)
signal gold_income_changed()

var current_gold : int = 0 setget set_gold_value

var _gold_income_id_amount_map : Dictionary = {}
var stage_round_manager


#

func _ready():
	_set_up_interest_income()


# direct set

func increase_gold_by(increase : int, increase_source : int):
	set_gold_value(current_gold + increase)

func decrease_gold_by(decrease : int, decrease_source : int):
	set_gold_value(current_gold - decrease)

func set_gold_value(val : int):
	current_gold = val
	call_deferred("emit_signal", "current_gold_changed", current_gold)


# income related

func set_gold_income(income_id : int, income_amount : int):
	_gold_income_id_amount_map[income_id] = income_amount
	emit_signal("gold_income_changed")

func remove_gold_income(income_id : int):
	if _gold_income_id_amount_map.has(income_id):
		_gold_income_id_amount_map.erase(income_id)
		emit_signal("gold_income_changed")

func get_total_income_for_the_round() -> int:
	var total : int = 0
	
	for i in _gold_income_id_amount_map.values():
		total += i
	
	return total


func get_gold_amount_from_win_streak(streak : int) -> int:
	var gold : int = 0
	
	if streak >= highest_win_streak:
		gold = win_streak_income_map.values()[win_streak_income_map.size() - 1]
	elif win_streak_income_map.has(streak):
		gold = win_streak_income_map[streak]
	
	return gold

func get_gold_amount_from_next_win_streak() -> int:
	return get_gold_amount_from_win_streak(stage_round_manager.current_win_streak + 1)


func get_gold_amount_from_lose_streak(streak : int) -> int:
	var gold : int = 0
	
	if streak >= highest_lose_streak:
		gold = lose_streak_income_map.values()[lose_streak_income_map.size() - 1]
	elif lose_streak_income_map.has(streak):
		gold = lose_streak_income_map[streak]
	
	return gold

func get_gold_amount_from_next_lose_streak() -> int:
	return get_gold_amount_from_lose_streak(stage_round_manager.current_lose_streak + 1)


# interest income related

func get_interest_amount(principal_amount : int = current_gold) -> int:
	for gold_needed in total_gold_interest_with_income_intervals.keys():
		if principal_amount >= gold_needed:
			return total_gold_interest_with_income_intervals[gold_needed]
	
	return 0

func _set_up_interest_income():
	connect("current_gold_changed", self, "_update_interest_income", [], CONNECT_PERSIST)
	_update_interest_income(current_gold)

func _update_interest_income(val):
	var income = get_interest_amount()
	if income <= 0:
		remove_gold_income(GoldIncomeIds.INTEREST)
	else:
		set_gold_income(GoldIncomeIds.INTEREST, income)


# income display related

func get_display_name_of_income_id(income_id : int) -> String:
	if income_id == GoldIncomeIds.ROUND_END:
		return "Round End"
	elif income_id == GoldIncomeIds.INTEREST:
		return "Interest"
	elif income_id == GoldIncomeIds.WIN_STREAK:
		return "Win Steak"
	elif income_id == GoldIncomeIds.LOSE_STREAK:
		return "Lose Steak"
	
	return "Err"
