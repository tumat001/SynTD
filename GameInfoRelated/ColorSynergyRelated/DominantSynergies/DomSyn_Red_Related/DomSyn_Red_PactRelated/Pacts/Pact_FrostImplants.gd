extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_Red_FrostImplants = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_FrostImplants.gd")

#const tier_0_slow_amount : float = 40.0
#const tier_1_slow_amount : float = 30.0
#const tier_2_slow_amount : float = 22.5
#const tier_3_slow_amount : float = 15.0


const tier_0_icicle_count : int = 14
const tier_1_icicle_count : int = 12
const tier_2_icicle_count : int = 8
const tier_3_icicle_count : int = 6

const tier_0_gold_cost : int = 2
const tier_1_gold_cost : int = 2
const tier_2_gold_cost : int = 1
const tier_3_gold_cost : int = 1

const tier_0_slow_amount : float = -45.0
const tier_1_slow_amount : float = -40.0
const tier_2_slow_amount : float = -30.0
const tier_3_slow_amount : float = -25.0

const frost_icicle_base_dmg : float = 0.5
const frost_icicle_dmg_type : int = DamageType.ELEMENTAL
const frost_icicle_pierce : int = 1

const frost_icicle_delay_between_shoot : float = 0.225


const slow_duration : float = 2.0

const frost_attacks_cooldown : float = 18.0


var frost_targeting : int = Targeting.RANDOM

var _current_icicle_count : int
var _current_gold_cost : int
var _current_slow_amount : float

var _current_affected_towers_by_buff : Array = []

#

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.FROST_IMPLANTS, "Frost Implants", arg_tier, arg_tier_for_activation):
	if tier == 0:
		_current_icicle_count = tier_0_icicle_count
		_current_gold_cost = tier_0_gold_cost
		_current_slow_amount = tier_0_slow_amount
	elif tier == 1:
		_current_icicle_count = tier_1_icicle_count
		_current_gold_cost = tier_1_gold_cost
		_current_slow_amount = tier_1_slow_amount
	elif tier == 2:
		_current_icicle_count = tier_2_icicle_count
		_current_gold_cost = tier_2_gold_cost
		_current_slow_amount = tier_2_slow_amount
	elif tier == 3:
		_current_icicle_count = tier_3_icicle_count
		_current_gold_cost = tier_3_gold_cost
		_current_slow_amount = tier_3_slow_amount
	
	#
	var plain_fragment__on_round_start = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_START, "On round start")
	var plain_fragment__gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % _current_gold_cost)
	var plain_fragment__absorbed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorbed")
	var plain_fragment__slow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "slow")
	
	bad_descriptions = [
		["|0|: lose |1| for each in map tower with at least 1 |2| ingredient effect.", [plain_fragment__on_round_start, plain_fragment__gold, plain_fragment__absorbed]],
		"(Good effect applies only when this gold requirement is met.)"
	]
	#
	
	good_descriptions = [
		["|0|: in map towers with at least 1 |1| ingredient effect release a flurry of [u]%s[/u] icicles every %s seconds." % [_current_icicle_count, frost_attacks_cooldown], [plain_fragment__on_round_start, plain_fragment__absorbed]],
		["Icicles |0| enemies hit by [u]%s%%[/u] for %s seconds." % [-_current_slow_amount, slow_duration], [plain_fragment__slow]],
	]
	
	#
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_FrostImplants_Icon.png")



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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_FROST_IMPLANTS_EFFECT):
		var effect = TowerEffect_Red_FrostImplants.new()
		effect.frost_icicle_count = _current_icicle_count
		effect.frost_icicle_base_dmg = frost_icicle_base_dmg
		effect.frost_icicle_dmg_type = frost_icicle_dmg_type
		effect.frost_icicle_pierce = frost_icicle_pierce
		
		effect.frost_icicle_delay_between_shoot = frost_icicle_delay_between_shoot
		effect.frost_targeting = frost_targeting
		
		effect.slow_amount = _current_slow_amount
		effect.slow_duration = slow_duration
		
		effect.frost_attack_cd = frost_attacks_cooldown
		
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
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_FROST_IMPLANTS_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)

##########

func _on_round_start__for_effects(arg_stageround):
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		var implant_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_FROST_IMPLANTS_EFFECT)
		
		if implant_effect != null:
			if game_elements.gold_manager.current_gold >= _current_gold_cost and tower.get_amount_of_ingredients_absorbed() > 0:
				implant_effect.add_effects_to_tower()
				_current_affected_towers_by_buff.append(tower)
				game_elements.gold_manager.decrease_gold_by(_current_gold_cost, game_elements.GoldManager.DecreaseGoldSource.SYNERGY)
			else:
				implant_effect.hide_frost_attack_module_icon_from_tower()


func _on_round_end__for_effects(arg_stageround):
	for tower in _current_affected_towers_by_buff:
		var implant_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_FROST_IMPLANTS_EFFECT)
		if implant_effect != null:
			implant_effect.remove_effects_from_tower()
	
	_current_affected_towers_by_buff.clear()

