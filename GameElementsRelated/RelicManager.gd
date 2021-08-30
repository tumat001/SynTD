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

var relic_give_at_stageround : Dictionary = {
	"41" : 1,
	"71" : 1,
	"81" : 1
}

signal current_relic_count_changed(new_amount)


#

var current_relic_count : int setget set_relic_count
var stage_round_manager setget set_stage_round_manager

#

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)


#

func increase_relic_count_by(increase : int, increase_source : int):
	set_relic_count(current_relic_count + increase)

func decrease_relic_count_by(decrease : int, decrease_source : int):
	set_relic_count(current_relic_count - decrease)

func set_relic_count(val : int):
	current_relic_count = val
	call_deferred("emit_signal", "current_relic_count_changed", current_relic_count)


#

func _on_round_end(curr_stageround):
	if relic_give_at_stageround.has(curr_stageround.id):
		increase_relic_count_by(relic_give_at_stageround[curr_stageround.id], IncreaseRelicSource.ROUND)

