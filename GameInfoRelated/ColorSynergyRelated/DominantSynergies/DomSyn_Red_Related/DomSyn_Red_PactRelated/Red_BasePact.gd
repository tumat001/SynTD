
const GameElements = preload("res://GameElementsRelated/GameElements.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

signal on_activation_requirements_met(curr_tier)
signal on_activation_requirements_unmet(curr_tier)

signal on_description_changed()

signal pact_sworn()

signal last_calculated_can_be_sworn_changed(arg_val)


var game_elements : GameElements
var red_dom_syn

var pact_icon : Texture
var pact_name : String
var pact_uuid : int

var good_descriptions : Array
var bad_descriptions : Array

var tier : int
var tier_needed_for_activation : int # most of the time, same as tier, but Future Sight can change this.

var is_sworn : bool
var is_effects_active_in_game_elements : bool
var is_activation_requirements_met : bool

var pact_mag_rng : RandomNumberGenerator

#

enum PactCanBeSwornClauseId {
	GENERIC__CANNOT_BE_SWORN_DURING_ROUND = 0
	
	HEALING_SYMBOL_BENCH_STATUS = 100
	COMBINATION_EFFICIENCY_AMOUNT_MIN_REACHED = 101
	
	DREAMS_REACH__DURING_ROUND = 102
}
var pact_can_be_sworn_conditional_clauses : ConditionalClauses
var last_calculated_can_be_sworn : bool

#

func _init(arg_uuid : int, arg_name : String, arg_tier : int,
		arg_tier_needed_for_activation : int):
	pact_uuid = arg_uuid
	tier = arg_tier
	tier_needed_for_activation = arg_tier_needed_for_activation
	pact_name = arg_name
	
	pact_mag_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.DOMSYN_RED_PACT_MAGNITUDE)
	
	#
	
	pact_can_be_sworn_conditional_clauses = ConditionalClauses.new()
	pact_can_be_sworn_conditional_clauses.connect("clause_inserted", self, "_on_pact_can_be_sworn_conditional_clauses_updated", [], CONNECT_PERSIST)
	pact_can_be_sworn_conditional_clauses.connect("clause_removed", self ,"_on_pact_can_be_sworn_conditional_clauses_updated", [], CONNECT_PERSIST)
	_on_pact_can_be_sworn_conditional_clauses_updated(null) # arg does not matter

#

func set_up_tier_changes_and_watch_requirements(arg_game_elements : GameElements, arg_red_dom_syn):
	if red_dom_syn == null:
		red_dom_syn = arg_red_dom_syn
	
	if game_elements == null:
		game_elements = arg_game_elements
	
	red_dom_syn.connect("on_curr_tier_changed", self, "red_dom_syn_curr_tier_changed", [], CONNECT_PERSIST)
	
	_check_requirement_status_and_do_appropriate_action()
	
	_first_time_initialize()

func _check_requirement_status_and_do_appropriate_action():
	if if_tier_requirement_is_met() and _if_other_requirements_are_met():
		is_activation_requirements_met = true
		emit_signal("on_activation_requirements_met", red_dom_syn.curr_tier)
		
		if is_sworn and !is_effects_active_in_game_elements:
			_apply_pact_to_game_elements(game_elements)
	else:
		is_activation_requirements_met = false
		emit_signal("on_activation_requirements_unmet", red_dom_syn.curr_tier)
		
		if is_sworn and is_effects_active_in_game_elements:
			_remove_pact_from_game_elements(game_elements)


func if_tier_requirement_is_met() -> bool:
	return red_dom_syn.curr_tier <= tier_needed_for_activation and red_dom_syn.curr_tier != red_dom_syn.TIER_INACTIVE

func _if_other_requirements_are_met() -> bool:
	return true


#

func _if_pact_can_be_sworn() -> bool:
	return last_calculated_can_be_sworn

#

func _first_time_initialize():
	pass

#

func red_dom_syn_curr_tier_changed(arg_new_tier : int):
	_check_requirement_status_and_do_appropriate_action()


#

func pact_sworn():
	is_sworn = true
	#_apply_pact_to_game_elements(game_elements)
	_check_requirement_status_and_do_appropriate_action()
	emit_signal("pact_sworn")

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
	
	is_effects_active_in_game_elements = true


#

func pact_unsworn(arg_replacing_pact):
	is_sworn = false
	_remove_pact_from_game_elements(game_elements)

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	is_effects_active_in_game_elements = false


###########

func is_pact_offerable(arg_game_elements : GameElements, dom_syn_red, tier_to_be_offered) -> bool:
	return true


###########

func _on_pact_can_be_sworn_conditional_clauses_updated(arg_clause_id):
	last_calculated_can_be_sworn = pact_can_be_sworn_conditional_clauses.is_passed
	emit_signal("last_calculated_can_be_sworn_changed", last_calculated_can_be_sworn)

########## COMMON METHODS ###########

func common__make_pact_untakable_during_round():
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end__make_pact_untakable_during_round", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("round_started", self, "_on_round_start__make_pact_untakable_during_round", [], CONNECT_PERSIST)
	
	connect("pact_sworn", self, "_on_pact_sworn__make_pact_untakable_during_round", [], CONNECT_PERSIST)

func _on_round_end__make_pact_untakable_during_round(arg_stageround):
	pact_can_be_sworn_conditional_clauses.remove_clause(PactCanBeSwornClauseId.GENERIC__CANNOT_BE_SWORN_DURING_ROUND)

func _on_round_start__make_pact_untakable_during_round(arg_stageround):
	pact_can_be_sworn_conditional_clauses.attempt_insert_clause(PactCanBeSwornClauseId.GENERIC__CANNOT_BE_SWORN_DURING_ROUND)

func _on_pact_sworn__make_pact_untakable_during_round():
	game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end__make_pact_untakable_during_round")
	game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_start__make_pact_untakable_during_round")
	
	disconnect("pact_sworn", self, "_on_pact_sworn__make_pact_untakable_during_round")
	
	pact_can_be_sworn_conditional_clauses.remove_clause(PactCanBeSwornClauseId.GENERIC__CANNOT_BE_SWORN_DURING_ROUND)
