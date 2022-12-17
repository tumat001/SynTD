extends "res://TowerRelated/AbstractTower.gd"

const Enervate_MainProj_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/Enervate_MainProj.png")
const Enervate_Orb_Death_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/Orbs/Enervate_Orbs_Death.png")
const Enervate_Orb_Decay_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/Orbs/Enervate_Orbs_Decay.png")
const Enervate_Orb_Shrivel_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/Orbs/Enervate_Orbs_Shrivel.png")
const Enervate_Orb_Slow_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/Orbs/Enervate_Orbs_Slow.png")
const Enervate_Orb_Stun_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/Orbs/Enervate_Orbs_Stun.png")

const Enervate_OrbBeam_Death_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/OrbBeams/Enervate_OrbBeams_Death.png")
const Enervate_OrbBeam_Decay_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/OrbBeams/Enervate_OrbBeams_Decay.png")
const Enervate_OrbBeam_Shrivel_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/OrbBeams/Enervate_OrbBeams_Shrivel.png")
const Enervate_OrbBeam_Slow_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/OrbBeams/Enervate_OrbBeams_Slow.png")
const Enervate_OrbBeam_Stun_Pic = preload("res://TowerRelated/Color_Red/Enervate/Assets/OrbBeams/Enervate_OrbBeams_Stun.png")
const CommonTexture_APParticle = preload("res://MiscRelated/CommonTextures/CommonTexture_APParticle.png")

const Enervate_OrbDeath_Explosion01 = preload("res://TowerRelated/Color_Red/Enervate/Assets/Others/OrbDeath_Explosion/OrbDeath_Explosion_01.png")
const Enervate_OrbDeath_Explosion02 = preload("res://TowerRelated/Color_Red/Enervate/Assets/Others/OrbDeath_Explosion/OrbDeath_Explosion_02.png")
const Enervate_OrbDeath_Explosion03 = preload("res://TowerRelated/Color_Red/Enervate/Assets/Others/OrbDeath_Explosion/OrbDeath_Explosion_03.png")
const Enervate_OrbDeath_Explosion04 = preload("res://TowerRelated/Color_Red/Enervate/Assets/Others/OrbDeath_Explosion/OrbDeath_Explosion_04.png")
const Enervate_OrbDeath_Explosion05 = preload("res://TowerRelated/Color_Red/Enervate/Assets/Others/OrbDeath_Explosion/OrbDeath_Explosion_05.png")
const Enervate_OrbDeath_Explosion06 = preload("res://TowerRelated/Color_Red/Enervate/Assets/Others/OrbDeath_Explosion/OrbDeath_Explosion_06.png")
const Enervate_OrbDeath_Explosion07 = preload("res://TowerRelated/Color_Red/Enervate/Assets/Others/OrbDeath_Explosion/OrbDeath_Explosion_07.png")
const Enervate_OrbDeath_Explosion08 = preload("res://TowerRelated/Color_Red/Enervate/Assets/Others/OrbDeath_Explosion/OrbDeath_Explosion_08.png")
const Enervate_OrbDeath_Explosion_AMI = preload("res://TowerRelated/Color_Red/Enervate/Assets/Others/OrbDeath_Explosion/OrbDeath_Explosion_AMI.png")

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")
const EnervateOrbAttkModule = preload("res://TowerRelated/Color_Red/Enervate/Subs/EnervateOrbAttkModule.gd")
const EnervateOrbAttkModule_Scene = preload("res://TowerRelated/Color_Red/Enervate/Subs/EnervateOrbAttkModule.tscn")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")


#

enum OrbTypes {
	DEATH = 0,
	DECAY = 1,
	SHRIVEL = 2,
	SLOW = 3,
	STUN = 4,
}

const available_orb_types : Array = [
	OrbTypes.DEATH,
	OrbTypes.DECAY,
	OrbTypes.SHRIVEL,
	OrbTypes.SLOW,
	OrbTypes.STUN,
]

const orb_type_to_orb_summon_method_map : Dictionary = {
	OrbTypes.DEATH : "_summon_death_orb",
	OrbTypes.DECAY : "_summon_decay_orb",
	OrbTypes.SHRIVEL : "_summon_shrivel_orb",
	OrbTypes.SLOW : "_summon_slow_orb",
	OrbTypes.STUN : "_summon_stun_orb",
}

var chant_ability : BaseAbility
var chant_ability_is_ready : bool = false
const chant_ability_base_cooldown : float = 12.0
const no_enemies_in_range_clause : int = -10

var _summoned_orb_types : Array
const initial_position_for_orb_attk_mod_spawn := Vector2(0, 4)
var enervate_orb_choose_rng : RandomNumberGenerator
const orb_range : float = 120.0
const orb_base_dmg : float = 0.4
const orb_attk_speed : float = 2.0
const orb_generic_effect_duration : float = 0.75 #attk speed + some allowance

var shrivel_orb_attk_module : EnervateOrbAttkModule
const shrivel_orb__base_armor_toughness_shred_percent_amount : float = 25.0
var shirvel_orb__armor_reduction_modi : PercentModifier
var shrivel_orb__toughness_reduction_modi : PercentModifier

var stun_orb_attk_module : EnervateOrbAttkModule
const stun_orb__base_stun_duration : float = 1.0
const stun_orb__cooldown : float = 6.0
var stun_orb__stun_effect : EnemyStunEffect
var stun_orb__timer_for_cooldown : TimerForTower

var slow_orb_attk_module : EnervateOrbAttkModule
const slow_orb__base_slow_percent_amount : float = -20.0
var slow_orb__slow_modi : PercentModifier

var death_orb_attk_module : EnervateOrbAttkModule
const death_orb__percent_damage_ratio : float = 0.2
var death_orb__dmg_modi : FlatModifier
var death_orb__on_hit_dmg : OnHitDamage
var death_orb_explosion_attack_module : AOEAttackModule
var _current_death_orb_enemy

var decay_orb_attk_module : EnervateOrbAttkModule
const decay_orb__base_percent_amount : float = 40.0
var decay_orb__health_decay_modi : PercentModifier
var decay_orb__shield_decay_modi : PercentModifier


var chant_stacking_ap_modi : FlatModifier
var chant_stacking_ability_potency_effect : TowerAttributesEffect
const chant_ap_per_cast_during_cast : float = 0.25
var chant_ap_inc_attk_sprite_pool : AttackSpritePoolComponent
var non_essential_rng : RandomNumberGenerator

var _had_no_enemies_in_range : bool = false
var _all_orb_attk_modules : Array = []


var _requested_enemy_manager_to_get_next_targetable_enemy : bool
var _requesting_orb_attk_modules : Array = []

#


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.ENERVATE)
	
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
	range_module.position.y += initial_position_for_orb_attk_mod_spawn.y
	range_module.add_targeting_option(Targeting.STRONGEST)
	range_module.set_current_targeting(Targeting.STRONGEST)
	range_module.remove_targeting_options([Targeting.LAST, Targeting.FIRST])
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 450
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= initial_position_for_orb_attk_mod_spawn.y
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Enervate_MainProj_Pic)
	
	add_attack_module(attack_module)
	
	_construct_shrivel_orb_attk_module_and_relateds()
	_construct_stun_orb_attk_module_and_relateds()
	_construct_slow_orb_attk_module_and_relateds()
	_construct_death_orb_attk_module_and_relateds()
	_construct_decay_orb_attk_module_and_relateds()
	
	#
	
	enervate_orb_choose_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.ENERVATE_ORB_CHOOSE)
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	_construct_and_register_ability()
	_construct_self_stacking_ap_effect_and_particles()
	
	connect("on_range_module_enemy_entered", self, "_on_enemies_entered_range_module", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_on_enemies_exited_range_module", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_on_round_start_e", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_e", [], CONNECT_PERSIST)
	connect("final_ability_potency_changed", self, "_on_final_ap_changed_e", [], CONNECT_PERSIST)
	
	_update_effect_value_modis()
	
	#
	
	_post_inherit_ready()


func _construct_and_register_ability():
	chant_ability = BaseAbility.new()
	
	chant_ability.is_timebound = true
	
	chant_ability.set_properties_to_usual_tower_based()
	chant_ability.tower = self
	
	chant_ability.connect("updated_is_ready_for_activation", self, "_can_cast_chant_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(chant_ability, false)

func _construct_self_stacking_ap_effect_and_particles():
	chant_stacking_ap_modi = FlatModifier.new(StoreOfTowerEffectsUUID.ENERVATE_STACKING_AP_EFFECT)
	chant_stacking_ap_modi.flat_modifier = 0
	chant_stacking_ability_potency_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, chant_stacking_ap_modi, StoreOfTowerEffectsUUID.ENERVATE_STACKING_AP_EFFECT)
	chant_stacking_ability_potency_effect.is_timebound = false
	add_tower_effect(chant_stacking_ability_potency_effect)
	
	chant_ap_inc_attk_sprite_pool = AttackSpritePoolComponent.new()
	chant_ap_inc_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	chant_ap_inc_attk_sprite_pool.node_to_listen_for_queue_free = self
	chant_ap_inc_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	chant_ap_inc_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_chant_ap_inc_particle"
	chant_ap_inc_attk_sprite_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_chant_ap_inc_particle_properties_when_get_from_pool_after_add_child"
	chant_ap_inc_attk_sprite_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_before_add_child = "_set_chant_ap_inc_particle_properties_when_get_from_pool_before_add_child"


func _construct_generic_orb_attk_module(arg_orb_pic, arg_beam_pic):
	var orb_range_module = RangeModule_Scene.instance()
	orb_range_module.base_range_radius = orb_range
	orb_range_module.set_range_shape(CircleShape2D.new())
	orb_range_module.can_display_range = false
	#configure_range_module_properties(orb_range_module)
	
	var attack_module : EnervateOrbAttkModule = EnervateOrbAttkModule_Scene.instance()
	attack_module.base_damage = orb_base_dmg
	attack_module.base_damage_type = DamageType.ELEMENTAL
	attack_module.base_attack_speed = orb_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = false
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = 1
	
	attack_module.range_module = orb_range_module
	
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_attack_speed = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", arg_beam_pic)
	beam_sprite_frame.set_animation_loop("default", false)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	
	attack_module.set_image_as_tracker_image(arg_orb_pic)
	
	add_attack_module(attack_module)
	
	attack_module.set_parent_enervate_tower(self)
	attack_module.orb_sprite.texture = arg_orb_pic
	attack_module.connect("request_for_new_target_to_acquire", self, "_on_orb_request_for_new_target_to_acquire", [attack_module])
	return attack_module

func _construct_shrivel_orb_attk_module_and_relateds():
	shrivel_orb_attk_module = _construct_generic_orb_attk_module(Enervate_Orb_Shrivel_Pic, Enervate_OrbBeam_Shrivel_Pic)
	_all_orb_attk_modules.append(shrivel_orb_attk_module)
	
	#
	
	shirvel_orb__armor_reduction_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.ENERVATE_SHRIVEL_ARMOR_REDUC_EFFECT)
	shirvel_orb__armor_reduction_modi.percent_amount = shrivel_orb__base_armor_toughness_shred_percent_amount
	shirvel_orb__armor_reduction_modi.percent_based_on = PercentType.MAX
	var shirvel_orb__armor_reduction_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_ARMOR, shirvel_orb__armor_reduction_modi, StoreOfEnemyEffectsUUID.ENERVATE_SHRIVEL_ARMOR_REDUC_EFFECT)
	shirvel_orb__armor_reduction_effect.is_timebound = true
	shirvel_orb__armor_reduction_effect.time_in_seconds = orb_generic_effect_duration
	var armor_reduc_effect_as_adder_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(shirvel_orb__armor_reduction_effect, StoreOfTowerEffectsUUID.ENERVATE_SHRIVEL_ARMOR_REDUC_ADDER_EFFECT)
	
	shrivel_orb__toughness_reduction_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.ENERVATE_SHRIVEL_TOU_REDUC_EFFECT)
	shrivel_orb__toughness_reduction_modi.percent_amount = shrivel_orb__base_armor_toughness_shred_percent_amount
	shrivel_orb__toughness_reduction_modi.percent_based_on = PercentType.MAX
	var shrivel_orb__toughness_reduction_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_TOUGHNESS, shrivel_orb__toughness_reduction_modi, StoreOfEnemyEffectsUUID.ENERVATE_SHRIVEL_TOU_REDUC_EFFECT)
	shrivel_orb__toughness_reduction_effect.is_timebound = true
	shrivel_orb__toughness_reduction_effect.time_in_seconds = orb_generic_effect_duration
	var toughness_reduc_effect_as_adder_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(shrivel_orb__toughness_reduction_effect, StoreOfTowerEffectsUUID.ENERVATE_SHRIVEL_TOUGHNESS_REDUC_ADDER_EFFECT)
	
	_force_add_on_hit_effect_adder_effect_to_module(armor_reduc_effect_as_adder_effect, shrivel_orb_attk_module)
	_force_add_on_hit_effect_adder_effect_to_module(toughness_reduc_effect_as_adder_effect, shrivel_orb_attk_module)


func _construct_stun_orb_attk_module_and_relateds():
	stun_orb_attk_module = _construct_generic_orb_attk_module(Enervate_Orb_Stun_Pic, Enervate_OrbBeam_Stun_Pic)
	_all_orb_attk_modules.append(stun_orb_attk_module)
	
	stun_orb__stun_effect = EnemyStunEffect.new(stun_orb__base_stun_duration, StoreOfEnemyEffectsUUID.ENERVATE_STUN_EFFECT)
	
	#
	
	stun_orb__timer_for_cooldown = TimerForTower.new()
	stun_orb__timer_for_cooldown.set_tower_and_properties(self)
	stun_orb__timer_for_cooldown.one_shot = true
	stun_orb__timer_for_cooldown.connect("timeout", self ,"_on_stun_orb__timer_for_cooldown_timeout")
	add_child(stun_orb__timer_for_cooldown)

func _construct_slow_orb_attk_module_and_relateds():
	slow_orb_attk_module = _construct_generic_orb_attk_module(Enervate_Orb_Slow_Pic, Enervate_OrbBeam_Slow_Pic)
	_all_orb_attk_modules.append(slow_orb_attk_module)
	
	slow_orb__slow_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.ENERVATE_SLOW_EFFECT)
	slow_orb__slow_modi.percent_amount = slow_orb__base_slow_percent_amount
	slow_orb__slow_modi.percent_based_on = PercentType.BASE
	
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_orb__slow_modi, StoreOfEnemyEffectsUUID.ENERVATE_SLOW_EFFECT)
	enemy_attr_eff.is_timebound = true
	enemy_attr_eff.time_in_seconds = orb_generic_effect_duration
	
	var tower_eff : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_attr_eff, StoreOfTowerEffectsUUID.ENERVATE_SLOW_ADDER_EFFECT)
	
	_force_add_on_hit_effect_adder_effect_to_module(tower_eff, slow_orb_attk_module)

func _construct_death_orb_attk_module_and_relateds():
	death_orb_attk_module = _construct_generic_orb_attk_module(Enervate_Orb_Death_Pic, Enervate_OrbBeam_Death_Pic)
	_all_orb_attk_modules.append(death_orb_attk_module)
	
	death_orb_attk_module.connect("on_enemy_hit", self, "_on_death_orb_enemy_hit", [], CONNECT_PERSIST)
	
	death_orb__dmg_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.ENERVATE_DEATH_ON_HIT_DMG)
	
	death_orb__on_hit_dmg = OnHitDamage.new(StoreOfEnemyEffectsUUID.ENERVATE_DEATH_ON_HIT_DMG, death_orb__dmg_modi, DamageType.ELEMENTAL)
	
	#
	
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = 0
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
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
	sprite_frames.add_frame("default", Enervate_OrbDeath_Explosion01)
	sprite_frames.add_frame("default", Enervate_OrbDeath_Explosion02)
	sprite_frames.add_frame("default", Enervate_OrbDeath_Explosion03)
	sprite_frames.add_frame("default", Enervate_OrbDeath_Explosion04)
	sprite_frames.add_frame("default", Enervate_OrbDeath_Explosion05)
	sprite_frames.add_frame("default", Enervate_OrbDeath_Explosion06)
	sprite_frames.add_frame("default", Enervate_OrbDeath_Explosion07)
	sprite_frames.add_frame("default", Enervate_OrbDeath_Explosion08)
	
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = -1
	explosion_attack_module.duration = 0.3
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(Enervate_OrbDeath_Explosion_AMI)
	
	add_attack_module(explosion_attack_module)
	death_orb_explosion_attack_module = explosion_attack_module 


func _construct_decay_orb_attk_module_and_relateds():
	decay_orb_attk_module = _construct_generic_orb_attk_module(Enervate_Orb_Decay_Pic, Enervate_OrbBeam_Decay_Pic)
	_all_orb_attk_modules.append(decay_orb_attk_module)
	
	decay_orb__health_decay_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.ENERVATE_HEAL_DECAY_EFFECT)
	decay_orb__health_decay_modi.percent_amount = decay_orb__base_percent_amount
	decay_orb__health_decay_modi.percent_based_on = PercentType.BASE
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_HEALTH_MODIFIER, decay_orb__health_decay_modi, StoreOfEnemyEffectsUUID.ENERVATE_HEAL_DECAY_EFFECT)
	enemy_attr_eff.is_timebound = true
	enemy_attr_eff.time_in_seconds = orb_generic_effect_duration
	var heal_decay_on_hit_adder : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_attr_eff, StoreOfTowerEffectsUUID.ENERVATE_HEAL_DECAY_ADDER_EFFECT)
	
	_force_add_on_hit_effect_adder_effect_to_module(heal_decay_on_hit_adder, decay_orb_attk_module)
	
	decay_orb__shield_decay_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.ENERVATE_SHIELD_DECAY_EFFECT)
	decay_orb__shield_decay_modi.percent_amount = decay_orb__base_percent_amount
	decay_orb__shield_decay_modi.percent_based_on = PercentType.BASE
	var enemy_attr_shield_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_SHIELD_RECEIVE_MODIFIER, decay_orb__shield_decay_modi, StoreOfEnemyEffectsUUID.ENERVATE_SHIELD_DECAY_EFFECT)
	enemy_attr_shield_eff.is_timebound = true
	enemy_attr_shield_eff.time_in_seconds = orb_generic_effect_duration
	var shield_decay_on_hit_adder : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_attr_shield_eff, StoreOfTowerEffectsUUID.ENERVATE_SHIELD_DECAY_ADDER_EFFECT)
	
	_force_add_on_hit_effect_adder_effect_to_module(shield_decay_on_hit_adder, decay_orb_attk_module)


#


func _on_enemies_entered_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		chant_ability.activation_conditional_clauses.remove_clause(no_enemies_in_range_clause)
		
		if !enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives", [], CONNECT_DEFERRED)
		
		if _had_no_enemies_in_range:
			_had_no_enemies_in_range = false
			for orb_attk_module in _all_orb_attk_modules:
				if !is_instance_valid(orb_attk_module.assigned_target):
					_give_orb_new_target_to_acquire(orb_attk_module)

func _on_enemy_killed_with_no_more_revives(damage_instance_report, arg_enemy):
	_on_enemies_exited_range_module(arg_enemy, null, range_module)


func _on_enemies_exited_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		if range_module.get_enemy_in_range_count() == 0:
			chant_ability.activation_conditional_clauses.attempt_insert_clause(no_enemies_in_range_clause)
			_had_no_enemies_in_range = true
		
		if enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.disconnect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives")


func _can_cast_chant_updated(arg_val):
	chant_ability_is_ready = arg_val
	_attempt_cast_chant()

func _attempt_cast_chant():
	if chant_ability_is_ready:
		_cast_chant()

func _cast_chant():
	var cd = _get_cd_to_use(chant_ability_base_cooldown)
	chant_ability.on_ability_before_cast_start(cd)
	chant_ability.start_time_cooldown(cd)
	
	_summon_orb__or_give_ap_to_self()
	
	chant_ability.on_ability_after_cast_ended(cd)

func _summon_orb__or_give_ap_to_self():
	var type_to_summon = _get_chosen_orb_type_to_summon()
	var target = _get_target_to_acquire_for_orbs()
	
	if type_to_summon == -1 or !is_instance_valid(target): #all are taken
		_give_self_stacking_ap()
	else:
		_summoned_orb_types.append(type_to_summon)
		var summon_orb_method : String = orb_type_to_orb_summon_method_map[type_to_summon]
		call(summon_orb_method, target)


func _get_target_to_acquire_for_orbs():
	if is_instance_valid(range_module):
		var curr_enemies = range_module.get_current_enemies()
		if curr_enemies.size() > 0:
			return curr_enemies[0]
		
		#
		var targets = range_module.get_targets_without_affecting_self_current_targets(1)
		if targets.size() > 0:
			return targets[0]
		
		#
		var map_targets = game_elements.enemy_manager.get_all_enemies()
		if map_targets.size() > 0:
			return map_targets[0]
		
	
	return null


func _give_self_stacking_ap():
	chant_stacking_ap_modi.flat_modifier += chant_ap_per_cast_during_cast
	_calculate_final_ability_potency()
	
	for i in 6:
		chant_ap_inc_attk_sprite_pool.get_or_create_attack_sprite_from_pool()


func _create_chant_ap_inc_particle():
	var particle = AttackSprite_Scene.instance()
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	particle.texture_to_use = CommonTexture_APParticle
	particle.scale *= 1.5
	
	return particle

func _set_chant_ap_inc_particle_properties_when_get_from_pool_before_add_child(particle):
	particle.lifetime = 0.5

func _set_chant_ap_inc_particle_properties_when_get_from_pool_after_add_child(particle):
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	particle.position = global_position
	
	particle.position.x += non_essential_rng.randi_range(-25, 25)
	particle.position.y += non_essential_rng.randi_range(-16, 10)
	
	particle.modulate.a = 1
	
	particle.visible = true

#

func _get_chosen_orb_type_to_summon():
	var all_untaken_orb_types = available_orb_types.duplicate()
	for orb_type in _summoned_orb_types:
		all_untaken_orb_types.erase(orb_type)
	
	if all_untaken_orb_types.size() == 0:
		return -1
	else:
		return all_untaken_orb_types[enervate_orb_choose_rng.randi_range(0, all_untaken_orb_types.size() - 1)]

func _on_round_start_e():
	if chant_stacking_ap_modi != null:
		chant_stacking_ap_modi.flat_modifier = 0
		_calculate_final_ability_potency()
	
	if stun_orb__timer_for_cooldown.time_left == 0:
		stun_orb__timer_for_cooldown.start(stun_orb__cooldown)

func _on_round_end_e():
	_summoned_orb_types.clear()
	
	_had_no_enemies_in_range = false

func _on_final_ap_changed_e():
	_update_effect_value_modis()

func _update_effect_value_modis():
	var ap_to_use = chant_ability.get_potency_to_use(last_calculated_final_ability_potency)
	#
	if shirvel_orb__armor_reduction_modi != null:
		shirvel_orb__armor_reduction_modi.percent_amount = shrivel_orb__base_armor_toughness_shred_percent_amount * ap_to_use
		shrivel_orb__toughness_reduction_modi.percent_amount = shrivel_orb__base_armor_toughness_shred_percent_amount * ap_to_use
	#
	if stun_orb__stun_effect != null:
		stun_orb__stun_effect.time_in_seconds = stun_orb__base_stun_duration * ap_to_use
	#
	if slow_orb__slow_modi != null:
		slow_orb__slow_modi.percent_amount = slow_orb__base_slow_percent_amount * ap_to_use
	#
	if decay_orb__health_decay_modi != null:
		decay_orb__health_decay_modi.percent_amount = decay_orb__base_percent_amount * ap_to_use
		decay_orb__shield_decay_modi.percent_amount = decay_orb__health_decay_modi.percent_amount

####### Orb specific behavior

func _on_stun_orb__timer_for_cooldown_timeout():
	if !stun_orb_attk_module.is_connected("on_enemy_hit", self, "_on_stun_orb_enemy_hit"):
		stun_orb_attk_module.connect("on_enemy_hit", self, "_on_stun_orb_enemy_hit", [], CONNECT_ONESHOT)

func _on_stun_orb_enemy_hit(enemy, damage_register_id, damage_instance, module):
	damage_instance.on_hit_effects[stun_orb__stun_effect.effect_uuid] = stun_orb__stun_effect
	stun_orb__timer_for_cooldown.start(stun_orb__cooldown)

#

func _on_death_orb_enemy_hit(enemy, damage_register_id, damage_instance, module):
	if is_instance_valid(_current_death_orb_enemy) and _current_death_orb_enemy != enemy:
		if _current_death_orb_enemy.is_connected("on_killed_by_damage", self, "_on_death_orb_enemy_killed_by_dmg"):
			_current_death_orb_enemy.disconnect("on_killed_by_damage", self, "_on_death_orb_enemy_killed_by_dmg")

	_current_death_orb_enemy = enemy
	
	if !enemy.is_connected("on_killed_by_damage", self, "_on_death_orb_enemy_killed_by_dmg"):
		enemy.connect("on_killed_by_damage", self, "_on_death_orb_enemy_killed_by_dmg")


func _on_death_orb_enemy_killed_by_dmg(damage_instance_report, enemy):
	var enemy_pos = enemy.global_position
	var explosion = death_orb_explosion_attack_module.construct_aoe(enemy_pos, enemy_pos)
	explosion.modulate.a = 0.75
	
	var copied_on_hit = death_orb__on_hit_dmg
	copied_on_hit.damage_as_modifier.flat_modifier = enemy._last_calculated_max_health * chant_ability.get_potency_to_use(last_calculated_final_ability_potency) * death_orb__percent_damage_ratio
	explosion.damage_instance.on_hit_damages[copied_on_hit.internal_id] = copied_on_hit
	
	death_orb_explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)



######## orb summon and relateds

func _on_orb_request_for_new_target_to_acquire(arg_orb):
	_give_orb_new_target_to_acquire(arg_orb)

func _give_orb_new_target_to_acquire(arg_orb):
	var target = _get_target_to_acquire_for_orbs()
	
	if is_instance_valid(target):
		arg_orb.assign_new_target_to_follow(target)
		
	else:
		game_elements.enemy_manager.request__get_next_targetable_enemy(self, "_on_requested__get_next_targetable_enemy__fulfilled", "_on_requested__get_next_targetable_enemy__cancelled")
		_requested_enemy_manager_to_get_next_targetable_enemy = true
		if !_requesting_orb_attk_modules.has(arg_orb):
			_requesting_orb_attk_modules.append(arg_orb)

func _summon_shrivel_orb(arg_target):
	shrivel_orb_attk_module.show_and_activate__as_summoned()
	shrivel_orb_attk_module.call_deferred("assign_new_target_to_follow", arg_target)

func _summon_stun_orb(arg_target):
	stun_orb_attk_module.show_and_activate__as_summoned()
	stun_orb_attk_module.call_deferred("assign_new_target_to_follow", arg_target)
	
	stun_orb__timer_for_cooldown.start(stun_orb__cooldown)

func _summon_slow_orb(arg_target):
	slow_orb_attk_module.show_and_activate__as_summoned()
	slow_orb_attk_module.call_deferred("assign_new_target_to_follow", arg_target)

func _summon_death_orb(arg_target):
	death_orb_attk_module.show_and_activate__as_summoned()
	death_orb_attk_module.call_deferred("assign_new_target_to_follow", arg_target)

func _summon_decay_orb(arg_target):
	decay_orb_attk_module.show_and_activate__as_summoned()
	decay_orb_attk_module.call_deferred("assign_new_target_to_follow", arg_target)


###

func _on_requested__get_next_targetable_enemy__fulfilled(arg_enemy):
	game_elements.enemy_manager.disconnect_request_get_next_targetable_enemy(self, "_on_requested__get_next_targetable_enemy__fulfilled", "_on_requested__get_next_targetable_enemy__cancelled")
	_requested_enemy_manager_to_get_next_targetable_enemy = false
	for orb_module in _requesting_orb_attk_modules:
		_give_orb_new_target_to_acquire(orb_module)
	_requesting_orb_attk_modules.clear()

func _on_requested__get_next_targetable_enemy__cancelled():
	game_elements.enemy_manager.disconnect_request_get_next_targetable_enemy(self, "_on_requested__get_next_targetable_enemy__fulfilled", "_on_requested__get_next_targetable_enemy__cancelled")
	_requested_enemy_manager_to_get_next_targetable_enemy = false
	_requesting_orb_attk_modules.clear()




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

