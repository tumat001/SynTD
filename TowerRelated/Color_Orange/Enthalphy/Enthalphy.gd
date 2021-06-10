extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

const Enthalphy_HitParticle01 = preload("res://TowerRelated/Color_Orange/Enthalphy/Enthalphy_AttkSprite/Enthalphy_AttkSprite01.png")
const Enthalphy_HitParticle02 = preload("res://TowerRelated/Color_Orange/Enthalphy/Enthalphy_AttkSprite/Enthalphy_AttkSprite02.png")
const Enthalphy_HitParticle03 = preload("res://TowerRelated/Color_Orange/Enthalphy/Enthalphy_AttkSprite/Enthalphy_AttkSprite03.png")
const Enthalphy_HitParticle04 = preload("res://TowerRelated/Color_Orange/Enthalphy/Enthalphy_AttkSprite/Enthalphy_AttkSprite04.png")
const Enthalphy_HitParticle05 = preload("res://TowerRelated/Color_Orange/Enthalphy/Enthalphy_AttkSprite/Enthalphy_AttkSprite05.png")
const Enthalphy_HitParticle06 = preload("res://TowerRelated/Color_Orange/Enthalphy/Enthalphy_AttkSprite/Enthalphy_AttkSprite06.png")

var effect_kill_on_hit_dmg : TowerOnHitDamageAdderEffect
var effect_range_based_on_hit_dmg : TowerOnHitDamageAdderEffect
var range_based_modifier : FlatModifier

const range_bonus_damage_ratio : float = 0.0125 # 40 range = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.RE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0.5
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.base_on_hit_damage_internal_name = "enthalphy_base_damage"
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = true
	
	var en_atk_sprite := SpriteFrames.new()
	en_atk_sprite.add_frame("default", Enthalphy_HitParticle01)
	en_atk_sprite.add_frame("default", Enthalphy_HitParticle02)
	en_atk_sprite.add_frame("default", Enthalphy_HitParticle03)
	en_atk_sprite.add_frame("default", Enthalphy_HitParticle04)
	en_atk_sprite.add_frame("default", Enthalphy_HitParticle05)
	en_atk_sprite.add_frame("default", Enthalphy_HitParticle06)
	
	attack_module.attack_sprite_scene = AttackSprite_Scene
	attack_module.attack_sprite_sprite_frames = en_atk_sprite
	
	_construct_on_hit_damage()
	
	attack_module.connect("on_post_mitigation_damage_dealt", self, "_check_if_enemy_hit_is_killed")
	connect("final_range_changed", self, "_on_main_range_changed")
	
	add_attack_module(attack_module)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	add_tower_effect(effect_range_based_on_hit_dmg)


func _construct_on_hit_damage():
	# Kill
	var modi : FlatModifier = FlatModifier.new("enthalphy_kill_bonus")
	modi.flat_modifier = 1.25
	
	var on_hit_dmg : OnHitDamage = OnHitDamage.new("enthalphy_kill_bonus", modi, DamageType.ELEMENTAL)
	
	effect_kill_on_hit_dmg = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.ENTHALPHY_KILL_ELE_ON_HIT)
	effect_kill_on_hit_dmg.is_countbound = true
	effect_kill_on_hit_dmg.count = 2
	
	
	# Range
	range_based_modifier = FlatModifier.new("enthalphy_range_bonus")
	range_based_modifier.flat_modifier = 0
	
	var r_on_hit_dmg : OnHitDamage = OnHitDamage.new("enthalphy_range_bonus", range_based_modifier, DamageType.ELEMENTAL)
	
	effect_range_based_on_hit_dmg = TowerOnHitDamageAdderEffect.new(r_on_hit_dmg, StoreOfTowerEffectsUUID.ENTHALPHY_RANGE_ELE_ON_HIT)


# range related

func _on_main_range_changed():
	var range_diff : float = main_attack_module.range_module.last_calculated_final_range - main_attack_module.range_module.base_range_radius
	var bonus_dmg = range_diff / range_bonus_damage_ratio
	
	range_based_modifier.flat_modifier = bonus_dmg


# kill related

func _check_if_enemy_hit_is_killed(damage, damage_type, killed, enemy, damage_register_id, module):
	if killed:
		add_tower_effect(effect_kill_on_hit_dmg._shallow_duplicate())

