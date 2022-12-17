extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

const Outreach_MainProj = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_MainProj.png")
const Outreach_MissleProj = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_MissleProj.png")
const Outreach_Explosion_01 = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_Explosion_01.png")
const Outreach_Explosion_02 = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_Explosion_02.png")
const Outreach_Explosion_03 = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_Explosion_03.png")
const Outreach_Explosion_04 = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_Explosion_04.png")
const Outreach_Explosion_05 = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_Explosion_05.png")
const Outreach_Explosion_06 = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_Explosion_06.png")
const Outreach_Explosion_07 = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_Explosion_07.png")
const Outreach_Explosion_AMI = preload("res://TowerRelated/Color_Red/Outreach/Assets/Outreach_Explosion_AMI.png")

const BulletHomingComponent = preload("res://TowerRelated/CommonBehaviorRelated/BulletHomingComponent.gd")
const BulletHomingComponentPool = preload("res://MiscRelated/PoolRelated/Implementations/BulletHomingComponentPool.gd")
const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

#

const reach_base_missle_count : int = 20
const reach_missle_explosion_base_dmg : float = 2.0
const reach_missle_explosion_on_hit_dmg_ratio : float = 0.25
const reach_missle_explosion_pierce : int = 3
const reach_missle_explosion_stun_duration : float = 0.75
const reach_missle_lifetime_duration : float = 12.0

const reach_bonus_range_amount : float = 150.0
var reach_range_effect : TowerAttributesEffect

const reach_base_bonus_missle_amount_on_no_enemies : int = 10

var reach_ability : BaseAbility
var is_reach_ability_ready : bool
const reach_base_ability_cooldown : float = 54.0
const reach_base_ability_cooldown_if_no_enemies : float = 27.0
const reach_ability_during_cast_clause : int = -10
const reach_initial_cooldown : float = 5.0

var reach_per_missle_delay_timer : TimerForTower
const reach_missle_delay_per_fire : float = 0.12

var reach_before_fire_of_missles_timer : TimerForTower
const reach_delay_before_missle_firing : float = 1.5

var _has_empowered_missle_count : bool = false
var _current_missle_count_left_for_fire : int = 0
var _cd_calculated_from_ability : float

var missle_positioning_rng : RandomNumberGenerator
var missle_attack_module : BulletAttackModule
var missle_homing_component_pool : BulletHomingComponentPool

var missle_explosion_attk_module : AOEAttackModule
var missle_explosion_stun_effect : EnemyStunEffect

var missle_multiple_trail_component : MultipleTrailsForNodeComponent
const trail_color : Color = Color(253/255.0, 43/255.0, 46/255.0, 0.65)
const base_trail_length : int = 5
const base_trail_width : int = 2

#

onready var wings_left = $TowerBase/KnockUpLayer/Wings_Left
onready var wings_right = $TowerBase/KnockUpLayer/Wings_Right

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.OUTREACH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift : float = 40
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += y_shift
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 502#420
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= y_shift
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Outreach_MainProj)
	
	add_attack_module(attack_module)
	
	#
	
	var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.OUTREACH_RANGE_EFFECT)
	range_attr_mod.flat_modifier = reach_bonus_range_amount
	reach_range_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.OUTREACH_RANGE_EFFECT)
	reach_range_effect.is_timebound = false
	
	reach_per_missle_delay_timer = TimerForTower.new()
	reach_per_missle_delay_timer.one_shot = false
	reach_per_missle_delay_timer.connect("timeout", self, "_on_reach_per_missle_delay_timer_timeout", [], CONNECT_PERSIST)
	reach_per_missle_delay_timer.set_tower_and_properties(self)
	reach_per_missle_delay_timer.stop_on_round_end_instead_of_pause = true
	add_child(reach_per_missle_delay_timer)
	
	reach_before_fire_of_missles_timer = TimerForTower.new()
	reach_before_fire_of_missles_timer.one_shot = true
	reach_before_fire_of_missles_timer.connect("timeout", self, "_on_reach_before_fire_of_missles_timer_timeout", [], CONNECT_PERSIST)
	reach_before_fire_of_missles_timer.set_tower_and_properties(self)
	reach_before_fire_of_missles_timer.stop_on_round_end_instead_of_pause = true
	add_child(reach_before_fire_of_missles_timer)
	
	connect("on_round_end", self, "_on_round_end_o", [], CONNECT_PERSIST)
	
	#
	
	_construct_and_register_ability()
	_construct_and_add_missle_bullet_attk_module(y_shift)
	_construct_and_add_explosion_attk_module()
	_construct_trails_components()
	
	#
	
	_post_inherit_ready()


func _construct_and_add_missle_bullet_attk_module(arg_y_shift):
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = 0
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = 1
	attack_module.base_proj_speed = 480
	#attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.base_proj_inaccuracy = 95
	attack_module.position.y -= arg_y_shift
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Outreach_MissleProj)
	
	attack_module.can_be_commanded_by_tower = false
	
	attack_module.is_displayed_in_tracker = false
	
	missle_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	#
	missle_positioning_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.INACCURACY)
	
	missle_homing_component_pool = BulletHomingComponentPool.new()
	missle_homing_component_pool.node_to_parent = CommsForBetweenScenes.current_game_elements__other_node_hoster
	missle_homing_component_pool.source_of_create_resource = self
	missle_homing_component_pool.func_name_for_create_resource = "_create_missle_homing_component"


func _construct_and_add_explosion_attk_module():
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = reach_missle_explosion_base_dmg
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.on_hit_damage_scale = reach_missle_explosion_on_hit_dmg_ratio
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Outreach_Explosion_01)
	sprite_frames.add_frame("default", Outreach_Explosion_02)
	sprite_frames.add_frame("default", Outreach_Explosion_03)
	sprite_frames.add_frame("default", Outreach_Explosion_04)
	sprite_frames.add_frame("default", Outreach_Explosion_05)
	sprite_frames.add_frame("default", Outreach_Explosion_06)
	sprite_frames.add_frame("default", Outreach_Explosion_07)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = reach_missle_explosion_pierce
	explosion_attack_module.duration = 0.28
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(Outreach_Explosion_AMI)
	
	missle_explosion_attk_module = explosion_attack_module
	
	add_attack_module(explosion_attack_module)
	
	
	missle_explosion_stun_effect = EnemyStunEffect.new(reach_missle_explosion_stun_duration, StoreOfEnemyEffectsUUID.OUTREACH_MISSLE_EXPLOSION_STUN_EFFECT)


func _construct_trails_components():
	missle_multiple_trail_component = MultipleTrailsForNodeComponent.new()
	missle_multiple_trail_component.node_to_host_trails = self
	missle_multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	missle_multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	


#

func _construct_and_register_ability():
	reach_ability = BaseAbility.new()
	
	reach_ability.is_timebound = true
	
	reach_ability.set_properties_to_usual_tower_based()
	reach_ability.tower = self
	
	reach_ability.connect("updated_is_ready_for_activation", self, "_can_cast_reach_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(reach_ability, false)
	
	reach_ability.start_time_cooldown(reach_initial_cooldown)


func _can_cast_reach_updated(arg_val):
	is_reach_ability_ready = arg_val
	_attempt_cast_reach()

func _attempt_cast_reach():
	if is_reach_ability_ready:
		_cast_reach()

func _cast_reach():
	_give_self_reach_range_effect()
	
	reach_ability.activation_conditional_clauses.attempt_insert_clause(reach_ability_during_cast_clause)
	reach_before_fire_of_missles_timer.start(reach_delay_before_missle_firing)

#

func _get_calculated_missle_count_for_cast() -> int:
	var base_count : int = _get_missle_count_rounded_by_potency(reach_base_missle_count)
	
	if _has_empowered_missle_count:
		base_count += _get_missle_count_rounded_by_potency(reach_base_bonus_missle_amount_on_no_enemies)
	
	return base_count

func _get_missle_count_rounded_by_potency(arg_amount) -> int:
	return int(ceil(arg_amount * reach_ability.get_potency_to_use(last_calculated_final_ability_potency)))


#

func _give_self_reach_range_effect():
	add_tower_effect(reach_range_effect)

func _remove_self_reach_range_effect():
	if has_tower_effect_uuid_in_buff_map(reach_range_effect.effect_uuid):
		remove_tower_effect(reach_range_effect)

#

func _on_reach_before_fire_of_missles_timer_timeout():
	if is_instance_valid(range_module) and range_module.is_a_targetable_enemy_in_range():
		_cd_calculated_from_ability = _get_cd_to_use(reach_base_ability_cooldown)
		reach_ability.on_ability_before_cast_start(_cd_calculated_from_ability)
		
		_current_missle_count_left_for_fire = _get_calculated_missle_count_for_cast()
		_attempt_fire_missle_at_random_enemy_in_range()
		
		reach_per_missle_delay_timer.start(reach_missle_delay_per_fire)
		
	else:
		_set_up_next_cast_as_empowered()
		_cd_calculated_from_ability = -1
		
		reach_ability.start_time_cooldown(_get_cd_to_use(reach_base_ability_cooldown_if_no_enemies))
		
		_end_reach_ability()

#

func _on_reach_per_missle_delay_timer_timeout():
	_attempt_fire_missle_at_random_enemy_in_range()

func _attempt_fire_missle_at_random_enemy_in_range():
	if _current_missle_count_left_for_fire > 0:
		_current_missle_count_left_for_fire -= 1
		_fire_missle_at_random_enemy_in_range()
		
	else:
		_end_reach_ability()

func _fire_missle_at_random_enemy_in_range():
	var target = _get_target_for_missle__including_in_map()
	
	if is_instance_valid(target):
		var missle = missle_attack_module.construct_bullet(target.global_position)
		missle.decrease_life_distance = false
		missle.decrease_life_duration = true
		missle.life_duration = reach_missle_lifetime_duration
		missle_multiple_trail_component.create_trail_for_node(missle)
		
		var homing_component : BulletHomingComponent = missle_homing_component_pool.get_or_create_resource_from_pool()
		homing_component.bullet = missle
		homing_component.target_node_to_home_to = target
		
		if !homing_component.is_connected("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_missle_tree_exiting"):
			homing_component.connect("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_missle_tree_exiting", [missle, homing_component])
			homing_component.connect("on_bullet_tree_exiting", self, "_on_missle_tree_exiting", [homing_component])
		
		missle.connect("hit_an_enemy", self, "_on_missle_hit_enemy")
		
		missle_attack_module.set_up_bullet__add_child_and_emit_signals(missle)

func _get_target_for_missle():
	if is_instance_valid(range_module):
		var targets = range_module.get_targets_without_affecting_self_current_targets(1, Targeting.RANDOM, false)
		if targets.size() > 0:
			return targets[0]
	
	return null

func _get_target_for_missle__including_in_map():
	var target = _get_target_for_missle()
	
	if is_instance_valid(target):
		return target
	
	
	var map_targets = game_elements.enemy_manager.get_all_targetable_enemies()
	map_targets = Targeting.enemies_to_target(map_targets, Targeting.RANDOM, 1, global_position)
	if map_targets.size() > 0:
		return map_targets[0]
	
	
	return null



func _end_reach_ability():
	_current_missle_count_left_for_fire = 0
	_remove_self_reach_range_effect()
	
	reach_per_missle_delay_timer.stop()
	reach_before_fire_of_missles_timer.stop()
	
	if _cd_calculated_from_ability != -1:
		reach_ability.start_time_cooldown(_cd_calculated_from_ability)
		reach_ability.on_ability_after_cast_ended(_cd_calculated_from_ability)
		
		_cd_calculated_from_ability = -1
		
		_remove_set_up_of_next_cast_as_empowered()
	
	reach_ability.activation_conditional_clauses.remove_clause(reach_ability_during_cast_clause)
	

func _on_round_end_o():
	call_deferred("_end_reach_ability")


##

func _set_up_next_cast_as_empowered():
	_has_empowered_missle_count = true
	wings_left.visible = _has_empowered_missle_count
	wings_right.visible = _has_empowered_missle_count

func _remove_set_up_of_next_cast_as_empowered():
	_has_empowered_missle_count = false
	wings_left.visible = _has_empowered_missle_count
	wings_right.visible = _has_empowered_missle_count

###

func _create_missle_homing_component():
	var homing_component = BulletHomingComponent.new()
	homing_component.max_deg_angle_turn_amount_per_sec = 130.0
	
	return homing_component

func _on_enemy_targeted_by_homing_missle_tree_exiting(missle, homing_component):
	var target = _get_target_for_missle__including_in_map()
	if is_instance_valid(target):
		homing_component.target_node_to_home_to = target
	else:
		missle.trigger_on_death_events()

func _on_missle_tree_exiting(homing_component):
	if homing_component.is_connected("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_missle_tree_exiting"):
		homing_component.disconnect("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_missle_tree_exiting")
		homing_component.disconnect("on_bullet_tree_exiting", self, "_on_missle_tree_exiting")
	
	homing_component.bullet = null
	missle_homing_component_pool.declare_resource_as_available(homing_component)


#

func _on_missle_hit_enemy(bullet, enemy):
	var explosion = missle_explosion_attk_module.construct_aoe(enemy.global_position, enemy.global_position)
	explosion.modulate.a = 0.6
	explosion.damage_instance.on_hit_effects[missle_explosion_stun_effect.effect_uuid] = missle_explosion_stun_effect
	
	missle_explosion_attk_module.set_up_aoe__add_child_and_emit_signals(explosion)

#

func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = base_trail_length
	arg_trail.trail_color = trail_color
	arg_trail.width = base_trail_width



# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 1
	.set_heat_module(module)

func _construct_heat_effect():
	var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	attr_mod.flat_modifier = 0.5
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	_calculate_final_ability_potency()


