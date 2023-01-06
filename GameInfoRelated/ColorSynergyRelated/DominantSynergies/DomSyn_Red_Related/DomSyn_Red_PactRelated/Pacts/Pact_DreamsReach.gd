extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")


const tier_0__v1__player_level_to_rewards_map : Dictionary = {
	LevelManager.LEVEL_5 : [4, 4, 4, 4],
	LevelManager.LEVEL_6 : [4, 4, 4, 4, 4],
	LevelManager.LEVEL_7 : [4, 4, 4, 4, 4, 4, 4],
	LevelManager.LEVEL_8 : [4, 5, 5, 5, 5],
	LevelManager.LEVEL_9 : [5, 5, 6, 6],
	LevelManager.LEVEL_10 : [6, 6, 6, 6, 6, 6, 6],
}

const tier_1__v1__player_level_to_rewards_map : Dictionary = {
	LevelManager.LEVEL_5 : [3, 3, 3, 3, 3],
	LevelManager.LEVEL_6 : [3, 3, 3, 4, 4],
	LevelManager.LEVEL_7 : [3, 4, 4, 4, 4],
	LevelManager.LEVEL_8 : [4, 5, 5, 5],
	LevelManager.LEVEL_9 : [5, 5, 5, 5],
	LevelManager.LEVEL_10 : [6, 6, 6, 6],
}

const tier_2__v1__player_level_to_rewards_map : Dictionary = {
	LevelManager.LEVEL_5 : [2, 2, 3, 3],
	LevelManager.LEVEL_6 : [2, 3, 3, 4],
	LevelManager.LEVEL_7 : [3, 3, 4, 4],
	LevelManager.LEVEL_8 : [4, 4, 5],
	LevelManager.LEVEL_9 : [4, 5, 5],
	LevelManager.LEVEL_10 : [6, 6, 6],
}

const tier_3__v1__player_level_to_rewards_map : Dictionary = {
	LevelManager.LEVEL_5 : [2, 3, 3], #8
	LevelManager.LEVEL_6 : [2, 3, 4], #9
	LevelManager.LEVEL_7 : [3, 4, 4], #11
	LevelManager.LEVEL_8 : [3, 4, 5], #12
	LevelManager.LEVEL_9 : [3, 5, 5], #13
	LevelManager.LEVEL_10 : [3, 6, 6], #16
}

const max_stage_for_offerable_inclusive : int = 8
const max_round_for_offerable_inclusive : int = 2
const min_player_level_for_offerable_inclusive : int = LevelManager.LEVEL_5



const wins_needed_for_v1 : int = 4
const version_count : int = 1 # add more if more versions are made

var _current_version_of_reach : int
var _current_consecutive_wins_needed : int
var _current_tier_to_count_map : Dictionary

var _tier_map_to_use : Dictionary

var _current_win_count : int = 0

#

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.DREAMS_REACH, "Dream's Reach", arg_tier, arg_tier_for_activation):
	
	var _current_version_of_reach = pact_mag_rng.randi_range(0, version_count - 1)
	
	if tier == 0:
		_tier_map_to_use = tier_0__v1__player_level_to_rewards_map
	elif tier == 1:
		_tier_map_to_use = tier_1__v1__player_level_to_rewards_map
	elif tier == 2:
		_tier_map_to_use = tier_2__v1__player_level_to_rewards_map
	elif tier == 3:
		_tier_map_to_use = tier_3__v1__player_level_to_rewards_map
	
	_current_consecutive_wins_needed = wins_needed_for_v1
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_DreamsReach_Icon.png")

func _first_time_initialize():
	var curr_player_level = game_elements.level_manager.current_level
	_current_tier_to_count_map = _convert_given_arr_to_tier_to_count_map(_tier_map_to_use[curr_player_level])
	
	good_descriptions = [
		_get_reward_as_description(),
		""
	]
	
	bad_descriptions = [
		"Lose this pact when you lose a round."
	]
	
	_update_description_based_on_curr_win_count()
	
	#
	
	game_elements.stage_round_manager.connect("round_started", self, "_on_round_started__d", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_ended__d", [], CONNECT_PERSIST)
	


func _convert_given_arr_to_tier_to_count_map(arg_arr : Array) -> Dictionary:
	var map : Dictionary = {}
	
	for tier in arg_arr:
		if map.has(tier):
			map[tier] += 1
		else:
			map[tier] = 1
	
	return map

func _get_reward_as_description():
	var tier_desc_plain_fragments_arr = []
	var result = ["After winning %s rounds with this pact, gain " % str(_current_consecutive_wins_needed), tier_desc_plain_fragments_arr]
	
	for i in _current_tier_to_count_map.size():
		if i == _current_tier_to_count_map.size() - 1:
			result[0] += " and "
		elif i != 0:
			result[0] += ", "
		
		#
		var tier = _current_tier_to_count_map.keys()[i]
		var tier_desc = "%s tier %s tower" % [str(_current_tier_to_count_map.values()[i]), str(tier)]
		
		if _current_tier_to_count_map.values()[i] > 1:
			tier_desc += "s"
		
		tier_desc_plain_fragments_arr.append(PlainTextFragment.new(_get_plain_frag_stat_type_based_on_tier(tier), tier_desc))
		#
		
		result[0] += "|%s|" % str(tier_desc_plain_fragments_arr.size() - 1)
		
		if i == _current_tier_to_count_map.size() - 1:
			result[0] += "."
	
	return result

func _get_plain_frag_stat_type_based_on_tier(arg_tier):
	return PlainTextFragment.get_stat_type_based_on_tower_tier(arg_tier)

#

func pact_sworn():
	.pact_sworn()
	
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	pact_can_be_sworn_conditional_clauses.remove_clause(PactCanBeSwornClauseId.DREAMS_REACH__DURING_ROUND)

func _on_round_end(curr_stageround):
	if game_elements.stage_round_manager.current_round_lost:
		red_dom_syn.remove_pact_from_sworn_list(self)
	elif if_tier_requirement_is_met():
		_current_win_count += 1
		if _current_win_count == _current_consecutive_wins_needed:
			_cashout_prize()
			red_dom_syn.remove_pact_from_sworn_list(self)
		else:
			_update_description_based_on_curr_win_count()

func _update_description_based_on_curr_win_count():
	good_descriptions[1] = "Wins needed before dream: [u]%s[/u]" % str(_current_consecutive_wins_needed - _current_win_count)
	emit_signal("on_description_changed")

#

func _cashout_prize():
	for i in _current_tier_to_count_map.size():
		var tier = _current_tier_to_count_map.keys()[i]
		var count = _current_tier_to_count_map.values()[i]
		
		for j in count:
			if !game_elements.tower_inventory_bench.is_bench_full():
				_create_and_add_random_tower(tier)
			else:
				game_elements.gold_manager.increase_gold_by(tier, game_elements.gold_manager.IncreaseGoldSource.TOWER_SELLBACK)

func _create_and_add_random_tower(arg_tier : int):
	var tower = game_elements.shop_manager.create_random_tower_at_bench(arg_tier)


#

func pact_unsworn(arg_replacing_pact):
	.pact_unsworn(arg_replacing_pact)
	
	game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_started__d")
	game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_ended__d")



#

func _on_round_started__d(curr_stageround):
	if !is_sworn:
		pact_can_be_sworn_conditional_clauses.attempt_insert_clause(PactCanBeSwornClauseId.DREAMS_REACH__DURING_ROUND)

func _on_round_ended__d(arg_stageround):
	if !is_sworn:
		pact_can_be_sworn_conditional_clauses.remove_clause(PactCanBeSwornClauseId.DREAMS_REACH__DURING_ROUND)



#########

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	if arg_game_elements.level_manager.current_level < min_player_level_for_offerable_inclusive:
		return false
	
	#
	
	var stage_round = arg_game_elements.stage_round_manager.current_stageround
	
	if stage_round.stage_num == max_stage_for_offerable_inclusive:
		return stage_round.round_num <= max_round_for_offerable_inclusive
	elif stage_round.stage_num > max_stage_for_offerable_inclusive:
		return false
	else:
		return true


