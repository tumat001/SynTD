
const RoundIcon_NormalRound = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/RoundIndicatorPanel/Assets/RoundIndicator_RoundIcon_NormalRound.png")
const RoundIcon_RelicRound = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/RoundIndicatorPanel/Assets/RoundIndicator_RoundIcon_Relic.png")
const RoundIcon_LastRound = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/RoundIndicatorPanel/Assets/RoundIndicator_RoundIcon_LastRound.png")


var stage_num : int
var round_num : int
var id : String

var can_gain_streak : bool = true
var end_of_round_gold : int

var enemy_damage_multiplier : float = 1
var enemy_health_multiplier : float = 1
var enemy_first_damage : float = 1

var give_relic_count_in_round : int = 0 setget set_give_relic_count_in_round
var round_icon = RoundIcon_NormalRound

var induce_enemy_strength_value_change : bool = true


func _init(arg_stage_num : int, arg_round_num : int):
	stage_num = arg_stage_num
	round_num = arg_round_num
	id = str(stage_num) + str(round_num)
	

func set_give_relic_count_in_round(arg_val):
	give_relic_count_in_round = arg_val
	
	if give_relic_count_in_round > 0:
		round_icon = RoundIcon_RelicRound
	else:
		round_icon = RoundIcon_NormalRound


######

static func convert_stageround_id_to_stage_and_round_num(arg_text_id : String) -> Array:
	var first = arg_text_id.substr(0, 1)
	var second = arg_text_id.substr(1, 1)
	
	return [first, second]

static func convert_stageround_id_to_stage_and_round_string_with_dash(arg_text_id : String) -> String:
	var nums = convert_stageround_id_to_stage_and_round_num(arg_text_id)
	
	return "%s-%s" % nums


static func is_stage_round_higher_than_second_param(a_stage_num, a_round_num, b_stage_num, b_round_num):
	if a_stage_num > b_stage_num:
		return true
	elif a_stage_num == b_stage_num:
		return a_round_num > b_round_num
	else:
		return false

static func is_stageround_id_higher_than_second_param(a_stageround_id, b_stageround_id):
	var converted_a = convert_stageround_id_to_stage_and_round_num(a_stageround_id)
	var converted_b = convert_stageround_id_to_stage_and_round_num(b_stageround_id)
	
	return is_stage_round_higher_than_second_param(converted_a[0], converted_a[1], converted_b[0], converted_b[1])


static func is_stage_round_higher_or_equal_than_second_param(a_stage_num, a_round_num, b_stage_num, b_round_num):
	if a_stage_num > b_stage_num:
		return true
	elif a_stage_num == b_stage_num:
		return a_round_num >= b_round_num
	else:
		return false

static func is_stageround_id_higher_or_equal_than_second_param(a_stageround_id, b_stageround_id):
	var converted_a = convert_stageround_id_to_stage_and_round_num(a_stageround_id)
	var converted_b = convert_stageround_id_to_stage_and_round_num(b_stageround_id)
	
	return is_stage_round_higher_or_equal_than_second_param(converted_a[0], converted_a[1], converted_b[0], converted_b[1])


static func is_stage_round_equal_than_second_param(a_stage_num, a_round_num, b_stage_num, b_round_num):
	return a_stage_num == b_stage_num and a_round_num == b_round_num

static func is_stageround_id_equal_than_second_param(a_stageround_id, b_stageround_id):
	return a_stageround_id == b_stageround_id
	#var converted_a = convert_stageround_id_to_stage_and_round_num(a_stageround_id)
	#var converted_b = convert_stageround_id_to_stage_and_round_num(b_stageround_id)
	
	#return is_stage_round_equal_than_second_param(converted_a[0], converted_a[1], converted_b[0], converted_b[1])

