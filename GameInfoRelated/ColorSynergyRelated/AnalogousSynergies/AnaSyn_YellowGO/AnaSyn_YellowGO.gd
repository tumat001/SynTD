extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const TowerEffect_AnaSyn_YellowGO_FluctuationEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_AnaSyn_YellowGO_FluctuationEffect.gd")
const Fluctuation_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_YellowGO/Assets/Fluctuation_StatusBarIcon.png")
const FluctuationParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_YellowGO/Assets/FluctuationParticle/FluctuationParticle.tscn")
const FluctuationParticle = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_YellowGO/Assets/FluctuationParticle/FluctuationParticle.gd")


const ele_on_hit_tier_1 : float = 5.0
const ele_on_hit_tier_2 : float = 3.0
const ele_on_hit_tier_3 : float = 2.0
const ele_on_hit_tier_4 : float = 1.0

const base_dmg_tier_1 : float = 130.0
const base_dmg_tier_2 : float = 70.0
const base_dmg_tier_3 : float = 40.0
const base_dmg_tier_4 : float = 20.0

const attk_speed_tier_1 : float = 130.0
const attk_speed_tier_2 : float = 70.0
const attk_speed_tier_3 : float = 40.0
const attk_speed_tier_4 : float = 20.0

const range_tier_1 : float = 50.0
const range_tier_2 : float = 30.0
const range_tier_3 : float = 20.0
const range_tier_4 : float = 10.0

const fluctuation_duration : float = 3.0


const tracked_towers_for_attacking_group_id : String = "AnaSyn_YellowGO_TowersInMap_MonitoringForFirstAttack"
const TARGETING_FIRST_ATTACKING_TOWER : int = -1

var fluctuation_cycle_targeting : Array = []

var _current_fluctuation_targeting_index : int = TARGETING_FIRST_ATTACKING_TOWER



var on_hit_dmg_adder_effect : TowerOnHitDamageAdderEffect
var on_hit_dmg_modi : FlatModifier

var base_dmg_effect : TowerAttributesEffect
var base_dmg_modi : PercentModifier

var attk_speed_effect : TowerAttributesEffect
var attk_speed_modi : PercentModifier

var range_effect : TowerAttributesEffect
var range_modi : PercentModifier

var fluctuation_effect : TowerEffect_AnaSyn_YellowGO_FluctuationEffect


var game_elements : GameElements
var fluctuated_tower : AbstractTower
var fluctuation_timer : Timer
var is_fluctuation_active : bool = false

var fluctutation_particle : FluctuationParticle


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if on_hit_dmg_adder_effect == null:
		_construct_effects()
	
	if !is_instance_valid(fluctuation_timer):
		fluctuation_timer = Timer.new()
		fluctuation_timer.wait_time = fluctuation_duration
		fluctuation_timer.one_shot = true
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(fluctuation_timer)
		fluctuation_timer.connect("timeout", self, "_on_flucuation_timer_done", [], CONNECT_PERSIST)
	
	# FLUCTUATION Cycle is set here
	if fluctuation_cycle_targeting.size() == 0:
		fluctuation_cycle_targeting.append(Targeting.TOWERS_HIGHEST_TOTAL_BASE_DAMAGE)
		fluctuation_cycle_targeting.append(Targeting.TOWERS_HIGHEST_TOTAL_ATTACK_SPEED)
		fluctuation_cycle_targeting.append(Targeting.TOWERS_HIGHEST_IN_ROUND_DAMAGE)
	
	
	if game_elements == null:
		game_elements = arg_game_elements
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	if tier == 1:
		on_hit_dmg_modi.flat_modifier = ele_on_hit_tier_1
		base_dmg_modi.percent_amount = base_dmg_tier_1
		attk_speed_modi.percent_amount = attk_speed_tier_1
		range_modi.percent_amount = range_tier_1
	elif tier == 2:
		on_hit_dmg_modi.flat_modifier = ele_on_hit_tier_2
		base_dmg_modi.percent_amount = base_dmg_tier_2
		attk_speed_modi.percent_amount = attk_speed_tier_2
		range_modi.percent_amount = range_tier_2
	elif tier == 3:
		on_hit_dmg_modi.flat_modifier = ele_on_hit_tier_3
		base_dmg_modi.percent_amount = base_dmg_tier_3
		attk_speed_modi.percent_amount = attk_speed_tier_3
		range_modi.percent_amount = range_tier_3
	elif tier == 4:
		on_hit_dmg_modi.flat_modifier = ele_on_hit_tier_4
		base_dmg_modi.percent_amount = base_dmg_tier_4
		attk_speed_modi.percent_amount = attk_speed_tier_4
		range_modi.percent_amount = range_tier_4
	
	
	fluctuated_tower = null
	call_deferred("_track_for_first_attack")
	#_track_for_first_attack()
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	_clean_up_fluc_modifications()
	
	fluctuated_tower = null
	_untrack_for_first_attack()
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


# Effects building

func _construct_effects():
	on_hit_dmg_modi = FlatModifier.new(StoreOfTowerEffectsUUID.YELLOW_GO_ELE_ON_HIT_EFFECT)
	var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.YELLOW_GO_ELE_ON_HIT_EFFECT, on_hit_dmg_modi, DamageType.ELEMENTAL)
	on_hit_dmg_adder_effect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.YELLOW_GO_ELE_ON_HIT_EFFECT)
	
	base_dmg_modi = PercentModifier.new(StoreOfTowerEffectsUUID.YELLOW_GO_BASE_DMG_EFFECT)
	base_dmg_modi.percent_based_on = PercentType.MAX
	base_dmg_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS, base_dmg_modi, StoreOfTowerEffectsUUID.YELLOW_GO_BASE_DMG_EFFECT)
	
	attk_speed_modi = PercentModifier.new(StoreOfTowerEffectsUUID.YELLOW_GO_ATTK_SPEED_EFFECT)
	attk_speed_modi.percent_based_on = PercentType.MAX
	attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_modi, StoreOfTowerEffectsUUID.YELLOW_GO_ATTK_SPEED_EFFECT)
	
	range_modi = PercentModifier.new(StoreOfTowerEffectsUUID.YELLOW_GO_RANGE_EFFECT)
	range_modi.percent_based_on = PercentType.BASE
	range_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_RANGE, range_modi, StoreOfTowerEffectsUUID.YELLOW_GO_RANGE_EFFECT)
	
	fluctuation_effect = TowerEffect_AnaSyn_YellowGO_FluctuationEffect.new()
	fluctuation_effect.on_hit_effect = on_hit_dmg_adder_effect
	fluctuation_effect.base_dmg_effect = base_dmg_effect
	fluctuation_effect.attk_speed_effect = attk_speed_effect
	fluctuation_effect.range_effect = range_effect
	fluctuation_effect.status_bar_icon = Fluctuation_Icon


# Fluc related

func _on_round_end(curr_stageround):
	if is_instance_valid(fluctuated_tower):
		_clean_up_fluc_modifications()
		
		fluctuation_timer.wait_time = 0.1
		fluctuation_timer.paused = true
		
		fluctuated_tower = null
		_untrack_for_first_attack()
		_track_for_first_attack()


# First attacking tower related

func _track_for_first_attack():
	reset_cycle_step()
	for tower in game_elements.tower_manager.get_all_active_towers():
		_tower_to_benefit_from_synergy(tower)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	if !tower.is_connected("on_any_attack", self, "_tower_attacked"):
		tower.connect("on_any_attack", self, "_tower_attacked", [tower], CONNECT_DEFERRED)
		tower.add_to_group("tracked_towers_for_attacking_group_id")


func _untrack_for_first_attack():
	for tower in game_elements.get_tree().get_nodes_in_group("tracked_towers_for_attacking_group_id"):
		_tower_to_remove_from_synergy(tower)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")

func _tower_to_remove_from_synergy(tower : AbstractTower):
	if tower.is_connected("on_any_attack", self, "_tower_attacked"):
		tower.disconnect("on_any_attack", self, "_tower_attacked")
		tower.remove_from_group("tracked_towers_for_attacking_group_id")


func _tower_attacked(attk_speed_delay, enemies, module, tower : AbstractTower):
	if !is_fluctuation_active:
		var successful_assign = _attempt_assign_fluctuation_to_tower(tower)
		
		if successful_assign:
			_untrack_for_first_attack()


# Fluctuation onto tower

func _attempt_assign_fluctuation_to_tower(tower : AbstractTower) -> bool:
	if fluctuated_tower != tower:
		fluctuated_tower = tower
		is_fluctuation_active = true
		
		if !fluctuated_tower.is_connected("on_tower_no_health", self, "_on_fluctuating_tower_zero_health_reached"):
			fluctuated_tower.connect("on_tower_no_health", self, "_on_fluctuating_tower_zero_health_reached")
			fluctuated_tower.connect("tree_exiting", self, "_on_flucutating_tower_tree_exiting")
			fluctuated_tower.connect("tower_not_in_active_map", self, "_on_fluctuating_tower_benched")
			fluctuated_tower.connect("on_effect_removed", self, "_on_effect_removed")
			#fluctuated_tower.connect("on_range_module_enemy_exited", self, "_on_enemy_left_tower_range")
		
		fluctuated_tower.add_tower_effect(fluctuation_effect)
		
		_attach_particle_to_tower(fluctuated_tower)
		
		advance_cycle_step()
		
		fluctuation_timer.paused = false
		fluctuation_timer.start(fluctuation_duration)
		
		return true
	
	return false


func _on_fluctuating_tower_zero_health_reached():
	_attempt_pass_flucutation_to_next_candidate()

func _on_flucutating_tower_tree_exiting():
	_attempt_pass_flucutation_to_next_candidate()

# somehow? Should normally not happen but just in case
func _on_fluctuating_tower_benched():
	_attempt_pass_flucutation_to_next_candidate()

func _on_effect_removed(effect):
	if effect.effect_uuid == fluctuation_effect.effect_uuid:
		_attempt_pass_flucutation_to_next_candidate()

#func _on_enemy_left_tower_range(enemy, module, range_module):
#	#if fluctuated_tower.range_module == null or (fluctuated_tower.range_module != null and !fluctuated_tower.range_module.is_an_enemy_in_range()):
#	#	_attempt_pass_flucutation_to_next_candidate()



func _on_flucuation_timer_done():
	# triggers "on_effect_removed" signal
	_remove_fluctuation_effect_from_curr_tower()

func _attach_particle_to_tower(tower):
	fluctutation_particle = FluctuationParticle_Scene.instance()
	fluctutation_particle.tower = tower
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(fluctutation_particle)

#

func _attempt_pass_flucutation_to_next_candidate():
	_clean_up_fluc_modifications()
	
	var candidate_tower = _find_next_candidate_tower()
	var success : bool = false
	if is_instance_valid(candidate_tower):
		success = _attempt_assign_fluctuation_to_tower(candidate_tower)
	
	if !success:
		_track_for_first_attack()

func _clean_up_fluc_modifications():
	_disconnect_from_current_fluctuated_tower()
	_remove_fluctuation_effect_from_curr_tower()
	_destroy_fluctuation_particle()
	
	is_fluctuation_active = false

func _disconnect_from_current_fluctuated_tower():
	if is_instance_valid(fluctuated_tower):
		if fluctuated_tower.is_connected("on_tower_no_health", self, "_on_fluctuating_tower_zero_health_reached"):
			fluctuated_tower.disconnect("on_tower_no_health", self, "_on_fluctuating_tower_zero_health_reached")
			fluctuated_tower.disconnect("tree_exiting", self, "_on_flucutating_tower_tree_exiting")
			fluctuated_tower.disconnect("tower_not_in_active_map", self, "_on_fluctuating_tower_benched")
			fluctuated_tower.disconnect("on_effect_removed", self, "_on_effect_removed")
			#fluctuated_tower.disconnect("on_range_module_enemy_exited", self, "_on_enemy_left_tower_range")

func _remove_fluctuation_effect_from_curr_tower():
	if is_instance_valid(fluctuated_tower):
		if fluctuated_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.YELLOW_GO_EFFECT_BUNDLE):
			fluctuated_tower.remove_tower_effect(fluctuation_effect)

func _destroy_fluctuation_particle():
	if is_instance_valid(fluctutation_particle):
		fluctutation_particle.queue_free()



func _find_next_candidate_tower() -> AbstractTower:
	var towers = game_elements.tower_manager.get_all_active_towers()
	if towers.size() > 0:
		var sorted_towers = Targeting.enemies_to_target(towers, get_targeting_in_cycle(), towers.size(), Vector2(0, 0), true)
		
		for tower in sorted_towers:
			# if one of these conditions is met, then this tower cannot be chosen as the next candidate
			if tower == fluctuated_tower or !is_instance_valid(tower.range_module) or tower.current_health <= 0 or tower.last_calculated_disabled_from_attacking or tower.range_module.enemies_in_range.size() == 0 or !tower.last_calculated_has_commandable_attack_modules:
				continue
			else:
				return tower
	
	return null


# Fluctuation "targeting"

func advance_cycle_step():
	_current_fluctuation_targeting_index += 1
	if _current_fluctuation_targeting_index >= fluctuation_cycle_targeting.size():
		_current_fluctuation_targeting_index = 0

func reset_cycle_step():
	_current_fluctuation_targeting_index = TARGETING_FIRST_ATTACKING_TOWER

func get_targeting_in_cycle() -> int:
	return fluctuation_cycle_targeting[_current_fluctuation_targeting_index]
