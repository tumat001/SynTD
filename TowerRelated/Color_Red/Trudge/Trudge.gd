extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")
const ArcingBaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")
const NullErasingArray = preload("res://MiscRelated/DataCollectionRelated/NullErasingArray.gd")
const EnemyKnockUpEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyKnockUpEffect.gd")
const ExpandingAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/ExpandingAttackSprite.gd")
const ExpandingAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/ExpandingAttackSprite.tscn")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")

const Trudge_PreSpurtSummongArea = preload("res://TowerRelated/Color_Red/Trudge/Subs/Trudge_PreSpurtSummoningArea.gd")
const Trudge_PreSpurtSummongArea_Scene = preload("res://TowerRelated/Color_Red/Trudge/Subs/Trudge_PreSpurtSummoningArea.tscn")

const Trudge_MainProj_Pic = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_MainProj.png")
const Trudge_PreSpurt_01 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_PreSpurt/Trudge_PreSpurt_01.png")
const Trudge_PreSpurt_02 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_PreSpurt/Trudge_PreSpurt_02.png")
const Trudge_PreSpurt_03 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_PreSpurt/Trudge_PreSpurt_03.png")
const Trudge_PreSpurt_04 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_PreSpurt/Trudge_PreSpurt_04.png")
const Trudge_PreSpurt_05 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_PreSpurt/Trudge_PreSpurt_05.png")
const Trudge_Spurt_01 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_Spurt/Trudge_Spurt_01.png")
const Trudge_Spurt_02 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_Spurt/Trudge_Spurt_02.png")
const Trudge_Spurt_03 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_Spurt/Trudge_Spurt_03.png")
const Trudge_Spurt_04 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_Spurt/Trudge_Spurt_04.png")
const Trudge_Spurt_05 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_Spurt/Trudge_Spurt_05.png")
const Trudge_Spurt_06 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_Spurt/Trudge_Spurt_06.png")
const Trudge_Spurt_07 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_Spurt/Trudge_Spurt_07.png")
const Trudge_Spurt_08 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_Spurt/Trudge_Spurt_08.png")
const Trudge_Spurt_09 = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_Spurt/Trudge_Spurt_09.png")
const Trudge_MainExplosion_01 = preload("res://TowerRelated/Color_Red/Trudge/Assets/MainExplosion/Trudge_MainExplosion_01.png")
const Trudge_MainExplosion_02 = preload("res://TowerRelated/Color_Red/Trudge/Assets/MainExplosion/Trudge_MainExplosion_02.png")
const Trudge_MainExplosion_03 = preload("res://TowerRelated/Color_Red/Trudge/Assets/MainExplosion/Trudge_MainExplosion_03.png")
const Trudge_MainExplosion_04 = preload("res://TowerRelated/Color_Red/Trudge/Assets/MainExplosion/Trudge_MainExplosion_04.png")
const Trudge_MainExplosion_05 = preload("res://TowerRelated/Color_Red/Trudge/Assets/MainExplosion/Trudge_MainExplosion_05.png")
const Trudge_MainExplosion_06 = preload("res://TowerRelated/Color_Red/Trudge/Assets/MainExplosion/Trudge_MainExplosion_06.png")
const Trudge_MainExplosion_07 = preload("res://TowerRelated/Color_Red/Trudge/Assets/MainExplosion/Trudge_MainExplosion_07.png")
const Trudge_MainExplosion_AMI = preload("res://TowerRelated/Color_Red/Trudge/Assets/AMAssets/Trudge_MainExplosion_AMI.png")
const Trudge_SpurtExplosion_AMI = preload("res://TowerRelated/Color_Red/Trudge/Assets/AMAssets/Trudge_SpurtExplosion_AMI.png")
const Trudge_SlamCircle_AMI = preload("res://TowerRelated/Color_Red/Trudge/Assets/AMAssets/Trudge_SlamCircle_AMI.png")
const Trudge_SlamCircle_Pic = preload("res://TowerRelated/Color_Red/Trudge/Assets/Trudge_SlamCircle.png")

const Trudge_IndicatorOn_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_Indicator_Glowing_Pic.png")
const Trudge_IndicatorOff_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_Indicator_NotGlowing_Pic.png")

#
const BasePlatform_Back_Normal_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_BasePlatform_Back_Pic.png")
const BasePlatform_Back_NoHealth_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_BasePlatform_Back_Pic_NoHealth.png")

const BasePlatform_Front_Normal_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_BasePlatform_Front_Pic.png")
const BasePlatform_Front_NoHealth_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_BasePlatform_Front_Pic_NoHealth.png")

const Weight_Back_Normal_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_Weight_Back_Pic.png")
const Weight_Back_NoHealth_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_Weight_Back_Pic_NoHealth.png")

const Weight_Front_Normal_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_Weight_Front_Pic.png")
const Weight_Front_NoHealth_Pic = preload("res://TowerRelated/Color_Red/Trudge/PartsAssets/Trudge_Weight_Front_Pic_NoHealth.png")

#

const slow_duration : float = 3.0
const slow_amount : float = -25.0
var _enemy_slow_effect : EnemyAttributesEffect

var explosion_from_main__attack_module : AOEAttackModule
var spurt_explosion_attack_module : AOEAttackModule

const pre_spurt_y_pos_summon_shift : int = 6
const pre_spurt_activation_delay_amount : float = 0.20
const pre_spurt_lifetime : float = 0.35
var pre_spurt_activation_timer : TimerForTower
var pre_spurt_attk_sprite_pool : AttackSpritePoolComponent

const spurt_base_dmg : float = 2.0
const spurt_pierce : int = 3

var _summon_pre_spurt_summoning_area_arr : NullErasingArray

#

var stampede_ability : BaseAbility
var stampede_ability_is_ready : bool = false
var stampede_ability_activation_cond_clause : ConditionalClauses

const stampede_is_casting_act_clause : int = -10
const no_enemies_in_range_clause : int = -11
const stampede_ability_base_cooldown : float = 40.0
const stampede_cd_reduc_on_spurt : float = 1.0

const stampede_cd_ratio_reduc_per_slam : float = 1 / 3.0
var _current_stampede_cd_ratio_scale : float

const slam_downward_velocity : float = 175.0
const slam_upward_velocity : float = -35.0
const slam_slow_upward_velocity : float = -15.0
var _current_slam_velocity : float = 0

const slam_y_pos_of_up : Vector2 = Vector2(0, -8.0)
const slam_y_pos_of_down : Vector2 = Vector2(0, 18.0)
const slam_back_weight_y_diff : float = -7.0

var _slam_count_state : int = 0 # 0 = none, 1 = first, 2 = second, 3 = third

var slam_ability_attk_module : InstantDamageAttackModule
const slam_damage : float = 4.0
const slam_pierce : int = 15
var slam_small_knock_up_effect : EnemyKnockUpEffect
var slam_big_knock_up_effect : EnemyKnockUpEffect

const slam_small_height_y_accel : float = 35.0
const slam_small_knock_up_stun_duration : float = 0.5

const slam_big_height_y_accel : float = 65.0
const slam_big_knock_up_base_stun_duration : float = 2.0

#

onready var weights_back =  $TowerBase/KnockUpLayer/WeightsBack
onready var weights_front = $TowerBase/KnockUpLayer/WeightsFront

onready var base_platform_front = $TowerBase/KnockUpLayer/BasePlatformFront
onready var base_platform_back = $TowerBase/KnockUpLayer/BasePlatformBack

onready var indicator_left = $TowerBase/KnockUpLayer/IndicatorLeft
onready var indicator_middle = $TowerBase/KnockUpLayer/IndicatorMiddle
onready var indicator_right = $TowerBase/KnockUpLayer/IndicatorRight

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.TRUDGE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 22
	
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = info.base_damage
	proj_attack_module.base_damage_type = info.base_damage_type
	proj_attack_module.base_attack_speed = info.base_attk_speed
	proj_attack_module.base_attack_wind_up = 0
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = true
	proj_attack_module.base_pierce = info.base_pierce
	proj_attack_module.base_proj_speed = 0.5
	proj_attack_module.module_id = StoreOfAttackModuleID.MAIN
	proj_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	proj_attack_module.benefits_from_bonus_base_damage = true
	proj_attack_module.benefits_from_bonus_on_hit_damage = true
	proj_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proj_attack_module.position.y -= 22
	
	proj_attack_module.bullet_scene = ArcingBaseBullet_Scene
	proj_attack_module.set_texture_as_sprite_frame(Trudge_MainProj_Pic)
	
	proj_attack_module.max_height = 700
	proj_attack_module.bullet_rotation_per_second = 160
	
	proj_attack_module.connect("before_bullet_is_shot", self, "_modify_bullet", [], CONNECT_PERSIST)
	
	proj_attack_module.is_displayed_in_tracker = false
	
	add_attack_module(proj_attack_module)
	
	
	# PROJ EXPLOSION AOE
	
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = info.base_damage
	explosion_attack_module.base_damage_type = info.base_damage_type
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.base_explosion_scale = 2.0
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Trudge_MainExplosion_01)
	sprite_frames.add_frame("default", Trudge_MainExplosion_02)
	sprite_frames.add_frame("default", Trudge_MainExplosion_03)
	sprite_frames.add_frame("default", Trudge_MainExplosion_04)
	sprite_frames.add_frame("default", Trudge_MainExplosion_05)
	sprite_frames.add_frame("default", Trudge_MainExplosion_06)
	sprite_frames.add_frame("default", Trudge_MainExplosion_07)
	
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 3
	explosion_attack_module.duration = 0.35
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	explosion_attack_module.set_image_as_tracker_image(Trudge_MainExplosion_AMI)
	
	add_attack_module(explosion_attack_module)
	explosion_from_main__attack_module = explosion_attack_module
	
	#
	
	_construct_and_add_spurt_explosion_attk_module()
	_construct_and_add_slam_attk_module()
	
	#
	
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.TRUDGE_SLOW_EFFECT)
	slow_modifier.percent_amount = slow_amount
	slow_modifier.percent_based_on = PercentType.BASE
	
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.TRUDGE_SLOW_EFFECT)
	enemy_attr_eff.is_timebound = true
	enemy_attr_eff.time_in_seconds = slow_duration
	_enemy_slow_effect = enemy_attr_eff
	
	
	pre_spurt_activation_timer = TimerForTower.new()
	pre_spurt_activation_timer.one_shot = false
	pre_spurt_activation_timer.connect("timeout", self, "_on_pre_spurt_activation_timer_timeout", [], CONNECT_PERSIST)
	pre_spurt_activation_timer.set_tower_and_properties(self)
	add_child(pre_spurt_activation_timer)
	
	pre_spurt_attk_sprite_pool = AttackSpritePoolComponent.new()
	pre_spurt_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	pre_spurt_attk_sprite_pool.node_to_listen_for_queue_free = self
	pre_spurt_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	pre_spurt_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_pre_spurt_particle"
	
	_summon_pre_spurt_summoning_area_arr = NullErasingArray.new()
	
	indicator_left.use_parent_material = false
	indicator_middle.use_parent_material = false
	indicator_right.use_parent_material = false
	
	#
	
	_construct_and_register_ability()
	_construct_knock_up_effects()
	
	connect("on_round_end", self, "_on_round_end_t", [], CONNECT_PERSIST)
	connect("on_any_attack_module_enemy_hit", self, "_on_any_attack_hit_enemy_t", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_entered", self, "_on_enemies_entered_range_module", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_on_enemies_exited_range_module", [], CONNECT_PERSIST)
	
	connect("changed_anim_from_alive_to_dead", self, "_on_changed_anim_from_alive_to_dead", [], CONNECT_PERSIST)
	connect("changed_anim_from_dead_to_alive", self, "_on_changed_anim_from_dead_to_alive", [], CONNECT_PERSIST)
	
	
	_post_inherit_ready()


func _construct_and_add_spurt_explosion_attk_module():
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = spurt_base_dmg
	explosion_attack_module.base_damage_type = DamageType.PHYSICAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.base_explosion_scale = 1.5
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Trudge_Spurt_01)
	sprite_frames.add_frame("default", Trudge_Spurt_02)
	sprite_frames.add_frame("default", Trudge_Spurt_03)
	sprite_frames.add_frame("default", Trudge_Spurt_04)
	sprite_frames.add_frame("default", Trudge_Spurt_05)
	sprite_frames.add_frame("default", Trudge_Spurt_06)
	sprite_frames.add_frame("default", Trudge_Spurt_07)
	sprite_frames.add_frame("default", Trudge_Spurt_08)
	sprite_frames.add_frame("default", Trudge_Spurt_09)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = spurt_pierce
	explosion_attack_module.duration = 0.35
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	explosion_attack_module.set_image_as_tracker_image(Trudge_SpurtExplosion_AMI)
	
	add_attack_module(explosion_attack_module)
	spurt_explosion_attack_module = explosion_attack_module

func _construct_and_add_slam_attk_module():
	slam_ability_attk_module = InstantDamageAttackModule_Scene.instance()
	slam_ability_attk_module.base_damage = slam_damage
	slam_ability_attk_module.base_damage_type = DamageType.PHYSICAL
	slam_ability_attk_module.base_attack_speed = 0
	slam_ability_attk_module.base_attack_wind_up = 0
	slam_ability_attk_module.is_main_attack = false
	slam_ability_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	slam_ability_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	slam_ability_attk_module.on_hit_damage_scale = 1
	
	slam_ability_attk_module.benefits_from_bonus_base_damage = false
	slam_ability_attk_module.benefits_from_bonus_attack_speed = false
	slam_ability_attk_module.benefits_from_bonus_on_hit_effect = false
	slam_ability_attk_module.benefits_from_bonus_on_hit_damage = false
	
	slam_ability_attk_module.can_be_commanded_by_tower = false
	
	slam_ability_attk_module.set_image_as_tracker_image(Trudge_SlamCircle_AMI)
	
	add_attack_module(slam_ability_attk_module)
	

func _construct_knock_up_effects():
	slam_small_knock_up_effect = EnemyKnockUpEffect.new(1, slam_small_height_y_accel, StoreOfEnemyEffectsUUID.TRUDGE_SMALL_KNOCK_UP_EFFECT)
	slam_small_knock_up_effect.custom_stun_duration = slam_small_knock_up_stun_duration
	
	slam_big_knock_up_effect = EnemyKnockUpEffect.new(1, slam_big_height_y_accel, StoreOfEnemyEffectsUUID.TRUDGE_BIG_KNOCK_UP_EFFECT)
	slam_big_knock_up_effect.custom_stun_duration = slam_big_knock_up_base_stun_duration


func _construct_and_register_ability():
	stampede_ability = BaseAbility.new()
	
	stampede_ability.is_timebound = true
	
	stampede_ability.set_properties_to_usual_tower_based()
	stampede_ability.tower = self
	stampede_ability_activation_cond_clause = stampede_ability.activation_conditional_clauses
	stampede_ability.activation_conditional_clauses.attempt_insert_clause(no_enemies_in_range_clause)
	
	stampede_ability.connect("current_time_cd_changed", self, "_on_stampede_ability_time_remaining_changed", [], CONNECT_PERSIST)
	stampede_ability.connect("updated_is_ready_for_activation", self, "_can_cast_stampede_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(stampede_ability, false)
	
	
	_on_stampede_ability_time_remaining_changed(0) # number here does not matter


# bullet signals related

func _modify_bullet(bullet : ArcingBaseBullet):
	bullet.connect("on_final_location_reached", self, "_main_proj_hit_ground", [], CONNECT_ONESHOT)

func _main_proj_hit_ground(arg_final_location : Vector2, bullet : ArcingBaseBullet):
	var explosion = explosion_from_main__attack_module.construct_aoe(arg_final_location, arg_final_location)
	
	explosion.modulate.a = 0.75
	explosion_from_main__attack_module.set_up_aoe__add_child_and_emit_signals(explosion)


func _on_any_attack_hit_enemy_t(enemy, damage_register_id, damage_instance, module):
	if module != spurt_explosion_attack_module:
		if module != slam_ability_attk_module or (module == slam_ability_attk_module and _slam_count_state == 3):
			if enemy.last_calculated_has_slow_effect or enemy._is_stunned:
				_summon_pre_spurt_summoning_area__and_add_to_stack(enemy.global_position)


#

func _summon_pre_spurt_summoning_area__and_add_to_stack(arg_location):
	var summoning_area : Trudge_PreSpurtSummongArea = pre_spurt_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	summoning_area.lifetime = pre_spurt_lifetime
	summoning_area.visible = true
	summoning_area.global_position = arg_location + Vector2(0, pre_spurt_y_pos_summon_shift)
	
	stampede_ability.time_decreased(stampede_cd_reduc_on_spurt)
	
	_add_pre_spurt_summoning_area_to_arr(summoning_area)

func _create_pre_spurt_particle():
	var particle = Trudge_PreSpurtSummongArea_Scene.instance()
	particle.connect("turned_invisible_from_lifetime_end", self, "_on_pre_spurt_lifetime_end", [particle])
	particle.modulate.a = 0.75
	
	particle.lifetime = pre_spurt_lifetime # needed to set proper fps of particle
	particle.set_anim_speed_based_on_lifetime()
	
	return particle


func _add_pre_spurt_summoning_area_to_arr(arg_pre_spurt_area):
	_summon_pre_spurt_summoning_area_arr.append_node_and_listen_for_tree_exiting(arg_pre_spurt_area)
	
	if pre_spurt_activation_timer.time_left <= 0:
		pre_spurt_activation_timer.start(pre_spurt_activation_delay_amount)

func _activate__and_remove_pre_spurt_summoning_area_from_arr(arg_pre_spurt_area):
	arg_pre_spurt_area.activate()
	_summon_pre_spurt_summoning_area_arr.array_of_nodes.erase(arg_pre_spurt_area)
	
	if _summon_pre_spurt_summoning_area_arr.array_of_nodes.size() <= 0:
		pre_spurt_activation_timer.stop()


func _on_pre_spurt_activation_timer_timeout():
	if _summon_pre_spurt_summoning_area_arr.array_of_nodes.size() > 0:
		_activate__and_remove_pre_spurt_summoning_area_from_arr(_summon_pre_spurt_summoning_area_arr.array_of_nodes[0])

#

func _on_pre_spurt_lifetime_end(arg_pre_spurt : Trudge_PreSpurtSummongArea):
	arg_pre_spurt.deactivate()
	
	var pos_of_summon = arg_pre_spurt.global_position - Vector2(0, pre_spurt_y_pos_summon_shift)
	var spurt_explosion = spurt_explosion_attack_module.construct_aoe(pos_of_summon, pos_of_summon)
	spurt_explosion.modulate.a = 0.75
	
	_add_ap_scaled_slow_effect_to_dmg_instance(spurt_explosion.damage_instance)
	
	spurt_explosion_attack_module.set_up_aoe__add_child_and_emit_signals(spurt_explosion)


func _add_ap_scaled_slow_effect_to_dmg_instance(arg_dmg_instance):
	arg_dmg_instance.on_hit_effects[_enemy_slow_effect.effect_uuid] = _enemy_slow_effect._get_copy_scaled_by(last_calculated_final_ability_potency)


#

func _on_round_end_t():
	_end_slam_state()
	
	for pre_spurt in _summon_pre_spurt_summoning_area_arr.array_of_nodes:
		if is_instance_valid(pre_spurt):
			pre_spurt.visible = false
			pre_spurt.deactivate()

#

func set_slam_state(arg_int):
	_slam_count_state = arg_int

#

func _on_enemies_entered_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		stampede_ability.activation_conditional_clauses.remove_clause(no_enemies_in_range_clause)
		
		if !enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives", [], CONNECT_DEFERRED)

func _on_enemy_killed_with_no_more_revives(damage_instance_report, arg_enemy):
	_on_enemies_exited_range_module(arg_enemy, null, range_module)


func _on_enemies_exited_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		if range_module.get_enemy_in_range_count() == 0:
			stampede_ability.activation_conditional_clauses.attempt_insert_clause(no_enemies_in_range_clause)
		
		if enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.disconnect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives")


func _can_cast_stampede_updated(arg_is_ready):
	stampede_ability_is_ready = arg_is_ready
	_attempt_cast_stampede_ability()

func _attempt_cast_stampede_ability():
	if stampede_ability_is_ready:
		_cast_stampede_ability()

func _cast_stampede_ability():
	_current_stampede_cd_ratio_scale = 0
	
	stampede_ability_activation_cond_clause.attempt_insert_clause(stampede_is_casting_act_clause)
	_set_weights_to_lifted_pos()
	set_slam_state(1)
	_set_weight_velocity(slam_downward_velocity)

##

func _set_weights_to_lifted_pos():
	weights_back.position = slam_y_pos_of_up + Vector2(0, slam_back_weight_y_diff)
	weights_front.position = slam_y_pos_of_up

func _set_weights_to_ground_pos():
	weights_back.position = slam_y_pos_of_down + Vector2(0, slam_back_weight_y_diff)
	weights_front.position = slam_y_pos_of_down

func _add_weights_y_shift(arg_y_shift):
	weights_back.position.y += arg_y_shift
	weights_front.position.y += arg_y_shift

func _is_weight_y_shift_on_or_below_ground():
	return weights_front.position.y >= slam_y_pos_of_down.y

func _is_weight_y_shift_at_or_above_lift():
	return weights_front.position.y <= slam_y_pos_of_up.y


func _set_weight_velocity(arg_y_velo):
	_current_slam_velocity = arg_y_velo


func _process(delta):
	if !is_dead_for_the_round:
		_add_weights_y_shift(_current_slam_velocity * delta)
		
		if _current_slam_velocity > 0: # going down
			if _is_weight_y_shift_on_or_below_ground():
				_set_weights_to_ground_pos()
				_on_weights_reached_ground()
			
		elif _current_slam_velocity < 0:
			if _is_weight_y_shift_at_or_above_lift():
				_set_weights_to_lifted_pos()
				_on_weights_reached_lift()

func _on_weights_reached_ground():
	var dmg_instance_modi_method : String
	
	if _slam_count_state == 1:
		dmg_instance_modi_method = "_add_ap_scaled_slow_effect_to_dmg_instance"
		_set_weight_velocity(slam_slow_upward_velocity)
		
	elif _slam_count_state == 2:
		dmg_instance_modi_method = "_add_small_knockup_effect_to_dmg_instance"
		_set_weight_velocity(slam_upward_velocity)
		
	elif _slam_count_state == 3:
		dmg_instance_modi_method = "_add_big_knockup_effect_to_dmg_instance"
		_set_weight_velocity(slam_upward_velocity)
	
	_current_stampede_cd_ratio_scale += stampede_cd_ratio_reduc_per_slam
	_execute_slam(dmg_instance_modi_method)

func _on_weights_reached_lift():
	if _slam_count_state == 1:
		set_slam_state(2)
		_set_weight_velocity(slam_downward_velocity)
		
	elif _slam_count_state == 2:
		set_slam_state(3)
		_set_weight_velocity(slam_downward_velocity)
		
	elif _slam_count_state == 3:
		_end_slam_state()
		

func _end_slam_state():
	set_slam_state(0)
	
	if is_equal_approx(_current_stampede_cd_ratio_scale, 1):
		_current_stampede_cd_ratio_scale = 1
	
	if stampede_ability_activation_cond_clause.has_clause(stampede_is_casting_act_clause):
		var cd = _get_cd_to_use(stampede_ability_base_cooldown * _current_stampede_cd_ratio_scale)
		stampede_ability.on_ability_before_cast_start(cd)
		
		stampede_ability.start_time_cooldown(cd)
		
		stampede_ability.on_ability_after_cast_ended(cd)
		stampede_ability_activation_cond_clause.remove_clause(stampede_is_casting_act_clause)
	
	
	_current_stampede_cd_ratio_scale = 0
	_set_weight_velocity(0)
	_set_weights_to_lifted_pos()


##

func _execute_slam(arg_dmg_instance_modi_method : String):
	if arg_dmg_instance_modi_method.length() > 0:
		for target in _get_targets_to_affect_with_slam():
			var dmg_instance = slam_ability_attk_module.construct_damage_instance()
			call(arg_dmg_instance_modi_method, dmg_instance)
			
			slam_ability_attk_module.set_up_dmg_instance__hit_enemy_and_emit_signals(target, dmg_instance)
	
	_construct_and_show_slam_expanding_attk_sprite(global_position, range_module)

func _add_small_knockup_effect_to_dmg_instance(arg_dmg_instance):
	var effect_copy = slam_small_knock_up_effect._get_copy_scaled_by(1)
	arg_dmg_instance.on_hit_effects[effect_copy.effect_uuid] = effect_copy

func _add_big_knockup_effect_to_dmg_instance(arg_dmg_instance):
	var effect_copy = slam_big_knock_up_effect._get_copy_scaled_by(stampede_ability.get_potency_to_use(last_calculated_final_ability_potency))
	arg_dmg_instance.on_hit_effects[effect_copy.effect_uuid] = effect_copy


func _get_targets_to_affect_with_slam():
	if is_instance_valid(range_module):
		return range_module.get_targets_without_affecting_self_current_targets(slam_pierce, Targeting.RANDOM, true)
	else:
		return []


func _construct_and_show_slam_expanding_attk_sprite(arg_global_pos, arg_range_module):
	if is_instance_valid(arg_range_module):
		var particle = ExpandingAttackSprite_Scene.instance()
		particle.lifetime = 0.25
		particle.texture_to_use = Trudge_SlamCircle_Pic
		particle.modulate.a = 0.5
		
		particle.position = arg_global_pos
		particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(particle)
		
		CommonAttackSpriteTemplater.configure_scale_and_expansion_of_expanding_attk_sprite(particle, 10, arg_range_module.last_calculated_final_range)
		

##

func _on_stampede_ability_time_remaining_changed(arg_curr_time_cd):
	var ratio = stampede_ability._time_current_cooldown / stampede_ability_base_cooldown
	
	if ratio <= 0.25:
		indicator_left.texture = Trudge_IndicatorOn_Pic
		indicator_middle.texture = Trudge_IndicatorOn_Pic
		indicator_right.texture = Trudge_IndicatorOn_Pic
	elif ratio <= 0.50:
		indicator_left.texture = Trudge_IndicatorOn_Pic
		indicator_middle.texture = Trudge_IndicatorOn_Pic
		indicator_right.texture = Trudge_IndicatorOff_Pic
	elif ratio <= 0.75:
		indicator_left.texture = Trudge_IndicatorOn_Pic
		indicator_middle.texture = Trudge_IndicatorOff_Pic
		indicator_right.texture = Trudge_IndicatorOff_Pic
	else:
		indicator_left.texture = Trudge_IndicatorOff_Pic
		indicator_middle.texture = Trudge_IndicatorOff_Pic
		indicator_right.texture = Trudge_IndicatorOff_Pic

###

func _on_changed_anim_from_alive_to_dead():
	weights_back.texture = Weight_Back_NoHealth_Pic
	weights_front.texture = Weight_Front_NoHealth_Pic
	
	base_platform_back.texture = BasePlatform_Back_NoHealth_Pic
	base_platform_front.texture = BasePlatform_Front_NoHealth_Pic


func _on_changed_anim_from_dead_to_alive():
	weights_back.texture = Weight_Back_Normal_Pic
	weights_front.texture = Weight_Front_Normal_Pic
	
	base_platform_back.texture = BasePlatform_Back_Normal_Pic
	base_platform_front.texture = BasePlatform_Front_Normal_Pic



# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 3
	.set_heat_module(module)

func _construct_heat_effect():
	var base_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_attr_mod.percent_amount = 12
	base_attr_mod.percent_based_on = PercentType.BASE
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_ABILITY_CDR , base_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)

func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	_calculate_final_ability_potency()

