extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const EnemyKnockUpEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyKnockUpEffect.gd")
const EnemyForcedPathOffsetMovementEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyForcedPathOffsetMovementEffect.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const Blast_MainProjPic = preload("res://TowerRelated/Color_Red/Blast/Assets/Blast_MainProj_Pic.png")
const Blast_ShockWaveProjPic = preload("res://TowerRelated/Color_Red/Blast/Assets/Blast_Shockwave_Pic.png")


const shockwave_knockup_accel : float = 40.0
const shockwave_knockup_time : float = 0.75
const shockwave_mov_speed : float = -85.0
const shockwave_mov_speed_deceleration : float = -65.0
const shockwave_pierce : int = 5
var shockwave_knockup_effect : EnemyKnockUpEffect
var shockwave_forced_path_mov_effect : EnemyForcedPathOffsetMovementEffect

const shockwave_base_slow_amount : float = -60.0
const shockwave_slow_duration : float = 2.0
var shockwave_slow_effect : EnemyAttributesEffect
const shockwave_cooldown_duration : float = 10.0
const shockwave_cooldown_duration_on_no_enemies_found : float = 2.0

var shockwave_attack_module : BulletAttackModule

var shockwave_ability : BaseAbility
var is_shockwave_ability_ready : bool
const no_enemies_in_range_clause = -10


const attack_speed_amount : float = 80.0
var attk_speed_effect : TowerAttributesEffect

#
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BLAST)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	
	var y_shift : float = 15
	
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
	attack_module.base_proj_speed = 350
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= y_shift
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(9, 4)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Blast_MainProjPic)
	
	add_attack_module(attack_module)
	
	#
	
	_construct_and_add_efflux_attk_module(y_shift, info)
	_construct_effects()
	_construct_and_register_ability()
	_construct_attk_speed_effect()
	
	connect("on_range_module_enemy_entered", self, "_on_enemies_entered_range_module", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_on_enemies_exited_range_module", [], CONNECT_PERSIST)
	connect("on_main_attack", self, "_on_main_attack_against_enemies", [], CONNECT_PERSIST)
	
	#
	
	_post_inherit_ready()


func _construct_and_add_efflux_attk_module(arg_y_shift_of_attack_module, info):
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = 0
	attack_module.base_damage_type = DamageType.ELEMENTAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = shockwave_pierce
	attack_module.base_proj_speed = 700
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = 1
	attack_module.position.y -= arg_y_shift_of_attack_module
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(5, 13)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Blast_ShockWaveProjPic)
	
	attack_module.can_be_commanded_by_tower = false
	
	shockwave_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	shockwave_attack_module.connect("on_enemy_hit", self, "_on_enemy_hit__by_shockwave", [], CONNECT_PERSIST)

func _construct_effects():
	shockwave_knockup_effect = EnemyKnockUpEffect.new(shockwave_knockup_time, shockwave_knockup_accel, StoreOfEnemyEffectsUUID.BLAST_KNOCKUP_EFFECT)
	#shockwave_knockup_effect.custom_stun_duration = repel_stun_duration
	
	shockwave_forced_path_mov_effect = EnemyForcedPathOffsetMovementEffect.new(shockwave_mov_speed, shockwave_mov_speed_deceleration, StoreOfEnemyEffectsUUID.BLAST_KNOCKBACK_FORCED_MOV_EFFECT)
	shockwave_forced_path_mov_effect.is_timebound = true
	shockwave_forced_path_mov_effect.time_in_seconds = shockwave_knockup_time
	
	
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.BLAST_SLOW_EFFECT)
	slow_modifier.percent_amount = shockwave_base_slow_amount
	slow_modifier.percent_based_on = PercentType.BASE
	shockwave_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.BLAST_SLOW_EFFECT)
	shockwave_slow_effect.is_timebound = true
	shockwave_slow_effect.time_in_seconds = shockwave_slow_duration


func _construct_and_register_ability():
	shockwave_ability = BaseAbility.new()
	
	shockwave_ability.is_timebound = true
	
	shockwave_ability.set_properties_to_usual_tower_based()
	shockwave_ability.tower = self
	
	shockwave_ability.connect("updated_is_ready_for_activation", self, "_can_cast_shockwave_updated", [], CONNECT_PERSIST)
	shockwave_ability.activation_conditional_clauses.attempt_insert_clause(no_enemies_in_range_clause)
	
	register_ability_to_manager(shockwave_ability, false)

func _construct_attk_speed_effect():
	var modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.BLAST_ATTACK_SPEED_EFFECT)
	modi.percent_amount = attack_speed_amount
	modi.percent_based_on = PercentType.BASE
	
	attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, modi, StoreOfTowerEffectsUUID.BLAST_ATTACK_SPEED_EFFECT)
	attk_speed_effect.is_countbound = true
	attk_speed_effect.count = 2
	attk_speed_effect.is_timebound = false


#


func _on_enemies_entered_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		shockwave_ability.activation_conditional_clauses.remove_clause(no_enemies_in_range_clause)
		
		if !enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives", [], CONNECT_DEFERRED)

func _on_enemy_killed_with_no_more_revives(damage_instance_report, arg_enemy):
	_on_enemies_exited_range_module(arg_enemy, null, range_module)


func _on_enemies_exited_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		if range_module.get_enemy_in_range_count() == 0:
			shockwave_ability.activation_conditional_clauses.attempt_insert_clause(no_enemies_in_range_clause)
		
		if enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.disconnect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives")



func _can_cast_shockwave_updated(arg_val):
	is_shockwave_ability_ready = arg_val
	_attempt_cast_shockwave()

func _attempt_cast_shockwave():
	if is_shockwave_ability_ready:
		_cast_shockwave()

func _cast_shockwave():
	var target = _get_target_for_shockwave()
	
	if is_instance_valid(target):
		var cd_to_use = _get_cd_to_use(shockwave_cooldown_duration)
		shockwave_ability.on_ability_before_cast_start(cd_to_use)
		
		shockwave_ability.start_time_cooldown(cd_to_use)
		_send_shockwave_towards_target(target)
		
		shockwave_ability.on_ability_after_cast_ended(cd_to_use)
		
	else:
		shockwave_ability.start_time_cooldown(shockwave_cooldown_duration_on_no_enemies_found)


func _get_target_for_shockwave():
	if is_instance_valid(range_module):
		var targets = range_module.get_targets_without_affecting_self_current_targets(1)
		if targets.size() > 0:
			return targets[0]
	
	return null

func _send_shockwave_towards_target(arg_target):
	var shockwave = shockwave_attack_module.construct_bullet(arg_target.global_position)
	shockwave.modulate.a = 0.8
	shockwave.scale.y *= 2
	
	shockwave_attack_module.set_up_bullet__add_child_and_emit_signals(shockwave)

#

func _on_enemy_hit__by_shockwave(enemy, damage_register_id, damage_instance, module):
	var ap_to_use = shockwave_ability.get_potency_to_use(last_calculated_final_ability_potency)
	
	if is_enemy_facing_self(enemy):
		damage_instance.on_hit_effects[shockwave_knockup_effect.effect_uuid] = shockwave_knockup_effect._get_copy_scaled_by(1)
		damage_instance.on_hit_effects[shockwave_forced_path_mov_effect.effect_uuid] = shockwave_forced_path_mov_effect._get_copy_scaled_by(ap_to_use)
		
	else:
		damage_instance.on_hit_effects[shockwave_slow_effect.effect_uuid] = shockwave_slow_effect._get_copy_scaled_by(ap_to_use)

###

func _on_main_attack_against_enemies(attk_speed_delay, enemies, module):
	if enemies.size() > 0:
		var enemy = enemies[0]
		if enemy.last_calculated_has_slow_effect or enemy._is_stunned:
			add_tower_effect(attk_speed_effect._get_copy_scaled_by(1))

#


# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 2
	.set_heat_module(module)

func _construct_heat_effect():
	var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	attr_mod.flat_modifier = 0.5
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	_calculate_final_ability_potency()



