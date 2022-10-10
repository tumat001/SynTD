extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

# For Red towers

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")

const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const RedGreen_Green_Pulse_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Green_Pulse/RedGreen_Green_Pulse.tscn")

const BaseTowerDetectingAOE = preload("res://EnemyRelated/TowerInteractingRelated/Spawnables/BaseTowerDetectingAOE.gd")
const BaseTowerDetectingAOE_Scene = preload("res://EnemyRelated/TowerInteractingRelated/Spawnables/BaseTowerDetectingAOE.tscn")
const TD_AOEAttackModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TD_AOEAttackModule.gd")
const TD_AOEAttackModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TD_AOEAttackModule.tscn")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")
const TowerEffectShieldEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerEffectShieldEffect.gd")

const RedGreen_Green_Slowdown_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/StatusBarIcons/RedGreen_Green_Slowdown_StatusBarIcon.png")
const RedGreen_Green_TowerApplySlowdown_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/StatusBarIcons/RedGreen_Green_TowerApplySlowdown_StatusBarIcon.png")

const Green_EffectShield_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/Green_EffectShield/Green_EffectShield.tscn")

const RedStack_01 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/RedStack/RedStack_02.png")
const RedStack_02 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/Assets/RedStack/RedStack_03.png")


var stack_per_attack_against_normal_enemies : int

var effect_shield_duration_per_stack : float

var base_slow_amount : float
var slow_amount_scale_inc_per_stack : float

var slow_attack_base_count : int
var slow_attack_count_inc_per_stack_ratio : float

var slow_base_duration : float
var slow_duration_scale_inc_per_stack : float


const pulse_min_radius : float = 15.0

const aoe_pulse_modulate := Color(1, 1, 1, 0)
const particle_pulse_modulate := Color(1, 1, 1, 0.5)
var green_pulse_aoe_module : TD_AOEAttackModule
var pulse_trigger_amount : int

var pulse_base_size : float
var pulse_size_inc_per_stack : float

var green_effect_shield_effect : TowerEffectShieldEffect


var heal_amount_per_stack : float

#

var red_stack_effect : EnemyStackEffect
var green_stack_effect_id : int
var red_stack_effect_id : int

var slow_on_hit_effect : TowerOnHitEffectAdderEffect

var attached_tower
var _green_shield_particle


func _init().(StoreOfTowerEffectsUUID.RED_GREEN_GREEN_DETONATE_SIDE_EFFECT_GIVER):
	pass



func _make_modifications_to_tower(tower):
	if tower._tower_colors.has(TowerColors.RED):
		attached_tower = tower
		
		if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy"):
			tower.connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy", [], CONNECT_PERSIST)
			tower.connect("on_effect_removed", self, "_tower_removed_effect", [tower], CONNECT_PERSIST)
		
		_construct_red_stack_effect()
		_construct_green_pulse_aoe_module()
		_construct_green_slow_effect()
		_construct_green_effect_shield()


func _construct_red_stack_effect():
	if red_stack_effect == null:
		red_stack_effect_id = StoreOfEnemyEffectsUUID.RED_GREEN_RED_STACK_EFFECT
		red_stack_effect = EnemyStackEffect.new(null, 1, 99999, red_stack_effect_id)
		
		green_stack_effect_id = StoreOfEnemyEffectsUUID.RED_GREEN_GREEN_STACK_EFFECT

func _construct_green_pulse_aoe_module():
	green_pulse_aoe_module = TD_AOEAttackModule_Scene.instance()
	
	green_pulse_aoe_module.sprite_frames_only_play_once = true
	green_pulse_aoe_module.pierce = -1
	green_pulse_aoe_module.duration = 0.3
	green_pulse_aoe_module.damage_repeat_count = 1
	
	green_pulse_aoe_module.aoe_default_coll_shape = BaseTowerDetectingAOE.BaseAOEDefaultShapes.CIRCLE
	green_pulse_aoe_module.base_aoe_scene = BaseTowerDetectingAOE_Scene
	green_pulse_aoe_module.spawn_location_and_change = TD_AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	attached_tower.add_child(green_pulse_aoe_module)

func _construct_green_slow_effect():
	var modi = PercentModifier.new(StoreOfEnemyEffectsUUID.RED_GREEN_GREEN_SLOW_EFFECT)
	modi.percent_based_on = PercentType.BASE
	
	var enemy_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, modi, StoreOfEnemyEffectsUUID.RED_GREEN_GREEN_SLOW_EFFECT)
	enemy_effect.is_timebound = true
	enemy_effect.status_bar_icon = RedGreen_Green_Slowdown_StatusBarIcon
	
	slow_on_hit_effect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.RED_GREEN_GREEN_SLOW_ON_HIT_EFFECT)
	slow_on_hit_effect.is_timebound = false
	slow_on_hit_effect.is_countbound = true
	slow_on_hit_effect.status_bar_icon = RedGreen_Green_TowerApplySlowdown_StatusBarIcon

func _construct_green_effect_shield():
	green_effect_shield_effect = TowerEffectShieldEffect.new(StoreOfTowerEffectsUUID.RED_GREEN_GREEN_EFFECT_SHIELD_EFFECT, -1, 1)
	
	_green_shield_particle = Green_EffectShield_Scene.instance()
	_green_shield_particle.set_size_adapting_to(attached_tower)
	_green_shield_particle.visible = false
	
	_green_shield_particle.queue_free_at_end_of_lifetime = false
	
	attached_tower.add_child(_green_shield_particle)


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy")
		tower.disconnect("on_effect_removed", self, "_tower_removed_effect")
		
		if is_instance_valid(green_pulse_aoe_module):
			green_pulse_aoe_module.queue_free()
		
		if is_instance_valid(_green_shield_particle):
			_green_shield_particle.queue_free()


#

func _on_main_attack_hit_enemy(enemy, damage_register_id, damage_instance, module):
	_check_if_green_detonatable(enemy, damage_instance)
	
	if !enemy.is_connected("effect_added", self, "_effect_added_to_enemy"):
		enemy.connect("effect_added", self, "_effect_added_to_enemy")
	
	if enemy.is_enemy_type_normal():
		red_stack_effect.num_of_stacks_per_apply = stack_per_attack_against_normal_enemies
	else:
		red_stack_effect.num_of_stacks_per_apply = 1
	
	damage_instance.on_hit_effects[red_stack_effect_id] = red_stack_effect


func _check_if_green_detonatable(enemy, damage_instance):
	if enemy._stack_id_effects_map.has(green_stack_effect_id):
		var stack_amount = enemy._stack_id_effects_map[green_stack_effect_id]._current_stack
		
		if stack_amount >= pulse_trigger_amount:
			_execute_pulse(stack_amount)
		
		enemy._remove_effect(enemy._stack_id_effects_map[green_stack_effect_id])
		enemy.statusbar.remove_status_icon(green_stack_effect_id)
		
		_apply_effect_shield_to_self(stack_amount)

#

func _execute_pulse(stack_amount : int):
	var final_radius = _get_final_pulse_radius(stack_amount)
	
	_construct_and_place_pulse_particle(pulse_min_radius, final_radius)
	_construct_and_place_pulse_aoe(final_radius, stack_amount)

func _get_final_pulse_radius(stack_amount : int):
	return pulse_base_size + int(round(pulse_size_inc_per_stack * stack_amount))


func _construct_and_place_pulse_particle(initial_radius : float, final_radius : float):
	var particle = RedGreen_Green_Pulse_Scene.instance()
	
	CommonAttackSpriteTemplater.configure_scale_and_expansion_of_expanding_attk_sprite(particle, initial_radius, final_radius)
	particle.position = attached_tower.global_position
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)

func _construct_and_place_pulse_aoe(final_radius : float, stack_amount : int):
	var aoe = green_pulse_aoe_module.construct_aoe(attached_tower.global_position, attached_tower.global_position)
	
	var coll_shape = CircleShape2D.new()
	coll_shape.radius = final_radius
	aoe.modulate = aoe_pulse_modulate
	aoe.connect("on_tower_hit", self, "_on_pulse_aoe_on_tower_hit", [stack_amount])
	
	CommsForBetweenScenes.ge_add_child_to_proj_hoster(aoe)
	aoe.set_coll_shape(coll_shape)


# Slow related

func _on_pulse_aoe_on_tower_hit(tower, stack_amount):
	if is_instance_valid(tower) and tower.is_current_placable_in_map():
		var slow_count = _get_attack_amount_from_stack_amount(stack_amount)
		var slow_amount = _get_slow_amount_from_stack_amount(stack_amount)
		var slow_duration = _get_slow_duration_from_stack_amount(stack_amount)
		
		var cloned_effect : TowerOnHitEffectAdderEffect = slow_on_hit_effect._shallow_copy()
		cloned_effect.enemy_base_effect.attribute_as_modifier.percent_amount = slow_amount
		cloned_effect.enemy_base_effect.time_in_seconds = slow_duration
		
		cloned_effect.count = slow_count
		
		tower.add_tower_effect(cloned_effect)
		
		#
		
		var heal_amount = _get_heal_amount_from_stack_amount(stack_amount)
		tower.heal_by_amount(heal_amount)


func _get_attack_amount_from_stack_amount(stack_amount : int) -> int:
	var final_amount = stack_amount - pulse_trigger_amount
	return slow_attack_base_count + int(round(final_amount * slow_attack_count_inc_per_stack_ratio))

func _get_slow_amount_from_stack_amount(stack_amount : int) -> float:
	var final_amount = stack_amount - pulse_trigger_amount
	return base_slow_amount * (1 + (slow_amount_scale_inc_per_stack * final_amount))

func _get_slow_duration_from_stack_amount(stack_amount : int) -> float:
	var final_amount = stack_amount - pulse_trigger_amount
	return slow_base_duration * (1 + (slow_duration_scale_inc_per_stack * final_amount))


func _get_heal_amount_from_stack_amount(stack_amount : int) -> float:
	return heal_amount_per_stack * stack_amount

#

func _effect_added_to_enemy(effect, enemy):
	if effect.effect_uuid == red_stack_effect_id:
		effect = enemy._stack_id_effects_map[red_stack_effect_id]
		
		var effect_curr_stack = effect._current_stack
		
		if effect_curr_stack >= pulse_trigger_amount:
			enemy.statusbar.add_status_icon(red_stack_effect_id, RedStack_02)
		elif effect_curr_stack > 0:
			enemy.statusbar.add_status_icon(red_stack_effect_id, RedStack_01)
		
		if enemy.is_connected("effect_added", self, "_effect_added_to_enemy"):
			enemy.disconnect("effect_added", self, "_effect_added_to_enemy")


func _apply_effect_shield_to_self(stack_amount : int):
	var shield_duration = _get_duration_for_effect_shield(stack_amount)
	
	if _green_shield_particle.lifetime < shield_duration:
		_green_shield_particle.lifetime = shield_duration
	_green_shield_particle.visible = true
	
	var copied_effect = green_effect_shield_effect._get_copy_scaled_by(1)
	copied_effect.time_in_seconds = shield_duration
	copied_effect.is_timebound = true
	copied_effect.count = 1
	copied_effect.is_countbound = true
	
	attached_tower.add_tower_effect(copied_effect)


func _get_duration_for_effect_shield(stack_amount : int):
	return effect_shield_duration_per_stack * stack_amount


func _tower_removed_effect(effect, tower):
	if effect.effect_uuid == StoreOfTowerEffectsUUID.RED_GREEN_GREEN_EFFECT_SHIELD_EFFECT:
		if is_instance_valid(_green_shield_particle):
			_green_shield_particle.visible = false

