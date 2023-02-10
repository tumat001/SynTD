extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Scatter_Fragment01 = preload("res://TowerRelated/Color_Orange/Scatter/Scatter_Fragment/Scatter_Fragment01.png")
const Scatter_Fragment02 = preload("res://TowerRelated/Color_Orange/Scatter/Scatter_Fragment/Scatter_Fragment02.png")
const Scatter_Fragment03 = preload("res://TowerRelated/Color_Orange/Scatter/Scatter_Fragment/Scatter_Fragment03.png")
const Scatter_Fragment04 = preload("res://TowerRelated/Color_Orange/Scatter/Scatter_Fragment/Scatter_Fragment04.png")


var scatter_attack_module : BulletAttackModule

var rng : RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SCATTER)
	
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
	range_module.position.y += 9
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 480#400
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.base_proj_inaccuracy = 25
	attack_module.position.y -= 9
	
	attack_module.burst_amount = 3
	attack_module.burst_attack_speed = 50
	attack_module.has_burst = true
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 4)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Scatter_Fragment01)
	
	#attack_module.connect("in_attack", self, "_scatter_attack_module_in_attack", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	attack_module.connect("before_bullet_is_shot", self, "_modify_bullet", [], CONNECT_PERSIST)
	scatter_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	#
	
	rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	#
	
	_post_inherit_ready()


func _modify_bullet(bullet : BaseBullet):
	var rand_num = rng.randi_range(1, 4)
	
	if rand_num == 1:
		bullet.set_texture_as_sprite_frames(Scatter_Fragment01)
	elif rand_num == 2:
		bullet.set_texture_as_sprite_frames(Scatter_Fragment02)
	elif rand_num == 3:
		bullet.set_texture_as_sprite_frames(Scatter_Fragment03)
	elif rand_num == 4:
		bullet.set_texture_as_sprite_frames(Scatter_Fragment04)


# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 1
	.set_heat_module(module)

func _construct_heat_effect():
	var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_dmg_attr_mod.flat_modifier = 2.5
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module.benefits_from_bonus_base_damage:
			module.calculate_final_base_damage()
	
	emit_signal("final_base_damage_changed")

