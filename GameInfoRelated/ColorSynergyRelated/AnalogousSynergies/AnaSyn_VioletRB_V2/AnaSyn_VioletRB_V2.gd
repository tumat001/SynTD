extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const TowerEffectShieldEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerEffectShieldEffect.gd")
const TowerInvulnerabilityEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerInvulnerabilityEffect.gd")
const TowerEffect_AnaSyn_VioletRB_SelfDamagePerttack = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_AnaSyn_VioletRB_SelfDamagePerAttackEffect.gd")

const EmpoweredAuraParticle = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2/Assets/InvulAura/InvulAuraParticle.gd")
const EmpoweredAuraParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2/Assets/InvulAura/InvulAuraParticle.tscn")

const Invul_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2/Assets/Invul_StatusBarIcon.png")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const tier_4_damage_split_percent : float = 0.4 #lowest
const tier_3_damage_split_percent : float = 0.6
const tier_2_damage_split_percent : float = 0.8
const tier_1_damage_split_percent : float = 1.0

const ap_ratio_of_percent : float = 0.25

const percent_health_damage_per_attack : float = 0.04
const proj_speed_percent_amount : float = 50.0

const death_count_for_stage_3_aura_particle : int = 2
const death_count_for_stage_2_aura_particle : int = 6
const death_count_for_stage_1_aura_particle : int = 9
const death_count_minimum_to_play_particle : int = death_count_for_stage_3_aura_particle

const aura_particle_stage_3_anim_name : String = "Stage3"
const aura_particle_stage_2_anim_name : String = "Stage2"
const aura_particle_stage_1_anim_name : String = "Stage1"


var game_elements
var curr_tier : int

var tower_to_VRB_base_damage_effects_map : Dictionary = {}
var tower_to_VRB_ability_potency_effects_map : Dictionary = {}

var last_standing_tower

var number_of_towers_that_died : int = 0
var tower_to_aura_particle_map : Dictionary = {}


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	curr_tier = tier
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(game_elements : GameElements, tier : int):
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	
	curr_tier = 0
	
	._remove_syn_from_game_elements(game_elements, tier)


#


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)
	
	if !tower.is_connected("on_tower_no_health", self, "_on_tower_lost_all_health"):
		tower.connect("on_tower_no_health", self, "_on_tower_lost_all_health", [tower], CONNECT_PERSIST)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_RB_V2_BASE_DAMAGE_EFFECT):
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.VIOLET_RB_V2_BASE_DAMAGE_EFFECT)
		base_dmg_attr_mod.flat_modifier = 0
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.VIOLET_RB_V2_BASE_DAMAGE_EFFECT)
		
		tower.add_tower_effect(attr_effect)
		
		tower_to_VRB_base_damage_effects_map[tower] = attr_effect
	
	
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_RB_V2_ABILITY_POTENCY_EFFECT):
		var ability_potency_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.VIOLET_RB_V2_ABILITY_POTENCY_EFFECT)
		ability_potency_attr_mod.flat_modifier = 0
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , ability_potency_attr_mod, StoreOfTowerEffectsUUID.VIOLET_RB_V2_ABILITY_POTENCY_EFFECT)
		
		tower.add_tower_effect(attr_effect)
		
		tower_to_VRB_ability_potency_effects_map[tower] = attr_effect
	
	
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_RB_V2_SELF_DAMAGE_EFFECT):
		var self_damage_effect = TowerEffect_AnaSyn_VioletRB_SelfDamagePerttack.new(percent_health_damage_per_attack)
		
		tower.add_tower_effect(self_damage_effect)

#

func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)
	
	if tower.is_connected("on_tower_no_health", self, "_on_tower_lost_all_health"):
		tower.disconnect("on_tower_no_health", self, "_on_tower_lost_all_health")


func _remove_effect_from_tower(tower : AbstractTower):
	var base_dmg_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_RB_V2_BASE_DAMAGE_EFFECT)
	
	if base_dmg_effect != null:
		tower.remove_tower_effect(base_dmg_effect)
		tower_to_VRB_base_damage_effects_map.erase(tower)
	
	#
	
	var ability_potency_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_RB_V2_ABILITY_POTENCY_EFFECT)
	
	if ability_potency_effect != null:
		tower.remove_tower_effect(ability_potency_effect)
		tower_to_VRB_ability_potency_effects_map.erase(tower)
	
	#
	
	var self_damage_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_RB_V2_SELF_DAMAGE_EFFECT)
	
	if self_damage_effect != null:
		tower.remove_tower_effect(self_damage_effect)
	
	#
	
	_remove_last_standing_effects_from_tower(tower)
	_remove_tower_from_aura_particle_map(tower)


#

func _on_round_end(curr_stageround):
	for tower in tower_to_VRB_ability_potency_effects_map:
		tower_to_VRB_ability_potency_effects_map[tower].attribute_as_modifier.flat_modifier = 0
		tower._calculate_final_ability_potency()
	
	for tower in tower_to_VRB_base_damage_effects_map:
		tower_to_VRB_base_damage_effects_map[tower].attribute_as_modifier.flat_modifier = 0
		tower.recalculate_final_base_damage()
	
	
	if is_instance_valid(last_standing_tower):
		_remove_last_standing_effects_from_tower(last_standing_tower)
		
		last_standing_tower = null
	
	number_of_towers_that_died = 0
	_hide_particles_from_towers()


func _remove_last_standing_effects_from_tower(arg_tower):
	var invul_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_RB_V2_INVULNERABILITY_EFFECT)
	if (invul_effect != null):
		arg_tower.remove_tower_effect(invul_effect)
	
	#
	
	var effect_shield_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_RB_V2_EFFECT_IMMUNE_EFFECT)
	if (effect_shield_effect != null):
		arg_tower.remove_tower_effect(effect_shield_effect)
	
	#
	
	var percent_proj_effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_RV_V2_PROJ_SPEED_EFFECT)
	if (percent_proj_effect != null):
		arg_tower.remove_tower_effect(percent_proj_effect)
	

#

func _get_percent_ratio_applicable_to_tier():
	if curr_tier == 4:
		return tier_4_damage_split_percent
	elif curr_tier == 3:
		return tier_3_damage_split_percent
	elif curr_tier == 2:
		return tier_2_damage_split_percent
	elif curr_tier == 1:
		return tier_1_damage_split_percent


func _on_tower_lost_all_health(tower : AbstractTower):
	var percent_of_base_damage = 0
	if is_instance_valid(tower.main_attack_module):
		percent_of_base_damage = tower.get_last_calculated_base_damage_of_main_attk_module() * _get_percent_ratio_applicable_to_tier()
	
	var percent_of_ability_potency = 0
	percent_of_ability_potency = tower.last_calculated_final_ability_potency * _get_percent_ratio_applicable_to_tier() * ap_ratio_of_percent
	
	
	#
	
	var all_active_valid_towers : Array = game_elements.tower_manager.get_all_active_and_alive_towers_except_in_queue_free()
	
	var flat_base_damage_to_add : float = _get_amount_after_split_to_valid_towers(percent_of_base_damage, all_active_valid_towers.size())
	var flat_ability_potency_to_add : float = _get_amount_after_split_to_valid_towers(percent_of_ability_potency, all_active_valid_towers.size())
	
	#
	
	for tower in tower_to_VRB_base_damage_effects_map:
		if !tower.is_dead_for_the_round:
			tower_to_VRB_base_damage_effects_map[tower].attribute_as_modifier.flat_modifier += flat_base_damage_to_add
			tower.recalculate_final_base_damage()
	
	for tower in tower_to_VRB_ability_potency_effects_map:
		if !tower.is_dead_for_the_round:
			tower_to_VRB_ability_potency_effects_map[tower].attribute_as_modifier.flat_modifier += flat_ability_potency_to_add
			tower._calculate_final_ability_potency()
	
	#
	
	if all_active_valid_towers.size() == 1:
		_give_last_standing_effects_to_tower(all_active_valid_towers[0])
	
	#
	
	number_of_towers_that_died += 1
	
	_play_appropriate_aura_particle_to_towers()

func _get_amount_after_split_to_valid_towers(initial_amount : float, total_valid_towers_in_map : float):
	if total_valid_towers_in_map != 0:
		return initial_amount / total_valid_towers_in_map
	else:
		return 0


func _give_last_standing_effects_to_tower(tower):
	if is_instance_valid(tower):
		var invul_effect = TowerInvulnerabilityEffect.new(StoreOfTowerEffectsUUID.VIOLET_RB_V2_INVULNERABILITY_EFFECT)
		invul_effect.status_bar_icon = Invul_StatusBarIcon
		tower.add_tower_effect(invul_effect)
		
		var effect_shield_effect = TowerEffectShieldEffect.new(StoreOfTowerEffectsUUID.VIOLET_RB_V2_EFFECT_IMMUNE_EFFECT)
		tower.add_tower_effect(effect_shield_effect)
		
		last_standing_tower = tower
		
		var proj_speed_modi = PercentModifier.new(StoreOfTowerEffectsUUID.VIOLET_RV_V2_PROJ_SPEED_EFFECT)
		proj_speed_modi.percent_amount = proj_speed_percent_amount
		proj_speed_modi.percent_based_on = PercentType.BASE
		
		var proj_percent_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_PROJ_SPEED , proj_speed_modi, StoreOfTowerEffectsUUID.VIOLET_RV_V2_PROJ_SPEED_EFFECT)
		tower.add_tower_effect(proj_percent_effect)

#

func _play_appropriate_aura_particle_to_towers():
	var all_towers_in_map = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	
	if death_count_minimum_to_play_particle:
		for tower in all_towers_in_map:
			_play_appropriate_aura_particle_to_specific_tower(tower)

func _play_appropriate_aura_particle_to_specific_tower(arg_tower):
	if (!arg_tower.is_dead_for_the_round):
		var aura_particle : EmpoweredAuraParticle
		
		if tower_to_aura_particle_map.has(arg_tower):
			aura_particle = tower_to_aura_particle_map[arg_tower]
		else:
			aura_particle = EmpoweredAuraParticle_Scene.instance()
		
		aura_particle.visible = true
		if number_of_towers_that_died >= death_count_for_stage_1_aura_particle:
			aura_particle.animation = aura_particle_stage_1_anim_name
		elif number_of_towers_that_died >= death_count_for_stage_2_aura_particle:
			aura_particle.animation = aura_particle_stage_2_anim_name
		elif number_of_towers_that_died >= death_count_for_stage_3_aura_particle:
			aura_particle.animation = aura_particle_stage_3_anim_name
		else:
			aura_particle.visible = false
		
		tower_to_aura_particle_map[arg_tower] = aura_particle
		aura_particle.set_tower(arg_tower)
		
		if !is_instance_valid(aura_particle.get_parent()):
			CommsForBetweenScenes.ge_add_child_to_other_node_hoster(aura_particle)
		
		if !arg_tower.is_connected("tree_exiting", self, "_tower_queued_free"):
			arg_tower.connect("tree_exiting", self, "_tower_queued_free", [arg_tower], CONNECT_PERSIST)
			arg_tower.connect("tower_not_in_active_map", self, "_tower_benched", [arg_tower], CONNECT_PERSIST)
		
	else:
		_remove_tower_from_aura_particle_map(arg_tower)


func _tower_queued_free(tower):
	_remove_tower_from_aura_particle_map(tower)

func _tower_benched(tower):
	_remove_tower_from_aura_particle_map(tower)


func _remove_tower_from_aura_particle_map(arg_tower):
	if tower_to_aura_particle_map.has(arg_tower):
		if arg_tower.is_connected("tree_exiting", self, "_tower_queued_free"):
			arg_tower.disconnect("tree_exiting", self, "_tower_queued_free")
			arg_tower.disconnect("tower_not_in_active_map", self, "_tower_benched")
		
		var aura_particle = tower_to_aura_particle_map[arg_tower]
		if !aura_particle.is_queued_for_deletion():
			aura_particle.queue_free()
		
		tower_to_aura_particle_map.erase(arg_tower)


#

func _hide_particles_from_towers():
	var all_towers_in_map = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	
	for tower in all_towers_in_map:
		if tower_to_aura_particle_map.has(tower):
			tower_to_aura_particle_map[tower].visible = false

