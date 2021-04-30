extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule = preload("res://TowerRelated/BulletAttackModule.gd")
const BulletAttackModule_Scene = preload("res://TowerRelated/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/BaseBullet.tscn")

# TODO REPLACE THIS SOON
const SimpleObeliskBullet_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Ana_BlueVioletGreen.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SIMPLE_OBELISK)
	
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
	attack_module.base_on_hit_damage_internal_name = "simple_obelisk_base_damage"
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 600
	attack_module.projectile_life_distance = info.base_range
	attack_module.module_name = "Main"
	
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(SimpleObeliskBullet_pic)
	
	attack_modules_and_target_num[attack_module] = 1
	
	
	_post_inherit_ready()
