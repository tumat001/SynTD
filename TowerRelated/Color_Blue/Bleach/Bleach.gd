extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Bleach_NormalProj01 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_Bullet01.png")
const Bleach_NormalProj02 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_Bullet02.png")
const Bleach_NormalProj03 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_Bullet03.png")

const Bleach_EmpoweredProj01 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_PierceBullet01.png")
const Bleach_EmpoweredProj02 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_PierceBullet02.png")
const Bleach_EmpoweredProj03 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_PierceBullet03.png")

const Bleach_BallProj = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_BallProj.png")
const Bleach_Explosion01 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_01.png")
const Bleach_Explosion02 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_02.png")
const Bleach_Explosion03 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_03.png")
const Bleach_Explosion04 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_04.png")
const Bleach_Explosion05 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_05.png")
const Bleach_Explosion06 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_06.png")
const Bleach_Explosion07 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_07.png")
const Bleach_Explosion08 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_08.png")
const Bleach_Explosion09 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_09.png")
const Bleach_Explosion_AMI = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/BleachExplosion/Bleach_Explosion_AMI.png")

const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")
const ArcingBaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const toughness_remove_amount : float = -3.0
const toughness_debuff_duration : float = 5.0

var cycle : int = 0

var base_attack_count_for_buff : int = 5
var current_attack_count : int = 0

var toughness_shred_effect : EnemyAttributesEffect
var non_essential_rng : RandomNumberGenerator

var bleach_lob_attk_module : ArcingBulletAttackModule
var bleach_burst_attk_module : AOEAttackModule

const base_bleach_burst_base_dmg : float = 2.5
const bleach_burst_pierce : int = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BLEACH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift_of_attk_module : float = 9
	
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
	attack_module.base_proj_speed = 435#360
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= y_shift_of_attk_module
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	
	attack_module.connect("before_bullet_is_shot", self, "_modify_bullet", [], CONNECT_PERSIST)
#	connect("on_main_attack_finished", self, "_on_main_attack_finished_b", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_b", [], CONNECT_PERSIST)
#
	
	add_attack_module(attack_module)
	
	_construct_and_add_lob_attack_module(y_shift_of_attk_module)
	
	_construct_and_add_spell_burst_explosion(y_shift_of_attk_module)
	
	#
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	connect("on_main_attack", self, "_on_main_attack_b", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	_construct_effect()
	
	_post_inherit_ready()


func _construct_effect():
	var tou_mod : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.BLEACH_SHREAD)
	tou_mod.flat_modifier = toughness_remove_amount
	
	toughness_shred_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, tou_mod, StoreOfEnemyEffectsUUID.BLEACH_SHREAD)
	toughness_shred_effect.is_timebound = true
	toughness_shred_effect.time_in_seconds = toughness_debuff_duration


func _construct_and_add_lob_attack_module(arg_y_shift : float):
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = 0
	proj_attack_module.base_damage_type = DamageType.ELEMENTAL
	proj_attack_module.base_attack_speed = 0
	proj_attack_module.base_attack_wind_up = 0
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = false
	proj_attack_module.base_pierce = 0
	proj_attack_module.base_proj_speed = 0.3
	proj_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	proj_attack_module.on_hit_damage_scale = 0
	
	proj_attack_module.benefits_from_bonus_base_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proj_attack_module.position.y -= arg_y_shift
	
	proj_attack_module.bullet_scene = ArcingBaseBullet_Scene
	proj_attack_module.set_texture_as_sprite_frame(Bleach_BallProj)
	
	proj_attack_module.max_height = 50
	proj_attack_module.bullet_rotation_per_second = 0
	
	proj_attack_module.connect("before_bullet_is_shot", self, "_before_bleach_ball_proj_is_shot_b", [], CONNECT_PERSIST)
	
	proj_attack_module.can_be_commanded_by_tower = false
	
	proj_attack_module.is_displayed_in_tracker = false
	
	bleach_lob_attk_module = proj_attack_module
	
	add_attack_module(proj_attack_module)


func _construct_and_add_spell_burst_explosion(arg_y_shift_of_attk_module):
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = base_bleach_burst_base_dmg
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.position.y -= arg_y_shift_of_attk_module
	explosion_attack_module.base_explosion_scale = 1.5
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Bleach_Explosion01)
	sprite_frames.add_frame("default", Bleach_Explosion02)
	sprite_frames.add_frame("default", Bleach_Explosion03)
	sprite_frames.add_frame("default", Bleach_Explosion04)
	sprite_frames.add_frame("default", Bleach_Explosion05)
	sprite_frames.add_frame("default", Bleach_Explosion06)
	sprite_frames.add_frame("default", Bleach_Explosion07)
	sprite_frames.add_frame("default", Bleach_Explosion09)
	sprite_frames.add_frame("default", Bleach_Explosion08)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = bleach_burst_pierce
	explosion_attack_module.duration = 0.32
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(Bleach_Explosion_AMI)
	
	bleach_burst_attk_module = explosion_attack_module
	
	add_attack_module(explosion_attack_module)


# Other signals

func _on_round_end_b():
	current_attack_count = 0


#########

func _on_main_attack_b(attk_speed_delay, enemies, module):
	current_attack_count += 1
	if current_attack_count >= base_attack_count_for_buff:
		current_attack_count = 0
		
		if enemies.size() > 0 and is_instance_valid(enemies[0]) and !enemies[0].is_queued_for_deletion():
			_fire_ball_proj_at_enemy(enemies[0])


func _fire_ball_proj_at_enemy(arg_enemy):
	bleach_lob_attk_module.on_command_attack_enemies_and_attack_when_ready([arg_enemy])

func _before_bleach_ball_proj_is_shot_b(arg_proj):
	arg_proj.connect("on_final_location_reached", self, "_on_bleach_lob_arcing_bullet_landed", [last_calculated_final_ability_potency], CONNECT_ONESHOT)

func _on_bleach_lob_arcing_bullet_landed(arg_final_location : Vector2, bullet : ArcingBaseBullet, arg_ap_to_use : float):
	var explosion = bleach_burst_attk_module.construct_aoe(arg_final_location, arg_final_location)
	explosion.damage_instance.scale_only_damage_by(arg_ap_to_use)
	explosion.damage_instance.on_hit_effects[toughness_shred_effect.effect_uuid] = toughness_shred_effect
	
	bleach_burst_attk_module.set_up_aoe__add_child_and_emit_signals(explosion)


# Only Self module modify

func _modify_bullet(bullet : BaseBullet):
	
	var cylce = non_essential_rng.randi_range(0, 2)
	
	if cycle == 0:
		bullet.set_texture_as_sprite_frames(Bleach_NormalProj01)
	elif cycle == 1:
		bullet.set_texture_as_sprite_frames(Bleach_NormalProj02)
	elif cycle == 2:
		bullet.set_texture_as_sprite_frames(Bleach_NormalProj03)


#
## Modify
#
#func _on_main_attack_finished_b(module):
#	if current_attack_count >= base_attack_count_for_buff:
#		current_attack_count = 0
#
#	current_attack_count += 1
#	if current_attack_count >= base_attack_count_for_buff:
#		connect("on_main_attack_module_damage_instance_constructed", self, "_on_benefiting_attack_damage_inst_constructed", [], CONNECT_ONESHOT)
#
#
#func _on_benefiting_attack_damage_inst_constructed(damage_instance, module):
#	damage_instance.on_hit_effects[toughness_shred_effect.effect_uuid] = toughness_shred_effect._get_copy_scaled_by(1)

