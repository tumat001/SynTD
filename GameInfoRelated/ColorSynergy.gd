
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergyCheckResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")

const tier_none_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_None.png")

# Make order similar to order in the synergy name
var colors_required : Array = []
# Number of towers required per tier of synergy.
# Ex: 9, 6, 3 -> 9 oranges, 6 oranges, 3 oranges
# when the colors_required contains 'orange' only.
# IMPORTANT: Highest to Lowest
var number_of_towers_in_tier : Array = []
# IMPORTANT: Highest to Lowest
var tier_pic_per_tier : Array = []
var synergy_name : String
var synergy_descriptions : Array = []
var synergy_picture

var synergy_effects : Array

func _init(arg_synergy_name : String,
		arg_colors_required : Array,
		arg_number_of_towers_in_tier : Array,
		arg_tier_pic_per_tier : Array,
		arg_synergy_picture,
		arg_synergy_descriptions : Array,
		arg_synergy_effects = []):
	
	colors_required = arg_colors_required
	number_of_towers_in_tier = arg_number_of_towers_in_tier
	synergy_name = arg_synergy_name
	synergy_picture = arg_synergy_picture
	tier_pic_per_tier = arg_tier_pic_per_tier
	synergy_descriptions = arg_synergy_descriptions
	synergy_effects = arg_synergy_effects

# A quick eliminator of non-candidates
func quick_incomplete_check_if_requirements_met(colors_active : Array) -> bool:
	for required_color in colors_required:
		if !colors_active.has(required_color):
			return false
	
	return true

func check_if_color_requirements_met(arg_colors_active : Array) -> ColorSynergyCheckResults:
	var colors_active = arg_colors_active.duplicate()
	var filtered_active = _filter_unrequired_colors(colors_active)
	var package = _get_count_per_color(filtered_active)
	
	var count_per_color : Array = package[0]
	var colors_compare : Array = package[1]
	var final_towers_in_tier : int = number_of_towers_in_tier[0]
	var final_exceed : int = 0
	var passed : bool = true
	
	for color_required_index in colors_required.size():
		var cmp_index = colors_compare.find(colors_required[color_required_index])
		var tier_applicable = 0
		var exceed = 0
		
		if cmp_index != -1:
			tier_applicable = _get_tier_applicable(count_per_color[cmp_index])
			exceed = count_per_color[cmp_index] - tier_applicable
		
		if tier_applicable == 0:
			passed = false
		
		if final_towers_in_tier > tier_applicable:
			final_towers_in_tier = tier_applicable
		
		final_exceed += exceed
	
	return ColorSynergyCheckResults.new(passed, final_towers_in_tier, final_exceed, 
			colors_required.size(), _find_synergy_tier(final_towers_in_tier), self,
			_get_tier_pic_to_use(final_towers_in_tier), _get_count_per_required_color(colors_active))

func _find_synergy_tier(final_towers_in_tier) -> int:
	if final_towers_in_tier == -1:
		return -1
	
	var index = number_of_towers_in_tier.find(final_towers_in_tier)
	return index + 1
	#return number_of_towers_in_tier.size() - index

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

# Returns 0 if not applicable for synergy
func _get_tier_applicable(amount_of_color : int) -> int:
	for tier in number_of_towers_in_tier:
		if amount_of_color >= tier:
			return tier
	
	return 0



