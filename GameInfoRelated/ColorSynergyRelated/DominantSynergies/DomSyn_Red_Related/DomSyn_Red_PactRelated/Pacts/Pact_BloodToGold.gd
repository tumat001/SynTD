extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const BloodtoGold_AbilityIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_AbilityIcons/Pact_BloodAndGold_AbilityIcon.png")

var _health_cost_per_cast : int
var _gold_gain_per_cast : int

var _blood_to_gold_ability : BaseAbility


const health_max_for_offerable_inc : int = 100
const health_min_for_offerable_inc : int = 50

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.BLOOD_TO_GOLD, "Blood to Gold", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		_health_cost_per_cast = 5
		_gold_gain_per_cast = 4
	elif tier == 1:
		_health_cost_per_cast = 4
		_gold_gain_per_cast = 3
	elif tier == 2:
		_health_cost_per_cast = 3
		_gold_gain_per_cast = 2
	elif tier == 3:
		
		_health_cost_per_cast = 2
		_gold_gain_per_cast = 1
	
	
	var plain_fragment__gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % str(_gold_gain_per_cast))
	
	good_descriptions = [
		["Gain ability: Blood to Gold. Convert %s health to |0|" % [str(_health_cost_per_cast)], [plain_fragment__gold]],
		""
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_BloodAndGold_Icon.png")
	

#

func _first_time_initialize():
	game_elements.health_manager.connect("current_health_changed", self, "_on_health_changed", [], CONNECT_PERSIST)
	
	_update_max_gold_description()


func _on_health_changed(new_val):
	_update_max_gold_description()

func _update_max_gold_description():
	var curr_health = game_elements.health_manager.current_health
	var max_gold = floor((curr_health - 1) / _health_cost_per_cast) * _gold_gain_per_cast
	
	good_descriptions[1] = "Max gold gained from this: %s" % max_gold
	emit_signal("on_description_changed")

#

func pact_sworn():
	.pact_sworn()
	
	_construct_and_add_ability()

func _construct_and_add_ability():
	_blood_to_gold_ability = BaseAbility.new()
	_blood_to_gold_ability.is_timebound = true
	_blood_to_gold_ability.connect("ability_activated", self, "_ability_activated", [], CONNECT_PERSIST)
	_blood_to_gold_ability.icon = BloodtoGold_AbilityIcon
	
	_blood_to_gold_ability.auto_castable_clauses.attempt_insert_clause(BaseAbility.AutoCastableClauses.CANNOT_BE_AUTOCASTED)
	_blood_to_gold_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	
	_blood_to_gold_ability.red_pact = self
	
	_blood_to_gold_ability.descriptions = [
		"Convert %s health to %s gold" % [str(_health_cost_per_cast), str(_gold_gain_per_cast)]
	]
	_blood_to_gold_ability.display_name = "Blood To Gold"
	
	register_ability_to_manager(_blood_to_gold_ability)

func register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	game_elements.ability_manager.add_ability(ability, add_to_panel)





func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	


func _ability_activated():
	game_elements.health_manager.decrease_health_by(_health_cost_per_cast, game_elements.HealthManager.DecreaseHealthSource.SYNERGY)
	game_elements.gold_manager.increase_gold_by(_gold_gain_per_cast, game_elements.GoldManager.IncreaseGoldSource.SYNERGY)

#


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	

func pact_unsworn(arg_replacing_pact):
	.pact_unsworn(arg_replacing_pact)
	
	_blood_to_gold_ability.destroy_self()
	game_elements.health_manager.disconnect("current_health_changed", self, "_on_health_changed")


####

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	var curr_health = arg_game_elements.health_manager.current_health
	return curr_health <= health_max_for_offerable_inc and curr_health >= health_min_for_offerable_inc

