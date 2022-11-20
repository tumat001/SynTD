extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

const Coal_Proj01 = preload("res://TowerRelated/Color_Orange/CoalLauncher/Coal_Proj/Coal_Proj01.png")
const Coal_Proj02 = preload("res://TowerRelated/Color_Orange/CoalLauncher/Coal_Proj/Coal_Proj02.png")

const burn_duration_inc : float = 3.0

var coal_attack_module : BulletAttackModule
var burn_effect_ids_to_inc : Array = [
	StoreOfEnemyEffectsUUID.ING_EMBER_BURN,
	StoreOfEnemyEffectsUUID.EMBER_BURN,
	
	StoreOfEnemyEffectsUUID._704_FIRE_BURN,
	StoreOfEnemyEffectsUUID.ROYAL_FLAME_BURN,
	StoreOfEnemyEffectsUUID.ING_RED_FRUIT_BURN,
	StoreOfEnemyEffectsUUID.ASHEND_BURN_EFFECT
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.COAL_LAUNCHER)
	
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
	range_module.position.y += 6
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 552#460
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 6
	
	#var bullet_shape = RectangleShape2D.new()
	#bullet_shape.extents = Vector2(7, 4)
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 4
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Coal_Proj01)
	
	attack_module.connect("before_bullet_is_shot", self, "_modify_bullet", [], CONNECT_PERSIST)
	attack_module.connect("on_enemy_hit", self, "_on_coal_hit_enemy", [], CONNECT_PERSIST)
	coal_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	
	_post_inherit_ready()


func _modify_bullet(bullet : BaseBullet):
	var rng := StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	var rand_num = rng.randi_range(1, 2)
	
	if rand_num == 1:
		bullet.set_texture_as_sprite_frames(Coal_Proj01)
	elif rand_num == 2:
		bullet.set_texture_as_sprite_frames(Coal_Proj02)


func _on_coal_hit_enemy(enemy : AbstractEnemy, damage_reg_id, damage_instance, module):
	for eff_id in enemy._dmg_over_time_id_effects_map.keys():
		if burn_effect_ids_to_inc.has(eff_id):
			enemy._dmg_over_time_id_effects_map[eff_id].time_in_seconds += burn_duration_inc


# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 1
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
