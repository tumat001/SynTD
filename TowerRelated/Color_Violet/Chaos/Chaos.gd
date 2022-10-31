# NOTE, Ingredient version of chaos has its own
# stats, found in TowerChaosTakeoverEffect.
# So when updating Chaos's stats, update the effect's as well.


extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const ChaosOrb_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_Orb.png")
const ChaosDiamond_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_Diamond.png")

const ChaosBolt01_pic = preload("res://TowerRelated/Color_Violet/Chaos/ChaosBolt_01.png")
const ChaosBolt02_pic = preload("res://TowerRelated/Color_Violet/Chaos/ChaosBolt_02.png")
const ChaosBolt03_pic = preload("res://TowerRelated/Color_Violet/Chaos/ChaosBolt_03.png")

const ChaosSword = preload("res://TowerRelated/Color_Violet/Chaos/ChaosSwordParticle.tscn")

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")


#
const ScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/ScreenTintEffect.gd")

const AbsoluteChaos_AbilityPic = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/Chaos_AbilityIcon.png")

const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")

const Chaos_BigBolt_ExplosionPic_01 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/BigLightning/Chaos_BigLightningExplosion_01.png")
const Chaos_BigBolt_ExplosionPic_02 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/BigLightning/Chaos_BigLightningExplosion_02.png")
const Chaos_BigBolt_ExplosionPic_03 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/BigLightning/Chaos_BigLightningExplosion_03.png")
const Chaos_BigBolt_ExplosionPic_04 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/BigLightning/Chaos_BigLightningExplosion_04.png")
const Chaos_BigBolt_ExplosionPic_05 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/BigLightning/Chaos_BigLightningExplosion_05.png")
const Chaos_BigBolt_ExplosionPic_06 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/BigLightning/Chaos_BigLightningExplosion_06.png")

const Chaos_BigLightning_AttackModuleIcon = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/BigLightning/Chaos_BigLightning_AttackModuleIcon.png")
const Chaos_BigLightningExplosion_AttackModuleIcon = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/BigLightning/Chaos_BigLightningExplosion_AttackModuleIcon.png")

const Chaos_BigBolt_Particle = preload("res://TowerRelated/Color_Violet/Chaos/AbilityRelated/BigBolt/BigBolt_Particle.gd")
const Chaos_BigBolt_Particle_Scene = preload("res://TowerRelated/Color_Violet/Chaos/AbilityRelated/BigBolt/BigBolt_Particle.tscn")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

const Chaos_CustomDiamonds_Script = preload("res://TowerRelated/Color_Violet/Chaos/AbilityRelated/Diamonds/Chaos_CustomDiamonds.gd")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const Chaos_VoidLakesPic_01 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/VoidLakes/Chaos_VoidLakes_01.png")
const Chaos_VoidLakesPic_02 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/VoidLakes/Chaos_VoidLakes_02.png")
const Chaos_VoidLakesPic_03 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/VoidLakes/Chaos_VoidLakes_03.png")
const Chaos_VoidLakesPic_04 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/VoidLakes/Chaos_VoidLakes_04.png")
const Chaos_VoidLakesPic_05 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/VoidLakes/Chaos_VoidLakes_05.png")

const Chaos_RainDrop_Scene = preload("res://TowerRelated/Color_Violet/Chaos/AbilityRelated/ExplosiveRain/ExplosiveRainDrop.tscn")

const Chaos_RainExplosionPic_01 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/ExplosiveRain/Chaos_RainExplosion_01.png")
const Chaos_RainExplosionPic_02 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/ExplosiveRain/Chaos_RainExplosion_02.png")
const Chaos_RainExplosionPic_03 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/ExplosiveRain/Chaos_RainExplosion_03.png")
const Chaos_RainExplosionPic_04 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/ExplosiveRain/Chaos_RainExplosion_04.png")
const Chaos_RainExplosionPic_05 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/ExplosiveRain/Chaos_RainExplosion_05.png")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")

const EnemyKnockUpEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyKnockUpEffect.gd")
const EnemyForcedPathOffsetMovementEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyForcedPathOffsetMovementEffect.gd")

const Chaos_SmallDarkPurpleParticle_Pic = preload("res://TowerRelated/Color_Violet/Chaos/Others/Assets/Absolute_DarkPurpleParticle_Pic.png")
const Chaos_SmallRedPurpleParticle_Pic = preload("res://TowerRelated/Color_Violet/Chaos/Others/Assets/Absolute_RedPurpleParticle_Pic.png")
const Chaos_BigLightPurpleParticle_Pic = preload("res://TowerRelated/Color_Violet/Chaos/Others/Assets/Absolute_BrightPurpleParticle_Pic.png")
const Chaos_ChangingPurpleParticle = preload("res://TowerRelated/Color_Violet/Chaos/Others/Particles/Chaos_ChangingPurpleParticle.gd")
const Chaos_ChangingPurpleParticle_Scene = preload("res://TowerRelated/Color_Violet/Chaos/Others/Particles/Chaos_ChangingPurpleParticle.tscn")


enum CHAOS_EVENTS {
	ORB_MAELSTROM = 1,
	DIAMOND_STORM = 2,
	BIG_BOLT = 3,
	SWORD_FIELD = 4,
	VOID_LAKES = 5,
	NIGHT_WATCHER = 6,
	EXPLOSIVE_RAIN = 7,
}

const playable_chaos_events : Array = [
	CHAOS_EVENTS.ORB_MAELSTROM,
	CHAOS_EVENTS.DIAMOND_STORM,
	CHAOS_EVENTS.BIG_BOLT,
	CHAOS_EVENTS.SWORD_FIELD,
	CHAOS_EVENTS.VOID_LAKES,
	CHAOS_EVENTS.NIGHT_WATCHER,
	CHAOS_EVENTS.EXPLOSIVE_RAIN,
]


const chaos_event_to_func_name_map : Dictionary = {
	CHAOS_EVENTS.ORB_MAELSTROM : "_play_orb_maelstrom_event",
	CHAOS_EVENTS.DIAMOND_STORM : "_play_diamond_storm_event",
	CHAOS_EVENTS.BIG_BOLT : "_play_big_bolt_event",
	CHAOS_EVENTS.SWORD_FIELD : "_play_sword_field_event",
	CHAOS_EVENTS.VOID_LAKES : "_play_void_lakes_event",
	CHAOS_EVENTS.NIGHT_WATCHER : "_play_night_watcher_event",
	CHAOS_EVENTS.EXPLOSIVE_RAIN : "_play_explosive_rain_event",
}

const chaos_event_to_end_cast_func_name_map : Dictionary = {
	CHAOS_EVENTS.ORB_MAELSTROM : "_end_orb_maelstrom_event",
	CHAOS_EVENTS.DIAMOND_STORM : "_end_diamond_storm_event",
	CHAOS_EVENTS.BIG_BOLT : "_end_big_bolt_event",
	CHAOS_EVENTS.SWORD_FIELD : "_end_sword_field_event",
	CHAOS_EVENTS.VOID_LAKES : "_end_void_lakes_event",
	CHAOS_EVENTS.NIGHT_WATCHER : "_end_night_watcher_event",
	CHAOS_EVENTS.EXPLOSIVE_RAIN : "_end_explosive_rain_event",
}

#

const original_damage_accumulated_trigger : float = 80.0
var damage_accumulated_trigger : float = original_damage_accumulated_trigger

var damage_accumulated : float = 0
var sword_attack_module : InstantDamageAttackModule

var trail_component_for_diamonds : MultipleTrailsForNodeComponent

#
var enemy_manager
var screen_effects_manager


var absolute_chaos_ability : BaseAbility
const absolute_chaos_base_cooldown : float = 120.0
const absolute_chaos_base_cast_count : int = 2

var absolute_chaos_rng_for_events_to_play : RandomNumberGenerator
var absolute_chaos_rng_general_purpose : RandomNumberGenerator
var non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)

const base_amount_of_events_to_play : int = 2

const chaos_still_playing_events_clause : int = -10
const chaos_ing_not_active_clause : int = -20

var general_purpose_timer : Timer

var _current_events_to_play : Array
var _current_event_id_playing : int

###
const orb_maelstrom_orb_count : int = 60
const orb_maelstrom_circle_slice : int = 20
var orb_attack_module : BulletAttackModule

const orb_maelstrom_delay_per_orb : float = 0.05

var _current_orb_maelstrom_orbs_fired : int
var _current_orb_maelstrom_poses_to_fire : Array

##
const diamond_storm_diamond_count : int = 18
var diamond_attack_module : BulletAttackModule

const diamond_storm_min_range_from_target_spawn : float = 30.0
const diamond_storm_max_range_from_target_spawn : float = 130.0

const diamond_storm_min_rotation_per_sec : float = 100.0
const diamond_storm_max_rotation_per_sec : float = 700.0

const diamond_storm_delay_per_diamond : float = 0.15
const diamond_storm_diamond_idle_time : float = 1.25

var _current_diamond_storm_diamonds_fired : int

##

const big_bolt_delay_before_strike : float = 3.0

const big_bolt_damage_primary_enemy_health_percent_amount : float = 35.0
const big_bolt_damage_primary_enemy_health_percent_type : int = PercentType.MAX
const big_bolt_damage_primary_enemy_health_max_flat_amount : float = 55.0

const big_bolt_damage_secondary_enemies_health_percent_amount : float = 15.0 
const big_bolt_damage_secondary_enemy_health_percent_type : int = PercentType.MAX
const big_bolt_damage_secondary_enemy_health_max_flat_amount : float = 22.5

const big_bolt_stun_duration_to_primary : float = 5.0
const big_bolt_stun_duration_to_secondary : float = 1.5

const big_bolt_explosion_pierce : int = 5

var big_bolt_instant_dmg_attack_module : InstantDamageAttackModule
var big_bolt_explosion_attack_module : AOEAttackModule

#

const sword_field_starting_sword_count : int = 3
const sword_field_count_replenish_per_sword_kill : int = 1
const sword_field_max_sword_count_for_replenish : int = 1

const sword_field_wait_time_for_kill_register : float = 0.5 # also serves as delay per sword

var _current_sword_field_sword_count : int
var _is_sword_from_ability : bool

#

const void_lakes_void_lake_count : int = 3
const void_lakes_slow_amount : float = -50.0

const void_lakes_delay_for_next_cast : float = 2.0

var void_lakes_aoe_attack_module : AOEAttackModule

#

const night_watcher_summon_count : int = 2

const night_watcher_summon_duration : float = 45.0
const night_watcher_stun_duration : float = 1.5
const night_watcher_explosion_flat_dmg : float = 0.5
const night_watcher_explosion_pierce : int = 3

const night_watcher_delay_for_next_cast : float = 2.0

#

const explosive_rain_flat_base_dmg : float = 2.0
const explosive_rain_pierce : int = 3
const explosive_rain_rain_count : int = 45

const explosive_rain_min_range_from_target_spawn : float = 10.0
const explosive_rain_max_range_from_target_spawn : float = 40.0

const explosive_rain_delay_per_rain : float = 0.125

var _current_explosive_rain_fired : int

var explosive_rain_aoe_attk_module : AOEAttackModule


var explosive_rain_knockup_effect : EnemyKnockUpEffect
var explosive_rain_forced_path_mov_effect : EnemyForcedPathOffsetMovementEffect

const explosive_rain_knockup_accel : float = 35.0
const explosive_rain_knockup_time : float = 0.7
const explosive_rain_stun_duration : float = 0.7

const explosive_rain_mov_speed_for_enemy : float = 50.0
const explosive_rain_mov_speed_deceleration_for_enemy : float = 65.0


#

var changing_purple_particle_attk_sprite_pool : AttackSpritePoolComponent
var light_background_purple_particle_attk_sprite_pool : AttackSpritePoolComponent

const particle_y_per_sec : float = -16.0
const particle_lifetime : float = 4.0
const particle_time_before_mov : float = 0.5
const particle_create_particle_interval : float = 0.3#particle_time_before_mov

const particle_modulate_a : float = 0.7
const particle_z_index : int = ZIndexStore.PARTICLE_EFFECTS_BELOW_TOWERS

var particle_center_particle_sprite_frames : SpriteFrames
var particle_background_particle_sprite_frames : SpriteFrames

var particle_create_timer : Timer

#

onready var pos_for_particle_summon = $TowerBase/PosForParticleSummon

#

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.CHAOS)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	# Orb's range module
	var orb_range_module = RangeModule_Scene.instance()
	orb_range_module.base_range_radius = info.base_range
	#orb_range_module.all_targeting_options = [Targeting.RANDOM, Targeting.FIRST, Targeting.LAST]
	orb_range_module.set_terrain_scan_shape(CircleShape2D.new())
	orb_range_module.position.y += 22
	orb_range_module.add_targeting_option(Targeting.RANDOM)
	orb_range_module.set_current_targeting(Targeting.RANDOM)
	
	# Orb related
	orb_attack_module = BulletAttackModule_Scene.instance()
	orb_attack_module.base_damage = info.base_damage
	orb_attack_module.base_damage_type = info.base_damage_type
	orb_attack_module.base_attack_speed = info.base_attk_speed
	orb_attack_module.base_attack_wind_up = 0
	orb_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	orb_attack_module.is_main_attack = true
	orb_attack_module.base_pierce = info.base_pierce
	orb_attack_module.base_proj_speed = 660 #550
	orb_attack_module.base_proj_life_distance = info.base_range
	orb_attack_module.module_id = StoreOfAttackModuleID.MAIN
	orb_attack_module.position.y -= 22
	orb_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	orb_attack_module.benefits_from_bonus_attack_speed = true
	orb_attack_module.benefits_from_bonus_base_damage = true
	orb_attack_module.benefits_from_bonus_on_hit_damage = true
	orb_attack_module.benefits_from_bonus_on_hit_effect = true
	orb_attack_module.benefits_from_bonus_pierce = true
	orb_attack_module.range_module = orb_range_module
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	orb_attack_module.bullet_shape = bullet_shape
	orb_attack_module.bullet_scene = BaseBullet_Scene
	orb_attack_module.set_texture_as_sprite_frame(ChaosOrb_pic)
	
	orb_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated")
	
	orb_attack_module.set_image_as_tracker_image(ChaosOrb_pic)
	
	add_attack_module(orb_attack_module)
	
	
	# Diamond related
	var dia_range_module = RangeModule_Scene.instance()
	dia_range_module.base_range_radius = info.base_range
	dia_range_module.set_terrain_scan_shape(CircleShape2D.new())
	dia_range_module.position.y += 22
	dia_range_module.can_display_range = false
	dia_range_module.clear_all_targeting()
	dia_range_module.add_targeting_option(Targeting.RANDOM)
	dia_range_module.set_current_targeting(Targeting.RANDOM)
	
	diamond_attack_module = BulletAttackModule_Scene.instance()
	diamond_attack_module.base_damage_scale = 0.1
	diamond_attack_module.base_damage = 2 / diamond_attack_module.base_damage_scale
	diamond_attack_module.base_damage_type = DamageType.PHYSICAL
	diamond_attack_module.base_attack_speed = 0.85
	diamond_attack_module.base_attack_wind_up = 2
	diamond_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	diamond_attack_module.is_main_attack = false
	diamond_attack_module.base_pierce = 3
	diamond_attack_module.base_proj_speed = 400
	diamond_attack_module.base_proj_life_distance = info.base_range
	diamond_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	diamond_attack_module.position.y -= 22
	diamond_attack_module.on_hit_damage_scale = 2
	diamond_attack_module.on_hit_effect_scale = 1
	
	diamond_attack_module.benefits_from_bonus_attack_speed = true
	diamond_attack_module.benefits_from_bonus_base_damage = true
	diamond_attack_module.benefits_from_bonus_on_hit_damage = true
	diamond_attack_module.benefits_from_bonus_on_hit_effect = true
	diamond_attack_module.benefits_from_bonus_pierce = true
	
	
	diamond_attack_module.use_self_range_module = true
	diamond_attack_module.range_module = dia_range_module
	
	var diamond_shape = RectangleShape2D.new()
	diamond_shape.extents = Vector2(11, 7)
	
	diamond_attack_module.bullet_shape = diamond_shape
	diamond_attack_module.bullet_scene = BaseBullet_Scene
	diamond_attack_module.bullet_script = Chaos_CustomDiamonds_Script
	diamond_attack_module.set_texture_as_sprite_frame(ChaosDiamond_pic)
	
	diamond_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated", [], CONNECT_PERSIST)
	diamond_attack_module.connect("after_bullet_is_shot", self, "_after_diamond_is_shot", [], CONNECT_PERSIST)
	
	diamond_attack_module.set_image_as_tracker_image(ChaosDiamond_pic)
	
	add_attack_module(diamond_attack_module)
	
	
	# Bolt related
	var bolt_range_module = RangeModule_Scene.instance()
	bolt_range_module.base_range_radius = info.base_range
	bolt_range_module.set_terrain_scan_shape(CircleShape2D.new())
	bolt_range_module.position.y += 22
	bolt_range_module.can_display_range = false
	bolt_range_module.clear_all_targeting()
	bolt_range_module.add_targeting_option(Targeting.RANDOM)
	bolt_range_module.set_current_targeting(Targeting.RANDOM)
	
	var bolt_attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	bolt_attack_module.base_damage_scale = 0.75
	bolt_attack_module.base_damage = 1 / bolt_attack_module.base_damage_scale
	bolt_attack_module.base_damage_type = DamageType.ELEMENTAL
	bolt_attack_module.base_attack_speed = 1.3
	bolt_attack_module.base_attack_wind_up = 0
	bolt_attack_module.is_main_attack = false
	bolt_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	bolt_attack_module.position.y -= 22
	bolt_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	
	bolt_attack_module.benefits_from_bonus_attack_speed = true
	bolt_attack_module.benefits_from_bonus_base_damage = true
	bolt_attack_module.benefits_from_bonus_on_hit_damage = false
	bolt_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	bolt_attack_module.use_self_range_module = true
	bolt_attack_module.range_module = bolt_range_module
	
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", ChaosBolt01_pic)
	beam_sprite_frame.add_frame("default", ChaosBolt02_pic)
	beam_sprite_frame.add_frame("default", ChaosBolt03_pic)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	bolt_attack_module.beam_scene = BeamAesthetic_Scene
	bolt_attack_module.beam_sprite_frames = beam_sprite_frame
	bolt_attack_module.beam_is_timebound = true
	bolt_attack_module.beam_time_visible = 0.15
	
	bolt_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated")
	
	bolt_attack_module.set_image_as_tracker_image(preload("res://TowerRelated/Color_Violet/Chaos/AMAssets/ChaosBolt_AttackModule_Icon.png"))
	
	add_attack_module(bolt_attack_module)
	
	
	# Sword related
	
	sword_attack_module = InstantDamageAttackModule_Scene.instance()
	sword_attack_module.base_damage_scale = 10
	sword_attack_module.base_damage = 20 / sword_attack_module.base_damage_scale
	sword_attack_module.base_damage_type = DamageType.PHYSICAL
	sword_attack_module.base_attack_speed = 0
	sword_attack_module.base_attack_wind_up = 0
	sword_attack_module.is_main_attack = false
	sword_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	sword_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	sword_attack_module.on_hit_damage_scale = 1
	sword_attack_module.range_module = orb_range_module
	sword_attack_module.benefits_from_bonus_attack_speed = false
	sword_attack_module.benefits_from_bonus_base_damage = true
	sword_attack_module.benefits_from_bonus_on_hit_damage = false
	sword_attack_module.benefits_from_bonus_on_hit_effect = false
	
	sword_attack_module.connect("on_enemy_hit", self, "_on_sword_attk_module_enemy_hit", [], CONNECT_PERSIST)
	
	add_attack_module(sword_attack_module)
	sword_attack_module.can_be_commanded_by_tower = false
	
	sword_attack_module.set_image_as_tracker_image(preload("res://TowerRelated/Color_Violet/Chaos/AMAssets/ChaosSword_AttackModule_Icon.png"))
	
	#
	
	trail_component_for_diamonds = MultipleTrailsForNodeComponent.new()
	trail_component_for_diamonds.node_to_host_trails = self
	trail_component_for_diamonds.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	trail_component_for_diamonds.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_diamond", [], CONNECT_PERSIST)
	
	
	#
	
	connect("on_round_end", self, "_on_round_end_ability_cleanup", [], CONNECT_PERSIST)
	
	enemy_manager = game_elements.enemy_manager
	screen_effects_manager = game_elements.screen_effect_manager
	
	_post_inherit_ready()


# Sword related

func _on_round_end():
	._on_round_end()
	
	damage_accumulated = 0


func _add_damage_accumulated(damage_report, killed_enemy : bool, enemy, damage_register_id : int, module):
	damage_accumulated += damage_report.get_total_effective_damage()
	call_deferred("_check_damage_accumulated")

func _check_damage_accumulated():
	if damage_accumulated >= damage_accumulated_trigger:
		var success = sword_attack_module.attempt_find_then_attack_enemies(1)
		if success:
			damage_accumulated = 0

# Showing sword related

func _construct_attack_sprite_on_attack():
	var sword = ChaosSword.instance()
	
	if _is_sword_from_ability:
		_is_sword_from_ability = false
		sword.animation = "fromability"
	else:
		sword.animation = "default"
	
	return sword


func _on_sword_attk_module_enemy_hit(enemy, damage_register_id, damage_instance, module):
	if is_instance_valid(enemy):
		var sword = _construct_attack_sprite_on_attack()
		sword.global_position = enemy.global_position
		
		CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(sword)
		sword.playing = true



#

func _after_diamond_is_shot(arg_diamond):
	trail_component_for_diamonds.create_trail_for_node(arg_diamond)

func _trail_before_attached_to_diamond(arg_trail, node):
	arg_trail.max_trail_length = 10
	arg_trail.trail_color = Color(109.0 / 255.0, 2 / 255.0, 217 / 255.0, 0.15)
	arg_trail.width = 4



# energy module related


func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Total damage dealt accumulation threshold for summoning dark sword is halved."
		]


func _module_turned_on(_first_time_per_round : bool):
	damage_accumulated_trigger = original_damage_accumulated_trigger / 2.0

func _module_turned_off():
	damage_accumulated_trigger = original_damage_accumulated_trigger


#################### ABSOLUTE CHAOS RELATED ###################

func _received_chaos_ing():
	if absolute_chaos_ability == null:
		_construct_absolute_chaos_ability()
	
	if absolute_chaos_rng_for_events_to_play == null:
		_initialize_rng()
	
	if !is_instance_valid(general_purpose_timer):
		_initialize_general_purpose_timer()
	
	if !is_instance_valid(big_bolt_instant_dmg_attack_module):
		_construct_absolute_chaos_attack_modules()
	
	if !is_instance_valid(particle_create_timer):
		_initialize_particle_timer()
	
	if particle_background_particle_sprite_frames == null:
		_initialize_particle_sprite_frames()
		_initialize_particle_attk_sprite_pool()
	
	_start_particle_timer()
	
	#
	
	absolute_chaos_ability.activation_conditional_clauses.remove_clause(chaos_ing_not_active_clause)
	absolute_chaos_ability.should_be_displaying_clauses.remove_clause(chaos_ing_not_active_clause)
	absolute_chaos_ability.counter_decrease_clauses.remove_clause(chaos_ing_not_active_clause)

func _removed_chaos_ing():
	_end_particle_timer()
	
	if absolute_chaos_ability != null:
		absolute_chaos_ability.activation_conditional_clauses.attempt_insert_clause(chaos_ing_not_active_clause)
		absolute_chaos_ability.should_be_displaying_clauses.attempt_insert_clause(chaos_ing_not_active_clause)
		absolute_chaos_ability.counter_decrease_clauses.attempt_insert_clause(chaos_ing_not_active_clause)



###

func _initialize_rng():
	absolute_chaos_rng_for_events_to_play = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.CHAOS_EVENTS_TO_PLAY)
	absolute_chaos_rng_general_purpose = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.CHAOS_EVENTS_GENERAL_PURPOSE)

func _initialize_general_purpose_timer():
	general_purpose_timer = Timer.new()
	general_purpose_timer.one_shot = true
	
	
	add_child(general_purpose_timer)

func _initialize_particle_timer():
	particle_create_timer = Timer.new()
	particle_create_timer.one_shot = false
	
	particle_create_timer.connect("timeout", self, "_on_particle_create_timer_timeout", [], CONNECT_PERSIST)
	
	add_child(particle_create_timer)

func _initialize_particle_sprite_frames():
	particle_center_particle_sprite_frames = SpriteFrames.new()
	particle_center_particle_sprite_frames.set_animation_loop("default", false)
	particle_center_particle_sprite_frames.set_animation_speed("default", 0)
	particle_center_particle_sprite_frames.add_frame("default", Chaos_SmallDarkPurpleParticle_Pic)
	particle_center_particle_sprite_frames.add_frame("default", Chaos_SmallRedPurpleParticle_Pic)
	
	#
	
	particle_background_particle_sprite_frames = SpriteFrames.new()
	particle_background_particle_sprite_frames.set_animation_loop("default", false)
	particle_background_particle_sprite_frames.set_animation_speed("default", 0)
	# two of the same frames is intented
	particle_background_particle_sprite_frames.add_frame("default", Chaos_BigLightPurpleParticle_Pic)
	particle_background_particle_sprite_frames.add_frame("default", Chaos_BigLightPurpleParticle_Pic)

func _initialize_particle_attk_sprite_pool():
	changing_purple_particle_attk_sprite_pool = AttackSpritePoolComponent.new()
	changing_purple_particle_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	changing_purple_particle_attk_sprite_pool.node_to_listen_for_queue_free = self
	changing_purple_particle_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	changing_purple_particle_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_center_purple_particle"
	changing_purple_particle_attk_sprite_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_center_particle_properties_when_get_from_pool_after_add_child"
	
	light_background_purple_particle_attk_sprite_pool = AttackSpritePoolComponent.new()
	light_background_purple_particle_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	light_background_purple_particle_attk_sprite_pool.node_to_listen_for_queue_free = self
	light_background_purple_particle_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	light_background_purple_particle_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_background_purple_particle"
	light_background_purple_particle_attk_sprite_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_background_particle_properties_when_get_from_pool_after_add_child"
	



func _start_particle_timer():
	particle_create_timer.start(particle_create_particle_interval)

func _end_particle_timer():
	particle_create_timer.stop()



func _construct_absolute_chaos_attack_modules():
	
	big_bolt_instant_dmg_attack_module = InstantDamageAttackModule_Scene.instance()
	big_bolt_instant_dmg_attack_module.base_damage = 0
	big_bolt_instant_dmg_attack_module.base_damage_type = DamageType.ELEMENTAL
	big_bolt_instant_dmg_attack_module.base_attack_speed = 10
	big_bolt_instant_dmg_attack_module.base_attack_wind_up = 0
	big_bolt_instant_dmg_attack_module.is_main_attack = false
	big_bolt_instant_dmg_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	big_bolt_instant_dmg_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	big_bolt_instant_dmg_attack_module.on_hit_damage_scale = 1
	
	big_bolt_instant_dmg_attack_module.benefits_from_bonus_base_damage = false
	big_bolt_instant_dmg_attack_module.benefits_from_bonus_attack_speed = false
	big_bolt_instant_dmg_attack_module.benefits_from_bonus_on_hit_damage = false
	big_bolt_instant_dmg_attack_module.benefits_from_bonus_on_hit_effect = false
	
	big_bolt_instant_dmg_attack_module.set_image_as_tracker_image(Chaos_BigLightning_AttackModuleIcon)
	
	big_bolt_instant_dmg_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(big_bolt_instant_dmg_attack_module)
	
	
	var big_bolt_primary_percent_dmg_modi = PercentModifier.new(StoreOfTowerEffectsUUID.CHAOS_BIG_BOLT_EVENT_PRIMARY_PERCENT_ON_HIT_DMG)
	big_bolt_primary_percent_dmg_modi.percent_amount = big_bolt_damage_primary_enemy_health_percent_amount
	big_bolt_primary_percent_dmg_modi.percent_based_on = big_bolt_damage_primary_enemy_health_percent_type
	big_bolt_primary_percent_dmg_modi.flat_maximum = big_bolt_damage_primary_enemy_health_max_flat_amount
	big_bolt_primary_percent_dmg_modi.flat_minimum = 0
	big_bolt_primary_percent_dmg_modi.ignore_flat_limits = false
	
	var big_bolt_primary_percent_on_hit_dmg = OnHitDamage.new(StoreOfTowerEffectsUUID.CHAOS_BIG_BOLT_EVENT_PRIMARY_PERCENT_ON_HIT_DMG, big_bolt_primary_percent_dmg_modi, DamageType.ELEMENTAL)
	var big_bolt_primary_percent_on_hit_dmg_as_effect = TowerOnHitDamageAdderEffect.new(big_bolt_primary_percent_on_hit_dmg, StoreOfTowerEffectsUUID.CHAOS_BIG_BOLT_EVENT_PRIMARY_PERCENT_ON_HIT_DMG)
	
	_force_add_on_hit_damage_adder_effect_to_module(big_bolt_primary_percent_on_hit_dmg_as_effect, big_bolt_instant_dmg_attack_module)
	
	var big_bolt_primary_stun_effect : EnemyStunEffect = EnemyStunEffect.new(big_bolt_stun_duration_to_primary, StoreOfEnemyEffectsUUID.CHAOS_BIG_BOLT_EVENT_PRIMARY_STUN_EFFECT)
	var big_bolt_primary_stun_tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(big_bolt_primary_stun_effect, StoreOfTowerEffectsUUID.CHAOS_BIG_BOLT_EVENT_PRIMARY_STUN_EFFECT)
	
	_force_add_on_hit_effect_adder_effect_to_module(big_bolt_primary_stun_tower_effect, big_bolt_instant_dmg_attack_module)
	
	
	###
	
	big_bolt_explosion_attack_module = AOEAttackModule_Scene.instance()
	big_bolt_explosion_attack_module.base_damage = 0
	big_bolt_explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	big_bolt_explosion_attack_module.base_attack_speed = 0
	big_bolt_explosion_attack_module.base_attack_wind_up = 0
	big_bolt_explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	big_bolt_explosion_attack_module.is_main_attack = false
	big_bolt_explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	big_bolt_explosion_attack_module.benefits_from_bonus_explosion_scale = true
	big_bolt_explosion_attack_module.benefits_from_bonus_base_damage = false
	big_bolt_explosion_attack_module.benefits_from_bonus_attack_speed = false
	big_bolt_explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	big_bolt_explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Chaos_BigBolt_ExplosionPic_01)
	sprite_frames.add_frame("default", Chaos_BigBolt_ExplosionPic_02)
	sprite_frames.add_frame("default", Chaos_BigBolt_ExplosionPic_03)
	sprite_frames.add_frame("default", Chaos_BigBolt_ExplosionPic_04)
	sprite_frames.add_frame("default", Chaos_BigBolt_ExplosionPic_05)
	sprite_frames.add_frame("default", Chaos_BigBolt_ExplosionPic_06)
	
	big_bolt_explosion_attack_module.aoe_sprite_frames = sprite_frames
	big_bolt_explosion_attack_module.sprite_frames_only_play_once = true
	big_bolt_explosion_attack_module.pierce = big_bolt_explosion_pierce
	big_bolt_explosion_attack_module.duration = 0.45
	big_bolt_explosion_attack_module.damage_repeat_count = 1
	
	big_bolt_explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	big_bolt_explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	big_bolt_explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	big_bolt_explosion_attack_module.can_be_commanded_by_tower = false
	
	big_bolt_explosion_attack_module.set_image_as_tracker_image(Chaos_BigLightningExplosion_AttackModuleIcon)
	
	add_attack_module(big_bolt_explosion_attack_module)
	
	
	var big_bolt_secondary_percent_dmg_modi = PercentModifier.new(StoreOfTowerEffectsUUID.CHAOS_BIG_BOLT_EVENT_SECONDARY_PERCENT_ON_HIT_DMG)
	big_bolt_secondary_percent_dmg_modi.percent_amount = big_bolt_damage_secondary_enemies_health_percent_amount
	big_bolt_secondary_percent_dmg_modi.percent_based_on = big_bolt_damage_secondary_enemy_health_percent_type
	big_bolt_secondary_percent_dmg_modi.flat_maximum = big_bolt_damage_secondary_enemy_health_max_flat_amount
	big_bolt_secondary_percent_dmg_modi.flat_minimum = 0
	big_bolt_secondary_percent_dmg_modi.ignore_flat_limits = false
	
	var big_bolt_secondary_percent_on_hit_dmg = OnHitDamage.new(StoreOfTowerEffectsUUID.CHAOS_BIG_BOLT_EVENT_SECONDARY_PERCENT_ON_HIT_DMG, big_bolt_secondary_percent_dmg_modi, DamageType.ELEMENTAL)
	var big_bolt_secondary_percent_on_hit_dmg_as_effect = TowerOnHitDamageAdderEffect.new(big_bolt_secondary_percent_on_hit_dmg, StoreOfTowerEffectsUUID.CHAOS_BIG_BOLT_EVENT_SECONDARY_PERCENT_ON_HIT_DMG)
	
	_force_add_on_hit_damage_adder_effect_to_module(big_bolt_secondary_percent_on_hit_dmg_as_effect, big_bolt_explosion_attack_module)
	
	var big_bolt_secondary_stun_effect : EnemyStunEffect = EnemyStunEffect.new(big_bolt_stun_duration_to_secondary, StoreOfEnemyEffectsUUID.CHAOS_BIG_BOLT_EVENT_SECONDARY_STUN_EFFECT)
	var big_bolt_secondary_stun_tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(big_bolt_secondary_stun_effect, StoreOfTowerEffectsUUID.CHAOS_BIG_BOLT_EVENT_SECONDARY_STUN_EFFECT)
	
	_force_add_on_hit_effect_adder_effect_to_module(big_bolt_secondary_stun_tower_effect, big_bolt_explosion_attack_module)
	
	######
	
	
	
	void_lakes_aoe_attack_module = AOEAttackModule_Scene.instance()
	void_lakes_aoe_attack_module.base_damage = 0
	void_lakes_aoe_attack_module.base_damage_type = DamageType.ELEMENTAL
	void_lakes_aoe_attack_module.base_attack_speed = 0
	void_lakes_aoe_attack_module.base_attack_wind_up = 0
	void_lakes_aoe_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	void_lakes_aoe_attack_module.is_main_attack = false
	void_lakes_aoe_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	void_lakes_aoe_attack_module.base_explosion_scale = 1.5
	
	void_lakes_aoe_attack_module.benefits_from_bonus_explosion_scale = true
	void_lakes_aoe_attack_module.benefits_from_bonus_base_damage = false
	void_lakes_aoe_attack_module.benefits_from_bonus_attack_speed = false
	void_lakes_aoe_attack_module.benefits_from_bonus_on_hit_damage = false
	void_lakes_aoe_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var void_lakes_sprite_frames = SpriteFrames.new()
	void_lakes_sprite_frames.add_frame("default", Chaos_VoidLakesPic_01)
	void_lakes_sprite_frames.add_frame("default", Chaos_VoidLakesPic_02)
	void_lakes_sprite_frames.add_frame("default", Chaos_VoidLakesPic_03)
	void_lakes_sprite_frames.add_frame("default", Chaos_VoidLakesPic_04)
	void_lakes_sprite_frames.add_frame("default", Chaos_VoidLakesPic_05)
	void_lakes_sprite_frames.set_animation_speed("default", 8)
	
	void_lakes_aoe_attack_module.aoe_sprite_frames = void_lakes_sprite_frames
	void_lakes_aoe_attack_module.sprite_frames_only_play_once = false
	void_lakes_aoe_attack_module.pierce = big_bolt_explosion_pierce
	void_lakes_aoe_attack_module.duration = 5.0
	void_lakes_aoe_attack_module.damage_repeat_count = 10
	
	void_lakes_aoe_attack_module.absolute_z_index_of_aoe = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	void_lakes_aoe_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	void_lakes_aoe_attack_module.base_aoe_scene = BaseAOE_Scene
	void_lakes_aoe_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	void_lakes_aoe_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(void_lakes_aoe_attack_module)
	
	
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.CHAOS_VOID_LAKES_SLOW_EFFECT)
	slow_modifier.percent_amount = void_lakes_slow_amount
	slow_modifier.percent_based_on = PercentType.BASE
	
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.CHAOS_VOID_LAKES_SLOW_EFFECT)
	enemy_attr_eff.is_timebound = true
	enemy_attr_eff.time_in_seconds = 1
	
	var void_lakes_slow_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_attr_eff, StoreOfTowerEffectsUUID.CHAOS_VOID_LAKES_SLOW_EFFECT)
	
	_force_add_on_hit_effect_adder_effect_to_module(void_lakes_slow_effect, void_lakes_aoe_attack_module)
	
	
	##
	
	explosive_rain_aoe_attk_module = AOEAttackModule_Scene.instance()
	explosive_rain_aoe_attk_module.base_damage = explosive_rain_flat_base_dmg
	explosive_rain_aoe_attk_module.base_damage_type = DamageType.ELEMENTAL
	explosive_rain_aoe_attk_module.base_attack_speed = 0
	explosive_rain_aoe_attk_module.base_attack_wind_up = 0
	explosive_rain_aoe_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosive_rain_aoe_attk_module.is_main_attack = false
	explosive_rain_aoe_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosive_rain_aoe_attk_module.base_explosion_scale = 1.5
	
	explosive_rain_aoe_attk_module.benefits_from_bonus_explosion_scale = true
	explosive_rain_aoe_attk_module.benefits_from_bonus_base_damage = false
	explosive_rain_aoe_attk_module.benefits_from_bonus_attack_speed = false
	explosive_rain_aoe_attk_module.benefits_from_bonus_on_hit_damage = false
	explosive_rain_aoe_attk_module.benefits_from_bonus_on_hit_effect = false
	
	
	var explosive_rain_sprite_frames = SpriteFrames.new()
	explosive_rain_sprite_frames.add_frame("default", Chaos_RainExplosionPic_01)
	explosive_rain_sprite_frames.add_frame("default", Chaos_RainExplosionPic_02)
	explosive_rain_sprite_frames.add_frame("default", Chaos_RainExplosionPic_03)
	explosive_rain_sprite_frames.add_frame("default", Chaos_RainExplosionPic_04)
	explosive_rain_sprite_frames.add_frame("default", Chaos_RainExplosionPic_05)
	
	explosive_rain_aoe_attk_module.aoe_sprite_frames = explosive_rain_sprite_frames
	explosive_rain_aoe_attk_module.sprite_frames_only_play_once = true
	explosive_rain_aoe_attk_module.pierce = explosive_rain_pierce
	explosive_rain_aoe_attk_module.duration = 0.35
	explosive_rain_aoe_attk_module.damage_repeat_count = 1
	
	explosive_rain_aoe_attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosive_rain_aoe_attk_module.base_aoe_scene = BaseAOE_Scene
	explosive_rain_aoe_attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	explosive_rain_aoe_attk_module.can_be_commanded_by_tower = false
	
	explosive_rain_aoe_attk_module.set_image_as_tracker_image(Chaos_RainExplosionPic_03)
	
	add_attack_module(explosive_rain_aoe_attk_module)
	
	
	explosive_rain_knockup_effect = EnemyKnockUpEffect.new(explosive_rain_knockup_time, explosive_rain_knockup_accel, StoreOfEnemyEffectsUUID.CHAOS_EXPLOSIVE_RAIN_KNOCK_UP_EFFECT)
	explosive_rain_knockup_effect.custom_stun_duration = explosive_rain_stun_duration
	
	explosive_rain_forced_path_mov_effect = EnemyForcedPathOffsetMovementEffect.new(explosive_rain_mov_speed_for_enemy, explosive_rain_mov_speed_deceleration_for_enemy, StoreOfEnemyEffectsUUID.CHAOS_EXPLOSIVE_RAIN_FORCED_OFFSET_EFFECT)
	explosive_rain_forced_path_mov_effect.is_timebound = true
	explosive_rain_forced_path_mov_effect.time_in_seconds = explosive_rain_stun_duration

	
	##
	



####

func _construct_absolute_chaos_ability():
	absolute_chaos_ability = BaseAbility.new()
	
	absolute_chaos_ability.is_timebound = true
	absolute_chaos_ability.connect("ability_activated", self, "_absolute_chaos_ability_activated", [], CONNECT_PERSIST)
	absolute_chaos_ability.icon = AbsoluteChaos_AbilityPic
	
	absolute_chaos_ability.set_properties_to_usual_tower_based()
	absolute_chaos_ability.tower = self
	
	absolute_chaos_ability.set_properties_to_auto_castable()
	absolute_chaos_ability.auto_cast_func = "_absolute_chaos_ability_activated"
	
	#
	
	var interpreter_for_cast_count = TextFragmentInterpreter.new()
	interpreter_for_cast_count.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_cast_count.display_body = true
	interpreter_for_cast_count.header_description = ""
	interpreter_for_cast_count.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.FLOOR
	
	var ins_for_cast_count = []
	ins_for_cast_count.append(NumericalTextFragment.new(absolute_chaos_base_cast_count, false, -1))
	ins_for_cast_count.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
	ins_for_cast_count.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, -1))
	
	interpreter_for_cast_count.array_of_instructions = ins_for_cast_count
	
	
	var interpreter_for_cooldown = TextFragmentInterpreter.new()
	interpreter_for_cooldown.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_cooldown.display_body = true
	interpreter_for_cooldown.header_description = "s"
	
	var ins_for_cooldown = []
	ins_for_cooldown.append(NumericalTextFragment.new(absolute_chaos_base_cooldown, false))
	ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
	ins_for_cooldown.append(TowerStatTextFragment.new(self, null, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
	
	interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
	
	
	#
	
	absolute_chaos_ability.descriptions = [
		["Bring about |0| out of the 7 chaotic events.", [interpreter_for_cast_count]],
		"1) Orb Maelstrom.",
		"2) Diamond Swarm.",
		"3) Big Bolt.",
		"4) Swords Field.",
		"5) Void Lakes.",
		"6) Night Watchers.",
		"7) Explosive Rain.", # rain (like pestilence) that minor knocks away enemies (similar to Brewd's yellow explosion potion).
		"",
		["Cooldown: |0|", [interpreter_for_cooldown]]
	]
	absolute_chaos_ability.simple_descriptions = [
		["Bring about |0| out of the 7 chaotic events.", [interpreter_for_cast_count]],
		"1) Orb Maelstrom.",
		"2) Diamond Swarm.",
		"3) Big Bolt.",
		"4) Swords Field.",
		"5) Void Lakes.",
		"6) Night Watchers.",
		"7) Explosive Rain.",
		"",
		["Cooldown: |0|", [interpreter_for_cooldown]]
	]
	
	absolute_chaos_ability.display_name = "Absolute Chaos"
	
	register_ability_to_manager(absolute_chaos_ability)


####

func _absolute_chaos_ability_activated():
	var cd = _get_cd_to_use(absolute_chaos_base_cooldown)
	absolute_chaos_ability.on_ability_before_cast_start(cd)
	absolute_chaos_ability.start_time_cooldown(cd)
	absolute_chaos_ability.activation_conditional_clauses.attempt_insert_clause(chaos_still_playing_events_clause)
	
	_current_events_to_play = _get_events_to_play()
	_play_event_in_front_index_and_configure_current(true)
	
	absolute_chaos_ability.on_ability_after_cast_ended(cd)

func _on_absolute_chaos_all_events_ended():
	_current_events_to_play.clear()
	
	absolute_chaos_ability.activation_conditional_clauses.remove_clause(chaos_still_playing_events_clause)


#

func _get_events_to_play() -> Array:
	var chosen_events = []
	
	for i in _get_amount_of_events_to_play():
		_set_next_event_to_play_based_on_chosen_events(chosen_events)
	
	
	# Putting the big bolt as the last event
	if chosen_events.has(CHAOS_EVENTS.BIG_BOLT):
		chosen_events.erase(CHAOS_EVENTS.BIG_BOLT)
		chosen_events.append(CHAOS_EVENTS.BIG_BOLT)
	
	
	return chosen_events



func _get_amount_of_events_to_play() -> float:
	var amount = floor(absolute_chaos_ability.get_potency_to_use(get_bonus_ability_potency()))
	amount += base_amount_of_events_to_play
	
	if amount > playable_chaos_events.size():
		amount = playable_chaos_events.size()
	
	return amount

func _set_next_event_to_play_based_on_chosen_events(arg_chosen : Array):
	var untaken_events = _get_untaken_events(arg_chosen)
	
	var rng_i = absolute_chaos_rng_for_events_to_play.randi_range(0, untaken_events.size() - 1)
	arg_chosen.append(untaken_events[rng_i])


func _get_untaken_events(arg_chosen : Array) -> Array:
	var bucket = playable_chaos_events.duplicate()
	for id in arg_chosen:
		bucket.erase(id)
	
	return bucket

##

func _play_event_in_front_index_and_configure_current(arg_play_next : bool):
	if _current_events_to_play.size() > 0 and arg_play_next:
		var event_id : int = _current_events_to_play[0]
		_current_events_to_play.erase(event_id)
		
		call(chaos_event_to_func_name_map[event_id])
		
	else:
		_on_absolute_chaos_all_events_ended()

##



func _play_orb_maelstrom_event():
	_current_event_id_playing = CHAOS_EVENTS.ORB_MAELSTROM
	_current_orb_maelstrom_poses_to_fire = _get_poses_to_fire_orbs_for_event()
	
	
	general_purpose_timer.connect("timeout", self, "_general_purpose_timer_timeout__for_orb_delay")
	
	_fire_one_orb_and_increase_fired_count()
	
	general_purpose_timer.start(orb_maelstrom_delay_per_orb)
	


func _get_poses_to_fire_orbs_for_event() -> Array:
	var poses_to_fire : Array = []
	for i in orb_maelstrom_orb_count:
		poses_to_fire.append(_get_pos_to_fire_orb(i))
	
	return poses_to_fire

func _get_pos_to_fire_orb(arg_index) -> Vector2:
	# the 5 in vector2 can be just any constant
	return orb_attack_module.global_position + Vector2(5, 0).rotated(2 * PI * float(arg_index) / orb_maelstrom_circle_slice)


func _fire_one_orb_and_increase_fired_count():
	var pos_to_fire = _current_orb_maelstrom_poses_to_fire[_current_orb_maelstrom_orbs_fired]
	
	orb_attack_module._attack_at_position(pos_to_fire)
	
	_current_orb_maelstrom_orbs_fired += 1


func _general_purpose_timer_timeout__for_orb_delay():
	if _current_orb_maelstrom_orbs_fired < orb_maelstrom_orb_count:
		_fire_one_orb_and_increase_fired_count()
		general_purpose_timer.start(orb_maelstrom_delay_per_orb)
	else:
		_end_orb_maelstrom_event(true)
		

func _end_orb_maelstrom_event(arg_play_next_event : bool):
	general_purpose_timer.disconnect("timeout", self, "_general_purpose_timer_timeout__for_orb_delay")
	_current_orb_maelstrom_orbs_fired = 0
	_current_orb_maelstrom_poses_to_fire.clear()
	
	_current_event_id_playing = -1
	
	_play_event_in_front_index_and_configure_current(arg_play_next_event)


#

func _play_diamond_storm_event():
	_current_event_id_playing = CHAOS_EVENTS.DIAMOND_STORM
	
	general_purpose_timer.connect("timeout", self, "_general_purpose_timer_timeout__for_dia_delay")
	
	_fire_one_diamond_and_increase_fired_count()
	
	general_purpose_timer.start(diamond_storm_delay_per_diamond)

func _fire_one_diamond_and_increase_fired_count():
	var enemy = _get_enemy_to_target_using_range_module__default_to_other_enemies(diamond_attack_module.range_module)
	var pos_to_target = global_position
	if is_instance_valid(enemy):
		pos_to_target = enemy.global_position
	
	var diamond = diamond_attack_module.construct_bullet(pos_to_target)
	
	diamond.is_from_diamond_storm = true
	
	diamond.initial_enemy_to_target = enemy
	diamond.diamond_attack_module = diamond_attack_module
	diamond.enemy_manager = enemy_manager
	diamond.chaos_tower = self
	
	diamond.current_delay_before_move = diamond_storm_diamond_idle_time
	
	_set_diamond_rotation_and_position(diamond, pos_to_target)
	
	diamond_attack_module.set_up_bullet__add_child_and_emit_signals(diamond)
	
	_current_diamond_storm_diamonds_fired += 1

func _get_enemy_to_target_using_range_module__default_to_other_enemies(arg_range_module, arg_targeting : int = -1, arg_amount : int = 1):
	if arg_targeting == -1:
		arg_targeting = arg_range_module.get_current_targeting_option()
	
	var arr = arg_range_module.get_targets_without_affecting_self_current_targets(arg_amount, arg_targeting)
	if arr.size() == 1 and arg_amount == 1:
		return arr[0]
	elif arr.size() > 0:
		return arr
	
	#var arr_2 = enemy_manager.get_random_targetable_enemies(1)
	var all_targetable_enemies = enemy_manager.get_all_targetable_enemies()
	var arr_2 = Targeting.enemies_to_target(all_targetable_enemies, arg_targeting, arg_amount, global_position)
	if arr_2.size() == 1 and arg_amount == 1:
		return arr_2[0]
	elif arr_2.size() > 0:
		return arr_2
	
	return null

func _set_diamond_rotation_and_position(arg_diamond, arg_enemy_pos):
	var rot_per_sec = non_essential_rng.randi_range(diamond_storm_min_rotation_per_sec, diamond_storm_max_rotation_per_sec)
	arg_diamond.rotation_per_second = rot_per_sec
	
	var magnitude : int = absolute_chaos_rng_general_purpose.randi_range(diamond_storm_min_range_from_target_spawn, diamond_storm_max_range_from_target_spawn)
	var rot : int = absolute_chaos_rng_general_purpose.randi_range(0, 359)
	var vector_of_rand = Vector2(magnitude, 0).rotated(deg2rad(rot))
	
	arg_diamond.position = vector_of_rand + arg_enemy_pos



func _general_purpose_timer_timeout__for_dia_delay():
	if _current_diamond_storm_diamonds_fired < diamond_storm_diamond_count:
		_fire_one_diamond_and_increase_fired_count()
		general_purpose_timer.start(diamond_storm_delay_per_diamond)
	else:
		_end_diamond_storm_event(true)
		

func _end_diamond_storm_event(arg_play_next : bool):
	general_purpose_timer.disconnect("timeout", self, "_general_purpose_timer_timeout__for_dia_delay")
	_current_diamond_storm_diamonds_fired = 0
	
	_current_event_id_playing = -1
	
	
	_play_event_in_front_index_and_configure_current(arg_play_next)
	

#

func _play_big_bolt_event():
	_current_event_id_playing = CHAOS_EVENTS.BIG_BOLT
	
	general_purpose_timer.connect("timeout", self, "_general_purpose_timer_timeout__for_big_bolt_delay")
	
	_play_big_bolt_screen_effect()
	
	general_purpose_timer.start(big_bolt_delay_before_strike)

func _play_big_bolt_screen_effect():
	var big_bolt_screen_effect = ScreenTintEffect.new()
	big_bolt_screen_effect.main_duration = big_bolt_delay_before_strike
	big_bolt_screen_effect.fade_in_duration = 1
	big_bolt_screen_effect.fade_out_duration = 1
	big_bolt_screen_effect.tint_color = Color(109.0 / 255.0, 2 / 255.0, 217 / 255.0, 0.15)
	big_bolt_screen_effect.ins_uuid = StoreOfScreenEffectsUUID.CHAOS_BIG_BOLT_EVENT
	big_bolt_screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS
	
	screen_effects_manager.add_screen_tint_effect(big_bolt_screen_effect)


func _general_purpose_timer_timeout__for_big_bolt_delay():
	_summon_big_bolt_at_enemy()
	
	_end_big_bolt_event(true)

func _summon_big_bolt_at_enemy():
	var target_enemy = _get_enemy_to_target_using_range_module__default_to_other_enemies(range_module, Targeting.HEALTHIEST)
	
	if is_instance_valid(target_enemy):
		var bolt_particle = Chaos_BigBolt_Particle_Scene.instance()
		bolt_particle.scale.y *= 2
		bolt_particle.position = target_enemy.global_position
		bolt_particle.connect("on_struck_ground", self, "_on_big_bolt_struck_ground", [target_enemy, target_enemy.global_position], CONNECT_ONESHOT)
		
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(bolt_particle)

func _on_big_bolt_struck_ground(arg_primary_target, arg_bolt_pos):
	if is_instance_valid(arg_primary_target):
		_big_bolt_hit_primary_target(arg_primary_target)
	
	_create_big_bolt_explosion_at_location(arg_bolt_pos)


func _big_bolt_hit_primary_target(arg_primary_target):
	big_bolt_instant_dmg_attack_module.on_command_attack_enemies([arg_primary_target], 1)


func _create_big_bolt_explosion_at_location(arg_pos : Vector2):
	var aoe = big_bolt_explosion_attack_module.construct_aoe(arg_pos, arg_pos)
	
	big_bolt_explosion_attack_module.set_up_aoe__add_child_and_emit_signals(aoe)


func _end_big_bolt_event(arg_play_next : bool):
	general_purpose_timer.disconnect("timeout", self, "_general_purpose_timer_timeout__for_big_bolt_delay")
	
	_current_event_id_playing = -1
	_play_event_in_front_index_and_configure_current(arg_play_next)
	

##


func _play_sword_field_event():
	_current_event_id_playing = CHAOS_EVENTS.SWORD_FIELD
	
	general_purpose_timer.connect("timeout", self, "_general_purpose_timer_timeout__for_sword_field_delay")
	sword_attack_module.connect("on_post_mitigation_damage_dealt", self, "_on_post_mitigated_dmg_dealt_by_sword_attack_module")
	
	_current_sword_field_sword_count = sword_field_starting_sword_count
	
	general_purpose_timer.start(sword_field_wait_time_for_kill_register)


func _general_purpose_timer_timeout__for_sword_field_delay():
	if _current_sword_field_sword_count > 0:
		_current_sword_field_sword_count -= 1
		_hit_enemy_with_chaos_sword()
		
		general_purpose_timer.start(sword_field_wait_time_for_kill_register)
	else:
		_end_sword_field_event(true)

func _hit_enemy_with_chaos_sword():
	var enemy = _get_enemy_to_target_using_range_module__default_to_other_enemies(sword_attack_module.range_module, Targeting.WEAKEST)
	
	_is_sword_from_ability = true
	sword_attack_module.on_command_attack_enemies([enemy], 1)


func _on_post_mitigated_dmg_dealt_by_sword_attack_module(damage_instance_report, killed, enemy, damage_register_id, module):
	if killed:
		if _current_sword_field_sword_count < sword_field_max_sword_count_for_replenish:
			_current_sword_field_sword_count += 1



func _end_sword_field_event(arg_play_next : bool):
	general_purpose_timer.disconnect("timeout", self, "_general_purpose_timer_timeout__for_sword_field_delay")
	sword_attack_module.disconnect("on_post_mitigation_damage_dealt", self, "_on_post_mitigated_dmg_dealt_by_sword_attack_module")
	
	_is_sword_from_ability = false
	_current_event_id_playing = -1
	_play_event_in_front_index_and_configure_current(arg_play_next)

##

func _play_void_lakes_event():
	_current_event_id_playing = CHAOS_EVENTS.VOID_LAKES
	
	general_purpose_timer.connect("timeout", self, "_general_purpose_timer_timeout__for_void_lakes_delay")
	
	_summon_void_lakes_to_enemies()
	
	general_purpose_timer.start(void_lakes_delay_for_next_cast)

func _summon_void_lakes_to_enemies():
	var enemies = _get_enemy_to_target_using_range_module__default_to_other_enemies(range_module, Targeting.RANDOM, 3)
	
	for enemy in enemies:
		var pos = enemy.global_position
		
		var void_lake = void_lakes_aoe_attack_module.construct_aoe(pos, pos)
		void_lake.modulate.a = 0.5
		
		
		void_lakes_aoe_attack_module.set_up_aoe__add_child_and_emit_signals(void_lake)



func _general_purpose_timer_timeout__for_void_lakes_delay():
	_end_void_lakes_event(true)




func _end_void_lakes_event(arg_play_next : bool):
	general_purpose_timer.disconnect("timeout", self, "_general_purpose_timer_timeout__for_void_lakes_delay")
	
	_current_event_id_playing = -1
	_play_event_in_front_index_and_configure_current(arg_play_next)


##

func _play_night_watcher_event():
	_current_event_id_playing = CHAOS_EVENTS.NIGHT_WATCHER
	
	for i in night_watcher_summon_count:
		var target_placable = _get_nearest_in_map_placable_from_random_pos()
		#call_deferred("_summon_nightwatcher_at_placable", target_placable)
		_summon_nightwatcher_at_placable(target_placable)
	
	general_purpose_timer.connect("timeout", self, "_general_purpose_timer_timeout__for_night_watcher_delay")
	
	general_purpose_timer.start(night_watcher_delay_for_next_cast)
	


func _summon_nightwatcher_at_placable(arg_placable):
	if is_instance_valid(arg_placable) and arg_placable.tower_occupying == null:
		var nightwatcher = game_elements.tower_inventory_bench.create_tower(Towers.NIGHTWATCHER, arg_placable)
		nightwatcher.lifetime = night_watcher_summon_duration
		nightwatcher.explosion_flat_dmg_amount = night_watcher_explosion_flat_dmg
		nightwatcher.explosion_pierce = night_watcher_explosion_pierce
		nightwatcher.stun_duration = night_watcher_stun_duration
		
		game_elements.tower_inventory_bench.add_tower_to_scene(nightwatcher)



func _get_nearest_in_map_placable_from_random_pos():
	var random_pos = _get_random_position_of_random_path_in_map()
	var placables = game_elements.map_manager.get_all_placables_in_range(random_pos, 400, game_elements.map_manager.PlacableState.UNOCCUPIED)
	
	if placables.size() > 1:
		return placables[0]
	else:
		return null

func _get_random_position_of_random_path_in_map():
	var random_path = game_elements.map_manager.get_random_enemy_path()
	var random_offset = _get_random_offset_with_weights()
	
	if is_instance_valid(random_path):
		return random_path.curve.interpolate_baked(random_offset * random_path.curve.get_baked_length())
	else:
		return global_position

func _get_random_offset_with_weights():
	var percent_prog = enemy_manager.get_percent_of_enemies_spawned_to_total_from_ins()
	if percent_prog > 0.5:
		return absolute_chaos_rng_general_purpose.randf_range(0.5, 0.95)
	else:
		return absolute_chaos_rng_general_purpose.randf_range(0.05, 0.95)



func _general_purpose_timer_timeout__for_night_watcher_delay():
	_end_night_watcher_event(true)

func _end_night_watcher_event(arg_play_next : bool):
	general_purpose_timer.disconnect("timeout", self, "_general_purpose_timer_timeout__for_night_watcher_delay")
	
	_current_event_id_playing = -1
	_play_event_in_front_index_and_configure_current(arg_play_next)

##

func _play_explosive_rain_event():
	_current_event_id_playing = CHAOS_EVENTS.EXPLOSIVE_RAIN
	
	general_purpose_timer.connect("timeout", self, "_general_purpose_timer_timeout__for_explosive_rain_delay")
	
	_summon_one_rain_drop_and_increase_fired_count()
	general_purpose_timer.start(explosive_rain_delay_per_rain)


func _general_purpose_timer_timeout__for_explosive_rain_delay():
	if _current_explosive_rain_fired < explosive_rain_rain_count:
		_summon_one_rain_drop_and_increase_fired_count()
		general_purpose_timer.start(explosive_rain_delay_per_rain)
	else:
		_end_explosive_rain_event(true)



func _summon_one_rain_drop_and_increase_fired_count():
	var enemy = _get_enemy_to_target_using_range_module__default_to_other_enemies(diamond_attack_module.range_module)
	var pos_to_target = global_position
	if is_instance_valid(enemy):
		pos_to_target = enemy.global_position
	
	var rain_drop = _create_rain_drop()
	_set_rain_drop_position(rain_drop, pos_to_target)
	rain_drop.connect("animation_finished", self, "_on_rain_drop_time_over", [rain_drop.position], CONNECT_ONESHOT)
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(rain_drop)
	
	_current_explosive_rain_fired += 1



func _create_rain_drop():
	var rain_drop = Chaos_RainDrop_Scene.instance()
	
	rain_drop.scale *= 2
	rain_drop.offset.y -= rain_drop.get_sprite_size().y / 2.0
	
	return rain_drop


func _set_rain_drop_position(arg_rain_drop, arg_enemy_pos):
	var magnitude : int = absolute_chaos_rng_general_purpose.randi_range(explosive_rain_min_range_from_target_spawn, explosive_rain_max_range_from_target_spawn)
	var rot : int = absolute_chaos_rng_general_purpose.randi_range(0, 359)
	var vector_of_rand = Vector2(magnitude, 0).rotated(deg2rad(rot))
	
	arg_rain_drop.position = vector_of_rand + arg_enemy_pos


func _on_rain_drop_time_over(arg_pos):
	_summon_rain_explosion_at_pos(arg_pos)


func _summon_rain_explosion_at_pos(arg_pos):
	var rain_explosion = explosive_rain_aoe_attk_module.construct_aoe(arg_pos, arg_pos)
	rain_explosion.connect("before_enemy_hit_aoe", self, "_before_explosive_rain_explosion_hit_enemy", [rain_explosion])
	
	explosive_rain_aoe_attk_module.set_up_aoe__add_child_and_emit_signals(rain_explosion)

func _before_explosive_rain_explosion_hit_enemy(enemy, explosion):
	if is_instance_valid(enemy) and is_instance_valid(explosion) and is_instance_valid(enemy.current_path):
		var knock_up_copy = explosive_rain_knockup_effect._get_copy_scaled_by(1)
		var forced_mov_copy = explosive_rain_forced_path_mov_effect._get_copy_scaled_by(1)
		
		var explosion_nearest_offset_path = enemy.current_path.curve.get_closest_offset(explosion.global_position)
		if explosion_nearest_offset_path >= enemy.offset:
			forced_mov_copy.reverse_movements()
		
		enemy._add_effect(knock_up_copy)
		enemy._add_effect(forced_mov_copy)



func _end_explosive_rain_event(arg_play_next : bool):
	_current_explosive_rain_fired = 0
	
	general_purpose_timer.disconnect("timeout", self, "_general_purpose_timer_timeout__for_explosive_rain_delay")
	
	_current_event_id_playing = -1
	_play_event_in_front_index_and_configure_current(arg_play_next)



######

func _on_round_end_ability_cleanup():
	_end_current_event(false)

func _end_current_event(arg_play_next_event : bool):
	if chaos_event_to_end_cast_func_name_map.has(_current_event_id_playing):
		call(chaos_event_to_end_cast_func_name_map[_current_event_id_playing], arg_play_next_event)



###


func _on_particle_create_timer_timeout():
	#light_background_purple_particle_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	
	for i in 3:
		changing_purple_particle_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	

func _create_center_purple_particle():
	var particle = Chaos_ChangingPurpleParticle_Scene.instance()
	particle.frames = particle_center_particle_sprite_frames
	
	particle.particle_y_per_sec = particle_y_per_sec
	particle.particle_lifetime = particle_lifetime
	particle.particle_time_before_mov = particle_time_before_mov
	
	particle.particle_modulate_a = particle_modulate_a
	particle.particle_z_index = particle_z_index
	
	return particle

func _set_center_particle_properties_when_get_from_pool_after_add_child(arg_particle):
	arg_particle.reset_states()
	
	arg_particle.global_position = pos_for_particle_summon.global_position
	
	var x_modi = non_essential_rng.randi_range(-22, 22)
	arg_particle.global_position.x += x_modi



func _create_background_purple_particle():
	var particle = Chaos_ChangingPurpleParticle_Scene.instance()
	particle.frames = particle_background_particle_sprite_frames
	
	particle.particle_y_per_sec = particle_y_per_sec
	particle.particle_lifetime = particle_lifetime
	particle.particle_time_before_mov = particle_time_before_mov
	
	particle.particle_modulate_a = particle_modulate_a
	particle.particle_z_index = particle_z_index
	
	return particle

func _set_background_particle_properties_when_get_from_pool_after_add_child(arg_particle):
	arg_particle.reset_states()
	
	arg_particle.global_position = pos_for_particle_summon.global_position
	
	var x_modi = non_essential_rng.randi_range(-2, 2)
	arg_particle.global_position.x += x_modi

