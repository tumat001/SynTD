
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

# Order does not matter here
var colors_required : Array = []
# Number of towers required per tier of synergy.
# Ex: 9, 6, 3 -> 9 oranges, 6 oranges, 3 oranges
# when the colors_required contains 'orange' only.
# IMPORTANT: Highest to Lowest
var number_of_towers_in_tier : Array = []
var synergy_name : String

func _init(arg_synergy_name : String,
		arg_colors_required : Array,
		arg_number_of_towers_in_tier : Array):
	
	colors_required = arg_colors_required
	number_of_towers_in_tier = arg_number_of_towers_in_tier
	synergy_name = arg_synergy_name

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
	
	for cmp_index in colors_compare.size():
		var index_of_required = colors_required.find(colors_compare[cmp_index])
		var tier_applicable = _get_tier_applicable(colors_compare[cmp_index])
		var exceed = count_per_color[cmp_index] - number_of_towers_in_tier[index_of_required]
		
		if tier_applicable == -1:
			return CheckResults.new(false, -1, exceed, colors_required.size(), 0)
		
		if final_towers_in_tier > tier_applicable:
			final_towers_in_tier = tier_applicable
		
		final_exceed += exceed
	
	return CheckResults.new(true, final_towers_in_tier, final_exceed, 
	colors_required.size(), _find_synergy_tier(final_towers_in_tier))

func _find_synergy_tier(final_tier) -> int:
	var rev_index = number_of_towers_in_tier.find(final_tier)
	return number_of_towers_in_tier.size() - rev_index

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
		color_bucket.append(color)
		count_bucket.append(colors.count(color))
	
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
	var exceed : int
	var raw_total : int
	
	func _init(arg_passed : bool, arg_towers_in_tier : int,
			arg_exceed : int, arg_num_of_colors : int,
			arg_synergy_tier : int):
		passed = arg_passed
		towers_in_tier = arg_towers_in_tier
		exceed = arg_exceed
		raw_total = towers_in_tier * arg_num_of_colors + exceed
		synergy_tier = arg_synergy_tier

