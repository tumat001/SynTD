extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const EnthalphyAttackSprite = preload("res://TowerRelated/Color_Orange/Enthalphy/Enthalphy_AttkSprite/EnthalphyAttkSprite.tscn")

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

var effect_kill_on_hit_dmg : TowerOnHitDamageAdderEffect
var effect_range_based_on_hit_dmg : TowerOnHitDamageAdderEffect
var range_based_modifier : FlatModifier

const range_bonus_damage_ratio : float = 0.01875 # 40 range = 0.75


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.ENTHALPHY)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 6
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.attack_sprite_scene = EnthalphyAttackSprite
	attack_module.attack_sprite_match_lifetime_to_windup = true
	attack_module.attack_sprite_show_in_windup = true
	attack_module.attack_sprite_show_in_attack = false
	
	
	_construct_on_hit_damage()
	
	attack_module.connect("on_post_mitigation_damage_dealt", self, "_check_if_enemy_hit_is_killed", [], CONNECT_PERSIST)
	connect("final_range_changed", self, "_on_main_range_changed", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	add_tower_effect(effect_range_based_on_hit_dmg)


func _construct_on_hit_damage():
	# Kill
	var modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ENTHALPHY_KILL_ELE_ON_HIT)
	modi.flat_modifier = 1.25
	
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ENTHALPHY_KILL_ELE_ON_HIT, modi, DamageType.ELEMENTAL)
	
	effect_kill_on_hit_dmg = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.ENTHALPHY_KILL_ELE_ON_HIT)
	effect_kill_on_hit_dmg.is_countbound = true
	effect_kill_on_hit_dmg.count = 3
	
	
	# Range
	range_based_modifier = FlatModifier.new(StoreOfTowerEffectsUUID.ENTHALPHY_RANGE_ELE_ON_HIT)
	range_based_modifier.flat_modifier = 0
	
	var r_on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ENTHALPHY_RANGE_ELE_ON_HIT, range_based_modifier, DamageType.ELEMENTAL)
	
	effect_range_based_on_hit_dmg = TowerOnHitDamageAdderEffect.new(r_on_hit_dmg, StoreOfTowerEffectsUUID.ENTHALPHY_RANGE_ELE_ON_HIT)


# range related

func _on_main_range_changed():
	var bonus_range : float = main_attack_module.range_module.last_calculated_final_range - main_attack_module.range_module.base_range_radius
	var bonus_dmg = bonus_range * range_bonus_damage_ratio
	
	range_based_modifier.flat_modifier = bonus_dmg


# kill related

func _check_if_enemy_hit_is_killed(damage_report, killed, enemy, damage_register_id, module):
	if killed:
		add_tower_effect(effect_kill_on_hit_dmg._shallow_duplicate())


# Heat Module



# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 1
	.set_heat_module(module)

func _construct_heat_effect():
	var base_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_attr_mod.flat_modifier = 50
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE , base_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if is_instance_valid(module.range_module) and module.range_module.benefits_from_bonus_range:
			module.range_module.update_range()
	
	emit_signal("final_range_changed")

