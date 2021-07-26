
var stage_num : int
var round_num : int
var id : String

var end_of_round_gold : int

var enemy_damage_multiplier : float = 1
var enemy_health_multiplier : float = 1
var enemy_first_damage : float = 1


func _init(arg_stage_num : int, arg_round_num : int):
	stage_num = arg_stage_num
	round_num = arg_round_num
	id = str(stage_num) + str(round_num)

