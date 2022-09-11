

var passed : bool
var towers_in_tier : int
var synergy_tier : int
var total_exceed : int
var raw_total : int
var tier_pic
var synergy
var color_types_amount_met : int
var color_types_amount_from_baseline : int

var count_per_color : Array = []

func _init(arg_passed : bool, arg_towers_in_tier : int,
		arg_total_exceed : int, arg_num_of_colors : int,
		arg_synergy_tier : int, arg_synergy,
		arg_tier_pic,
		arg_count_per_color : Array):
	
	passed = arg_passed
	towers_in_tier = arg_towers_in_tier
	total_exceed = arg_total_exceed
	synergy_tier = arg_synergy_tier
	synergy = arg_synergy
	tier_pic = arg_tier_pic
	count_per_color = arg_count_per_color
	
	for count in arg_count_per_color[0]:
		raw_total += count
		
		color_types_amount_from_baseline += 1
		if count != 0:
			color_types_amount_met += 1
	
	#raw_total = (towers_in_tier * arg_num_of_colors) + total_exceed


func functionally_equal_to(other_res) -> bool:
	if other_res is get_script():
		
		return other_res.synergy_tier == synergy_tier and other_res.synergy == synergy
		
	else:
		return false
