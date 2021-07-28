extends Node

enum IncreaseRelicSource {
	
	ROUND,
	SYNERGY,
	
}

enum DecreaseRelicSource {
	
	TOWER_USE,
	TOWER_CAP_INCREASE,
	ING_CAP_INCREASE,
	LEVEL_UP,
	
}

signal current_relic_count_changed(new_amount)

var current_relic_count : int setget set_relic_count



func increase_relic_count_by(increase : int, increase_source : int):
	set_relic_count(current_relic_count + increase)

func decrease_relic_count_by(decrease : int, decrease_source : int):
	set_relic_count(current_relic_count - decrease)

func set_relic_count(val : int):
	current_relic_count = val
	call_deferred("emit_signal", "current_relic_count_changed", current_relic_count)
