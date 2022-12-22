extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")


var less_towers_for_combination : int
var total_attk_speed_reduction_percent : float


const combinations_required_for_offerable_inclusive : int = 0
const gold_requirement_for_offerable_inclusive : int = 35


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.COMBINATION_EFFICIENCY, "Combination Efficiency", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		less_towers_for_combination = -2
		total_attk_speed_reduction_percent = -10
		
	elif tier == 1:
		less_towers_for_combination = -1
		total_attk_speed_reduction_percent = -20
		
	elif tier == 2:
		less_towers_for_combination = -1
		total_attk_speed_reduction_percent = -40
		
	elif tier == 3:
		less_towers_for_combination = -1
		total_attk_speed_reduction_percent = -60
	
	#
	var interpreter_for_attk_speed_reduc = TextFragmentInterpreter.new()
	interpreter_for_attk_speed_reduc.display_body = false
	
	var ins_for_attk_speed_reduc = []
	ins_for_attk_speed_reduc.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "total attack speed", -total_attk_speed_reduction_percent, true))
	
	interpreter_for_attk_speed_reduc.array_of_instructions = ins_for_attk_speed_reduc
	
	
	
	#
	good_descriptions = [
		
	]
	
	bad_descriptions = [
		["All towers lose |0|", [interpreter_for_attk_speed_reduc]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_CombinationEfficiency_Icon.png")


#

func _first_time_initialize():
	_update_good_descriptions()
	
	game_elements.combination_manager.connect("on_combination_amount_needed_changed", self, "_on_combination_amount_needed_changed", [], CONNECT_PERSIST)

func _update_good_descriptions():
	good_descriptions.clear()
	
	
	var plain_fragment__combinations = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COMBINATION, "combinations")
	
	good_descriptions.append(["%s less tower(s) are needed for |0|." % str(-less_towers_for_combination), [plain_fragment__combinations]])
	good_descriptions.append("Towers needed for combinations cannot go lower than: %s." % game_elements.combination_manager.minimum_combination_amount)
	
	emit_signal("on_description_changed")


func _on_combination_amount_needed_changed(arg_val):
	if _is_comb_amount_after_reduction_at_or_above_minimum(game_elements):
		pact_can_be_sworn_conditional_clauses.remove_clause(PactCanBeSwornClauseId.COMBINATION_EFFICIENCY_AMOUNT_MIN_REACHED)
	else:
		pact_can_be_sworn_conditional_clauses.attempt_insert_clause(PactCanBeSwornClauseId.COMBINATION_EFFICIENCY_AMOUNT_MIN_REACHED)

#

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)
	
	#
	
	game_elements.combination_manager.set_combination_amount_modi(game_elements.combination_manager.AmountForCombinationModifiers.DOMSYN_RED__COMBINATION_EFFICIENCY, less_towers_for_combination)

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_COMBINATION_EFFICIENCY_ATTK_SPEED_REDUC):
		
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_COMBINATION_EFFICIENCY_ATTK_SPEED_REDUC)
		attk_speed_attr_mod.percent_amount = total_attk_speed_reduction_percent
		attk_speed_attr_mod.percent_based_on = PercentType.MAX
		var attk_speed_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_COMBINATION_EFFICIENCY_ATTK_SPEED_REDUC)
		
		tower.add_tower_effect(attk_speed_attr_effect)



func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)
	
	#
	
	game_elements.combination_manager.remove_combination_amount_modi(game_elements.combination_manager.AmountForCombinationModifiers.DOMSYN_RED__COMBINATION_EFFICIENCY)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_COMBINATION_EFFICIENCY_ATTK_SPEED_REDUC)
	
	if effect != null:
		tower.remove_tower_effect(effect)


#

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.combination_manager.all_combination_id_to_effect_map.size() >= combinations_required_for_offerable_inclusive and arg_game_elements.gold_manager.current_gold >= gold_requirement_for_offerable_inclusive and _is_comb_amount_after_reduction_at_or_above_minimum(arg_game_elements)

func _is_comb_amount_after_reduction_at_or_above_minimum(arg_game_elements : GameElements):
	return arg_game_elements.combination_manager.last_calculated_combination_amount + less_towers_for_combination >= arg_game_elements.combination_manager.minimum_combination_amount

