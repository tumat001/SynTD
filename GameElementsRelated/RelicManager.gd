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
	#"41" : 1,
	#"71" : 1,
	#"81" : 1
}

signal current_relic_count_changed(new_amount)


#

var current_relic_count : int setget set_relic_count
var stage_round_manager setget set_stage_round_manager

#

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	if stage_round_manager.stagerounds == null:
		stage_round_manager.connect("stage_rounds_set", self, "_on_stagerounds_set", [], CONNECT_ONESHOT)
	else:
		_on_stagerounds_set(stage_round_manager.stagerounds)


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

#

func _on_stagerounds_set(arg_stagerounds):
	for stage_round in arg_stagerounds.stage_rounds:
		if stage_round.give_relic_count_in_round > 0:
			relic_give_at_stageround[stage_round.id] = stage_round.give_relic_count_in_round

