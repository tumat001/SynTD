extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const BrownSeed_Pic = preload("res://TowerRelated/Color_Yellow/Sunflower/BrownSeed.png")
const GreenSeed_Pic = preload("res://TowerRelated/Color_Yellow/Sunflower/GreenSeed.png")
const YellowSeed_Pic = preload("res://TowerRelated/Color_Yellow/Sunflower/YellowSeed.png")

const base_sunflower_burst_amount : int = 7
const sunflower_original_inaccuracy : float = 30.0
var sunflower_attack_module : BulletAttackModule
var cycle : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SUNFLOWER)
	
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
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage_scale = 1
	attack_module.base_damage = info.base_damage / attack_module.base_damage_scale
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 530
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.base_proj_inaccuracy = sunflower_original_inaccuracy
	
	attack_module.burst_amount = base_sunflower_burst_amount
	attack_module.burst_attack_speed = 12
	attack_module.has_burst = true
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 3
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	attack_module.connect("before_bullet_is_shot", self, "_modify_bullet", [], CONNECT_PERSIST)
	
	sunflower_attack_module = attack_module
	add_attack_module(attack_module)
	
	_post_inherit_ready()


func _modify_bullet(bullet : BaseBullet):
	if cycle == 0:
		bullet.set_texture_as_sprite_frames(BrownSeed_Pic)
	elif cycle == 1:
		bullet.set_texture_as_sprite_frames(GreenSeed_Pic)
	elif cycle == 2:
		bullet.set_texture_as_sprite_frames(YellowSeed_Pic)
	
	cycle += 1
	if cycle >= 3:
		cycle = 0


# energy module

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Greatly increases sunflower's accuracy. Attacks in bursts of 12 instead."
		]


func _module_turned_on(_first_time_per_round : bool):
	sunflower_attack_module.base_proj_inaccuracy = 3
	sunflower_attack_module.calculate_final_proj_inaccuracy()
	sunflower_attack_module.burst_amount = 12

func _module_turned_off():
	sunflower_attack_module.base_proj_inaccuracy = sunflower_original_inaccuracy
	sunflower_attack_module.calculate_final_proj_inaccuracy()
	sunflower_attack_module.burst_amount = base_sunflower_burst_amount
