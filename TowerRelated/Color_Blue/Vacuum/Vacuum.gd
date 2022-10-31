extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const MainProj_Bullet_pic = preload("res://TowerRelated/Color_Blue/Vacuum/Assets/Vacuum_MainProj.png")
const VacuumStunCircleParticle_Scene = preload("res://TowerRelated/Color_Blue/Vacuum/VacuumStunCircleParticle.tscn")
const Suck_AestheticParticle_Pic = preload("res://TowerRelated/Color_Blue/Vacuum/Assets/Suck_Particle.png")

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const EnemyKnockUpEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyKnockUpEffect.gd")
const EnemyForcedPathOffsetMovementEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyForcedPathOffsetMovementEffect.gd")

const CenterBasedAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd")
const CenterBasedAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.tscn")


#

onready var center_pos_2d_for_suck_particles = $TowerBase/CenterOfSuck

#

const slow_duration_per_apply : float = 0.6
const slow_apply_delay : float = 0.5 # wait for x sec before applying another slow
const base_suck_duration : float = 3.0
const suck_slow_percent_amount : float = -70.0
var suck_slow_effect : EnemyAttributesEffect

var suck_ability : BaseAbility
var is_suck_ability_ready : bool
var _current_duration_before_suck_end_and_shockwave_start : float
const base_suck_cooldown : float = 18.0
const is_sucking_clause : int = -10
const no_enemies_in_range_clause : int = -11

var suck_slow_applier_timer : Timer
var suck_duration_timer : Timer

var suck_particle_show_timer : Timer
var suck_particle_show_interval_delay : float = 0.15


const shockwave_stun_duration : float = 1.5
const shockwave_knockup_accel : float = 30.0
const shockwave_knockup_time : float = 0.8

const shockwave_mov_speed : float = 20.0
const shockwave_mov_speed_deceleration : float = 65.0


var suck_particle_attk_sprite_pool : AttackSpritePoolComponent
var shockwave_knockup_effect : EnemyKnockUpEffect
var shockwave_forced_path_mov_effect : EnemyForcedPathOffsetMovementEffect

const trail_color : Color = Color(0.3, 0.4, 1, 0.75)
const base_trail_length : int = 10
const base_trail_width : int = 3

var multiple_trail_component : MultipleTrailsForNodeComponent


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.VACUUM)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift_of_attack_module : float = 17
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += y_shift_of_attack_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 375
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= y_shift_of_attack_module
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(4, 10)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(MainProj_Bullet_pic)
	
	add_attack_module(attack_module)
	
	#
	
	multiple_trail_component = MultipleTrailsForNodeComponent.new()
	multiple_trail_component.node_to_host_trails = self
	multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	
	connect("on_round_end", self, "_on_round_end_v", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_entered", self, "_on_enemies_entered_range_module", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_on_enemies_exited_range_module", [], CONNECT_PERSIST)
	
	_initialize_particle_attk_sprite_pool()
	
	#
	
	
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.VACCUM_SLOW_FROM_SUCK_EFFECT)
	slow_modifier.percent_amount = suck_slow_percent_amount
	slow_modifier.percent_based_on = PercentType.BASE
	
	suck_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.VACCUM_SLOW_FROM_SUCK_EFFECT)
	suck_slow_effect.is_timebound = true
	suck_slow_effect.time_in_seconds = slow_duration_per_apply
	
	#
	
	shockwave_knockup_effect = EnemyKnockUpEffect.new(shockwave_knockup_time, shockwave_knockup_accel, StoreOfEnemyEffectsUUID.VACUUM_KNOCK_UP_EFFECT)
	shockwave_knockup_effect.custom_stun_duration = shockwave_stun_duration
	
	shockwave_forced_path_mov_effect = EnemyForcedPathOffsetMovementEffect.new(shockwave_mov_speed, shockwave_mov_speed_deceleration, StoreOfEnemyEffectsUUID.VACUUM_FORCED_MOV_OFFSET_EFFECT)
	shockwave_forced_path_mov_effect.is_timebound = true
	shockwave_forced_path_mov_effect.time_in_seconds = shockwave_stun_duration
	
	#
	
	_construct_and_register_ability()
	
	_post_inherit_ready()

#

func _construct_and_register_ability():
	suck_ability = BaseAbility.new()
	
	suck_ability.is_timebound = true
	
	suck_ability.set_properties_to_usual_tower_based()
	suck_ability.tower = self
	
	suck_ability.connect("updated_is_ready_for_activation", self, "_can_cast_suck_updated", [], CONNECT_PERSIST)
	suck_ability.activation_conditional_clauses.attempt_insert_clause(no_enemies_in_range_clause)
	
	register_ability_to_manager(suck_ability, false)
	
	#
	
	suck_slow_applier_timer = Timer.new()
	suck_slow_applier_timer.one_shot = false
	suck_slow_applier_timer.connect("timeout", self, "_on_suck_slow_applier_timer_timeout", [], CONNECT_PERSIST)
	add_child(suck_slow_applier_timer)
	
	suck_duration_timer = Timer.new()
	suck_duration_timer.one_shot = true
	suck_duration_timer.connect("timeout", self, "_on_suck_duration_timer_timeout", [], CONNECT_PERSIST)
	add_child(suck_duration_timer)
	
	suck_particle_show_timer = Timer.new()
	suck_particle_show_timer.one_shot = false
	suck_particle_show_timer.connect("timeout", self, "_on_suck_particle_show_timer_timeout", [], CONNECT_PERSIST)
	add_child(suck_particle_show_timer)

func _initialize_particle_attk_sprite_pool():
	suck_particle_attk_sprite_pool = AttackSpritePoolComponent.new()
	suck_particle_attk_sprite_pool.node_to_parent_attack_sprites = get_tree().get_root()
	suck_particle_attk_sprite_pool.node_to_listen_for_queue_free = self
	suck_particle_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	suck_particle_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_suck_particle"
	suck_particle_attk_sprite_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_suck_particle_properties_when_get_from_pool_after_add_child"
	

#

func _can_cast_suck_updated(is_ready):
	is_suck_ability_ready = is_ready
	_attempt_cast_suck()

func _on_enemies_entered_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		suck_ability.activation_conditional_clauses.remove_clause(no_enemies_in_range_clause)
		
		if !enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives", [], CONNECT_DEFERRED)

func _on_enemy_killed_with_no_more_revives(damage_instance_report, arg_enemy):
	_on_enemies_exited_range_module(arg_enemy, null, range_module)


func _on_enemies_exited_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		if range_module.get_enemy_in_range_count() == 0:
			suck_ability.activation_conditional_clauses.attempt_insert_clause(no_enemies_in_range_clause)
		
		if is_instance_valid(enemy) and enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.disconnect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives")



func _attempt_cast_suck():
	if is_suck_ability_ready:
		_cast_suck()

func _cast_suck():
	var cd = _get_cd_to_use(base_suck_cooldown)
	suck_ability.on_ability_before_cast_start(cd)
	
	suck_ability.start_time_cooldown(cd)
	_start_suck_timers()
	disabled_from_attacking_clauses.attempt_insert_clause(is_sucking_clause)
	
	suck_ability.on_ability_after_cast_ended(cd)


#

func _start_suck_timers():
	var final_duration_of_suck = base_suck_duration * suck_ability.get_potency_to_use(last_calculated_final_ability_potency)
	suck_duration_timer.start(final_duration_of_suck)
	suck_slow_applier_timer.start(slow_apply_delay)
	suck_particle_show_timer.start(suck_particle_show_interval_delay)
	
	_apply_slow_to_enemies_in_range()


func _on_suck_slow_applier_timer_timeout():
	_apply_slow_to_enemies_in_range()

func _apply_slow_to_enemies_in_range():
	if is_instance_valid(range_module):
		var enemies_in_range = range_module.get_enemies_in_range__not_affecting_curr_enemies_in_range()
		
		for enemy in enemies_in_range:
			if !is_enemy_facing_self(enemy):
				_apply_slow_to_enemy(enemy)

func _apply_slow_to_enemy(arg_enemy):
	arg_enemy._add_effect(suck_slow_effect)

#

func _on_suck_duration_timer_timeout():
	_apply_slow_to_enemies_in_range()
	_end_suck()
	_knock_all_enemies_in_range()

func _end_suck():
	if is_instance_valid(suck_slow_applier_timer):
		suck_slow_applier_timer.stop()
		suck_duration_timer.stop()
		suck_particle_show_timer.stop()
	
	disabled_from_attacking_clauses.remove_clause(is_sucking_clause)



#

func _knock_all_enemies_in_range():
	var particle = VacuumStunCircleParticle_Scene.instance()
	particle.global_position = global_position
	get_tree().get_root().add_child(particle)
	
	var enemies_in_range = range_module.get_enemies_in_range__not_affecting_curr_enemies_in_range()
	for enemy in enemies_in_range:
		enemy._add_effect(shockwave_knockup_effect)
		enemy._add_effect(shockwave_forced_path_mov_effect)


#

func _on_round_end_v():
	_end_suck()


#

func _on_suck_particle_show_timer_timeout():
	var particle = suck_particle_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	particle.visible = true
	particle.lifetime = 0.4
	
	multiple_trail_component.create_trail_for_node(particle)


func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = base_trail_length
	arg_trail.trail_color = trail_color
	arg_trail.width = base_trail_width
	
	arg_trail.set_to_idle_and_available_if_node_is_not_visible = true

#

func _create_suck_particle():
	var particle = CenterBasedAttackSprite_Scene.instance()
	
	particle.center_pos_of_basis = center_pos_2d_for_suck_particles.global_position
	particle.initial_speed_towards_center = 100
	particle.speed_accel_towards_center = 175
	particle.min_starting_distance_from_center = 50
	particle.max_starting_distance_from_center = 90
	particle.texture_to_use = Suck_AestheticParticle_Pic
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	#particle.lifetime = 0.7
	
	return particle


func _set_suck_particle_properties_when_get_from_pool_after_add_child(arg_particle):
	arg_particle.center_pos_of_basis = center_pos_2d_for_suck_particles.global_position
	arg_particle.reset_for_another_use()
	

