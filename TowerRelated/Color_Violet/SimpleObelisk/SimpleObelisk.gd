extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")


const SimpleObeliskBullet_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_Bullet.png")

const Explosion03_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_03.png")
const Explosion04_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_04.png")
const Explosion05_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_05.png")
const Explosion06_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_06.png")
const Explosion07_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_07.png")
const Explosion08_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_08.png")


var aoe_attack_module : AOEAttackModule

var explode_per_hit : bool = false
var original_base_range : float
var original_base_pierce : int

var obelisk_range_module : RangeModule
var obelisk_attack_module : BulletAttackModule

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SIMPLE_OBELISK)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	original_base_range = info.base_range
	original_base_pierce = info.base_pierce
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 30
	
	obelisk_range_module = range_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 250
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 30
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 3
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(SimpleObeliskBullet_pic)
	
	attack_module.connect("before_bullet_is_shot", self, "_modify_obelisk_bullet")
	
	obelisk_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	# AOE
	
	aoe_attack_module = AOEAttackModule_Scene.instance()
	aoe_attack_module.base_damage = info.base_damage
	aoe_attack_module.base_damage_type = DamageType.ELEMENTAL
	aoe_attack_module.base_attack_speed = 0
	aoe_attack_module.base_attack_wind_up = 0
	aoe_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	aoe_attack_module.is_main_attack = false
	aoe_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	aoe_attack_module.benefits_from_bonus_explosion_scale = true
	aoe_attack_module.benefits_from_bonus_base_damage = true
	aoe_attack_module.benefits_from_bonus_attack_speed = false
	aoe_attack_module.benefits_from_bonus_on_hit_damage = false
	aoe_attack_module.benefits_from_bonus_on_hit_effect = false
	
	aoe_attack_module.base_damage_scale = 0.5
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Explosion03_pic)
	sprite_frames.add_frame("default", Explosion04_pic)
	sprite_frames.add_frame("default", Explosion05_pic)
	sprite_frames.add_frame("default", Explosion06_pic)
	sprite_frames.add_frame("default", Explosion07_pic)
	sprite_frames.add_frame("default", Explosion08_pic)
	
	aoe_attack_module.aoe_sprite_frames = sprite_frames
	aoe_attack_module.sprite_frames_only_play_once = true
	aoe_attack_module.pierce = -1
	aoe_attack_module.duration = 0.5
	aoe_attack_module.damage_repeat_count = 1
	
	aoe_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	aoe_attack_module.base_aoe_scene = BaseAOE_Scene
	aoe_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	aoe_attack_module.can_be_commanded_by_tower = false
	
	add_attack_module(aoe_attack_module)
	
	#
	
	_post_inherit_ready()


func _modify_obelisk_bullet(bullet : BaseBullet):
	if !explode_per_hit:
		bullet.connect("on_zero_pierce", self, "_summon_explosion")
	else:
		bullet.connect("hit_an_enemy", self, "_summon_explosion_per_hit")


func _summon_explosion_per_hit(bullet : BaseBullet, enemy):
	_summon_explosion(bullet)

func _summon_explosion(bullet : BaseBullet):
	var pos = bullet.global_position
	
	var aoe = aoe_attack_module.construct_aoe(pos, pos)
	get_tree().get_root().add_child(aoe)


# energy module related

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Arcane bolts explode per enemy hit. This tower's base range is increased by 125, and pierce is increased by 4."
		]


func _module_turned_on(_first_time_per_round : bool):
	explode_per_hit = true
	
	obelisk_range_module.base_range_radius = original_base_range + 125
	obelisk_range_module.update_range()
	
	obelisk_attack_module.base_pierce = original_base_pierce + 4
	obelisk_attack_module.calculate_final_pierce()
	

func _module_turned_off():
	explode_per_hit = false
	
	obelisk_range_module.base_range_radius = original_base_range
	obelisk_range_module.update_range()
	
	obelisk_attack_module.base_pierce = original_base_pierce
	obelisk_attack_module.calculate_final_pierce()
	
