extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerMarkEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerMarkEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

var _curr_number_of_towers_that_cant_attack : int
var _additional_dom_syn_activatable : int
var _less_comple_syn_activatable : int

var _disabled_by_this_pact_towers : Array = []

var _is_unsworn : bool = false



func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.DOMINANCE_SUPPLEMENT, "Dominance Supplement", arg_tier, arg_tier_for_activation):
	if tier == 0:
		_additional_dom_syn_activatable = 2
		_curr_number_of_towers_that_cant_attack = 6
	elif tier == 1:
		_additional_dom_syn_activatable = 2
		_curr_number_of_towers_that_cant_attack = 5
	elif tier == 2:
		_additional_dom_syn_activatable = 1
		_curr_number_of_towers_that_cant_attack = 3
	elif tier == 3:
		_additional_dom_syn_activatable = 1
		_curr_number_of_towers_that_cant_attack = 2
	
	_less_comple_syn_activatable = -1
	
	#
	
	var plain_fragment__dominant_synergies = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_DOMINANT, "+%s dominant synergies" % str(_additional_dom_syn_activatable))
	var plain_fragment__less_composite_synergies = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SYNERGY_COMPOSITE, "%s less complementary synergies" % str(-_less_comple_syn_activatable))
	
	good_descriptions = [
		["|0| can be activated. Synergies do not cancel each other out.", [plain_fragment__dominant_synergies]],
		"The next %s tower(s) you buy do not take tower slots, but cannot attack." % str(_curr_number_of_towers_that_cant_attack)
	]
	
	bad_descriptions = [
		["|0| can be activated.", [plain_fragment__less_composite_synergies]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_DominanceSupplement_Icon.png")

##

func pact_sworn():
	.pact_sworn()
	
	game_elements.synergy_manager.dont_allow_same_total_conditonal_clause.attempt_insert_clause(game_elements.synergy_manager.DontAllowSameTotalsContionalClauseIds.SYN_RED__DOMINANCE_SUPPLEMENT)
	
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added", [], CONNECT_PERSIST)
	
	var dom_syn_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_DOMINANCE_EXTRA_DOMINANCE_SLOTS)
	dom_syn_modi.flat_modifier = _additional_dom_syn_activatable
	game_elements.synergy_manager.add_dominant_syn_limit_modi(dom_syn_modi)
	
	var comple_syn_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_DOMINANCE_LESS_COMPLEMENTARY_SLOTS)
	comple_syn_modi.flat_modifier = _less_comple_syn_activatable
	game_elements.synergy_manager.add_composite_syn_limit_modi(comple_syn_modi)
	

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	for tower in _disabled_by_this_pact_towers:
		if is_instance_valid(tower):
			tower.contributing_to_synergy_clauses.remove_clause(tower.ContributingToSynergyClauses.DOM_SYN__RED__DOMINANCE_SUPPLEMENT)
	
	#
	
	

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
		
		var effect = TowerMarkEffect.new(StoreOfTowerEffectsUUID.RED_PACT_DOMINANCE_SUPPLEMENT_MARK_EFFECT)
		effect.status_bar_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/TowerDisabled_StatusBarIcon.png")
		arg_tower.add_tower_effect(effect)
		
		_disabled_by_this_pact_towers.append(arg_tower)


func _apply_supplement_effects_on_tower(arg_tower):
	arg_tower.disabled_from_attacking_clauses.attempt_insert_clause(arg_tower.DisabledFromAttackingSourceClauses.DOM_SYN__RED__DOMINANCE_SUPPLEMENT)
	arg_tower.tower_limit_slots_taken = 0

##

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	for tower in _disabled_by_this_pact_towers:
		if is_instance_valid(tower):
			tower.contributing_to_synergy_clauses.attempt_insert_clause(tower.ContributingToSynergyClauses.DOM_SYN__RED__DOMINANCE_SUPPLEMENT)
	
	#
	
#	game_elements.synergy_manager.remove_dominant_syn_limit_modi(StoreOfTowerEffectsUUID.RED_PACT_DOMINANCE_EXTRA_DOMINANCE_SLOTS, false)
#	game_elements.synergy_manager.remove_composite_syn_limit_modi(StoreOfTowerEffectsUUID.RED_PACT_DOMINANCE_LESS_COMPLEMENTARY_SLOTS)
#
#	if _is_unsworn:
#		game_elements.synergy_manager.dont_allow_same_total_conditonal_clause.remove_clause(game_elements.synergy_manager.DontAllowSameTotalsContionalClauseIds.SYN_RED__DOMINANCE_SUPPLEMENT)


func pact_unsworn(arg_replacing_pact):
	.pact_unsworn(arg_replacing_pact)
	_is_unsworn = true
	
	for tower in _disabled_by_this_pact_towers:
		if is_instance_valid(tower):
			tower.sell_tower()
	
	
	if _is_unsworn:
		game_elements.synergy_manager.remove_dominant_syn_limit_modi(StoreOfTowerEffectsUUID.RED_PACT_DOMINANCE_EXTRA_DOMINANCE_SLOTS, false)
		game_elements.synergy_manager.remove_composite_syn_limit_modi(StoreOfTowerEffectsUUID.RED_PACT_DOMINANCE_LESS_COMPLEMENTARY_SLOTS)
		
		game_elements.synergy_manager.dont_allow_same_total_conditonal_clause.remove_clause(game_elements.synergy_manager.DontAllowSameTotalsContionalClauseIds.SYN_RED__DOMINANCE_SUPPLEMENT)



##################

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.level_manager.current_level >= arg_game_elements.level_manager.LEVEL_6

