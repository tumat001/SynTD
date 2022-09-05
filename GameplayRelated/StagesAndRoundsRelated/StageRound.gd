
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


