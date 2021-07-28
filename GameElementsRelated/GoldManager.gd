extends Node

enum IncreaseGoldSource {
	
	END_OF_ROUND,
	ENEMY_KILLED, #By effects/ingredient effects
	TOWER_SELLBACK,
	TOWER_EFFECT_RESET,
	TOWER_GOLD_INCOME,
	SYNERGY,
	
}

enum DecreaseGoldSource {
	
	TOWER_BUY,
	TOWER_USE,
	LEVEL_UP,
	
}


signal current_gold_changed(current_gold)

var current_gold : int = 0 setget set_gold_value


func increase_gold_by(increase : int, increase_source : int):
	set_gold_value(current_gold + increase)

func decrease_gold_by(decrease : int, decrease_source : int):
	set_gold_value(current_gold - decrease)

func set_gold_value(val : int):
	current_gold = val
	call_deferred("emit_signal", "current_gold_changed", current_gold)

