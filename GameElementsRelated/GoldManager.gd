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
	
}


signal current_gold_changed(current_gold)

var current_gold : int = 0
var gold_amount_label : Label


func increase_gold_by(increase : int, increase_source : int):
	current_gold += increase
	call_deferred("emit_signal", "current_gold_changed", current_gold)
	_update_gold_amount_label()


func decrease_gold_by(decrease : int, decrease_source : int):
	current_gold -= decrease
	call_deferred("emit_signal", "current_gold_changed", current_gold)
	_update_gold_amount_label()


func _update_gold_amount_label():
	gold_amount_label.text = str(current_gold)
