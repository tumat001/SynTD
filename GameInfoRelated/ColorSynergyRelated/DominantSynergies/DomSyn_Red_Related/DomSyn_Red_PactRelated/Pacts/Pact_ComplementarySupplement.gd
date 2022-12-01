extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerMarkEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerMarkEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

var _curr_number_of_towers_that_cant_attack : int
var _additional_comple_syn_activatable : int

var _disabled_by_this_pact_towers : Array = []

var _is_unsworn : bool = false



func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.COMPLEMENTARY_SUPPLEMENT, "Composite Supplement", arg_tier, arg_tier_for_activation):
	if tier == 0:
		_additional_comple_syn_activatable = 2
		_curr_number_of_towers_that_cant_attack = 2
	elif tier == 1:
		_additional_comple_syn_activatable = 1
		_curr_number_of_towers_that_cant_attack = 1
	elif tier == 2:
		pass
	elif tier == 3:
		pass
	
	#
	
	var plain_fragment__composite_synergies = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_COMPOSITE, "+%s composite synergies" % str(_additional_comple_syn_activatable))
	var plain_fragment__on_round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
	
	
	good_descriptions = [
		["|0| can be activated. Synergies do not cancel each other out.", [plain_fragment__composite_synergies]],
		"The next %s tower(s) you buy do not take tower slots, but cannot attack." % str(_curr_number_of_towers_that_cant_attack)
	]
	
	bad_descriptions = [
		["|0|: a random non-red and non-disabled tower is sold.", [plain_fragment__on_round_end]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_ComplementSupplement_Icon.png")
	

#


func pact_sworn():
	.pact_sworn()
	
	game_elements.synergy_manager.dont_allow_same_total_conditonal_clause.attempt_insert_clause(game_elements.synergy_manager.DontAllowSameTotalsContionalClauseIds.SYN_RED__COMPLEMENTARY_SUPPLEMENT)
	
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST | CONNECT_DEFERRED)

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	for tower in _disabled_by_this_pact_towers:
		if is_instance_valid(tower):
			tower.contributing_to_synergy_clauses.remove_clause(tower.ContributingToSynergyClauses.DOM_SYN__RED__COMPLEMENTARY_SUPPLEMENT)
	
	#
	
	var comple_syn_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_COMPLEMENTARY_EXTRA_COMPLEMENTARY_SLOTS)
	comple_syn_modi.flat_modifier = _additional_comple_syn_activatable
	game_elements.synergy_manager.add_composite_syn_limit_modi(comple_syn_modi)
	


func _on_tower_added(arg_tower):
	if arg_tower.is_tower_bought:
		
		_apply_supplement_effects_on_tower(arg_tower)
		_curr_number_of_towers_that_cant_attack -= 1
		
		if _curr_number_of_towers_that_cant_attack > 0:
			good_descriptions[1] = "The next %s tower(s) you buy do not take tower slots, but cannot perform actions." % str(_curr_number_of_towers_that_cant_attack)
		else:
			good_descriptions[1] = ""
			game_elements.tower_manager.disconnect("tower_added", self, "_on_tower_added")
		emit_signal("on_description_changed")
		
		#
		
		var effect = TowerMarkEffect.new(StoreOfTowerEffectsUUID.RED_PACT_COMPLEMENTARY_SUPPLEMENT_MARK_EFFECT)
		effect.status_bar_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/TowerDisabled_StatusBarIcon.png")
		arg_tower.add_tower_effect(effect)
		
		_disabled_by_this_pact_towers.append(arg_tower)


func _apply_supplement_effects_on_tower(arg_tower):
	arg_tower.disabled_from_attacking_clauses.attempt_insert_clause(arg_tower.DisabledFromAttackingSourceClauses.DOM_SYN__RED__COMPLEMENTARY_SUPPLEMENT)
	arg_tower.tower_limit_slots_taken = 0

#

func _on_round_end(arg_stage_round):
	var all_non_red_towers = game_elements.tower_manager.get_all_active_towers_without_color(TowerColors.RED)
	var bucket := []
	for tower in all_non_red_towers:
		if !tower.is_queued_for_deletion() and !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_COMPLEMENTARY_SUPPLEMENT_MARK_EFFECT):
			bucket.append(tower)
	
	bucket = Targeting.enemies_to_target(bucket, Targeting.RANDOM, 1, Vector2(0, 0), true)
	
	if bucket.size() > 0:
		bucket[0].sell_tower()

##

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	for tower in _disabled_by_this_pact_towers:
		if is_instance_valid(tower):
			tower.contributing_to_synergy_clauses.attempt_insert_clause(tower.ContributingToSynergyClauses.DOM_SYN__RED__COMPLEMENTARY_SUPPLEMENT)
	
	#
#	game_elements.synergy_manager.remove_composite_syn_limit_modi(StoreOfTowerEffectsUUID.RED_PACT_COMPLEMENTARY_EXTRA_COMPLEMENTARY_SLOTS)
#
#	if _is_unsworn:
#		game_elements.synergy_manager.dont_allow_same_total_conditonal_clause.remove_clause(game_elements.synergy_manager.DontAllowSameTotalsContionalClauseIds.SYN_RED__COMPLEMENTARY_SUPPLEMENT)


func pact_unsworn(arg_replacing_pact):
	.pact_unsworn(arg_replacing_pact)
	_is_unsworn = true
	
	for tower in _disabled_by_this_pact_towers:
		if is_instance_valid(tower):
			tower.sell_tower()
	
	game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	game_elements.synergy_manager.remove_composite_syn_limit_modi(StoreOfTowerEffectsUUID.RED_PACT_COMPLEMENTARY_EXTRA_COMPLEMENTARY_SLOTS)
	
	if _is_unsworn:
		game_elements.synergy_manager.dont_allow_same_total_conditonal_clause.remove_clause(game_elements.synergy_manager.DontAllowSameTotalsContionalClauseIds.SYN_RED__COMPLEMENTARY_SUPPLEMENT)


##################

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.level_manager.current_level >= arg_game_elements.level_manager.LEVEL_6

