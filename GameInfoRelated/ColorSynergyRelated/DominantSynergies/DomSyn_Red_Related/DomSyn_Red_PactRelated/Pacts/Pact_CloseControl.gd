extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"


const TowerEffect_Red_CombatControlEffect = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_CloseControl.gd")


var _range_percent_reduc : float
var _explosion_cooldown : float

var _current_explosion_stun_duration : float
var _range_trigger_for_explosion : float


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.CLOSE_CONTROL, "Close Control", arg_tier, arg_tier_for_activation):
	if tier == 0:
		_current_explosion_stun_duration = 1.3
		_range_percent_reduc = -19
		_explosion_cooldown = 3.0
	elif tier == 1:
		_current_explosion_stun_duration = 1.0
		_range_percent_reduc = -16
		_explosion_cooldown = 3.0
	elif tier == 2:
		_current_explosion_stun_duration = 0.7
		_range_percent_reduc = -13
		_explosion_cooldown = 3.0
	elif tier == 3:
		_current_explosion_stun_duration = 0.3
		_range_percent_reduc = -10
		_explosion_cooldown = 3.0
	
	_range_trigger_for_explosion = 70
	
	
	# INS START
	var interpreter_for_range_reduc = TextFragmentInterpreter.new()
	interpreter_for_range_reduc.display_body = false
	
	var ins_for_range = []
	ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", -_range_percent_reduc, true))
	
	interpreter_for_range_reduc.array_of_instructions = ins_for_range
	
	var plain_fragment__stunning = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunning")
	
	# INS END
	
	good_descriptions = [
		["Main attacks on hit against enemies within %s range cause towers to release an electical explosion around themselves, |0| enemies for %s seconds. Cooldown : %s s." % [str(_range_trigger_for_explosion), str(_current_explosion_stun_duration), str(_explosion_cooldown)], [plain_fragment__stunning]]
	]
	
	bad_descriptions = [
		["Towers lose |0|", [interpreter_for_range_reduc]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_CloseControl_Icon.png")

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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_CLOSE_CONTROL_EFFECT):
		var effect = TowerEffect_Red_CombatControlEffect.new()
		effect.range_percent_reduc = _range_percent_reduc
		effect.explosion_cooldown = _explosion_cooldown
		effect.current_explosion_stun_duration = _current_explosion_stun_duration
		effect.range_trigger_for_explosion = _range_trigger_for_explosion
		
		tower.add_tower_effect(effect)



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
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_CLOSE_CONTROL_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)


###

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return true

