extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_Red_DamageImplants = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_DamageImplants.gd")


signal base_dmg_changed(arg_val)

const tier_0_gold_cost : int = 1
const tier_0_tower_count_for_gold_cost : int = 1
const tier_0_stage_to_damage_map : Dictionary = {
	0 : 1.6,
	1 : 1.8,
	2 : 2.0,
	3 : 2.2,
	4 : 2.4,
	5 : 2.6,
	6 : 3.0,
	7 : 3.2,
	8 : 3.4,
	9 : 3.6,
}

const tier_1_gold_cost : int = 1
const tier_1_tower_count_for_gold_cost : int = 2
const tier_1_stage_to_damage_map : Dictionary = {
	0 : 1.20,
	1 : 1.20,
	2 : 1.35,
	3 : 1.50,
	4 : 1.65,
	5 : 1.80,
	6 : 1.95,
	7 : 1.95,
	8 : 2.10,
	9 : 2.25,
}

const tier_2_gold_cost : int = 1
const tier_2_tower_count_for_gold_cost : int = 2
const tier_2_stage_to_damage_map : Dictionary = {
	0 : 0.8,
	1 : 0.8,
	2 : 0.9,
	3 : 1.0,
	4 : 1.10,
	5 : 1.20,
	6 : 1.30,
	7 : 1.30,
	8 : 1.40,
	9 : 1.50,
}

const tier_3_gold_cost : int = 1
const tier_3_tower_count_for_gold_cost : int = 2
const tier_3_stage_to_damage_map : Dictionary = {
	0 : 0.40,
	1 : 0.40,
	2 : 0.45,
	3 : 0.50,
	4 : 0.55,
	5 : 0.60,
	6 : 0.65,
	7 : 0.65,
	8 : 0.70,
	9 : 0.75,
}

var _current_damage_map : Dictionary
var _current_base_dmg_amount : float
var _current_gold_cost : float
var _current_tower_amount_for_gold_cost : int

var _current_affected_towers_by_buff : Array = []

#

var _current_gold_carry_over__for_curr_round : float


var _current_gold_deduction_on_round_start : float
var _current_towers_to_give_effect_to : Array

var _current_gold_cost_per_round_with_carry_over : float  # for display purposes

var _current_gold_carry_over__for_all : float

#

const no_ingredient_towers_ratio_for_offerable_inclusive : float = 0.25

#

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.DAMAGE_IMPLANTS, "Damage Implants", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		_current_damage_map = tier_0_stage_to_damage_map
		_current_gold_cost = tier_0_gold_cost
		_current_tower_amount_for_gold_cost = tier_0_tower_count_for_gold_cost
	elif tier == 1:
		_current_damage_map = tier_1_stage_to_damage_map
		_current_gold_cost = tier_1_gold_cost
		_current_tower_amount_for_gold_cost = tier_1_tower_count_for_gold_cost
	elif tier == 2:
		_current_damage_map = tier_2_stage_to_damage_map
		_current_gold_cost = tier_2_gold_cost
		_current_tower_amount_for_gold_cost = tier_2_tower_count_for_gold_cost
	elif tier == 3:
		_current_damage_map = tier_3_stage_to_damage_map
		_current_gold_cost = tier_3_gold_cost
		_current_tower_amount_for_gold_cost = tier_3_tower_count_for_gold_cost
	
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_DamageImplants_Icon.png")

#

func _first_time_initialize():
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	_update_base_dmg()
	
	#
	
	game_elements.tower_manager.connect("tower_in_queue_free", self, "_on_tower_in_queue_free", [], CONNECT_PERSIST)
	game_elements.tower_manager.connect("tower_transfered_in_map_from_bench", self, "_on_tower_transfered_in_map_from_bench", [], CONNECT_PERSIST)
	game_elements.tower_manager.connect("tower_transfered_on_bench_from_in_map", self, "_on_tower_transfered_on_bench_from_in_map", [], CONNECT_PERSIST)
	game_elements.tower_manager.connect("tower_absorbed_ingredients_changed", self, "_on_tower_absorbed_ingredients_changed", [], CONNECT_PERSIST)
	
	_calculate_gold_cost_per_round__and_update_bad_descriptions()

#

func _on_tower_in_queue_free(arg_tower):
	if _is_tower_have_at_least_one_ingredient(arg_tower):
		_calculate_gold_cost_per_round__and_update_bad_descriptions()

func _on_tower_transfered_in_map_from_bench(arg_tower, arg_pla, arg_bench):
	if _is_tower_have_at_least_one_ingredient(arg_tower):
		_calculate_gold_cost_per_round__and_update_bad_descriptions()

func _on_tower_transfered_on_bench_from_in_map(arg_tower, arg_bench, arg_pla):
	if _is_tower_have_at_least_one_ingredient(arg_tower):
		_calculate_gold_cost_per_round__and_update_bad_descriptions()

func _on_tower_absorbed_ingredients_changed(arg_tower):
	_calculate_gold_cost_per_round__and_update_bad_descriptions()


func _is_tower_have_at_least_one_ingredient(arg_tower):
	return arg_tower.get_amount_of_ingredients_absorbed() > 0

#

func _calculate_gold_cost_per_round__and_update_bad_descriptions():
	_calculate_and_update_gold_cost_per_round()
	_update_bad_descriptions()

func _update_bad_descriptions():
	var plain_fragment__on_round_start = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_START, "On round start")
	var plain_fragment__gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % _current_gold_cost)
	var plain_fragment__absorbed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorbed")
	
	var plain_fragment__curr_gold_x = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s" % _current_gold_cost_per_round_with_carry_over)
	
	bad_descriptions = [
		["|0|: lose |1| for every %s in map tower(s) with at least 1 |2| ingredient effect." % _current_tower_amount_for_gold_cost, [plain_fragment__on_round_start, plain_fragment__gold, plain_fragment__absorbed]],
		["Current gold reduction per round: |0|.", [plain_fragment__curr_gold_x]]
		#"(Good effect applies only when this gold requirement is met.)"
	]
	
	emit_signal("on_description_changed")

func _calculate_and_update_gold_cost_per_round():
	var towers = game_elements.tower_manager.get_all_in_map_towers_except_in_queue_free()
	
	_current_gold_cost_per_round_with_carry_over = 0
	_current_gold_deduction_on_round_start = 0
	_current_gold_carry_over__for_curr_round = 0
	
	_current_towers_to_give_effect_to.clear()
	
	for tower in towers:
		if _is_tower_have_at_least_one_ingredient(tower):
			_current_gold_carry_over__for_curr_round += _current_gold_cost / _current_tower_amount_for_gold_cost
			_current_gold_cost_per_round_with_carry_over += _current_gold_cost / _current_tower_amount_for_gold_cost
			
			if _current_gold_carry_over__for_curr_round >= _current_gold_cost:
				_current_gold_deduction_on_round_start += _current_gold_cost
				_current_gold_carry_over__for_curr_round -= _current_gold_cost
			
			_current_towers_to_give_effect_to.append(tower)
	
	#_current_gold_carry_over = _carry_over_gold_cost



#

func _on_round_end(curr_stageround):
	_update_base_dmg()

func _update_base_dmg():
	var current_stage_num = game_elements.stage_round_manager.current_stageround.stage_num
	var dmg_at_stage : float = _current_damage_map[current_stage_num]
	
	if !is_equal_approx(_current_base_dmg_amount, dmg_at_stage):
		_current_base_dmg_amount = dmg_at_stage # setting var first to reflect changes immediately before doing anything
		
		# Ins start
		var interpreter_for_dmg = TextFragmentInterpreter.new()
		interpreter_for_dmg.display_body = false
		
		var ins_for_dmg = []
		ins_for_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "base damage", _current_base_dmg_amount, false))
		
		interpreter_for_dmg.array_of_instructions = ins_for_dmg
		
		var plain_fragment__absorbed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorbed")
		
		# Ins end
		_update_good_descs()
		
		emit_signal("base_dmg_changed", _current_base_dmg_amount)
	
	_current_base_dmg_amount = dmg_at_stage


func _update_good_descs():
	var plain_fragment__on_round_start = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_START, "On round start")
	
	
	var interpreter_for_base_dmg = TextFragmentInterpreter.new()
	interpreter_for_base_dmg.display_body = false
	var ins_for_base_dmg = []
	ins_for_base_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "base damage", _current_base_dmg_amount, false))
	interpreter_for_base_dmg.array_of_instructions = ins_for_base_dmg
	
	var plain_fragment__absorbed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorbed")
	
	good_descriptions.clear()
	good_descriptions = [
		["|0|: in map towers with at least 1 |1| ingredient effect gain |2| (based on stage number).", [plain_fragment__on_round_start, plain_fragment__absorbed, interpreter_for_base_dmg]],
		
	]
	
	emit_signal("on_description_changed")

##########


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
		
		game_elements.stage_round_manager.connect("round_started", self, "_on_round_start__for_effects", [], CONNECT_PERSIST)
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end__for_effects", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_DAMAGE_IMPLANTS_EFFECT):
		var effect = TowerEffect_Red_DamageImplants.new(self)
		
		tower.add_tower_effect(effect)

#


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
		
		game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_start__for_effects")
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end__for_effects")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_DAMAGE_IMPLANTS_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)

##########

func _on_round_start__for_effects(arg_stageround):
	for tower in _current_towers_to_give_effect_to:
		var implant_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_DAMAGE_IMPLANTS_EFFECT)
		
		if implant_effect != null:
			implant_effect.add_effects_to_tower()
			_current_affected_towers_by_buff.append(tower)
	
	_current_gold_carry_over__for_all += _current_gold_carry_over__for_curr_round
	var whole_num_carry_over : int = _current_gold_carry_over__for_all
	if whole_num_carry_over > 0:
		_current_gold_carry_over__for_all -= whole_num_carry_over
	
	game_elements.gold_manager.decrease_gold_by(_current_gold_deduction_on_round_start + whole_num_carry_over, game_elements.GoldManager.DecreaseGoldSource.SYNERGY)
	
	
#	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
#	var _carry_over_gold_cost : float = _current_gold_carry_over
#	for tower in towers:
#		var implant_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_DAMAGE_IMPLANTS_EFFECT)
#
#		if implant_effect != null and game_elements.gold_manager.current_gold >= _current_gold_cost and tower.get_amount_of_ingredients_absorbed() > 0:
#			implant_effect.add_effects_to_tower()
#			_current_affected_towers_by_buff.append(tower)
#			#game_elements.gold_manager.decrease_gold_by(_current_gold_cost, game_elements.GoldManager.DecreaseGoldSource.SYNERGY)
#
#			_carry_over_gold_cost += _current_gold_cost / _current_tower_amount_for_gold_cost
#			if _carry_over_gold_cost >= _current_gold_cost:
#				game_elements.gold_manager.decrease_gold_by(_current_gold_cost, game_elements.GoldManager.DecreaseGoldSource.SYNERGY)
#				_carry_over_gold_cost -= _current_gold_cost
#
#	_current_gold_carry_over = _carry_over_gold_cost



func _on_round_end__for_effects(arg_stageround):
	for tower in _current_affected_towers_by_buff:
		var implant_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_DAMAGE_IMPLANTS_EFFECT)
		if implant_effect != null:
			implant_effect.remove_effects_from_tower()
	
	_current_affected_towers_by_buff.clear()


############

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	var ingless_towers : float = 0
	
	var all_active_towers = arg_game_elements.tower_manager.get_all_in_map_towers_except_in_queue_free()
	for tower in all_active_towers:
		if tower.get_amount_of_ingredients_absorbed() == 0:
			ingless_towers += 1
	
	var is_offerable = (ingless_towers / all_active_towers.size()) <= no_ingredient_towers_ratio_for_offerable_inclusive
	
	return is_offerable


