extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_Red_CombinationCatalog = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_CombinationCatalog.gd")

signal on_bonus_dmg_amount_changed(arg_bonus_amount)

var bonus_dmg_per_combination : float
var gold_reduction_per_round : int

var _current_bonus_dmg_amount : float


const combinations_required_for_offerable_inclusive : int = 2


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.COMBINATION_CATALOG, "Combination Catalog", arg_tier, arg_tier_for_activation):
	if tier == 0:
		bonus_dmg_per_combination = 0.08
		gold_reduction_per_round = 2
		
	elif tier == 1:
		bonus_dmg_per_combination = 0.05
		gold_reduction_per_round = 2
		
	elif tier == 2:
		bonus_dmg_per_combination = 0.03
		gold_reduction_per_round = 2
		
	elif tier == 3:
		bonus_dmg_per_combination = 0.01
		gold_reduction_per_round = 2
	
	#
	var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
	interpreter_for_bonus_dmg.display_body = false
	
	var ins_for_bonus_dmg = []
	ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", bonus_dmg_per_combination * 100, true))
	
	interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
	
	var plain_fragment__combination = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COMBINATION, "combination")
	var plain_fragment__gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % str(gold_reduction_per_round))
	var plain_fragment__on_round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
	
	#
	good_descriptions = [
		["Gain |0| for each |1| you have.", [interpreter_for_bonus_dmg, plain_fragment__combination]],
		""
	]
	
	bad_descriptions = [
		["|0|: lose |1|.", [plain_fragment__on_round_end, plain_fragment__gold]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_CombinationCatalog_Icon.png")

#

func _first_time_initialize():
	game_elements.combination_manager.connect("on_combination_effect_added", self, "_on_combination_effect_added", [], CONNECT_PERSIST)
	_update_bonus_dmg()


func _on_combination_effect_added(arg_combi_id):
	_update_bonus_dmg()


func _update_bonus_dmg():
	var amount_of_combi = game_elements.combination_manager.all_combination_id_to_effect_map.size()
	var total_bonus_dmg = amount_of_combi * bonus_dmg_per_combination
	_current_bonus_dmg_amount = total_bonus_dmg
	
	#
	var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
	interpreter_for_bonus_dmg.display_body = false
	
	var ins_for_bonus_dmg = []
	ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", total_bonus_dmg * 100, true))
	
	interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
	
	#
	good_descriptions[1] = (["Current bonus: |0|", [interpreter_for_bonus_dmg]])
	emit_signal("on_description_changed")
	
	emit_signal("on_bonus_dmg_amount_changed", _current_bonus_dmg_amount)

#


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_COMBINATION_CATALOG_BONUS_DMG_EFFECT_GIVER):
		var effect = TowerEffect_Red_CombinationCatalog.new(self)
		
		tower.add_tower_effect(effect)


func _on_round_end(arg_stageround):
	game_elements.gold_manager.decrease_gold_by(gold_reduction_per_round, game_elements.gold_manager.DecreaseGoldSource.SYNERGY)


#


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_COMBINATION_CATALOG_BONUS_DMG_EFFECT_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)


func pact_unsworn(arg_replacing_pact):
	.pact_unsworn(arg_replacing_pact)
	
	game_elements.combination_manager.disconnect("on_combination_effect_added", self, "_on_combination_effect_added")

#####

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.combination_manager.all_combination_id_to_effect_map.size() >= combinations_required_for_offerable_inclusive
