extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const IEU_AttkSprite = preload("res://TowerRelated/Color_Orange/IEU/IEU_AttkSprite/IEU_AttkSprite.tscn")

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")


var ieu_entropy_attk_speed_effect : TowerAttributesEffect
var as_mod : PercentModifier
var ieu_enthalphy_range_effect : TowerAttributesEffect
var range_mod : FlatModifier

var absorbed_entropy_attk_speed_rounds_left : Array = []
var absorbed_enthalphy_range_rounds_left : Array = []

const round_duration : int = 5

const first_absorbed_entropy_attk_speed_buff : float = 60.0
const subsequent_absorbed_entropy_attk_speed_buff : float = 20.0

const first_absorbed_enthalphy_range_buff : float = 125.0
const subsequent_absorbed_enthalphy_range_buff : float = 45.0

var energy_module_is_on : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.IEU)
	
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
	
	attack_module.attack_sprite_scene = IEU_AttkSprite
	attack_module.attack_sprite_match_lifetime_to_windup = true
	attack_module.attack_sprite_show_in_windup = true
	attack_module.attack_sprite_show_in_attack = false
	
	
	_construct_effects()
	
	add_attack_module(attack_module)
	
	connect("on_round_end", self, "_ieu_on_round_end", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	add_tower_effect(ieu_enthalphy_range_effect)
	add_tower_effect(ieu_entropy_attk_speed_effect)


func _construct_effects():
	# First
	as_mod = PercentModifier.new(StoreOfTowerEffectsUUID.IEU_ATTK_SPEED)
	as_mod.percent_amount = 0
	
	ieu_entropy_attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, as_mod, StoreOfTowerEffectsUUID.IEU_ATTK_SPEED)
	
	
	# Second
	range_mod = FlatModifier.new(StoreOfTowerEffectsUUID.IEU_RANGE)
	range_mod.flat_modifier = 0
	
	ieu_enthalphy_range_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_mod, StoreOfTowerEffectsUUID.IEU_RANGE)


# Absorb

func _can_accept_ingredient(ingredient_effect : IngredientEffect, tower_selected) -> bool:
	if ingredient_effect.tower_id == Towers.ENTHALPHY or ingredient_effect.tower_id == Towers.ENTROPY:
		return true
	
	return ._can_accept_ingredient(ingredient_effect, tower_selected)


func absorb_ingredient(ingredient_effect : IngredientEffect, ingredient_gold_base_cost : int):
	if ingredient_effect != null:
		if ingredient_effect.tower_id == Towers.ENTHALPHY:
			_enthalphy_absorbed()
			return
			
		elif ingredient_effect.tower_id == Towers.ENTROPY:
			_entropy_absorbed()
			return
	
	.absorb_ingredient(ingredient_effect, ingredient_gold_base_cost)


func _enthalphy_absorbed():
	absorbed_enthalphy_range_rounds_left.push_front(round_duration)
	
	_update_range_buff()

func _entropy_absorbed():
	absorbed_entropy_attk_speed_rounds_left.push_front(round_duration)
	
	_update_attk_speed_buff()


# Calculation

func _calculate_entropy_attk_speed():
	var size_of_absorbed : int = absorbed_entropy_attk_speed_rounds_left.size()
	var attks = subsequent_absorbed_entropy_attk_speed_buff * size_of_absorbed
	
	if size_of_absorbed != 0:
		attks -= subsequent_absorbed_entropy_attk_speed_buff
		attks += first_absorbed_entropy_attk_speed_buff
	
	return attks

func _calculate_enthalphy_range():
	var size_of_absorbed : int = absorbed_enthalphy_range_rounds_left.size()
	var rnge = subsequent_absorbed_enthalphy_range_buff * size_of_absorbed
	
	if size_of_absorbed != 0:
		rnge -= subsequent_absorbed_enthalphy_range_buff
		rnge += first_absorbed_enthalphy_range_buff
	
	return rnge


# round end

func _ieu_on_round_end():
	if !energy_module_is_on:
		for i in absorbed_enthalphy_range_rounds_left.size():
			absorbed_enthalphy_range_rounds_left[i] -= 1
		
		for i in absorbed_entropy_attk_speed_rounds_left.size():
			absorbed_entropy_attk_speed_rounds_left[i] -= 1
	
	while absorbed_enthalphy_range_rounds_left.find_last(0) != -1:
		absorbed_enthalphy_range_rounds_left.pop_back()
	
	while absorbed_entropy_attk_speed_rounds_left.find_last(0) != -1:
		absorbed_entropy_attk_speed_rounds_left.pop_back()
	
	_update_as_and_range_buff()


func _update_as_and_range_buff():
	as_mod.percent_amount = _calculate_entropy_attk_speed()
	range_mod.flat_modifier = _calculate_enthalphy_range()
	
	for am in all_attack_modules:
		if am.range_module.benefits_from_bonus_range:
			am.range_module.update_range()
		if am.benefits_from_bonus_attack_speed:
			am.calculate_all_speed_related_attributes()
			emit_signal("final_attack_speed_changed")


func _update_attk_speed_buff():
	as_mod.percent_amount = _calculate_entropy_attk_speed()
	
	for am in all_attack_modules:
		if am.benefits_from_bonus_attack_speed:
			am.calculate_all_speed_related_attributes()
			emit_signal("final_attack_speed_changed")

func _update_range_buff():
	range_mod.flat_modifier = _calculate_enthalphy_range()
	
	for am in all_attack_modules:
		if am.range_module.benefits_from_bonus_range:
			am.range_module.update_range()


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


# Enetgy module

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Absorbed buffs's round duration is not decreased."
		]


func _module_turned_on(_first_time_per_round : bool):
	energy_module_is_on = true

func _module_turned_off():
	energy_module_is_on = false
