extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerEffect_CompliSyn_RedGreen_RedDetonateSide = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_CompliSyn_RedGreen_RedDetonateSide.gd")
const TowerEffect_CompliSyn_RedGreen_GreenDetonateSide = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_CompliSyn_RedGreen_GreenDetonateSide.gd")


const stack_per_attack_against_normal_enemies : int = 2

const red_detonation_damage_per_stack_tier_1 : float = 0.4
const red_detonation_damage_per_stack_tier_2 : float = 0.3
const red_detonation_damage_per_stack_tier_3 : float = 0.2

const red_bolt_damage_tier_1 : float = 12.0
const red_bolt_damage_tier_2 : float = 8.0
const red_bolt_damage_tier_3 : float = 6.0

const red_bolt_base_count : int = 5
const red_bolt_count_stack_ratio : float = 0.5

const red_tantrum_trigger_amount : int = 10


const green_detonation_effect_shield_duration_per_stack_tier_1 : float = 0.5
const green_detonation_effect_shield_duration_per_stack_tier_2 : float = 0.4
const green_detonation_effect_shield_duration_per_stack_tier_3 : float = 0.3

const green_detonation_heal_per_stack_tier_1 : float = 0.5
const green_detonation_heal_per_stack_tier_2 : float = 0.4
const green_detonation_heal_per_stack_tier_3 : float = 0.3

const green_base_slow_tier_1 : float = -40.0
const green_base_slow_tier_2 : float = -30.0
const green_base_slow_tier_3 : float = -20.0
const green_slow_scale_inc_per_stack : float = 0.075

const green_slow_base_count : int = 3
const green_slow_count_stack_ratio : float = 0.20

const green_slow_base_duration : float = 8.0
const green_slow_duration_scale_inc_per_stack : float = 0.0#5.0

const green_pulse_trigger_amount : int = 10
const green_pulse_base_size : float = 20.0
const green_pulse_size_inc_per_stack : float = 10.0


var curr_tier : int
var game_elements : GameElements


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
	
	._apply_syn_to_game_elements(arg_game_elements, tier)



# Remove

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	if arg_game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		arg_game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		arg_game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	curr_tier = 0
	
	var all_towers = arg_game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


#

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower._all_uuid_tower_buffs_map.has(StoreOfTowerEffectsUUID.RED_GREEN_RED_DETONATE_SIDE_EFFECT_GIVER):
		var red_deto_effect = TowerEffect_CompliSyn_RedGreen_RedDetonateSide.new(0, 0, red_bolt_base_count, red_bolt_count_stack_ratio, red_tantrum_trigger_amount, green_pulse_trigger_amount)
		
		red_deto_effect.stack_per_attack_against_normal_enemies = stack_per_attack_against_normal_enemies
		
		if curr_tier == 1:
			red_deto_effect.damage_per_stack = red_detonation_damage_per_stack_tier_1
			red_deto_effect.damage_per_bolt = red_bolt_damage_tier_1
		elif curr_tier == 2:
			red_deto_effect.damage_per_stack = red_detonation_damage_per_stack_tier_2
			red_deto_effect.damage_per_bolt = red_bolt_damage_tier_2
		elif curr_tier == 3:
			red_deto_effect.damage_per_stack = red_detonation_damage_per_stack_tier_3
			red_deto_effect.damage_per_bolt = red_bolt_damage_tier_3
		
		tower.add_tower_effect(red_deto_effect)
	
	if !tower._all_uuid_tower_buffs_map.has(StoreOfTowerEffectsUUID.RED_GREEN_GREEN_DETONATE_SIDE_EFFECT_GIVER):
		var green_deto_effect = TowerEffect_CompliSyn_RedGreen_GreenDetonateSide.new()
		
		green_deto_effect.stack_per_attack_against_normal_enemies = stack_per_attack_against_normal_enemies
		
		green_deto_effect.slow_amount_scale_inc_per_stack = green_slow_scale_inc_per_stack
		green_deto_effect.slow_attack_base_count = green_slow_base_count
		green_deto_effect.slow_attack_count_inc_per_stack_ratio = green_slow_count_stack_ratio
		
		green_deto_effect.pulse_trigger_amount = green_pulse_trigger_amount
		green_deto_effect.pulse_base_size = green_pulse_base_size
		green_deto_effect.pulse_size_inc_per_stack = green_pulse_size_inc_per_stack
		
		green_deto_effect.slow_base_duration = green_slow_base_duration
		green_deto_effect.slow_duration_scale_inc_per_stack = green_slow_duration_scale_inc_per_stack
		
		if curr_tier == 1:
			green_deto_effect.effect_shield_duration_per_stack = green_detonation_effect_shield_duration_per_stack_tier_1
			green_deto_effect.base_slow_amount = green_base_slow_tier_1
			green_deto_effect.heal_amount_per_stack = green_detonation_heal_per_stack_tier_1
		elif curr_tier == 2:
			green_deto_effect.effect_shield_duration_per_stack = green_detonation_effect_shield_duration_per_stack_tier_2
			green_deto_effect.base_slow_amount = green_base_slow_tier_2
			green_deto_effect.heal_amount_per_stack = green_detonation_heal_per_stack_tier_2
		elif curr_tier == 3:
			green_deto_effect.effect_shield_duration_per_stack = green_detonation_effect_shield_duration_per_stack_tier_3
			green_deto_effect.base_slow_amount = green_base_slow_tier_3
			green_deto_effect.heal_amount_per_stack = green_detonation_heal_per_stack_tier_3
		
		tower.add_tower_effect(green_deto_effect)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	# red deto side
	var red_deto = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_GREEN_RED_DETONATE_SIDE_EFFECT_GIVER)
	
	if red_deto != null:
		tower.remove_tower_effect(red_deto)
	
	
	# green deto side
	var green_deto = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_GREEN_GREEN_DETONATE_SIDE_EFFECT_GIVER)
	
	if green_deto != null:
		tower.remove_tower_effect(green_deto)
	
