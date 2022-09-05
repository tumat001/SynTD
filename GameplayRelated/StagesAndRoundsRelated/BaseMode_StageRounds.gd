
const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")


var stage_rounds : Array
var stage_rounds_with_relic : Array
var last_stage_round : StageRound

func get_second_half_faction() -> int:
	return -1

func get_first_half_faction() -> int:
	return -1

###

func _post_init():
	for i in stage_rounds.size():
		var curr_stage_round : StageRound = stage_rounds[i]
		if i == stage_rounds.size() - 1:
			last_stage_round = curr_stage_round
			last_stage_round.round_icon = last_stage_round.RoundIcon_LastRound
		
		if curr_stage_round.give_relic_count_in_round > 0:
			stage_rounds_with_relic.append(curr_stage_round)


