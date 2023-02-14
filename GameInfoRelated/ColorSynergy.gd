
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergyCheckResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")

const AbstractTowerModifyingSynergyEffect = preload("res://GameInfoRelated/ColorSynergyRelated/AbstractTowerModifyingSynergyEffect.gd")
const AbstractGameElementsModifyingSynergyEffect = preload("res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd")

const tier_none_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_None.png")

signal current_synergy_tier_changed(new_tier)

enum HighlightDeterminer {
	SINGLE = 10,
	ALL_BELOW = 20,
	CUSTOM = 30
}

enum Difficulty {
	EFFORTLESS = 1,
	EASY = 2,
	CHALLENGING = 3,
	DIFFICULT = 4,
	COMPLEX = 5
}

# Make order similar to order in the synergy name
var colors_required : Array = []
# Number of towers required per tier of synergy.
# Ex: 9, 6, 3 -> 9 oranges, 6 oranges, 3 oranges
# where the colors_required contains 'orange' only.
# IMPORTANT: Highest to Lowest
var number_of_towers_in_tier : Array = []
# IMPORTANT: Highest to Lowest
var tier_pic_per_tier : Array = []
var synergy_id : String
var synergy_name : String
var synergy_descriptions : Array = []
var synergy_simple_descriptions : Array = []
var synergy_picture : Texture
var synergy_big_picture : Texture

var synergy_effects : Array
var synergy_effects_gd_script : Array
var synergy_effects_descriptions : Array = []

var highlight_determiner : int

# An example of highlight instructions would be:
# {
# 0: [],
# 3: [0],
# 6: [0, 1],
# 9: [0, 2],
# }
#
var custom_highlight_instructions : Dictionary = {}

var synergy_difficulty_num : int        #from 1 to 5

# curr stuffs

var current_tier : int
var current_highlighted_index_effects_descriptions : Array = []

var current_synergy_tier_id : String

#

func _init(
		arg_synergy_id,
		arg_synergy_name : String,
		arg_colors_required : Array,
		arg_number_of_towers_in_tier : Array,
		arg_tier_pic_per_tier : Array,
		arg_synergy_picture,
		arg_synergy_big_picture,
		arg_synergy_descriptions : Array,
		arg_synergy_effects_gd_script = [],
		arg_synergy_effects_descriptions = [],
		arg_highlight_determiner : int = HighlightDeterminer.SINGLE,
		arg_custom_highlight_instructions = {},
		arg_synergy_simple_descriptions = [],
		arg_synergy_difficulty_num : int = Difficulty.EFFORTLESS
		):
	
	synergy_id = arg_synergy_id
	colors_required = arg_colors_required
	number_of_towers_in_tier = arg_number_of_towers_in_tier
	synergy_name = arg_synergy_name
	synergy_picture = arg_synergy_picture
	synergy_big_picture = arg_synergy_big_picture
	tier_pic_per_tier = arg_tier_pic_per_tier
	synergy_descriptions = arg_synergy_descriptions
	
	#synergy_effects = arg_synergy_effects
	synergy_effects_gd_script = arg_synergy_effects_gd_script
	
	synergy_effects_descriptions = arg_synergy_effects_descriptions
	highlight_determiner = arg_highlight_determiner
	custom_highlight_instructions = arg_custom_highlight_instructions
	synergy_simple_descriptions = arg_synergy_simple_descriptions
	
	synergy_difficulty_num = arg_synergy_difficulty_num
	
	#reset_synergy_effects_instances()


#

func reset_synergy_effects_instances():
	synergy_effects.clear()
	
	for script in synergy_effects_gd_script:
		synergy_effects.append(script.new())

func reset_synergy_effects_instances_and_curr_tier():
	reset_synergy_effects_instances()
	
	current_tier = 0
	current_highlighted_index_effects_descriptions.clear()
	construct_current_synergy_tier_id__based_on_properties()



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
			get_tier_pic_to_use(final_towers_in_tier), _get_count_per_required_color(colors_active))

func _find_synergy_tier(final_towers_in_tier) -> int:
	if final_towers_in_tier == -1:
		return -1
	
	var index = number_of_towers_in_tier.find(final_towers_in_tier)
	return index + 1
	#return number_of_towers_in_tier.size() - index

func get_tier_pic_to_use(final_towers_in_tier):
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


#

func apply_this_synergy_to_towers(tier, towers, game_elements, tower_synergies_only):
	current_tier = tier
	construct_current_synergy_tier_id__based_on_properties()
	
	if !tower_synergies_only:
		_update_current_highlighted_index_syn_effects_desc()
	
	for synergy_effect in synergy_effects:
		if synergy_effect is AbstractTowerModifyingSynergyEffect:
			for tower in towers:
				synergy_effect._apply_syn_to_tower(tower, tier)
		
		elif synergy_effect is AbstractGameElementsModifyingSynergyEffect and !tower_synergies_only:
			synergy_effect._apply_syn_to_game_elements(game_elements, tier)
	
	call_deferred("emit_signal", "current_synergy_tier_changed", current_tier)


func remove_this_synergy_from_towers(tier, towers, game_elements, tower_synergies_only):
	current_tier = 0
	construct_current_synergy_tier_id__based_on_properties()
	
	if !tower_synergies_only:
		_update_current_highlighted_index_syn_effects_desc()
	
	for synergy_effect in synergy_effects:
		if synergy_effect is AbstractTowerModifyingSynergyEffect:
			for tower in towers:
				synergy_effect._remove_syn_from_tower(tower, tier)
			
		elif synergy_effect is AbstractGameElementsModifyingSynergyEffect and !tower_synergies_only:
			synergy_effect._remove_syn_from_game_elements(game_elements, tier)
	
	call_deferred("emit_signal", "current_synergy_tier_changed", current_tier)


func _update_current_highlighted_index_syn_effects_desc():
	if highlight_determiner == HighlightDeterminer.SINGLE:
		_update_current_highlighted_index_eff_as_single()
	elif highlight_determiner == HighlightDeterminer.ALL_BELOW:
		_update_current_highlighted_index_eff_as_all_below()
	else:
		
		current_highlighted_index_effects_descriptions.clear()
		for highlight_index in custom_highlight_instructions[current_tier]:
			current_highlighted_index_effects_descriptions.append(highlight_index)


func _update_current_highlighted_index_eff_as_single():
	current_highlighted_index_effects_descriptions.clear()
	
	var index = number_of_towers_in_tier.size() - current_tier
	current_highlighted_index_effects_descriptions.append(index)
	#current_highlighted_index_effects_descriptions.append(current_tier - 1)

func _update_current_highlighted_index_eff_as_all_below():
	current_highlighted_index_effects_descriptions.clear()
	
	for i in (number_of_towers_in_tier.size() - current_tier) + 1:
		current_highlighted_index_effects_descriptions.append(i)
	
	
#	for i in current_tier - 1:
#		current_highlighted_index_effects_descriptions.erase(i)


###

func has_simple_description() -> bool:
	return synergy_simple_descriptions != null and synergy_simple_descriptions.size() != 0

###

func get_tier_pic_to_use__from_syn_tier(arg_tier):
	var index = arg_tier - 1
	if index == -1:
		return tier_none_pic
	return tier_pic_per_tier[index]

func get_tower_count_to_use__from_syn_tier(arg_tier):
	var index = arg_tier - 1
	if index == -1:
		return 0
	return number_of_towers_in_tier[index]

##

func construct_current_synergy_tier_id__based_on_properties():
	#current_synergy_tier_id = "%s-%s" % [synergy_id, current_tier]
	current_synergy_tier_id = construct_current_synergy_tier_id(synergy_id, current_tier)

static func construct_current_synergy_tier_id(synergy_id, current_tier):
	return "%s-%s" % [synergy_id, current_tier]

static func decompose_current_synergy_id_and_tier(arg_syn_id_tier : String):
	return arg_syn_id_tier.split("-")

func construct_all_possible_synergy_tier_ids():
	var bucket = []
	
	for tier_minus_1 in number_of_towers_in_tier.size():
		bucket.append(construct_current_synergy_tier_id(synergy_id, tier_minus_1 + 1))
	
	return bucket

###################


func get_description__for_almanac_use():
	return synergy_descriptions

func get_simple_description__for_almanac_use():
	return synergy_simple_descriptions


func get_atlased_image_as_list__for_almanac_use():
	return [synergy_big_picture]

func get_altasted_image_list_size():
	return 0

func get_name__for_almanac_use():
	return synergy_name

func get_id__for_almanac_use():
	return synergy_id


