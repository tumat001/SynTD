extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_Red_PersonalSpace = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_PersonalSpace.gd")


var _attk_speed_gain_val : float
var _range_of_space_val : float

var _initial_good_desc_size : int

const tower_limit_for_offerable_inclusive : int = 8

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.PERSONAL_SPACE, "Personal Space", arg_tier, arg_tier_for_activation):
	
	var possible_speed_gain_values : Array
	var possible_range_values : Array
	
	if tier == 0:
		possible_speed_gain_values = [80, 115, 150]
		possible_range_values = [65, 85, 110]
	elif tier == 1:
		possible_speed_gain_values = [55, 75, 95]
		possible_range_values = [65, 85, 110]
	elif tier == 2:
		possible_speed_gain_values = [35, 50, 75]
		possible_range_values = [65, 85, 110]
	elif tier == 3:
		possible_speed_gain_values = [10, 25, 40]
		possible_range_values = [65, 85, 110]
	
	var index_rng = pact_mag_rng.randi_range(0, 2)
	_attk_speed_gain_val = possible_speed_gain_values[index_rng]
	_range_of_space_val = possible_range_values[index_rng]
	
	#
	
	# INS START
	var interpreter_for_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_attk_speed.display_body = false
	
	var ins_for_attk_speed = []
	ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", _attk_speed_gain_val, true))
	
	interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
	# INS END
	
	good_descriptions = [
		["Towers gain |0|.", [interpreter_for_attk_speed]]
	]
	_initial_good_desc_size = good_descriptions.size()
	
	bad_descriptions = [
		"Gain the attack speed only if there are no towers within [u]%s range[/u]." % _range_of_space_val
	]
	
	#
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_PersonalSpace_Icon.png")



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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_EFFECT_GIVER):
		var effect = TowerEffect_Red_PersonalSpace.new()
		
		effect.attk_speed_amount = _attk_speed_gain_val
		effect.range_of_personal_space = _range_of_space_val
		
		tower.add_tower_effect(effect)

#


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_EFFECT_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)


#########

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.tower_manager.get_all_active_towers_except_in_queue_free().size() >= tower_limit_for_offerable_inclusive


