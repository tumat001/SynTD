
const GameElements = preload("res://GameElementsRelated/GameElements.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


signal on_activation_requirements_met(curr_tier)
signal on_activation_requirements_unmet(curr_tier)

signal on_description_changed()

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

func _init(arg_uuid : int, arg_name : String, arg_tier : int,
		arg_tier_needed_for_activation : int):
	pact_uuid = arg_uuid
	tier = arg_tier
	tier_needed_for_activation = arg_tier_needed_for_activation
	pact_name = arg_name
	
	pact_mag_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.DOMSYN_RED_PACT_MAGNITUDE)

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
	return true

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

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
	
	is_effects_active_in_game_elements = true


#

func pact_unsworn():
	is_sworn = false
	_remove_pact_from_game_elements(game_elements)

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	is_effects_active_in_game_elements = false


###########

func is_pact_offerable(arg_game_elements : GameElements, dom_syn_red, tier_to_be_offered) -> bool:
	return true

