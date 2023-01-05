
const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")


var stage_rounds : Array
var stage_rounds_with_relic : Array
var last_stage_round : StageRound

var early_game_stageround_id_start_exclusive #= "03"
var early_game_stageround_id_exclusive #= "51"
var mid_game_stageround_id_exclusive #= "91"
var last_round_end_game_stageround_id_exclusive #= "94"
var first_round_of_game_stageround_id_exclusive #= "01"



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


# queries

func get_next_relic_giving_round_from_current(arg_curr_stage_round : StageRound):
	for relic_stage_round in stage_rounds_with_relic:
		if StageRound.is_stageround_id_higher_than_second_param(relic_stage_round.id, arg_curr_stage_round.id):
			return relic_stage_round


func get_stage_round_after_x_rounds_from_current(arg_curr_stage_round : StageRound, arg_x_count : int):
	var index_of_curr = stage_rounds.find(arg_curr_stage_round)
	return get_stage_round_after_x_rounds_from_current_index(index_of_curr, arg_x_count)

func get_stage_round_after_x_rounds_from_current_index(arg_index : int, arg_x_count : int):
	var stage_round_size : int = stage_rounds.size()
	arg_index += arg_x_count
	if arg_index >= stage_round_size:
		arg_index = stage_round_size - 1
	
	if arg_index < 0:
		arg_index = 0
	
	return stage_rounds[arg_index]

# returns null if either id is invalid
func get_number_of_rounds_from_x_to_y__using_ids(arg_stageround_x : String, arg_stageround_y : String):
	var index_of_x = _get_index_of_stageround_using_id(arg_stageround_x)
	var index_of_y = _get_index_of_stageround_using_id(arg_stageround_y)
	
	if index_of_x != -1 and index_of_y != -1:
		return index_of_y - index_of_x
	else:
		return null


func _get_index_of_stageround_using_id(arg_id : String):
	var index = 0
	for stage_round in stage_rounds:
		if stage_round.id == arg_id:
			return index
		
		index += 1
	
	return -1


