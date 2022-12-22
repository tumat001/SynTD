extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"


const round_count_of_extra_difficulty = 4

const sv_inc__tier_1 = 2
const sv_inc__tier_2 = 3

const violet_tower_count_min_for_offerable : int = 2
const current_min_stageround_id_for_offerable_inclusive : String = "81"
const current_max_stageround_id_for_offerable_inclusive : String = "91"

const bad_desc_line_01 : String = "The last %s rounds will be %s difficulty higher (max difficulty: %s). Difficulty increase starts at stage-round [u]%s[/u]."
const bad_desc_line_02 : String = "This effect cannot be removed."


var _stageround_id_start_of_difficulty : String
var _current_round_sv_inc : int

var _base_round_count_of_extra_difficulty : int

var _stage_and_round_of_start
var _stageround_of_start

#

var sv_modi_id
var syn_to_always_activate_modi_id
var tower_benefit_as_if_modi_id

#
func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.VIOLET_IDENTITY, "Violet Identity", arg_tier, arg_tier_for_activation):
	
	var plain_fragment__red_tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Red towers")
	var plain_fragment__violet_synergy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_DOMINANT, "Violet Synergy")
	
	good_descriptions = [
		["|0| benefit from the |1|.", [plain_fragment__red_tower, plain_fragment__violet_synergy]],
		["The |0| is always active.", [plain_fragment__violet_synergy]]
		
	]
	
	if arg_tier == 1:
		_current_round_sv_inc = sv_inc__tier_1
	elif arg_tier == 2:
		_current_round_sv_inc = sv_inc__tier_2
	_base_round_count_of_extra_difficulty = round_count_of_extra_difficulty
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_VioletIdentity_Icon.png")

##


func _first_time_initialize():
	sv_modi_id = game_elements.EnemyManager.SVModiferIds.DOM_SYN_RED__VIOLET_IDENTITY
	syn_to_always_activate_modi_id = game_elements.synergy_manager.SynergiesToAlwaysActivateModiIds.DOM_SYN_RED__VIOLET_SYNERGY__VIOLET
	tower_benefit_as_if_modi_id = AbstractTower.BenefitFromSynAsIfHavingColorsModiIds.DOM_SYN_RED__VIOLET_SYNERGY__VIOLET
	
	_update_stage_and_round_of_end()
	game_elements.stage_round_manager.connect("before_round_ends", self, "_before_round_end", [], CONNECT_PERSIST)
	
	_update_description_o()
	
	common__make_pact_untakable_during_round()


func _update_stage_and_round_of_end():
	_stageround_of_start = game_elements.stage_round_manager.stagerounds.get_stage_round_after_x_rounds_from_current(game_elements.stage_round_manager.stagerounds.last_stage_round, -_base_round_count_of_extra_difficulty + 1)
	var arr = _stageround_of_start.convert_stageround_id_to_stage_and_round_num(_stageround_of_start.id)
	_stage_and_round_of_start = "%s-%s" % arr
	

func _update_description_o():
	bad_descriptions = [
		bad_desc_line_01 % [_base_round_count_of_extra_difficulty, _current_round_sv_inc, game_elements.enemy_manager.highest_final_sv, _stage_and_round_of_start],
		bad_desc_line_02
	]
	
	emit_signal("on_description_changed")


#########

func pact_sworn():
	.pact_sworn()
	
	if !game_elements.stage_round_manager.is_connected("before_round_ends", self, "_before_round_end"):
		game_elements.stage_round_manager.connect("before_round_ends", self, "_before_round_end", [], CONNECT_PERSIST)

#

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	_apply_syn_relateds()


func _apply_syn_relateds():
	game_elements.synergy_manager.add_dominant_synergy_id_to_always_activate(syn_to_always_activate_modi_id, TowerDominantColors.SynergyId.VIOLET)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_pact"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_pact", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_pact", [], CONNECT_PERSIST)
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	_towers_to_benefit_from_pact(all_towers)


#

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_pact"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_pact")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_pact")
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	_towers_to_remove_from_pact(all_towers)
	
	game_elements.synergy_manager.remove_dominant_synergy_id_to_always_activate(syn_to_always_activate_modi_id)


#

func _towers_to_benefit_from_pact(towers : Array):
	for tower in towers:
		_tower_to_benefit_from_pact(tower, false)
	game_elements.tower_manager.update_active_synergy__called_from_misc()

func _tower_to_benefit_from_pact(tower : AbstractTower, arg_update_syn : bool = true):
	if tower.is_benefit_from_syn_having_or_as_if_having_color(TowerColors.RED) and !tower.has_modi_id_benefit_from_syn_as_if_having_color(tower_benefit_as_if_modi_id):
		tower.add_benefit_from_syn_as_if_having_color(tower_benefit_as_if_modi_id, TowerColors.VIOLET, arg_update_syn)


func _towers_to_remove_from_pact(towers : Array):
	for tower in towers:
		_tower_to_remove_from_pact(tower, false)
	game_elements.tower_manager.update_active_synergy__called_from_misc()

func _tower_to_remove_from_pact(tower : AbstractTower, arg_update_syn : bool = true):
	if tower.has_modi_id_benefit_from_syn_as_if_having_color(tower_benefit_as_if_modi_id):
		tower.remove_benefit_from_syn_as_if_having_color(tower_benefit_as_if_modi_id, arg_update_syn)

##

func _before_round_end(arg_stageround):
	if arg_stageround.id == _stageround_of_start.id:
		_stageround_of_start_reached()


func _stageround_of_start_reached():
	game_elements.enemy_manager.add_sv_flat_value_modi_map__non_average_moving(sv_modi_id, _current_round_sv_inc)
	
	if game_elements.stage_round_manager.is_connected("before_round_ends", self, "_before_round_end"):
		game_elements.stage_round_manager.disconnect("before_round_ends", self, "_before_round_end")



func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier : int) -> bool:
	if !arg_game_elements.stage_round_manager.current_stageround.induce_enemy_strength_value_change:
		return false
	
	#
	var curr_stageround = arg_game_elements.stage_round_manager.current_stageround
	
	if _is_stageround_below_max_and_above_min_inclusive(curr_stageround):
		# perform color checks
		var all_towers = arg_game_elements.tower_manager.get_all_active_towers()
		var tower_count : int = 0
		for tower in all_towers:
			if tower.is_benefit_from_syn_having_or_as_if_having_color(TowerColors.VIOLET):
				tower_count += 1
				
				if tower_count <= violet_tower_count_min_for_offerable:
					return true
	
	return false

func _is_stageround_below_max_and_above_min_inclusive(arg_stageround):
	return arg_stageround.is_stageround_id_higher_or_equal_than_second_param(arg_stageround.id, current_min_stageround_id_for_offerable_inclusive) and !arg_stageround.is_stageround_id_higher_than_second_param(arg_stageround.id, current_max_stageround_id_for_offerable_inclusive)

func _has_no_other_offered_identity_pacts(arg_dom_syn_red):
	return !arg_dom_syn_red.has_at_least_one_of_pact_in_sworn_or_unsworn_list(StoreOfPactUUID.all_identity_pacts) 
