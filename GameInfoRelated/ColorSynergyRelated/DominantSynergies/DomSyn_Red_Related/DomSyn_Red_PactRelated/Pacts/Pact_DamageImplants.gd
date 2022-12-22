extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_Red_DamageImplants = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_DamageImplants.gd")


signal base_dmg_changed(arg_val)

const tier_0_gold_cost : int = 2
const tier_0_stage_to_damage_map : Dictionary = {
	0 : 1.6,
	1 : 1.6,
	2 : 1.8,
	3 : 2.0,
	4 : 2.2,
	5 : 2.4,
	6 : 2.6,
	7 : 2.6,
	8 : 2.8,
	9 : 3.0,
}

const tier_1_gold_cost : int = 2
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

var _current_affected_towers_by_buff : Array = []

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.DAMAGE_IMPLANTS, "Damage Implants", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		_current_damage_map = tier_0_stage_to_damage_map
		_current_gold_cost = tier_0_gold_cost
	elif tier == 1:
		_current_damage_map = tier_1_stage_to_damage_map
		_current_gold_cost = tier_1_gold_cost
	elif tier == 2:
		_current_damage_map = tier_2_stage_to_damage_map
		_current_gold_cost = tier_2_gold_cost
	elif tier == 3:
		_current_damage_map = tier_3_stage_to_damage_map
		_current_gold_cost = tier_3_gold_cost
	
	var plain_fragment__on_round_start = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_START, "On round start")
	var plain_fragment__gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % _current_gold_cost)
	var plain_fragment__absorbed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorbed")
	
	bad_descriptions = [
		["|0|: lose |1| for each in map tower with at least 1 |2| ingredient effect.", [plain_fragment__on_round_start, plain_fragment__gold, plain_fragment__absorbed]],
		"(Good effect applies only when this gold requirement is met.)"
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_DamageImplants_Icon.png")

func _first_time_initialize():
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	_update_base_dmg()

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
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		var implant_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_DAMAGE_IMPLANTS_EFFECT)
		
		if implant_effect != null and game_elements.gold_manager.current_gold >= _current_gold_cost and tower.get_amount_of_ingredients_absorbed() > 0:
			implant_effect.add_effects_to_tower()
			_current_affected_towers_by_buff.append(tower)
			game_elements.gold_manager.decrease_gold_by(_current_gold_cost, game_elements.GoldManager.DecreaseGoldSource.SYNERGY)

func _on_round_end__for_effects(arg_stageround):
	for tower in _current_affected_towers_by_buff:
		var implant_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_DAMAGE_IMPLANTS_EFFECT)
		if implant_effect != null:
			implant_effect.remove_effects_from_tower()
	
	_current_affected_towers_by_buff.clear()


