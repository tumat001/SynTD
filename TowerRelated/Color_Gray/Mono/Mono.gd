extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const MonoBullet_pic = preload("res://TowerRelated/Color_Gray/Mono/Mono_Bullet.png")

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.MONO)
	
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
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 600
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 3
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(MonoBullet_pic)
	
	add_attack_module(attack_module)
	
	
	_post_inherit_ready()


## How to add: on hit damager adder effect
#func _post_inherit_ready():
#	._post_inherit_ready()
#	
#	var extra_on_hit_modifier : PercentModifier = PercentModifier.new("1")
#	extra_on_hit_modifier.percent_amount = 50
#	extra_on_hit_modifier.percent_based_on = PercentType.MISSING
#	var extra_on_hit : OnHitDamage = OnHitDamage.new("1", extra_on_hit_modifier, DamageType.PHYSICAL)
#	var on_hit_damage_adder_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(extra_on_hit, 1)
#	
#	add_tower_effect(on_hit_damage_adder_effect)
