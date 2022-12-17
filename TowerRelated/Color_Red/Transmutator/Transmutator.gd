extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const EnemyHealEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyHealEffect.gd")

const Transmutator_Proj = preload("res://TowerRelated/Color_Red/Transmutator/Transmutator_Attks/Transmutator_Proj.png")


const base_slow_percent : float = -35.0
const base_slow_duration : float = 1.5
const base_max_health_reduc_percent : float = -12.5
const min_max_health_reduc_amount : float = -25.0
const max_max_health_reduc_amount : float = -5.0
#const base_heal_ratio : float = 3.0

var enemy_slow_modi : PercentModifier
var enemy_slow_effect : EnemyAttributesEffect

var enemy_max_health_modi : PercentModifier
var enemy_max_health_reduc_effect : EnemyAttributesEffect

#var enemy_heal_modi : FlatModifier
#var enemy_heal_effect : EnemyHealEffect

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.TRANSMUTATOR)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var attack_module_y_shift : float = 5.0
	
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
	attack_module.base_proj_speed = 408#340
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attack_module_y_shift
	
	attack_module.benefits_from_bonus_on_hit_damage = false
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(9, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Transmutator_Proj)
	
	attack_module.is_displayed_in_tracker = false
	
	add_attack_module(attack_module)
	
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy_t", [], CONNECT_PERSIST)
	
	_construct_effects()
	
	_post_inherit_ready()


func _construct_effects():
	enemy_slow_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.TRANSMUTATOR_SLOW_EFFECT)
	enemy_slow_modi.percent_based_on = PercentType.BASE
	enemy_slow_modi.percent_amount = base_slow_percent
	
	enemy_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_MOV_SPEED, enemy_slow_modi, StoreOfEnemyEffectsUUID.TRANSMUTATOR_SLOW_EFFECT)
	enemy_slow_effect.time_in_seconds = base_slow_duration
	enemy_slow_effect.is_timebound = true
	
	#
	enemy_max_health_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.TRANSMUTATOR_MAX_HEALTH_REDUCTION_EFFECT)
	enemy_max_health_modi.percent_based_on = PercentType.BASE
	enemy_max_health_modi.ignore_flat_limits = false
	enemy_max_health_modi.flat_minimum = min_max_health_reduc_amount
	enemy_max_health_modi.flat_maximum = max_max_health_reduc_amount
	
	enemy_max_health_reduc_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_HEALTH, enemy_max_health_modi, StoreOfEnemyEffectsUUID.TRANSMUTATOR_MAX_HEALTH_REDUCTION_EFFECT)
	enemy_max_health_reduc_effect.is_timebound = false
	
	#
	#enemy_heal_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.TRANSMUTATOR_HEAL)
	
	#enemy_heal_effect = EnemyHealEffect.new(enemy_heal_modi, StoreOfEnemyEffectsUUID.TRANSMUTATOR_HEAL)


#

func _on_main_attack_hit_enemy_t(enemy, damage_register_id, damage_instance, module):
	var health_ratio : float = enemy.current_health / enemy._last_calculated_max_health
	
	damage_instance.on_hit_damages.clear()
	
	if health_ratio == 1:
		var copy_of_max_health_reduc : EnemyAttributesEffect  = enemy_max_health_reduc_effect._get_copy_scaled_by(1)
		copy_of_max_health_reduc.attribute_as_modifier.percent_amount = base_max_health_reduc_percent * last_calculated_final_ability_potency
		copy_of_max_health_reduc.attribute_as_modifier.flat_maximum = max_max_health_reduc_amount * last_calculated_final_ability_potency 
		
		damage_instance.on_hit_effects[StoreOfEnemyEffectsUUID.TRANSMUTATOR_MAX_HEALTH_REDUCTION_EFFECT] = copy_of_max_health_reduc
		
		
	else:
		#var copy_of_heal_eff = enemy_heal_effect._get_copy_scaled_by(1)
		
		#if is_instance_valid(main_attack_module):
		#	#copy_of_heal_eff.heal_as_modifier.flat_modifier = main_attack_module.last_calculated_final_damage * base_heal_ratio
		#	#damage_instance.on_hit_effects[StoreOfEnemyEffectsUUID.TRANSMUTATOR_HEAL] = copy_of_heal_eff
		#	pass
		
		damage_instance.on_hit_effects[StoreOfEnemyEffectsUUID.TRANSMUTATOR_SLOW_EFFECT] = enemy_slow_effect._get_copy_scaled_by(1)


# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 1
	.set_heat_module(module)

func _construct_heat_effect():
	var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	attr_mod.flat_modifier = 0.5
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	_calculate_final_ability_potency()
