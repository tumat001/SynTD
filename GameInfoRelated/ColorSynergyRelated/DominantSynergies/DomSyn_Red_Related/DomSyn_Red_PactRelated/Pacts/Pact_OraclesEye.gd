extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_Red_OraclesEyeEffect = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_OraclesEye.gd")


signal on_shadow_enemy_killed()

var _base_downtime_for_range_gain : float

var _range_gain_per_second_percent : float
var _max_limit_of_range_percent : float

var _amount_of_shadow_enemies_to_spawn : int

var _range_per_shadow_kill : float

#

var _time_pos_to_spawn_shadows : Array = []

#

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.ORACLES_EYE, "Oracle's Eye", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		_base_downtime_for_range_gain = 3.0
		_range_gain_per_second_percent = 5.0
		_max_limit_of_range_percent = 40.0
		
		_amount_of_shadow_enemies_to_spawn = 3
		_range_per_shadow_kill = 5
	elif tier == 1:
		_base_downtime_for_range_gain = 4.0
		_range_gain_per_second_percent = 4.0
		_max_limit_of_range_percent = 32.0
		
		_amount_of_shadow_enemies_to_spawn = 2
		_range_per_shadow_kill = 5
	elif tier == 2:
		_base_downtime_for_range_gain = 4.0
		_range_gain_per_second_percent = 3.0
		_max_limit_of_range_percent = 24.0
		
		_amount_of_shadow_enemies_to_spawn = 2
		_range_per_shadow_kill = 5
	elif tier == 3:
		_base_downtime_for_range_gain = 5.0
		_range_gain_per_second_percent = 1.5
		_max_limit_of_range_percent = 12.0
		
		_amount_of_shadow_enemies_to_spawn = 2
		_range_per_shadow_kill = 5
	
	# INS START
	var interpreter_for_range_per_sec = TextFragmentInterpreter.new()
	interpreter_for_range_per_sec.display_body = false
	
	var ins_for_range_per_sec = []
	ins_for_range_per_sec.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", _range_gain_per_second_percent, true))
	
	interpreter_for_range_per_sec.array_of_instructions = ins_for_range_per_sec
	
	
	var interpreter_for_max_range = TextFragmentInterpreter.new()
	interpreter_for_max_range.display_body = false
	
	var ins_for_max_range = []
	ins_for_max_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", _max_limit_of_range_percent, true))
	
	interpreter_for_max_range.array_of_instructions = ins_for_max_range
	
	
	var interpreter_for_range_per_kill = TextFragmentInterpreter.new()
	interpreter_for_range_per_kill.display_body = false
	
	var ins_for_range_per_kill = []
	ins_for_range_per_kill.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", _range_per_shadow_kill, false))
	
	interpreter_for_range_per_kill.array_of_instructions = ins_for_range_per_kill
	
	
	# INS END
	good_descriptions = [
		["After %s seconds of not attacking, towers gain |0| per second, up to |1|." % str(_base_downtime_for_range_gain), [interpreter_for_range_per_sec, interpreter_for_max_range]],
		["Killing a shadow enemy grants all towers additional |0|.", [interpreter_for_range_per_kill]]
	]
	
	bad_descriptions = [
		"%s shadow enemy(ies) spawn during the round." % str(_amount_of_shadow_enemies_to_spawn)
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_OraclesEye_Icon.png")



func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
		#game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
		game_elements.enemy_manager.connect("round_time_passed", self, "_on_round_time_passed", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)
	
	if !game_elements.stage_round_manager.round_started:
		_calculate_spawn_time_for_shadows()

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_RETRIBUTION_EFFECT_GIVER):
		var effect = TowerEffect_Red_OraclesEyeEffect.new(self)
		effect.base_downtime_for_range_gain = _base_downtime_for_range_gain
		effect.range_gain_per_second_percent = _range_gain_per_second_percent
		effect.max_limit_of_range_percent = _max_limit_of_range_percent
		
		effect.range_per_shadow_kill = _range_per_shadow_kill
		
		tower.add_tower_effect(effect)


#

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
		#game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_start")
		game_elements.enemy_manager.disconnect("round_time_passed", self, "_on_round_time_passed")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_ORACLES_EYE_EFFECT_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)


# enemy related

func _on_round_end(arg_stageround):
	_calculate_spawn_time_for_shadows()

func _calculate_spawn_time_for_shadows():
	var highest_timepos : float = game_elements.enemy_manager.highest_enemy_spawn_timepos_in_round
	var div_time : float = highest_timepos / float(_amount_of_shadow_enemies_to_spawn + 1)
	
	_time_pos_to_spawn_shadows.clear()
	for i in _amount_of_shadow_enemies_to_spawn:
		_time_pos_to_spawn_shadows.append(div_time * (i + 1))


#func _on_round_start(arg_stageround):
#	pass


func _on_round_time_passed(arg_delta, arg_curr_timepos):
	if _time_pos_to_spawn_shadows.size() > 0:
		if arg_curr_timepos > _time_pos_to_spawn_shadows[0]:
			_spawn_shadow_enemy()
			_time_pos_to_spawn_shadows.remove(0)

func _spawn_shadow_enemy():
	var shadow_enemy = game_elements.enemy_manager.spawn_enemy(EnemyConstants.Enemies.DOMSYN_RED_ORACLES_EYE_SHADOW)
	shadow_enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_shadow_enemy_killed", [], CONNECT_ONESHOT)

func _on_shadow_enemy_killed(damage_instance_report, arg_enemy):
	emit_signal("on_shadow_enemy_killed")

###

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.level_manager.current_level >= arg_game_elements.level_manager.LEVEL_6


