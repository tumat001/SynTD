extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"



const TowerEffect_Red_RangeProvisionsEffect = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_RangeProvisions.gd")

var _range_flat_amount : float

var _attk_speed_reduc_percent : float

const no_ingredient_towers_ratio_for_offerable_inclusive : float = 0.5


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.RANGE_PROVISIONS, "Range Provisions", arg_tier, arg_tier_for_activation):
	if tier == 0:
		_range_flat_amount = 100
		_attk_speed_reduc_percent = -10
	elif tier == 1:
		_range_flat_amount = 70
		_attk_speed_reduc_percent = -8
	elif tier == 2:
		_range_flat_amount = 50
		_attk_speed_reduc_percent = -6
	elif tier == 3:
		_range_flat_amount = 15
		_attk_speed_reduc_percent = -4
	
	
	#
	var interpreter_for_range = TextFragmentInterpreter.new()
	interpreter_for_range.display_body = false
	
	var ins_for_range = []
	ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", _range_flat_amount, false))
	
	interpreter_for_range.array_of_instructions = ins_for_range
	
	
	var interpreter_for_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_attk_speed.display_body = false
	
	var ins_for_attk_speed = []
	ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", -_attk_speed_reduc_percent, true))
	
	interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
	
	var plain_fragment__absorbed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorbed")
	
	#
	
	good_descriptions = [
		["Towers with no |0| ingredient effects gain |1|.", [plain_fragment__absorbed, interpreter_for_range]]
	]
	
	bad_descriptions = [
		["Towers with |0| ingredient effects lose |1|.", [plain_fragment__absorbed, interpreter_for_attk_speed]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_RangeProvisions_Icon.png")

#


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


#

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_EFFECT_GIVER):
		var effect = TowerEffect_Red_RangeProvisionsEffect.new()
		
		effect.attk_speed_reduc_amount = _attk_speed_reduc_percent
		effect.range_amount = _range_flat_amount
		
		tower.add_tower_effect(effect)

#


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_EFFECT_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)

######

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	var ingless_towers : float = 0
	
	var all_active_towers = arg_game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in all_active_towers:
		if tower.get_amount_of_ingredients_absorbed() == 0:
			ingless_towers += 1
	
	var is_offerable = (ingless_towers / all_active_towers.size()) >= no_ingredient_towers_ratio_for_offerable_inclusive
	
	return is_offerable
