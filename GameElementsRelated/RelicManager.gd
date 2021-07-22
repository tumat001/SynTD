extends Node

enum IncreaseRelicSource {
	
	ROUND,
	SYNERGY,
	
}

enum DecreaseRelicSource {
	
	TOWER_USE,
	TOWER_CAP_INCREASE,
	ING_CAP_INCREASE,
	
}

signal current_relic_count_changed(new_amount)

var current_relic_count : int



func increase_relic_count_by(increase : int, increase_source : int):
	current_relic_count += increase
	call_deferred("emit_signal", "current_relic_count_changed", current_relic_count)


func decrease_relic_count_by(decrease : int, decrease_source : int):
	current_relic_count -= decrease
	call_deferred("emit_signal", "current_relic_count_changed", current_relic_count)

