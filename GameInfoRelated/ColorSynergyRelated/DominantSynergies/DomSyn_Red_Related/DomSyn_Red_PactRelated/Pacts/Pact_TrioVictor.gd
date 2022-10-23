extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const TrioCrown_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/VictorTrioCrown_StatusBarIcon.png")



var _base_damage_buff_amount : float
var _attack_speed_buff_amount : float


var _ability_potency_reduction_amount : float
var _attack_speed_reduction_amount : float


var _towers_sorted_damage_descending : Array = []
var _current_victor_towers : Array = []


const base_amount_of_victors : int = 3
const tower_amount_for_offerable_inclusive = 7


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.TRIO_VICTOR, "Trio Victor", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		_base_damage_buff_amount = 3.0
		_attack_speed_buff_amount = 45
		
		_ability_potency_reduction_amount = -0.25
		_attack_speed_reduction_amount = -30
	elif tier == 1:
		_base_damage_buff_amount = 2.0
		_attack_speed_buff_amount = 35
		
		_ability_potency_reduction_amount = -0.20
		_attack_speed_reduction_amount = -25
	elif tier == 2:
		_base_damage_buff_amount = 1.0
		_attack_speed_buff_amount = 25
		
		_ability_potency_reduction_amount = -0.15
		_attack_speed_reduction_amount = -20
	elif tier == 3:
		_base_damage_buff_amount = 0.25
		_attack_speed_buff_amount = 15
		
		_ability_potency_reduction_amount = -0.10
		_attack_speed_reduction_amount = -15
	
	
	#
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
	
	#
	
	var interpreter_for_attk_speed_reduction = TextFragmentInterpreter.new()
	interpreter_for_attk_speed_reduction.display_body = false
	var ins_for_attk_speed_reduc = []
	ins_for_attk_speed_reduc.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", -_attack_speed_reduction_amount, true))
	interpreter_for_attk_speed_reduction.array_of_instructions = ins_for_attk_speed_reduc
	
	var interpreter_for_ability_potency_reduction = TextFragmentInterpreter.new()
	interpreter_for_ability_potency_reduction.display_body = false
	var ins_for_ability_potency_reduction = []
	ins_for_ability_potency_reduction.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", -_ability_potency_reduction_amount, false))
	interpreter_for_ability_potency_reduction.array_of_instructions = ins_for_ability_potency_reduction
	
	var plain_fragment__on_round_start = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_START, "On round start")
	
	#
	
	good_descriptions = [
		["The 3 towers that has dealt the most damage last round gains |0| and |1|.", [interpreter_for_base_dmg, interpreter_for_attk_speed]]
	]
	
	bad_descriptions = [
		["|0|: all other towers lose |1| and |2|.", [plain_fragment__on_round_start, interpreter_for_attk_speed_reduction, interpreter_for_ability_potency_reduction]]
	]
	
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_TrioVictor.png")



func pact_sworn():
	.pact_sworn()
	
	if !game_elements.stage_round_manager.round_started:
		_update_tower_damage_list_descending()
		_find_towers_to_declare_as_trio_victors()

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
		_find_towers_to_declare_as_trio_victors()

#

func _on_round_end(stage_round):
	_remove_victor_effect_from_towers()
	_all_current_victors_to_be_disconnected()
	_update_tower_damage_list_descending()
	_find_towers_to_declare_as_trio_victors()

func _update_tower_damage_list_descending():
	_towers_sorted_damage_descending = _get_tower_damage_list_descending()

func _get_tower_damage_list_descending() -> Array:
	var towers = Targeting.enemies_to_target(game_elements.tower_manager.get_all_active_towers_except_in_queue_free(), Targeting.TOWERS_HIGHEST_IN_ROUND_DAMAGE, -1, Vector2(0, 0), true)
	return towers


func _find_towers_to_declare_as_trio_victors():
	var towers = get_valid_highest_damaging_towers_from_arr()
	_towers_to_be_declared_victors(towers)

func get_valid_highest_damaging_towers_from_arr(arg_amount : int = base_amount_of_victors) -> Array:
	var bucket = []
	for tower in _towers_sorted_damage_descending:
		if is_instance_valid(tower) and !tower.is_queued_for_deletion() and tower.is_current_placable_in_map():
			bucket.append(tower)
			if bucket.size() >= arg_amount:
				break
	
	return bucket


func _towers_to_be_declared_victors(towers : Array):
	_assign_towers_as_trio_victors(towers)
	_attempt_add_victor_effect_to_towers(towers)


func _assign_towers_as_trio_victors(arg_towers : Array):
	_current_victor_towers = arg_towers
	
	for tower in arg_towers:
		if !tower.is_connected("tower_in_queue_free", self, "_on_victor_queued_free"):
			tower.connect("tower_in_queue_free", self, "_on_victor_queued_free", [], CONNECT_PERSIST | CONNECT_DEFERRED)
			tower.connect("tower_not_in_active_map", self, "_on_victor_not_active_in_map", [], CONNECT_PERSIST | CONNECT_DEFERRED)


func _attempt_add_victor_effect_to_towers(arg_towers : Array):
	for tower in arg_towers:
		if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__BASE_DAMAGE_BUFF_EFFECT):
			var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__BASE_DAMAGE_BUFF_EFFECT)
			base_dmg_attr_mod.flat_modifier = _base_damage_buff_amount
			var base_dmg_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__BASE_DAMAGE_BUFF_EFFECT)
			base_dmg_attr_effect.is_roundbound = true
			base_dmg_attr_effect.round_count = 1
			base_dmg_attr_effect.status_bar_icon = TrioCrown_StatusBarIcon
			
			var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__ATTACK_SPEED_BUFF_EFFECT)
			attk_speed_attr_mod.percent_amount = _attack_speed_buff_amount
			attk_speed_attr_mod.percent_based_on = PercentType.BASE
			var attk_speed_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__ATTACK_SPEED_BUFF_EFFECT)
			attk_speed_attr_effect.is_roundbound = true
			attk_speed_attr_effect.round_count = 1
			
			tower.add_tower_effect(base_dmg_attr_effect)
			tower.add_tower_effect(attk_speed_attr_effect)

#

func _on_before_round_start(stage_round):
	var all_towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in all_towers:
		if !_current_victor_towers.has(tower):
			call_deferred("_apply_effects_to_other_non_trio_tower", tower)
		


func _all_current_victors_to_be_disconnected():
	for tower in _current_victor_towers:
		_victor_to_be_disconnected(tower)

func _victor_to_be_disconnected(arg_tower : AbstractTower):
	if is_instance_valid(arg_tower):
		if arg_tower.is_connected("tower_in_queue_free", self, "_on_victor_queued_free"):
			arg_tower.disconnect("tower_in_queue_free", self, "_on_victor_queued_free")
			arg_tower.disconnect("tower_not_in_active_map", self, "_on_victor_not_active_in_map")


func _on_victor_queued_free(tower):
	if !game_elements.stage_round_manager.round_started:
		_remove_victor_effect_from_towers()
		_all_current_victors_to_be_disconnected()
		_current_victor_towers.clear()
		_update_tower_damage_list_descending()
		_find_towers_to_declare_as_trio_victors()

func _on_victor_not_active_in_map():
	if !game_elements.stage_round_manager.round_started:
		_remove_victor_effect_from_towers()
		_all_current_victors_to_be_disconnected()
		_current_victor_towers.clear()
		_update_tower_damage_list_descending()
		_find_towers_to_declare_as_trio_victors()

#

func _on_tower_placed_in_map(arg_tower):
	if !game_elements.stage_round_manager.round_started:
		_remove_victor_effect_from_towers()
		_all_current_victors_to_be_disconnected()
		_current_victor_towers.clear()
		_update_tower_damage_list_descending()
		_find_towers_to_declare_as_trio_victors()


func _remove_victor_effect_from_towers():
	for tower in _current_victor_towers:
		_remove_victor_effect_from_tower(tower)

func _remove_victor_effect_from_tower(tower : AbstractTower):
	if is_instance_valid(tower):
		var base_dmg_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__BASE_DAMAGE_BUFF_EFFECT)
		if base_dmg_effect != null:
			tower.remove_tower_effect(base_dmg_effect)
		
		var attk_speed_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__ATTACK_SPEED_BUFF_EFFECT)
		if attk_speed_effect != null:
			tower.remove_tower_effect(attk_speed_effect)
		


func _apply_effects_to_other_non_trio_tower(tower : AbstractTower):
	var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__ATTACK_SPEED_REDUC_EFFECT)
	attk_speed_attr_mod.percent_amount = _attack_speed_reduction_amount
	attk_speed_attr_mod.percent_based_on = PercentType.BASE
	var attk_speed_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__ATTACK_SPEED_REDUC_EFFECT)
	attk_speed_attr_effect.is_roundbound = true
	attk_speed_attr_effect.round_count = 1
	
	var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__ABILITY_POTENCY_REDUC_EFFECT)
	base_ap_attr_mod.flat_modifier = _ability_potency_reduction_amount
	var ap_attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_TRIO_VICTOR__ABILITY_POTENCY_REDUC_EFFECT)
	ap_attr_effect.is_roundbound = true
	ap_attr_effect.round_count = 1
	
	tower.add_tower_effect(attk_speed_attr_effect)
	tower.add_tower_effect(ap_attr_effect)


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	#if _current_victor_towers.size() > 0: #and arg_game_elements.stage_round_manager.round_started:
	_all_current_victors_to_be_disconnected()
	_remove_victor_effect_from_towers()
	
	if game_elements.stage_round_manager.is_connected("before_round_starts", self, "_on_before_round_start"):
		game_elements.stage_round_manager.disconnect("before_round_starts", self, "_on_before_round_start")
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_on_tower_placed_in_map")
	


#####

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.tower_manager.current_tower_limit_taken >= tower_amount_for_offerable_inclusive


