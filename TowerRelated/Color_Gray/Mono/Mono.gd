extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule = preload("res://TowerRelated/BulletAttackModule.gd")
const BulletAttackModule_Scene = preload("res://TowerRelated/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/BaseBullet.tscn")

const MonoBullet_pic = preload("res://TowerRelated/Color_Gray/Mono/Mono_Bullet.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.MONO)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_name = "mono_base_damage"
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 600
	attack_module.projectile_life_distance = info.base_range
	attack_module.module_name = "Main"
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 3
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(MonoBullet_pic)
	
	attack_modules_and_target_num[attack_module] = 1
	
	
	_post_inherit_ready()

