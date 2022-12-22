extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"


#const round_count_of_extra_difficulty__tier_0 = 2
#const sv_inc__tier_0 = 1
#
#const round_count_of_extra_difficulty__tier_1 = 4
#const sv_inc__tier_1 = 2

const round_count_of_extra_difficulty = 8

const sv_inc__tier_2 = 1
const sv_inc__tier_3 = 2


const stageround_id_end_of_difficult_rounds_for_offerable : String = "92"
const blue_tower_count_min_for_offerable : int = 2


const bad_desc_line_01 : String = "The next %s rounds will be %s difficulty higher (max difficulty: %s)."
const bad_desc_line_02 : String = "Current round count: [u]%s[/u]. (Ends at stage-round %s)"


var _current_round_count_of_extra_difficulty : int
var _base_round_count_of_extra_difficulty : int
var _current_round_sv_inc : int

var _stage_and_round_of_end
var _removed_extra_difficulty : bool

# ids

var sv_modi_id
var syn_to_always_activate_modi_id
var tower_benefit_as_if_modi_id

#

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.BLUE_IDENTITY, "Blue Identity", arg_tier, arg_tier_for_activation):
	
	var plain_fragment__red_tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Red towers")
	var plain_fragment__blue_synergy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_DOMINANT, "Blue Synergy")
	
	good_descriptions = [
		["|0| benefit from the |1|.", [plain_fragment__red_tower, plain_fragment__blue_synergy]],
		["The |0| is always active.", [plain_fragment__blue_synergy]]
	]
	
	if arg_tier == 2:
		_current_round_count_of_extra_difficulty = round_count_of_extra_difficulty
		_current_round_sv_inc = sv_inc__tier_2
	elif arg_tier == 3:
		_current_round_count_of_extra_difficulty = round_count_of_extra_difficulty
		_current_round_sv_inc = sv_inc__tier_3
	_base_round_count_of_extra_difficulty = _current_round_count_of_extra_difficulty
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_BlueIdentity_Icon.png")


func _first_time_initialize():
	sv_modi_id = game_elements.EnemyManager.SVModiferIds.DOM_SYN_RED__BLUE_IDENTITY
	syn_to_always_activate_modi_id = game_elements.synergy_manager.SynergiesToAlwaysActivateModiIds.DOM_SYN_RED__BLUE_SYNERGY__BLUE
	tower_benefit_as_if_modi_id = AbstractTower.BenefitFromSynAsIfHavingColorsModiIds.DOM_SYN_RED__BLUE_SYNERGY__BLUE
	
	_update_stage_and_round_of_end()
	game_elements.stage_round_manager.connect("before_round_ends", self, "_before_round_end", [], CONNECT_PERSIST)
	
	_update_description_o()
	
	common__make_pact_untakable_during_round()


func _update_stage_and_round_of_end():
	var stageround_of_end = game_elements.stage_round_manager.stagerounds.get_stage_round_after_x_rounds_from_current_index(game_elements.stage_round_manager.current_stageround_index, _current_round_count_of_extra_difficulty)
	var arr = stageround_of_end.convert_stageround_id_to_stage_and_round_num(stageround_of_end.id)
	_stage_and_round_of_end = "%s-%s" % arr
	

func _update_description_o():
	if _current_round_count_of_extra_difficulty > 0:
		bad_descriptions = [
			bad_desc_line_01 % [_base_round_count_of_extra_difficulty, _current_round_sv_inc, game_elements.enemy_manager.highest_final_sv],
			bad_desc_line_02 % [_current_round_count_of_extra_difficulty, _stage_and_round_of_end],
		]
	else:
		bad_descriptions = [
			
		]
	
	emit_signal("on_description_changed")


#########

func _before_round_end(arg_stageround):
	if !is_sworn:
		_update_stage_and_round_of_end()
	elif !_removed_extra_difficulty:
		_decrease_current_round_count_of_extra_difficulty()
	
	_update_description_o()

func _decrease_current_round_count_of_extra_difficulty():
	_current_round_count_of_extra_difficulty -= 1
	
	if _current_round_count_of_extra_difficulty <= 0:
		_removed_extra_difficulty = true
		
		_unapply_extra_difficulty()

##

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	_apply_extra_difficulty__and_syn_relateds()

func _apply_extra_difficulty__and_syn_relateds():
	if !_removed_extra_difficulty:
		game_elements.enemy_manager.add_sv_flat_value_modi_map__non_average_moving(sv_modi_id, _current_round_sv_inc)
	
	game_elements.synergy_manager.add_dominant_synergy_id_to_always_activate(syn_to_always_activate_modi_id, TowerDominantColors.SynergyId.BLUE)
	
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
	
	_unapply_extra_difficulty()
	game_elements.synergy_manager.remove_dominant_synergy_id_to_always_activate(syn_to_always_activate_modi_id)


func _unapply_extra_difficulty():
	game_elements.enemy_manager.remove_sv_flat_value_modi_map__non_average_moving(sv_modi_id)
	


#

func _towers_to_benefit_from_pact(towers : Array):
	for tower in towers:
		_tower_to_benefit_from_pact(tower, false)
	game_elements.tower_manager.update_active_synergy__called_from_misc()

func _tower_to_benefit_from_pact(tower : AbstractTower, arg_update_syn : bool = true):
	if tower.is_benefit_from_syn_having_or_as_if_having_color(TowerColors.RED) and !tower.has_modi_id_benefit_from_syn_as_if_having_color(tower_benefit_as_if_modi_id):
		tower.add_benefit_from_syn_as_if_having_color(tower_benefit_as_if_modi_id, TowerColors.BLUE, arg_update_syn)


func _towers_to_remove_from_pact(towers : Array):
	for tower in towers:
		_tower_to_remove_from_pact(tower, false)
	game_elements.tower_manager.update_active_synergy__called_from_misc()

func _tower_to_remove_from_pact(tower : AbstractTower, arg_update_syn : bool = true):
	if tower.has_modi_id_benefit_from_syn_as_if_having_color(tower_benefit_as_if_modi_id):
		tower.remove_benefit_from_syn_as_if_having_color(tower_benefit_as_if_modi_id, arg_update_syn)

#

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier : int) -> bool:
	if !arg_game_elements.stage_round_manager.current_stageround.induce_enemy_strength_value_change:
		return false
	
	#
	var curr_stageround_index = arg_game_elements.stage_round_manager.current_stageround_index
	var first_bool_check : bool = arg_dom_syn_red._x_identity_first_bool_check_status__8_rounds
	
	if arg_dom_syn_red._x_identity_stage_round_index_used_for_cals__8_rounds != curr_stageround_index:
		#print("curr index calculating - BLUE: %s. %s" % [curr_stageround_index, arg_dom_syn_red._x_identity_stage_round_index_used_for_cals__8_rounds])
		arg_dom_syn_red._x_identity_stage_round_index_used_for_cals__8_rounds = curr_stageround_index
		
		var round_count : int
		if arg_tier == 2:
			round_count = round_count_of_extra_difficulty
		elif arg_tier == 3:
			round_count = round_count_of_extra_difficulty
		
		var stageround_of_end = arg_game_elements.stage_round_manager.stagerounds.get_stage_round_after_x_rounds_from_current_index(curr_stageround_index, round_count)
		
		if !stageround_of_end.is_stageround_id_higher_than_second_param(stageround_id_end_of_difficult_rounds_for_offerable, stageround_of_end.id) and !_has_no_other_offered_identity_pacts(arg_dom_syn_red):
			first_bool_check = true
			arg_dom_syn_red._x_identity_first_bool_check_status__8_rounds = first_bool_check
			
		else:
			arg_dom_syn_red._x_identity_first_bool_check_status__8_rounds = false
			return false
	
	if first_bool_check:
		# perform color checks
		var all_towers = arg_game_elements.tower_manager.get_all_active_towers()
		var tower_count : int = 0
		for tower in all_towers:
			if tower.is_benefit_from_syn_having_or_as_if_having_color(TowerColors.BLUE):
				tower_count += 1
				
				if tower_count <= blue_tower_count_min_for_offerable:
					return true
	
	return false

func _has_no_other_offered_identity_pacts(arg_dom_syn_red):
	return !arg_dom_syn_red.has_at_least_one_of_pact_in_sworn_or_unsworn_list(StoreOfPactUUID.all_identity_pacts) 

