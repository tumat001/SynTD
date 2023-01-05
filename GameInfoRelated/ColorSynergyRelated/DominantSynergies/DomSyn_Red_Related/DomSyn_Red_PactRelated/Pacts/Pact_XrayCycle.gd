extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")

const TowerEffect_Red_XrayCycle = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_XrayCycle.gd")


signal start_buffs()
signal end_buffs_and_start_debuffs()
signal remove_buffs_and_remove_debuffs()
#signal end_debuffs()

const level_min_for_offerable : int = LevelManager.LEVEL_7

const tier_0_range_bonus : float = 130.0
const tier_1_range_bonus : float = 100.0
const tier_2_range_bonus : float = 60.0
const tier_3_range_bonus : float = 30.0


const bonus_effect_duration : float = 6.0
const base_bonus_effect_cooldown : float = 15.0


var stun_duration_after_buff_per_map : Dictionary = {
	StoreOfMaps.MapsIds.RIDGED : 0.85,
	StoreOfMaps.MapsIds.MESA : 1.5,
	StoreOfMaps.MapsIds.ENCHANT : 0.85,
}


var _current_range_bonus : float
var _current_stun_duration_after_buff : float

var _current_bonus_effect_cooldown : float

#

var _buff_and_debuff_timer : Timer

var _is_during_buff : bool

#

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.XRAY_CYCLE, "X-Ray Cycle", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		_current_range_bonus = tier_0_range_bonus
	elif tier == 1:
		_current_range_bonus = tier_1_range_bonus
	elif tier == 2:
		_current_range_bonus = tier_2_range_bonus
	elif tier == 3:
		_current_range_bonus = tier_3_range_bonus
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_XrayCycle_Icon.png")


func _first_time_initialize():
	if stun_duration_after_buff_per_map.has(game_elements.map_id):
		_current_stun_duration_after_buff = stun_duration_after_buff_per_map[game_elements.map_id]
	
	_current_bonus_effect_cooldown = base_bonus_effect_cooldown + bonus_effect_duration
	
	#
	
	var interpreter_for_range = TextFragmentInterpreter.new()
	interpreter_for_range.display_body = false
	var ins_for_range = []
	ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", _current_range_bonus, false))
	interpreter_for_range.array_of_instructions = ins_for_range
	
	good_descriptions = [
		["Every %s seconds, towers become Sighted, gaining |0| and the ability to see through all terrain for %s seconds." % [_current_bonus_effect_cooldown, bonus_effect_duration], [interpreter_for_range]]
	]
	
	var plain_fragment__stunned = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunned")
	
	
	bad_descriptions = [
		["After Sighted's buff expires, towers are |0| for %s seconds." % [_current_stun_duration_after_buff], [plain_fragment__stunned]]
	]
	
	emit_signal("on_description_changed")

#

func pact_sworn():
	.pact_sworn()
	
	_buff_and_debuff_timer = Timer.new()
	_buff_and_debuff_timer.one_shot = true
	_buff_and_debuff_timer.connect("timeout", self, "_on_buff_and_debuff_timer_timeout", [], CONNECT_PERSIST)
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_buff_and_debuff_timer)


func pact_unsworn(arg_replacing_pact):
	.pact_unsworn(arg_replacing_pact)
	
	if is_instance_valid(_buff_and_debuff_timer):
		_buff_and_debuff_timer.queue_free()


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
		game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
		game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_start")
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


#

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_XRAY_CYCLE_EFFECT):
		var effect = TowerEffect_Red_XrayCycle.new(self)
		
		effect.range_bonus = _current_range_bonus
		effect.stun_duration = _current_stun_duration_after_buff
		
		tower.add_tower_effect(effect)

#


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_XRAY_CYCLE_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)


#

func _on_round_start(arg_stageround):
	_buff_and_debuff_timer.start(base_bonus_effect_cooldown)
	_is_during_buff = false

func _on_round_end(arg_stageround):
	_buff_and_debuff_timer.stop()
	_is_during_buff = false
	
	emit_signal("remove_buffs_and_remove_debuffs")

#

func _on_buff_and_debuff_timer_timeout():
	if !_is_during_buff:
		_is_during_buff = true
		emit_signal("start_buffs")
		_buff_and_debuff_timer.start(bonus_effect_duration)
		
	else:
		_is_during_buff = false
		emit_signal("end_buffs_and_start_debuffs")
		_buff_and_debuff_timer.start(_current_bonus_effect_cooldown)


#

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.level_manager.current_level >= level_min_for_offerable and stun_duration_after_buff_per_map.has(arg_game_elements.map_id)
	

