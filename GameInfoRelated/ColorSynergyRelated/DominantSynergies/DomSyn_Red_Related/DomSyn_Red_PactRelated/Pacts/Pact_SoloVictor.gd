extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const VictorCrown_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/VictorCrown_StatusBarIcon.png")

var _base_damage_buff_amount : float
var _attack_speed_buff_amount : float
var _range_amount_buff : float

var _amount_of_towers_to_kill_at_start : int

var _towers_sorted_damage_descending : Array = []
var _current_victor_tower : AbstractTower


const tower_amount_for_offerable_inclusive = 7


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.SOLO_VICTOR, "Solo Victor", arg_tier, arg_tier_for_activation):
	var possible_base_dmg_values : Array
	var possible_speed_gain_values : Array
	var possible_range_values : Array
	var amount_of_towers_to_kill_values : Array
	
	if tier == 0:
		possible_speed_gain_values = [55, 60, 70]
		possible_range_values = [55, 60, 70]
		possible_base_dmg_values = [2.75, 3.0, 3.5]
		amount_of_towers_to_kill_values = [1, 2, 3]
	elif tier == 1:
		possible_speed_gain_values = [40, 45, 55]
		possible_range_values = [40, 45, 55]
		possible_base_dmg_values = [2.0, 2.25, 2.75]
		amount_of_towers_to_kill_values = [1, 2, 3]
	elif tier == 2:
		possible_speed_gain_values = [25, 30, 40]
		possible_range_values = [25, 30, 40]
		possible_base_dmg_values = [1.25, 1.5, 2.0]
		amount_of_towers_to_kill_values = [1, 2, 3]
	elif tier == 3:
		possible_speed_gain_values = [15, 20, 30]
		possible_range_values = [20, 25, 35]
		possible_base_dmg_values = [0.5, 0.75, 1.25]
		amount_of_towers_to_kill_values = [1, 2, 3]
	
	var index_rng = pact_mag_rng.randi_range(0, 2)
	_base_damage_buff_amount = possible_base_dmg_values[index_rng]
	_attack_speed_buff_amount = possible_speed_gain_values[index_rng]
	_range_amount_buff = possible_range_values[index_rng]
	_amount_of_towers_to_kill_at_start = amount_of_towers_to_kill_values[index_rng]
	
	# INS START
	var interpreter_for_base_dmg = TextFragmentInterpreter.new()
	interpreter_for_base_dmg.display_body = false
	var ins_for_base_dmg = []
	ins_for_base_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "base damage", _base_damage_buff_amount, false))
	interpreter_for_base_dmg.array_of_instructions = ins_for_base_dmg
	
	var interpreter_for_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_attk_speed.display_body = false
	var ins_for_attk_speed = []
	ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", _attack_speed_buff_amount, true))
	interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
	
	var interpreter_for_range = TextFragmentInterpreter.new()
	interpreter_for_range.display_body = false
	var ins_for_range = []
	ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", _range_amount_buff, false))
	interpreter_for_range.array_of_instructions = ins_for_range
	
	var plain_fragment__on_round_start = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_START, "On round start")
	
	# INS END
	
	good_descriptions = [
		["The tower that has dealt the most damage last round gains |0|, |1| and |2|.", [interpreter_for_base_dmg, interpreter_for_attk_speed, interpreter_for_range]]
	]
	
	bad_descriptions = [
		["|0|: The [u]%s tower(s)[/u] that dealt the least damage last round is killed." % str(_amount_of_towers_to_kill_at_start), [plain_fragment__on_round_start]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_SoloVictor.png")

#

func pact_sworn():
	.pact_sworn()
	
	if !game_elements.stage_round_manager.round_started:
		_update_tower_damage_list_descending()
		_find_tower_to_declare_as_victor()

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.stage_round_manager.is_connected("before_round_starts", self, "_on_before_round_start"):
		game_elements.stage_round_manager.connect("before_round_starts", self, "_on_before_round_start", [], CONNECT_PERSIST)
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_on_tower_placed_in_map", [], CONNECT_PERSIST)
	
	#if _current_victor_tower != null: #and arg_game_elements.stage_round_manager.round_started:
	#	_attempt_add_victor_effect_to_tower(_current_victor_tower)
	
	if !arg_game_elements.stage_round_manager.round_started:
		_update_tower_damage_list_descending()
		_find_tower_to_declare_as_victor()

#

func _on_round_end(stage_round):
	_remove_victor_effect_from_tower(_current_victor_tower)
	_current_victor_to_be_disconnected()
	_update_tower_damage_list_descending()
	_find_tower_to_declare_as_victor()
	


func _update_tower_damage_list_descending():
	_towers_sorted_damage_descending = _get_tower_damage_list_descending()

func _get_tower_damage_list_descending() -> Array:
	var towers = Targeting.enemies_to_target(game_elements.tower_manager.get_all_active_towers_except_in_queue_free(), Targeting.TOWERS_HIGHEST_IN_ROUND_DAMAGE, -1, Vector2(0, 0), true)
	return towers


func _find_tower_to_declare_as_victor():
	var tower = get_valid_highest_damaging_tower_from_arr()
	if is_instance_valid(tower):
		_tower_to_be_declared_victor(tower)


func get_valid_highest_damaging_tower_from_arr():
	for tower in _towers_sorted_damage_descending:
		if is_instance_valid(tower) and !tower.is_queued_for_deletion() and tower.is_current_placable_in_map():
			return tower
	
	return null



func _tower_to_be_declared_victor(tower : AbstractTower):
	_assign_tower_as_victor(tower)
	_attempt_add_victor_effect_to_tower(tower)

func _assign_tower_as_victor(arg_tower):
	_current_victor_tower = arg_tower
	
	if is_instance_valid(_current_victor_tower):
		if !_current_victor_tower.is_connected("tower_in_queue_free", self, "_on_victor_queued_free"):
			_current_victor_tower.connect("tower_in_queue_free", self, "_on_victor_queued_free", [], CONNECT_PERSIST | CONNECT_DEFERRED)
			_current_victor_tower.connect("tower_not_in_active_map", self, "_on_victor_not_active_in_map", [], CONNECT_PERSIST | CONNECT_DEFERRED)


func _attempt_add_victor_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_BASE_DAMAGE_EFFECT):
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_BASE_DAMAGE_EFFECT)
		base_dmg_attr_mod.flat_modifier = _base_damage_buff_amount
		var base_dmg_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_BASE_DAMAGE_EFFECT)
		base_dmg_attr_effect.is_roundbound = true
		base_dmg_attr_effect.round_count = 1
		base_dmg_attr_effect.status_bar_icon = VictorCrown_StatusBarIcon
		
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_ATTACK_SPEED_EFFECT)
		attk_speed_attr_mod.percent_amount = _attack_speed_buff_amount
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		var attk_speed_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_ATTACK_SPEED_EFFECT)
		attk_speed_attr_effect.is_roundbound = true
		attk_speed_attr_effect.round_count = 1
		
		var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_RANGE_EFFECT)
		range_attr_mod.flat_modifier = _range_amount_buff
		var range_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_RANGE_EFFECT)
		range_attr_effect.is_roundbound = true
		range_attr_effect.round_count = 1
		
		tower.add_tower_effect(base_dmg_attr_effect)
		tower.add_tower_effect(attk_speed_attr_effect)
		tower.add_tower_effect(range_attr_effect)


#

func _on_before_round_start(stage_round):
	var least_dmging_towers = get_valid_lowest_damaging_towers(_amount_of_towers_to_kill_at_start)
	for least_dmging_tower in least_dmging_towers:
		call_deferred("_apply_lowest_dmg_effects_to_tower", least_dmging_tower)
	


func get_valid_lowest_damaging_towers(arg_amount : int, towers_list : Array = _get_tower_damage_list_descending()):
	var inverted_list = towers_list.duplicate()
	inverted_list.invert()
	var bucket : Array = []
	
	for tower in inverted_list:
		if is_instance_valid(tower) and !tower.is_queued_for_deletion() and tower.is_current_placable_in_map() and tower != _current_victor_tower:
			bucket.append(tower)
			if bucket.size() >= arg_amount:
				break
	
	return bucket


#

func _current_victor_to_be_disconnected():
	if is_instance_valid(_current_victor_tower):
		if _current_victor_tower.is_connected("tower_in_queue_free", self, "_on_victor_queued_free"):
			_current_victor_tower.disconnect("tower_in_queue_free", self, "_on_victor_queued_free")
			_current_victor_tower.disconnect("tower_not_in_active_map", self, "_on_victor_not_active_in_map")


func _on_victor_queued_free(tower):
	if !game_elements.stage_round_manager.round_started:
		_remove_victor_effect_from_tower(_current_victor_tower)
		_current_victor_to_be_disconnected()
		_current_victor_tower = null
		_update_tower_damage_list_descending()
		_find_tower_to_declare_as_victor()

func _on_victor_not_active_in_map():
	if !game_elements.stage_round_manager.round_started:
		_remove_victor_effect_from_tower(_current_victor_tower)
		_current_victor_to_be_disconnected()
		_current_victor_tower = null
		_update_tower_damage_list_descending()
		_find_tower_to_declare_as_victor()

#

func _on_tower_placed_in_map(arg_tower):
	if !game_elements.stage_round_manager.round_started:
		_remove_victor_effect_from_tower(_current_victor_tower)
		_current_victor_to_be_disconnected()
		_current_victor_tower = null
		_update_tower_damage_list_descending()
		_find_tower_to_declare_as_victor()

#

func _remove_victor_effect_from_tower(tower : AbstractTower):
	if is_instance_valid(tower):
		var base_dmg_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_BASE_DAMAGE_EFFECT)
		if base_dmg_effect != null:
			tower.remove_tower_effect(base_dmg_effect)
		
		var attk_speed_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_ATTACK_SPEED_EFFECT)
		if attk_speed_effect != null:
			tower.remove_tower_effect(attk_speed_effect)
		
		var range_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_SOLO_VICTOR_RANGE_EFFECT)
		if range_effect != null:
			tower.remove_tower_effect(range_effect)
	


func _apply_lowest_dmg_effects_to_tower(tower : AbstractTower):
	tower.take_damage(tower.last_calculated_max_health)



#

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if is_instance_valid(_current_victor_tower): #and arg_game_elements.stage_round_manager.round_started:
		_current_victor_to_be_disconnected()
		_remove_victor_effect_from_tower(_current_victor_tower)
	
	if game_elements.stage_round_manager.is_connected("before_round_starts", self, "_on_before_round_start"):
		game_elements.stage_round_manager.disconnect("before_round_starts", self, "_on_before_round_start")
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_on_tower_placed_in_map")
	

#######

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.tower_manager.current_tower_limit_taken >= tower_amount_for_offerable_inclusive


