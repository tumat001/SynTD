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

const Cannon_Proj_Pic = preload("res://TowerRelated/Color_Green/Cannon/Cannon_Attks/Cannon_Proj.png")

const Cannon_Explosion_01 = preload("res://TowerRelated/Color_Green/Cannon/Cannon_Attks/Cannon_Explosion01.png")
const Cannon_Explosion_02 = preload("res://TowerRelated/Color_Green/Cannon/Cannon_Attks/Cannon_Explosion02.png")
const Cannon_Explosion_03 = preload("res://TowerRelated/Color_Green/Cannon/Cannon_Attks/Cannon_Explosion03.png")
const Cannon_Explosion_04 = preload("res://TowerRelated/Color_Green/Cannon/Cannon_Attks/Cannon_Explosion04.png")
const Cannon_Explosion_05 = preload("res://TowerRelated/Color_Green/Cannon/Cannon_Attks/Cannon_Explosion05.png")
const Cannon_Explosion_06 = preload("res://TowerRelated/Color_Green/Cannon/Cannon_Attks/Cannon_Explosion06.png")

var explosion_attack_module : AOEAttackModule


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.CANNON)
	
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
	range_module.position.y += 7
	
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = info.base_damage
	proj_attack_module.base_damage_type = info.base_damage_type
	proj_attack_module.base_attack_speed = info.base_attk_speed
	proj_attack_module.base_attack_wind_up = 0
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = true
	proj_attack_module.base_pierce = info.base_pierce
	proj_attack_module.base_proj_speed = 0.35 # 0.35 seconds to reach target
	proj_attack_module.module_id = StoreOfAttackModuleID.MAIN
	proj_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	proj_attack_module.benefits_from_bonus_base_damage = true
	proj_attack_module.benefits_from_bonus_on_hit_damage = true
	proj_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proj_attack_module.position.y -= 7
	
	proj_attack_module.bullet_scene = ArcingBaseBullet_Scene
	proj_attack_module.set_texture_as_sprite_frame(Cannon_Proj_Pic)
	
	proj_attack_module.max_height = 75
	proj_attack_module.bullet_rotation_per_second = 0
	
	proj_attack_module.connect("before_bullet_is_shot", self, "_modify_bullet", [], CONNECT_PERSIST)
	
	proj_attack_module.is_displayed_in_tracker = false
	
	add_attack_module(proj_attack_module)
	
	
	# PROJ EXPLOSION AOE
	
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = 3.25
	explosion_attack_module.base_damage_type = DamageType.PHYSICAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Cannon_Explosion_01)
	sprite_frames.add_frame("default", Cannon_Explosion_02)
	sprite_frames.add_frame("default", Cannon_Explosion_03)
	sprite_frames.add_frame("default", Cannon_Explosion_04)
	sprite_frames.add_frame("default", Cannon_Explosion_05)
	sprite_frames.add_frame("default", Cannon_Explosion_06)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 3
	explosion_attack_module.duration = 0.25
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(explosion_attack_module)
	
	
	_post_inherit_ready()


# bullet signals related

func _modify_bullet(bullet : ArcingBaseBullet):
	bullet.connect("on_final_location_reached", self, "_cannon_proj_hit_ground", [], CONNECT_ONESHOT)

func _cannon_proj_hit_ground(arg_final_location : Vector2, bullet : ArcingBaseBullet):
	var explosion = explosion_attack_module.construct_aoe(arg_final_location, arg_final_location)
	explosion.scale *= 1.5
	#get_tree().get_root().add_child(explosion)
	explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)
