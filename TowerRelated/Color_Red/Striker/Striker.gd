extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const StrikerProj_Empowered_Pic = preload("res://TowerRelated/Color_Red/Striker/Striker_Attks/StrikerProj_Empowered.png")
const StrikerProj_Normal_Pic = preload("res://TowerRelated/Color_Red/Striker/Striker_Attks/StrikerProj_Normal.png")
const StrikerProj_Super_Pic = preload("res://TowerRelated/Color_Red/Striker/Striker_Attks/StrikerProj_SuperEmp.png")


const super_bonus_dmg : float = 2.5
const empowered_bonus_dmg : float = 1.0

const super_streak : int = 9
const empowered_streak : int = 3

var super_on_hit : OnHitDamage
var empowered_on_hit : OnHitDamage

var current_attk_streak : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.STRIKER)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var attack_module_y_shift : float = 6.0
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attack_module_y_shift
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 580#480
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attack_module_y_shift
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(6, 3)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	add_attack_module(attack_module)
	
	attack_module.connect("before_bullet_is_shot", self, "_before_arrow_is_shot", [], CONNECT_PERSIST)
	
	connect("on_main_attack", self, "_on_main_attack_s", [], CONNECT_PERSIST)
	connect("on_main_attack_module_damage_instance_constructed", self, "_on_main_dmg_instance_constructed_s", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_s", [], CONNECT_PERSIST)
	
	_construct_on_hits()
	
	_post_inherit_ready()


func _construct_on_hits():
	var super_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.STRIKER_BONUS_DMG)
	super_modi.flat_modifier = super_bonus_dmg
	super_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.STRIKER_BONUS_DMG, super_modi, DamageType.PHYSICAL)
	
	var emp_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.STRIKER_BONUS_DMG)
	emp_modi.flat_modifier = empowered_bonus_dmg
	empowered_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.STRIKER_BONUS_DMG, emp_modi, DamageType.PHYSICAL)
	


#

func _on_main_attack_s(attk_speed_delay, enemies, module):
	current_attk_streak += 1

func _on_main_dmg_instance_constructed_s(damage_instance, module):
	if current_attk_streak % super_streak == 0:
		damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.STRIKER_BONUS_DMG] = super_on_hit
	elif current_attk_streak % empowered_streak == 0:
		damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.STRIKER_BONUS_DMG] = empowered_on_hit


func _before_arrow_is_shot(bullet):
	var to_use_texture : Texture
	if current_attk_streak % super_streak == 0:
		to_use_texture = StrikerProj_Super_Pic
	elif current_attk_streak % empowered_streak == 0:
		to_use_texture = StrikerProj_Empowered_Pic
	else:
		to_use_texture = StrikerProj_Normal_Pic
	
	bullet.set_texture_as_sprite_frames(to_use_texture)


#
func _on_round_end_s():
	current_attk_streak = 0



# HeatModule

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
