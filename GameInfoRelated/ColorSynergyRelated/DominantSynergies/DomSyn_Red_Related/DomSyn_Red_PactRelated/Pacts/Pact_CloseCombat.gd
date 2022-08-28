extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"


const TowerEffect_Red_CloseCombatEffect = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_CloseCombatEffect.gd")

signal on_damage_of_explosion_changed(arg_new_val)

const tier_0_stage_to_damage_map : Dictionary = {
	0 : 4,
	1 : 4.25,
	2 : 4.5,
	3 : 4.75,
	4 : 5,
	5 : 5.25,
	6 : 5.5,
	7 : 5.75,
	8 : 6,
	9 : 6.25
}

const tier_1_stage_to_damage_map : Dictionary = {
	0 : 3,
	1 : 3.25,
	2 : 3.5,
	3 : 3.75,
	4 : 4,
	5 : 4.25,
	6 : 4.5,
	7 : 4.75,
	8 : 5,
	9 : 5.25
}

const tier_2_stage_to_damage_map : Dictionary = {
	0 : 1,
	1 : 1.25,
	2 : 1.5,
	3 : 1.75,
	4 : 2,
	5 : 2.25,
	6 : 2.5,
	7 : 2.75,
	8 : 3,
	9 : 3.25
}

const tier_3_stage_to_damage_map : Dictionary = {
	0 : 0.25,
	1 : 0.25,
	2 : 0.5,
	3 : 0.75,
	4 : 1,
	5 : 1.25,
	6 : 1.5,
	7 : 1.75,
	8 : 2,
	9 : 2.25
}


var _current_damage_map : Dictionary
var _range_percent_reduc : float
var _explosion_cooldown : float

var _current_explosion_dmg : float = 0
var _range_trigger_for_explosion : float

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.CLOSE_COMBAT, "Close Combat", arg_tier, arg_tier_for_activation):
	if tier == 0:
		_current_damage_map = tier_0_stage_to_damage_map
		_range_percent_reduc = -19
		_explosion_cooldown = 3.0
	elif tier == 1:
		_current_damage_map = tier_1_stage_to_damage_map
		_range_percent_reduc = -16
		_explosion_cooldown = 3.0
	elif tier == 2:
		_current_damage_map = tier_2_stage_to_damage_map
		_range_percent_reduc = -13
		_explosion_cooldown = 3.0
	elif tier == 3:
		_current_damage_map = tier_3_stage_to_damage_map
		_range_percent_reduc = -10
		_explosion_cooldown = 3.0
	
	_range_trigger_for_explosion = 70
	
	# INS START
	var interpreter_for_range_reduc = TextFragmentInterpreter.new()
	interpreter_for_range_reduc.display_body = false
	
	var ins_for_range = []
	ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", -_range_percent_reduc, true))
	
	interpreter_for_range_reduc.array_of_instructions = ins_for_range
	
	# INS END
	
	good_descriptions = []
	
	bad_descriptions = [
		["Towers lose |0|", [interpreter_for_range_reduc]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_CloseCombat_Icon.png")


func _first_time_initialize():
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	_update_explosion_dmg()

func _on_round_end(curr_stageround):
	_update_explosion_dmg()


func _update_explosion_dmg():
	var current_stage_num = game_elements.stage_round_manager.current_stageround.stage_num
	var dmg_at_stage : float = _current_damage_map[current_stage_num]
	
	if !is_equal_approx(_current_explosion_dmg, dmg_at_stage):
		_current_explosion_dmg = dmg_at_stage # setting var first to reflect changes immediately before doing anything
		
		# Ins start
		var interpreter_for_dmg = TextFragmentInterpreter.new()
		interpreter_for_dmg.display_body = false
		
		var ins_for_dmg = []
		ins_for_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "damage", _current_explosion_dmg, false))
		
		interpreter_for_dmg.array_of_instructions = ins_for_dmg
		
		# Ins end
		good_descriptions.clear()
		good_descriptions.append(["Main attacks on hit against enemies within %s range cause towers to release an explosion around themselves, dealing |0| damage (based on stage number). Cooldown : %s s." % [str(_range_trigger_for_explosion), str(_explosion_cooldown)], [interpreter_for_dmg]])
		emit_signal("on_description_changed")
		
		emit_signal("on_damage_of_explosion_changed", _current_explosion_dmg)
	
	_current_explosion_dmg = dmg_at_stage

#

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_CLOSE_COMBAT_EFFECT):
		var effect = TowerEffect_Red_CloseCombatEffect.new(self)
		effect.range_percent_reduc = _range_percent_reduc
		effect.explosion_cooldown = _explosion_cooldown
		effect.current_explosion_dmg = _current_explosion_dmg
		effect.range_trigger_for_explosion = _range_trigger_for_explosion
		
		tower.add_tower_effect(effect)

#


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_CLOSE_COMBAT_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)


###

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return true
