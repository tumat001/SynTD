
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const tier_none_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_None.png")
const tier_bronze_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Bronze.png")
const tier_silver_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Silver.png")
const tier_gold_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Gold.png")
const tier_dia_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Diamond.png")

const syn_dom_red = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Red.png")
const syn_dom_orange = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Orange.png")

const syn_compo_comple_redgreen = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Comple_RedGreen.png")

# Order does not matter here
var colors_required : Array = []
# Number of towers required per tier of synergy.
# Ex: 9, 6, 3 -> 9 oranges, 6 oranges, 3 oranges
# when the colors_required contains 'orange' only.
# IMPORTANT: Highest to Lowest
var number_of_towers_in_tier : Array = []
var tier_pic_per_tier : Array = []
var synergy_name : String
var synergy_picture

func _init(arg_synergy_name : String,
		arg_colors_required : Array,
		arg_number_of_towers_in_tier : Array,
		arg_tier_pic_per_tier : Array,
		arg_synergy_picture):
	
	colors_required = arg_colors_required
	number_of_towers_in_tier = arg_number_of_towers_in_tier
	synergy_name = arg_synergy_name
	synergy_picture = arg_synergy_picture
	tier_pic_per_tier = arg_tier_pic_per_tier

# A quick eliminator of non-candidates
func quick_incomplete_check_if_requirements_met(colors_active : Array) -> bool:
	for required_color in colors_required:
		if !colors_active.has(required_color):
			return false
	
	return true

func check_if_color_requirements_met(colors_active : Array) -> CheckResults:
	var filtered_active = _filter_unrequired_colors(colors_active)
	var package = _get_count_per_color(filtered_active)
	
	var count_per_color : Array = package[0]
	var colors_compare : Array = package[1]
	var final_towers_in_tier : int = number_of_towers_in_tier[0]
	var final_exceed : int
	var passed : bool = true
	
	for color_required_index in colors_required.size():
		var cmp_index = colors_compare.find(colors_required[color_required_index])
		var tier_applicable = -1
		var exceed = 0
		
		if cmp_index != -1:
			tier_applicable = _get_tier_applicable(count_per_color[cmp_index])
			exceed = count_per_color[cmp_index] - number_of_towers_in_tier[color_required_index]
		
		if tier_applicable == -1:
			passed = false
		
		if final_towers_in_tier > tier_applicable:
			final_towers_in_tier = tier_applicable
		
		final_exceed += exceed
	
	return CheckResults.new(passed, final_towers_in_tier, final_exceed, 
			colors_required.size(), _find_synergy_tier(final_towers_in_tier),
			_get_tier_pic_to_use(final_towers_in_tier), _get_count_per_required_color(colors_active))

func _find_synergy_tier(final_towers_in_tier) -> int:
	if final_towers_in_tier == -1:
		return 0
	
	var index = number_of_towers_in_tier.find(final_towers_in_tier)
	return number_of_towers_in_tier.size() - index

func _get_tier_pic_to_use(final_towers_in_tier):
	var index = number_of_towers_in_tier.find(final_towers_in_tier)
	if index == -1:
		return tier_none_pic
	return tier_pic_per_tier[index]

func _filter_unrequired_colors(colors : Array) -> Array:
	var bucket : Array = []
	for color in colors:
		if colors_required.has(color):
			bucket.append(color)
	
	return bucket

# "Compression"
# Returns the count per color, and also the colors
# ordered in a way that corresponds to the positions.
func _get_count_per_color(colors : Array) -> Array:
	var count_bucket : Array = []
	var color_bucket : Array = []
	
	for color in colors:
		if !color_bucket.has(color):
			color_bucket.append(color)
			count_bucket.append(colors.count(color))
	
	return [count_bucket, color_bucket]

func _get_count_per_required_color(colors : Array) -> Array:
	var count_bucket : Array = []
	var color_bucket : Array = []
	
	for req_color in colors_required:
		if !color_bucket.has(req_color):
			color_bucket.append(req_color)
			count_bucket.append(colors.count(req_color))
	
	return [count_bucket, color_bucket]

# Returns -1 if not applicable
func _get_tier_applicable(amount_of_color : int) -> int:
	for tier in number_of_towers_in_tier:
		if amount_of_color >= tier:
			return tier
	
	return -1


class CheckResults:
	
	var passed : bool
	var towers_in_tier : int
	var synergy_tier : int
	var total_exceed : int
	var raw_total : int
	var tier_pic
	
	var count_per_color : Array = []
	
	func _init(arg_passed : bool, arg_towers_in_tier : int,
			arg_total_exceed : int, arg_num_of_colors : int,
			arg_synergy_tier : int, arg_tier_pic,
			arg_count_per_color : Array):
		passed = arg_passed
		towers_in_tier = arg_towers_in_tier
		total_exceed = arg_total_exceed
		raw_total = towers_in_tier * arg_num_of_colors + total_exceed
		synergy_tier = arg_synergy_tier
		tier_pic = arg_tier_pic
		count_per_color = arg_count_per_color

