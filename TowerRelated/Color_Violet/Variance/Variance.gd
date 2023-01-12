extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")
const ArcingBaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")
const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const MapManager = preload("res://GameElementsRelated/MapManager.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const Variance_MainProj = preload("res://TowerRelated/Color_Violet/Variance/Attks/Variance_MainProj.png")

const Variance_Frame_Yellow_Pic = preload("res://TowerRelated/Color_Violet/Variance/Variance_Frame_Yellow.png")
const Variance_Frame_Blue_Pic = preload("res://TowerRelated/Color_Violet/Variance/Variance_Frame_Blue.png")
const Variance_Frame_Red_Pic = preload("res://TowerRelated/Color_Violet/Variance/Variance_Frame_Red.png")
const Variance_LockAbility_Pic = preload("res://TowerRelated/Color_Violet/Variance/Panel/Assets/LockVariance_ButtonImage.png")
const Variance_RedExplosion_AMI = preload("res://TowerRelated/Color_Violet/Variance/Assets/Variance_RedExplosion_AttkModuleAsset.png")
const Variance_BlueExplosion_AMI = preload("res://TowerRelated/Color_Violet/Variance/Assets/Variance_BlueExplosion_AttkModuleAsset.png")
const Variance_BlueBeam_AMI = preload("res://TowerRelated/Color_Violet/Variance/Assets/Variance_BlueBeam_AttkModuleAsset.png")
const CommonTexture_APParticle = preload("res://MiscRelated/CommonTextures/CommonTexture_APParticle.png")
const Variance_AttkSpeed_StatusBarIcon = preload("res://TowerRelated/Color_Violet/Variance_Vessel/AMI/Variance_AttkSpeed_StatusBarIcon.png")

const Variance_RedLobProj_Pic = preload("res://TowerRelated/Color_Violet/Variance/Attks/Variance_RedLobProj.png")
const Variance_ClearCircle_Scene = preload("res://TowerRelated/Color_Violet/Variance/Attks/ClearCircle/VarianceClearCircle.tscn")
const Variance_Red_Explosion_01 = preload("res://TowerRelated/Color_Violet/Variance/Attks/RedExplosion/Variance_RedExplosion_01.png")
const Variance_Red_Explosion_02 = preload("res://TowerRelated/Color_Violet/Variance/Attks/RedExplosion/Variance_RedExplosion_02.png")
const Variance_Red_Explosion_03 = preload("res://TowerRelated/Color_Violet/Variance/Attks/RedExplosion/Variance_RedExplosion_03.png")
const Variance_Red_Explosion_04 = preload("res://TowerRelated/Color_Violet/Variance/Attks/RedExplosion/Variance_RedExplosion_04.png")
const Variance_Red_Explosion_05 = preload("res://TowerRelated/Color_Violet/Variance/Attks/RedExplosion/Variance_RedExplosion_05.png")
const Variance_Red_Explosion_06 = preload("res://TowerRelated/Color_Violet/Variance/Attks/RedExplosion/Variance_RedExplosion_06.png")
const Variance_Red_Explosion_07 = preload("res://TowerRelated/Color_Violet/Variance/Attks/RedExplosion/Variance_RedExplosion_07.png")

const Variance_BlueBeam_Pic = preload("res://TowerRelated/Color_Violet/Variance/Attks/BlueBeam/Variance_BlueBeam.png")
const Variance_BlueExplosion_01 = preload("res://TowerRelated/Color_Violet/Variance/Attks/BlueExplosion/Variance_BlueExplosion_01.png")
const Variance_BlueExplosion_02 = preload("res://TowerRelated/Color_Violet/Variance/Attks/BlueExplosion/Variance_BlueExplosion_02.png")
const Variance_BlueExplosion_03 = preload("res://TowerRelated/Color_Violet/Variance/Attks/BlueExplosion/Variance_BlueExplosion_03.png")
const Variance_BlueExplosion_04 = preload("res://TowerRelated/Color_Violet/Variance/Attks/BlueExplosion/Variance_BlueExplosion_04.png")
const Variance_BlueExplosion_05 = preload("res://TowerRelated/Color_Violet/Variance/Attks/BlueExplosion/Variance_BlueExplosion_05.png")
const Variance_BlueExplosion_06 = preload("res://TowerRelated/Color_Violet/Variance/Attks/BlueExplosion/Variance_BlueExplosion_06.png")
const Variance_BlueExplosion_07 = preload("res://TowerRelated/Color_Violet/Variance/Attks/BlueExplosion/Variance_BlueExplosion_07.png")
const Variance_BlueParticle_Scene = preload("res://TowerRelated/Color_Violet/Variance/Assets/Particles/Variance_BlueParticle.tscn")

const EnemyClearAllEffects = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyClearAllEffects.gd")
const EnemyKnockUpEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyKnockUpEffect.gd")
const EnemyForcedPathOffsetMovementEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyForcedPathOffsetMovementEffect.gd")


onready var variance_frame_sprites = $TowerBase/KnockUpLayer/FrameSprites
onready var variance_chain_sprite = $TowerBase/KnockUpLayer/ChainSprite

enum VarianceState {
	INITIAL = 1,
	YELLOW = 2,
	BLUE = 3,
	RED = 4
}

var current_variance_state : int #= VarianceState.INITIAL #changing this does nothing. use method in _ready to change initial
var variance_state_rng : RandomNumberGenerator
var current_cd_for_change_state : int = 1    # 1 is needed to not change state immediately upon buying

var variance_blue_ing_effect : IngredientEffect
var variance_yellow_ing_effect : IngredientEffect
var variance_red_ing_effect : IngredientEffect

var lock_ability : BaseAbility
const lock_already_casted_clause : int = -10

#
var specialize_ability : BaseAbility
const specialize_base_cooldown : float = 22.0
const specialize_initial_cooldown : float = 5.0
var _specialize_ability_is_ready : bool = false
var is_an_enemy_in_range : bool = false

#
var enemy_clear_effect : EnemyClearAllEffects
var clear_ability_timer : Timer
const clear_ability_interval_delay : float = 5.0
const base_clear_cast_count : int = 3
var current_clear_cast_count_remaining : int
var is_casting_as_clear_type : bool

#
var red_knockup_effect : EnemyKnockUpEffect
var red_forced_path_mov_effect : EnemyForcedPathOffsetMovementEffect

const red_knockup_accel : float = 30.0
const red_knockup_time : float = 0.6
const red_stun_duration : float = 2.0

const red_mov_speed : float = 60.0
const red_mov_speed_deceleration : float = 65.0

const red_blob_explosion_flat_dmg : float = 30.0
const red_blob_explosion_base_dmg_scale : float = 8.0
const red_blob_pierce : int = 5

# the first knocks back and stuns, the second one stuns
var current_main_attack_count_as_red : int
var is_casting_as_red_type : bool

var current_attks_left_for_lob_glob_red : int
const lob_glob_red_disabled_from_attking_clause : int = -10
var red_lob_glob_attk_module : ArcingBulletAttackModule
var red_burst_attk_module : AOEAttackModule

#
var is_casting_as_blue_type : bool
const blue_beam_dmg_per_instance : float = 4.0
const blue_beam_attk_speed : float = 4.0

var blue_beam_attk_module : WithBeamInstantDamageAttackModule
const blue_beam_disabled_from_attking_clause : int = -10

const blue_explosion_base_dmg : float = 20.0
const blue_explosion_pierce : int = 3
var blue_explosion_attk_module : AOEAttackModule

var blue_particle_attk_sprite_pool : AttackSpritePoolComponent
var position_offset_for_center_of_blue_particle : Vector2
var non_essential_rng : RandomNumberGenerator

var blue_stacking_ap_modi : FlatModifier
var blue_stacking_ability_potency_effect : TowerAttributesEffect
const blue_ap_per_cast_during_cast : float = 0.5
var blue_ap_inc_attk_sprite_pool : AttackSpritePoolComponent

#
var is_casting_as_yellow_type : bool

var yellow_inst_dmg_attk_module : InstantDamageAttackModule
const yellow_bullet_flat_dmg : float = 3.0
const yellow_bullet_on_hit_dmg_ratio_of_creator : float = 0.4
const base_main_attks_for_vessel_summon : int = 25
var _current_main_attack_count_for_vessel_summon : int

var yellow_attk_speed_effect : TowerAttributesEffect
const yellow_attk_speed_percent_amount : float = 50.0
const yellow_attk_speed_duration : float = 15.0

#

const y_shift_of_attk_module : float = 16.0

var descs_for_clear : Array
var descs_for_red : Array
var descs_for_yellow : Array
var descs_for_blue : Array

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.VARIANCE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	position_offset_for_center_of_blue_particle = Vector2(0, -y_shift_of_attk_module)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += y_shift_of_attk_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 504 #420
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= y_shift_of_attk_module
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 7
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Variance_MainProj)
	
	add_attack_module(attack_module)
	
	#
	
	#_construct_and_add_lob_attack_module()
	#_construct_and_add_red_burst_explosion()
	
	_construct_lock_ability()
	variance_chain_sprite.visible = false
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	_construct_and_register_specialize_ability()
	
	variance_state_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.VARIANCE_STATE)
	connect("on_round_end", self, "_on_round_end_v", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_entered", self, "_on_enemy_entered_range_v", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_on_enemy_exited_range_v", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_v__ability_reset", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_on_round_start_v", [], CONNECT_PERSIST)
	
	_set_variance_state(VarianceState.INITIAL)
	
	#_set_variance_state(VarianceState.BLUE) #For testing
	
	variance_frame_sprites.use_parent_material = false
	
	_post_inherit_ready()


func _construct_and_add_lob_attack_module():
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = 0
	proj_attack_module.base_damage_type = DamageType.ELEMENTAL
	proj_attack_module.base_attack_speed = 5
	proj_attack_module.base_attack_wind_up = 0
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = false
	proj_attack_module.base_pierce = 0
	proj_attack_module.base_proj_speed = 0.45
	proj_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	proj_attack_module.on_hit_damage_scale = 0
	
	proj_attack_module.benefits_from_bonus_base_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proj_attack_module.position.y -= y_shift_of_attk_module
	
	proj_attack_module.bullet_scene = ArcingBaseBullet_Scene
	proj_attack_module.set_texture_as_sprite_frame(Variance_RedLobProj_Pic)
	
	proj_attack_module.max_height = 700
	proj_attack_module.bullet_rotation_per_second = 0
	
	proj_attack_module.connect("before_bullet_is_shot", self, "_modify_bullet_v__red_lob", [], CONNECT_PERSIST)
	
	proj_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(lob_glob_red_disabled_from_attking_clause)
	
	proj_attack_module.is_displayed_in_tracker = false
	
	red_lob_glob_attk_module = proj_attack_module
	
	add_attack_module(proj_attack_module)


func _construct_and_add_red_burst_explosion():
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = red_blob_explosion_base_dmg_scale
	explosion_attack_module.base_damage = red_blob_explosion_flat_dmg / explosion_attack_module.base_damage_scale
	explosion_attack_module.base_damage_type = DamageType.PURE
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.base_explosion_scale = 3.6#2.6
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Variance_Red_Explosion_01)
	sprite_frames.add_frame("default", Variance_Red_Explosion_02)
	sprite_frames.add_frame("default", Variance_Red_Explosion_03)
	sprite_frames.add_frame("default", Variance_Red_Explosion_04)
	sprite_frames.add_frame("default", Variance_Red_Explosion_05)
	sprite_frames.add_frame("default", Variance_Red_Explosion_06)
	sprite_frames.add_frame("default", Variance_Red_Explosion_07)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = red_blob_pierce
	explosion_attack_module.duration = 0.32
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(Variance_RedExplosion_AMI)
	explosion_attack_module.is_displayed_in_tracker = false
	
	red_burst_attk_module = explosion_attack_module
	
	add_attack_module(explosion_attack_module)

func _construct_and_add_blue_beam_attk_module():
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = blue_beam_dmg_per_instance
	attack_module.base_damage_type = DamageType.ELEMENTAL
	attack_module.base_attack_speed = blue_beam_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = false
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= y_shift_of_attk_module
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Variance_BlueBeam_Pic)
	#beam_sprite_frame.set_animation_loop("default", true)
	#beam_sprite_frame.set_animation_speed("default", 15)
	
	attack_module.is_displayed_in_tracker = false
	attack_module.set_image_as_tracker_image(Variance_BlueBeam_AMI)
	
	attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(blue_beam_disabled_from_attking_clause)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	
	blue_beam_attk_module = attack_module
	
	blue_beam_attk_module.connect("on_damage_instance_constructed", self, "_on_dmg_instance_constructed__by_blue_beam", [], CONNECT_PERSIST)
	blue_beam_attk_module.connect("on_enemy_hit", self, "_on_blue_beam_attk_module_hit_enemy", [], CONNECT_PERSIST)
	
	#
	
	_initialize_particle_attk_sprite_pool()
	
	blue_stacking_ap_modi = FlatModifier.new(StoreOfTowerEffectsUUID.VARIANCE_BLUE_STACKING_AP_EFFECT)
	blue_stacking_ap_modi.flat_modifier = 0
	blue_stacking_ability_potency_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, blue_stacking_ap_modi, StoreOfTowerEffectsUUID.VARIANCE_BLUE_STACKING_AP_EFFECT)
	blue_stacking_ability_potency_effect.is_timebound = false
	add_tower_effect(blue_stacking_ability_potency_effect)
	
	#
	
	add_attack_module(attack_module)


func _construct_and_add_blue_explosion_attk_module():
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = blue_explosion_base_dmg
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.base_explosion_scale = 2
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Variance_BlueExplosion_01)
	sprite_frames.add_frame("default", Variance_BlueExplosion_02)
	sprite_frames.add_frame("default", Variance_BlueExplosion_03)
	sprite_frames.add_frame("default", Variance_BlueExplosion_04)
	sprite_frames.add_frame("default", Variance_BlueExplosion_05)
	sprite_frames.add_frame("default", Variance_BlueExplosion_06)
	sprite_frames.add_frame("default", Variance_BlueExplosion_07)
	
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = blue_explosion_pierce
	explosion_attack_module.duration = 0.32
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(Variance_BlueExplosion_AMI)
	explosion_attack_module.is_displayed_in_tracker = false
	
	blue_explosion_attk_module = explosion_attack_module
	
	add_attack_module(explosion_attack_module)


func _construct_and_add_yellow_inst_attack_module():
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = yellow_bullet_flat_dmg
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = false
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = yellow_bullet_on_hit_dmg_ratio_of_creator
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = true
	attack_module.benefits_from_bonus_on_hit_effect = false
	
	yellow_inst_dmg_attk_module = attack_module
	
	attack_module.is_displayed_in_tracker = false
	
	attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(attack_module)
	#
	
	var attk_speed_modi = PercentModifier.new(StoreOfTowerEffectsUUID.VARIANCE_YELLOW_ATTK_SPEED_EFFECT)
	attk_speed_modi.percent_amount = yellow_attk_speed_percent_amount
	
	yellow_attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_modi, StoreOfTowerEffectsUUID.VARIANCE_YELLOW_ATTK_SPEED_EFFECT)
	yellow_attk_speed_effect.is_timebound = true
	yellow_attk_speed_effect.time_in_seconds = yellow_attk_speed_duration
	yellow_attk_speed_effect.status_bar_icon = Variance_AttkSpeed_StatusBarIcon
	




#

func _construct_lock_ability():
	lock_ability = BaseAbility.new()
	
	lock_ability.is_timebound = true
	lock_ability.connect("ability_activated", self, "_lock_ability_activated", [], CONNECT_PERSIST)
	lock_ability.icon = Variance_LockAbility_Pic
	
	lock_ability.set_properties_to_usual_tower_based()
	lock_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	lock_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	lock_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	lock_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	
	lock_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.TOWER_IN_BENCH)
	lock_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	lock_ability.activation_conditional_clauses.blacklisted_clauses.append(disabled_from_attacking_clauses)
	lock_ability.activation_conditional_clauses.remove_clause(BaseAbility.ActivationClauses.TOWER_IN_BENCH)
	lock_ability.activation_conditional_clauses.remove_clause(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	
	
	lock_ability.tower = self
	
	lock_ability.descriptions = [
		"On activation: Permanently prevents Variance from changing types on round end."
	]
	lock_ability.display_name = "Lock"
	
	register_ability_to_manager(lock_ability, false)


func _on_round_start_v():
	if current_variance_state == VarianceState.INITIAL:
		_set_attack_module_is_displayed_in_tracker(red_burst_attk_module, false)
		_set_attack_module_is_displayed_in_tracker(blue_beam_attk_module, false)
		_set_attack_module_is_displayed_in_tracker(blue_explosion_attk_module, false)
		
	elif current_variance_state == VarianceState.RED:
		_set_attack_module_is_displayed_in_tracker(red_burst_attk_module, true)
		_set_attack_module_is_displayed_in_tracker(blue_beam_attk_module, false)
		_set_attack_module_is_displayed_in_tracker(blue_explosion_attk_module, false)
		
	elif current_variance_state == VarianceState.YELLOW:
		_set_attack_module_is_displayed_in_tracker(red_burst_attk_module, false)
		_set_attack_module_is_displayed_in_tracker(blue_beam_attk_module, false)
		_set_attack_module_is_displayed_in_tracker(blue_explosion_attk_module, false)
		
	elif current_variance_state == VarianceState.BLUE:
		_set_attack_module_is_displayed_in_tracker(red_burst_attk_module, false)
		_set_attack_module_is_displayed_in_tracker(blue_beam_attk_module, true)
		_set_attack_module_is_displayed_in_tracker(blue_explosion_attk_module, true)
	
	
	if blue_stacking_ap_modi != null:
		blue_stacking_ap_modi.flat_modifier = 0
		_calculate_final_ability_potency()


func _set_attack_module_is_displayed_in_tracker(arg_module, arg_should_display):
	if is_instance_valid(arg_module):
		arg_module.is_displayed_in_tracker = arg_should_display

#

func _on_round_end_v(): # EVENTUALLY DISCONNECTED.
	if current_cd_for_change_state <= 0:
		_update_curr_state_to_random_state()
	
	current_cd_for_change_state -= 1
	
	#


func _update_curr_state_to_random_state():
	var new_state = variance_state_rng.randi_range(2, 4)
	
	_set_variance_state(new_state)
	
	#_set_variance_state(VarianceState.RED) #testing

#

func _set_variance_state(arg_state_id):
	var old_state = current_variance_state
	current_variance_state = arg_state_id
	
	if old_state != current_variance_state:
		if arg_state_id == VarianceState.BLUE:
			_set_variance_state_to_blue()
		elif arg_state_id == VarianceState.YELLOW:
			_set_variance_state_to_yellow()
		elif arg_state_id == VarianceState.RED:
			_set_variance_state_to_red()
		elif arg_state_id == VarianceState.INITIAL:
			_set_vairance_state_to_initial()
		
		if arg_state_id == VarianceState.YELLOW and !is_connected("on_main_attack", self, "_on_main_attack__for_yellow_summon_vessel_count"):
			connect("on_main_attack", self, "_on_main_attack__for_yellow_summon_vessel_count", [], CONNECT_PERSIST)
		elif arg_state_id != VarianceState.YELLOW and is_connected("on_main_attack", self, "_on_main_attack__for_yellow_summon_vessel_count"):
			disconnect("on_main_attack", self, "_on_main_attack__for_yellow_summon_vessel_count")


func _set_vairance_state_to_initial():
	if descs_for_clear.size() == 0:
		descs_for_clear = _get_descriptions_for_clear_var()
	tower_type_info.tower_descriptions = descs_for_clear
	
	
	#Do this when needed (if revertable to clear)
	#variance_frame_sprites.texture = Variance_fra
	#initialize_clear_ing

func _set_variance_state_to_blue():
	if !is_instance_valid(blue_beam_attk_module):
		_construct_and_add_blue_beam_attk_module()
		_construct_and_add_blue_explosion_attk_module()
	
	if descs_for_blue.size() == 0:
		descs_for_blue = _get_descriptions_for_blue_var()
	tower_type_info.tower_descriptions = descs_for_blue
	
	variance_frame_sprites.texture = Variance_Frame_Blue_Pic
	_initialize_blue_ing()
	set_self_ingredient_effect(variance_blue_ing_effect)

func _initialize_blue_ing():
	if variance_blue_ing_effect == null:
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_VARIANCE_STAT)
		base_ap_attr_mod.flat_modifier = Towers.tier_ap_map[tower_type_info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_VARIANCE_STAT)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		variance_blue_ing_effect = ing_effect
		


#

func _set_variance_state_to_yellow():
	if !is_instance_valid(yellow_inst_dmg_attk_module):
		_construct_and_add_yellow_inst_attack_module()
	
	if descs_for_yellow.size() == 0:
		descs_for_yellow = _get_descriptions_for_yellow_var()
	tower_type_info.tower_descriptions = descs_for_yellow
	
	variance_frame_sprites.texture = Variance_Frame_Yellow_Pic
	_initialize_yellow_ing()
	set_self_ingredient_effect(variance_yellow_ing_effect)

func _initialize_yellow_ing():
	if variance_yellow_ing_effect == null:
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_VARIANCE_STAT)
		attk_speed_attr_mod.percent_amount = Towers.tier_attk_speed_map[tower_type_info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_VARIANCE_STAT)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		variance_yellow_ing_effect = ing_effect

#

func _set_variance_state_to_red():
	if !is_instance_valid(red_lob_glob_attk_module):
		_construct_and_add_lob_attack_module()
		_construct_and_add_red_burst_explosion()
	
	if descs_for_red.size() == 0:
		descs_for_red = _get_descriptions_for_red_var()
	tower_type_info.tower_descriptions = descs_for_red
	
	variance_frame_sprites.texture = Variance_Frame_Red_Pic
	_initialize_red_ing()
	set_self_ingredient_effect(variance_red_ing_effect)

func _initialize_red_ing():
	if variance_red_ing_effect == null:
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_VARIANCE_STAT)
		base_dmg_attr_mod.flat_modifier = Towers.tier_base_dmg_map[tower_type_info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_VARIANCE_STAT)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		variance_red_ing_effect = ing_effect

#

func _lock_ability_activated():
	lock_ability.activation_conditional_clauses.attempt_insert_clause(lock_already_casted_clause)
	variance_chain_sprite.visible = true
	if is_connected("on_round_end", self, "_on_round_end_v"):
		disconnect("on_round_end", self, "_on_round_end_v")

#########

func _construct_and_register_specialize_ability():
	specialize_ability = BaseAbility.new()
	
	specialize_ability.is_timebound = true
	
	specialize_ability.set_properties_to_usual_tower_based()
	specialize_ability.tower = self
	
	specialize_ability.connect("updated_is_ready_for_activation", self, "_can_cast_specialize_changed", [], CONNECT_PERSIST)
	register_ability_to_manager(specialize_ability, false)
	
	specialize_ability.start_time_cooldown(specialize_initial_cooldown)
	
	# Clear related
	enemy_clear_effect = EnemyClearAllEffects.new(StoreOfEnemyEffectsUUID.VARIANCE_CLEAR_ENEMY_EFFECT)
	clear_ability_timer = Timer.new()
	clear_ability_timer.one_shot = false
	clear_ability_timer.connect("timeout", self, "_clear_ability_timer_timeout", [], CONNECT_PERSIST)
	add_child(clear_ability_timer)
	
	# Red related
	red_knockup_effect = EnemyKnockUpEffect.new(red_knockup_time, red_knockup_accel, StoreOfEnemyEffectsUUID.VARIANCE_RED_KNOCK_UP_EFFECT)
	red_knockup_effect.custom_stun_duration = red_stun_duration
	
	red_forced_path_mov_effect = EnemyForcedPathOffsetMovementEffect.new(red_mov_speed, red_mov_speed_deceleration, StoreOfEnemyEffectsUUID.VARIANCE_RED_FORCED_MOV_EFFECT)
	red_forced_path_mov_effect.is_timebound = true
	red_forced_path_mov_effect.time_in_seconds = red_stun_duration



func _can_cast_specialize_changed(arg_val):
	_specialize_ability_is_ready = arg_val
	
	_attempt_cast_specialize()

func _on_enemy_entered_range_v(enemy, arg_module, arg_range_module):
	if is_instance_valid(main_attack_module) and arg_range_module == main_attack_module.range_module:
		is_an_enemy_in_range = true
		_attempt_cast_specialize()

func _on_enemy_exited_range_v(enemy, arg_module, arg_range_module):
	if is_instance_valid(main_attack_module) and arg_range_module == main_attack_module.range_module:
		is_an_enemy_in_range = arg_range_module.is_an_enemy_in_range()


func _attempt_cast_specialize():
	if _specialize_ability_is_ready and is_an_enemy_in_range:
		_cast_specialize()

func _cast_specialize():
	var cd = _get_cd_to_use(specialize_base_cooldown)
	specialize_ability.on_ability_before_cast_start(cd)
	specialize_ability.start_time_cooldown(cd)
	
	if current_variance_state == VarianceState.INITIAL:
		_cast_specialize_as_clear_state()
	elif current_variance_state == VarianceState.BLUE:
		_cast_specialize_as_blue_state()
	elif current_variance_state == VarianceState.RED:
		_cast_specialize_as_red_state()
	elif current_variance_state == VarianceState.YELLOW:
		_cast_specialize_as_yellow_type()
	
	specialize_ability.on_ability_after_cast_ended(cd)

#

func _on_round_end_v__ability_reset(): # PUT USUAL ROUND END STUFF HERE
	if is_casting_as_clear_type:
		_stop_clear_ability()
	elif is_casting_as_red_type:
		_stop_red_ability()
	elif is_casting_as_blue_type:
		_stop_blue_ability()
	elif is_casting_as_yellow_type:
		_stop_yellow_ability()
	
	_current_main_attack_count_for_vessel_summon = 0

#

func _cast_specialize_as_clear_state():
	is_casting_as_clear_type = true
	current_clear_cast_count_remaining = base_clear_cast_count
	_clear_ability_timer_timeout()
	clear_ability_timer.start(clear_ability_interval_delay)


func _clear_ability_timer_timeout():
	if current_clear_cast_count_remaining > 0:
		var particle = Variance_ClearCircle_Scene.instance()
		
		particle.position = global_position
		CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)
		
		#
		
		if is_instance_valid(range_module):
			for enemy in range_module.get_enemies_in_range__not_affecting_curr_enemies_in_range():
				enemy._add_effect(enemy_clear_effect)
		
		current_clear_cast_count_remaining -= 1
		
	else:
		_stop_clear_ability()

func _stop_clear_ability():
	current_clear_cast_count_remaining = 0
	clear_ability_timer.stop()
	is_casting_as_clear_type = false


#

func _cast_specialize_as_red_state():
	if !is_casting_as_red_type:
		current_main_attack_count_as_red = 1
		is_casting_as_red_type = true
		if !is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_v__as_red"):
			connect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_v__as_red")

func _on_main_bullet_attack_module_before_bullet_is_shot_v__as_red(bullet : BaseBullet, attack_module):
	if current_main_attack_count_as_red == 1:
		bullet.damage_instance.on_hit_effects[red_knockup_effect.effect_uuid] = red_knockup_effect
		bullet.connect("hit_an_enemy", self, "_on_red_knockback_bullet_hit_enemy")
		current_main_attack_count_as_red += 1
		
	elif current_main_attack_count_as_red == 2:
		bullet.damage_instance.on_hit_effects[red_knockup_effect.effect_uuid] = red_knockup_effect
		current_main_attack_count_as_red += 1
		
	elif current_main_attack_count_as_red == 3:
		current_attks_left_for_lob_glob_red = 1
		red_lob_glob_attk_module.can_be_commanded_by_tower_other_clauses.remove_clause(lob_glob_red_disabled_from_attking_clause)
		current_main_attack_count_as_red = 0
		if is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_v__as_red"):
			disconnect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_v__as_red")
		is_casting_as_red_type = false

func _on_red_knockback_bullet_hit_enemy(bullet, arg_enemy):
	var knockback_effect = red_forced_path_mov_effect._get_copy_scaled_by(1)
	arg_enemy.configure_path_move_offset_to_mov_self_backward_on_track(knockback_effect)
	
	arg_enemy._add_effect(knockback_effect)


func _modify_bullet_v__red_lob(bullet):
	if current_attks_left_for_lob_glob_red > 0:
		current_attks_left_for_lob_glob_red -= 1
		
		bullet.connect("on_final_location_reached", self, "_on_red_lob_arcing_bullet_landed", [], CONNECT_ONESHOT)
		
		if current_attks_left_for_lob_glob_red <= 0:
			red_lob_glob_attk_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(lob_glob_red_disabled_from_attking_clause)

func _on_red_lob_arcing_bullet_landed(arg_final_location : Vector2, bullet : ArcingBaseBullet):
	var explosion = red_burst_attk_module.construct_aoe(arg_final_location, arg_final_location)
	
	red_burst_attk_module.set_up_aoe__add_child_and_emit_signals(explosion)


func _stop_red_ability():
	current_attks_left_for_lob_glob_red = 0
	red_lob_glob_attk_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(lob_glob_red_disabled_from_attking_clause)
	current_main_attack_count_as_red = 0
	
	is_casting_as_red_type = false
	
	if is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_v__as_red"):
		disconnect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_v__as_red")

###

func _cast_specialize_as_blue_state():
	if !is_casting_as_blue_type:
		is_casting_as_blue_type = true
		
		var curr_target
		if is_instance_valid(range_module):
			#var enemies = range_module.get_enemies_in_range__not_affecting_curr_enemies_in_range()
			var enemies = range_module.get_targets_without_affecting_self_current_targets(1, Targeting.STRONGEST)
			if enemies.size() > 0:
				curr_target = enemies[0]
		
		if is_instance_valid(curr_target):
			blue_beam_attk_module.can_be_commanded_by_tower_other_clauses.remove_clause(blue_beam_disabled_from_attking_clause)
			range_module.connect("enemy_left_range", self, "_on_enemy_exited_range_module", [range_module])
			
			#curr_target.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed", [curr_target, range_module])
			
			if !curr_target.is_connected("tree_exiting", self, "_on_enemy_killed"):
				curr_target.connect("tree_exiting", self, "_on_enemy_killed", [null, null, curr_target, range_module])
			
		else:
			blue_beam_attk_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(blue_beam_disabled_from_attking_clause)
		
	else:
		blue_stacking_ap_modi.flat_modifier += blue_ap_per_cast_during_cast
		_calculate_final_ability_potency()
		
		for i in 6:
			blue_ap_inc_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
		_stop_blue_ability()


func _on_dmg_instance_constructed__by_blue_beam(arg_dmg_instance, arg_module):
	arg_dmg_instance.scale_only_damage_by(specialize_ability.get_potency_to_use(last_calculated_final_ability_potency))

func _on_enemy_exited_range_module(arg_enemy, arg_range_mod):
	_create_blue_explosion_at_pos__and_end_blue_beam(arg_enemy.global_position, arg_enemy, arg_range_mod)

func _on_enemy_killed(damage_instance_report, enemy_me, arg_enemy, arg_range_mod):
	_create_blue_explosion_at_pos__and_end_blue_beam(arg_enemy.global_position, arg_enemy, arg_range_mod)


func _create_blue_explosion_at_pos__and_end_blue_beam(arg_pos : Vector2, arg_enemy, arg_range_mod):
	var explosion = blue_explosion_attk_module.construct_aoe(arg_pos, arg_pos)
	explosion.damage_instance.scale_only_damage_by(specialize_ability.get_potency_to_use(last_calculated_final_ability_potency))
	blue_explosion_attk_module.set_up_aoe__add_child_and_emit_signals(explosion)
	
	if arg_enemy.is_connected("tree_exiting", self, "_on_enemy_killed"):
		arg_enemy.disconnect("tree_exiting", self, "_on_enemy_killed")
	
	_stop_blue_ability()


func _stop_blue_ability():
	is_casting_as_blue_type = false
	blue_beam_attk_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(blue_beam_disabled_from_attking_clause)
	
	if range_module.is_connected("enemy_left_range", self, "_on_enemy_exited_range_module"):
		range_module.disconnect("enemy_left_range", self, "_on_enemy_exited_range_module")

#

func _initialize_particle_attk_sprite_pool():
	blue_particle_attk_sprite_pool = AttackSpritePoolComponent.new()
	blue_particle_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	blue_particle_attk_sprite_pool.node_to_listen_for_queue_free = self
	blue_particle_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	blue_particle_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_blue_particle"
	blue_particle_attk_sprite_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_blue_particle_properties_when_get_from_pool_after_add_child"
	
	blue_ap_inc_attk_sprite_pool = AttackSpritePoolComponent.new()
	blue_ap_inc_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	blue_ap_inc_attk_sprite_pool.node_to_listen_for_queue_free = self
	blue_ap_inc_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	blue_ap_inc_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_blue_ap_inc_particle"
	blue_ap_inc_attk_sprite_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_blue_ap_inc_particle_properties_when_get_from_pool_after_add_child"
	blue_ap_inc_attk_sprite_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_before_add_child = "_set_blue_ap_inc_particle_properties_when_get_from_pool_before_add_child"

func _create_blue_particle():
	var particle = Variance_BlueParticle_Scene.instance()
	
	particle.initial_speed_towards_center = 200
	particle.speed_accel_towards_center = 300
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	
	return particle

func _set_blue_particle_properties_when_get_from_pool_after_add_child(particle):
	pass
	

func _on_blue_beam_attk_module_hit_enemy(enemy, damage_register_id, damage_instance, module):
	var particle = blue_particle_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	
	var pos_of_center = global_position + position_offset_for_center_of_blue_particle
	#var distance_to_enemy = pos_of_center.distance_to(enemy.global_position)
	particle.center_pos_of_basis = pos_of_center
	
	particle.reset_for_another_use()
	
	var rand_num_01 = non_essential_rng.randi_range(-14, 14)
	var rand_num_02 = non_essential_rng.randi_range(-14, 14)
	particle.global_position = enemy.global_position + Vector2(rand_num_01, rand_num_01)
	
	particle.lifetime = 0.3
	particle.visible = true

#

func _create_blue_ap_inc_particle():
	var particle = AttackSprite_Scene.instance()
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	particle.texture_to_use = CommonTexture_APParticle
	particle.scale *= 1.5
	
	return particle

func _set_blue_ap_inc_particle_properties_when_get_from_pool_before_add_child(particle):
	particle.lifetime = 0.5

func _set_blue_ap_inc_particle_properties_when_get_from_pool_after_add_child(particle):
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	particle.position = global_position
	
	particle.position.x += non_essential_rng.randi_range(-25, 25)
	particle.position.y += non_essential_rng.randi_range(-16, 10)
	
	particle.modulate.a = 1
	
	particle.visible = true


###

func _cast_specialize_as_yellow_type():
	is_casting_as_yellow_type = true
	
	add_tower_effect(yellow_attk_speed_effect._get_copy_scaled_by(1))
	
	is_casting_as_yellow_type = false

func _stop_yellow_ability():
	is_casting_as_yellow_type = false



#

func _on_main_attack__for_yellow_summon_vessel_count(attk_speed_delay, enemies, module):
	_current_main_attack_count_for_vessel_summon += 1
	if _current_main_attack_count_for_vessel_summon >= base_main_attks_for_vessel_summon:
		_current_main_attack_count_for_vessel_summon = 0
		_attempt_summon_variance_vessel()


func _attempt_summon_variance_vessel():
	if !is_queued_for_deletion():
		var range_to_use : float = 100
		if is_instance_valid(range_module):
			range_to_use = range_module.last_calculated_final_range
		
		var placables = game_elements.map_manager.get_all_placables_out_of_range(global_position, range_to_use, MapManager.PlacableState.UNOCCUPIED, MapManager.SortOrder.RANDOM)
		if placables.size() > 0:
			var placable = placables[0]
			
			var vessel = game_elements.tower_inventory_bench.create_tower_and_add_to_scene(Towers.VARIANCE_VESSEL, placable)
			vessel.set_variance_creator(self)

func get_tower_descriptions_to_use_for_vessel():
	var interpreter_for_bullet_dmg = TextFragmentInterpreter.new()
	interpreter_for_bullet_dmg.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_bullet_dmg.display_body = true
	
	var ins_for_bullet_dmg = []
	ins_for_bullet_dmg.append(NumericalTextFragment.new(yellow_bullet_flat_dmg, false, DamageType.PHYSICAL))
	ins_for_bullet_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
	ins_for_bullet_dmg.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, yellow_bullet_on_hit_dmg_ratio_of_creator)) # stat basis does not matter here
	
	interpreter_for_bullet_dmg.array_of_instructions = ins_for_bullet_dmg
	
	
	var interpreter_for_pierce = TextFragmentInterpreter.new()
	interpreter_for_pierce.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_pierce.display_body = true
	interpreter_for_pierce.header_description = "pierce"
	
	var ins_for_pierce = []
	ins_for_pierce.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
	
	interpreter_for_pierce.array_of_instructions = ins_for_pierce
	
	#
	
	return [
		["On its creator's main attack: fire a bullet toward its creator's target. Bullets deal |0| and has |1|. These stats are based on the creator.", [interpreter_for_bullet_dmg, interpreter_for_pierce]],
		"On this tower's 10th attack, fire additional 3 bullets to the largest line of enemies. These bullets have infinite pierce."
	]

################# DESCRIPTIONS ################


func _get_descriptions_for_clear_var():
	var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Specialize as Clear Type")
	
	return [
		_get_descriptions_header_01(),
		"",
		_get_descriptions_header_02(),
		["|0|: Remove almost all effects from enemies in range three times over 10 seconds.", [plain_fragment__ability_name]],
		"",
		_get_descriptions_for_cooldown(),
	]

func _get_descriptions_for_red_var():
	var interpreter_for_red_explosion = TextFragmentInterpreter.new()
	interpreter_for_red_explosion.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_red_explosion.header_description = "pure damage"
	interpreter_for_red_explosion.display_body = true
	
	var ins_for_red_explosion = []
	ins_for_red_explosion.append(NumericalTextFragment.new(red_blob_explosion_flat_dmg, false, DamageType.PURE))
	ins_for_red_explosion.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
	ins_for_red_explosion.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, red_blob_explosion_base_dmg_scale, DamageType.PURE))
	
	interpreter_for_red_explosion.array_of_instructions = ins_for_red_explosion
	
	var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Specialize as Damage Type")
	var plain_text__knock_back = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.KNOCK_BACK, "knocks its target back")
	var plain_fragment__stuns = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stuns")
	
	
	return [
		_get_descriptions_header_01(),
		"",
		_get_descriptions_header_02(),
		["|0|: The first main attack |1|. The first and second main attack |2| for 2 seconds. Afterwards, fire a massive glob that deals |3| to 5 enemies.", [plain_fragment__ability_name, plain_text__knock_back, plain_fragment__stuns, interpreter_for_red_explosion]],
		"",
		_get_descriptions_for_cooldown(),
	]

func _get_descriptions_for_blue_var():
	var interpreter_for_blue_beam_dmg = TextFragmentInterpreter.new()
	interpreter_for_blue_beam_dmg.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_blue_beam_dmg.display_body = true
	
	var ins_for_blue_beam_dmg = []
	ins_for_blue_beam_dmg.append(NumericalTextFragment.new(blue_beam_dmg_per_instance, false, DamageType.ELEMENTAL))
	ins_for_blue_beam_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
	ins_for_blue_beam_dmg.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
	
	interpreter_for_blue_beam_dmg.array_of_instructions = ins_for_blue_beam_dmg
	
	
	var interpreter_for_blue_explosion_dmg = TextFragmentInterpreter.new()
	interpreter_for_blue_explosion_dmg.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_blue_explosion_dmg.display_body = true
	
	var ins_for_blue_explosion_dmg = []
	ins_for_blue_explosion_dmg.append(NumericalTextFragment.new(blue_explosion_base_dmg, false, DamageType.ELEMENTAL))
	ins_for_blue_explosion_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
	ins_for_blue_explosion_dmg.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
	
	interpreter_for_blue_explosion_dmg.array_of_instructions = ins_for_blue_explosion_dmg
	
	
	var interpreter_for_ap = TextFragmentInterpreter.new()
	interpreter_for_ap.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_ap.display_body = false
	
	var ins_for_ap = []
	ins_for_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", blue_ap_per_cast_during_cast, false))
	
	interpreter_for_ap.array_of_instructions = ins_for_ap
	
	
	var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Specialize as Potency Type")
	
	return [
		_get_descriptions_header_01(),
		"",
		_get_descriptions_header_02(),
		["|0|: Deal |1| per 0.25 seconds to the Strongest target in range until it leaves Variance's range. Afterwards, release an explosion at its target's location, dealing |2|. If this is casted while the beam is active, gain stacking |3|.", [plain_fragment__ability_name, interpreter_for_blue_beam_dmg, interpreter_for_blue_explosion_dmg, interpreter_for_ap]],
		"",
		_get_descriptions_for_cooldown(),
	]

func _get_descriptions_for_yellow_var():
	var interpreter_for_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_attk_speed.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_attk_speed.display_body = false
	interpreter_for_attk_speed.header_description = "attack speed"
	
	var ins_for_attk_speed = []
	ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", yellow_attk_speed_percent_amount, true))
	
	interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
	
	
	var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Specialize as Speed Type")
	var plain_fragment__tower_vessel = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Variance-Vessel")
		
	
	return [
		_get_descriptions_header_01(),
		"",
		_get_descriptions_header_02(),
		["|0|: Gain |1| for %s seconds. Innate: Summon a |2| outside of range every 25 main attacks. Vessels last for only one round." % str(yellow_attk_speed_duration), [plain_fragment__ability_name, interpreter_for_attk_speed, plain_fragment__tower_vessel]],
		"",
		_get_descriptions_for_cooldown(),
	]



func _get_descriptions_header_01():
	var plain_fragment__round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
	
	return ["|0|: Variance morphs, changing type and its ingredient effect. Activates even if not placed in the map. Always starts as Clear type, but cannot revert to it.", [plain_fragment__round_end]]

func _get_descriptions_header_02():
	return "Auto casts Specialize."


func _get_descriptions_for_cooldown():
	var interpreter_for_cooldown = TextFragmentInterpreter.new()
	interpreter_for_cooldown.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_cooldown.display_body = true
	interpreter_for_cooldown.header_description = "s"
	
	var ins_for_cooldown = []
	ins_for_cooldown.append(NumericalTextFragment.new(22, false))
	ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
	ins_for_cooldown.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
	
	interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
	
	return ["Cooldown: |0|", [interpreter_for_cooldown]]
