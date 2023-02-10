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

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const Volcano_Proj_Pic = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Proj.png")

const Volcano_Crater_Pic01 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Crater/Volcano_Crater01.png")
const Volcano_Crater_Pic02 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Crater/Volcano_Crater02.png")
const Volcano_Crater_Pic03 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Crater/Volcano_Crater03.png")
const Volcano_Crater_Pic04 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Crater/Volcano_Crater04.png")
const Volcano_Crater_Pic05 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Crater/Volcano_Crater05.png")

const Volcano_Explosion_Pic01 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Explosion/Volano_Explosion01.png")
const Volcano_Explosion_Pic02 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Explosion/Volano_Explosion02.png")
const Volcano_Explosion_Pic03 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Explosion/Volano_Explosion03.png")
const Volcano_Explosion_Pic04 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Explosion/Volano_Explosion04.png")
const Volcano_Explosion_Pic05 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Explosion/Volano_Explosion05.png")
const Volcano_Explosion_Pic06 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Explosion/Volano_Explosion06.png")
const Volcano_Explosion_Pic07 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Explosion/Volano_Explosion07.png")
const Volcano_Explosion_Pic08 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Explosion/Volano_Explosion08.png")
const Volcano_Explosion_Pic09 = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Explosion/Volano_Explosion09.png")

const VolcanoExplosion_AttackModule_Icon = preload("res://TowerRelated/Color_Orange/Volcano/AMAssets/VolcanoExplosion_AttackModule_Icon.png")
const VolcanoCrater_AttackModule_Icon = preload("res://TowerRelated/Color_Orange/Volcano/AMAssets/VolcanoCrater_AttackModule_Icon.png")


var explosion_attack_module : AOEAttackModule
var crater_attack_module : AOEAttackModule


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.VOLCANO)
	
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
	range_module.position.y += 24
	
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = info.base_damage
	proj_attack_module.base_damage_type = info.base_damage_type
	proj_attack_module.base_attack_speed = info.base_attk_speed
	proj_attack_module.base_attack_wind_up = 1
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = true
	proj_attack_module.base_pierce = info.base_pierce
	proj_attack_module.base_proj_speed = 4 # 4 sec to reach the location
	#attack_module.base_proj_life_distance = info.base_range
	proj_attack_module.module_id = StoreOfAttackModuleID.MAIN
	proj_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	
	proj_attack_module.position.y -= 24
	#var bullet_shape = CircleShape2D.new()
	#bullet_shape.radius = 3
	
	#proj_attack_module.bullet_shape = bullet_shape
	proj_attack_module.bullet_scene = ArcingBaseBullet_Scene
	proj_attack_module.set_texture_as_sprite_frame(Volcano_Proj_Pic)
	
	proj_attack_module.max_height = 300
	proj_attack_module.bullet_rotation_per_second = 180
	
	proj_attack_module.connect("before_bullet_is_shot", self, "_modify_bullet", [], CONNECT_PERSIST)
	
	proj_attack_module.is_displayed_in_tracker = false
	
	add_attack_module(proj_attack_module)
	
	
	# PROJ EXPLOSION AOE
	
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = 6
	explosion_attack_module.base_damage_type = DamageType.PHYSICAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.base_explosion_scale = 1.25
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	explosion_attack_module.on_hit_damage_scale = 3
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Volcano_Explosion_Pic01)
	sprite_frames.add_frame("default", Volcano_Explosion_Pic02)
	sprite_frames.add_frame("default", Volcano_Explosion_Pic03)
	sprite_frames.add_frame("default", Volcano_Explosion_Pic04)
	sprite_frames.add_frame("default", Volcano_Explosion_Pic05)
	sprite_frames.add_frame("default", Volcano_Explosion_Pic06)
	sprite_frames.add_frame("default", Volcano_Explosion_Pic07)
	sprite_frames.add_frame("default", Volcano_Explosion_Pic08)
	sprite_frames.add_frame("default", Volcano_Explosion_Pic09)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = -1
	explosion_attack_module.duration = 0.5
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(VolcanoExplosion_AttackModule_Icon)
	
	add_attack_module(explosion_attack_module)
	
	
	# CRATER/SCORCHED EARTH EXPLOSION AOE
	
	crater_attack_module = AOEAttackModule_Scene.instance()
	crater_attack_module.base_damage_scale = 0.75
	crater_attack_module.base_damage = 1 / crater_attack_module.base_damage_scale
	crater_attack_module.base_damage_type = DamageType.ELEMENTAL
	crater_attack_module.base_attack_speed = 0
	crater_attack_module.base_attack_wind_up = 0
	crater_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	crater_attack_module.is_main_attack = false
	crater_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	crater_attack_module.base_explosion_scale = 1.25
	
	crater_attack_module.benefits_from_bonus_explosion_scale = true
	crater_attack_module.benefits_from_bonus_base_damage = true
	crater_attack_module.benefits_from_bonus_attack_speed = false
	crater_attack_module.benefits_from_bonus_on_hit_damage = false
	crater_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var crater_sprite_frames = SpriteFrames.new()
	crater_sprite_frames.add_frame("default", Volcano_Crater_Pic01)
	crater_sprite_frames.add_frame("default", Volcano_Crater_Pic02)
	crater_sprite_frames.add_frame("default", Volcano_Crater_Pic03)
	crater_sprite_frames.add_frame("default", Volcano_Crater_Pic04)
	crater_sprite_frames.add_frame("default", Volcano_Crater_Pic05)
	
	crater_attack_module.aoe_sprite_frames = crater_sprite_frames
	crater_attack_module.sprite_frames_only_play_once = false
	crater_attack_module.pierce = -1
	crater_attack_module.duration = 7
	crater_attack_module.damage_repeat_count = 14
	
	crater_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	crater_attack_module.base_aoe_scene = BaseAOE_Scene
	crater_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	crater_attack_module.absolute_z_index_of_aoe = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	crater_attack_module.can_be_commanded_by_tower = false
	
	crater_attack_module.set_image_as_tracker_image(VolcanoCrater_AttackModule_Icon)
	
	add_attack_module(crater_attack_module)
	
	# add slow effect here
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.VOLCANO_SLOW)
	slow_modifier.percent_amount = -30
	slow_modifier.percent_based_on = PercentType.BASE
	
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.VOLCANO_SLOW)
	enemy_attr_eff.is_timebound = true
	enemy_attr_eff.time_in_seconds = 1
	
	var tower_eff : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_attr_eff, StoreOfTowerEffectsUUID.VOLCANO_SLOW)
	tower_eff.force_apply = true
	
	add_tower_effect(tower_eff, [crater_attack_module], false)
	
	_post_inherit_ready()


# bullet signals related

func _modify_bullet(bullet : ArcingBaseBullet):
	bullet.connect("on_final_location_reached", self, "_volcano_proj_hit_ground", [], CONNECT_ONESHOT)


func _volcano_proj_hit_ground(arg_final_location : Vector2, bullet : ArcingBaseBullet):
	var scorched_e = crater_attack_module.construct_aoe(arg_final_location, arg_final_location)
	#scorched_e.scale *= 1
	crater_attack_module.set_up_aoe__add_child_and_emit_signals(scorched_e)
	
	var explosion = explosion_attack_module.construct_aoe(arg_final_location, arg_final_location)
	explosion.scale *= 1.5
	explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)

# HeatModule

func set_heat_module(module):
	module.heat_per_attack = 4
	.set_heat_module(module)

func _construct_heat_effect():
	var base_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_attr_mod.percent_amount = 50
	base_attr_mod.percent_based_on = PercentType.BASE
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED , base_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module.benefits_from_bonus_attack_speed:
			module.calculate_all_speed_related_attributes()
	
	emit_signal("final_attack_speed_changed")
