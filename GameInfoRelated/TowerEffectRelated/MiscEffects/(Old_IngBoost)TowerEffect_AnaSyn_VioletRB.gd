extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")


#[
#		"Each absorbed active ingredient gives additional effects.",
#		"Only 10% of the bonus effect is gained when the additional ingredient absorbed is beyond the limit given by relics or natural leveling.",
#		""
#	],

#[
#		"+6 pure on hit damage",
#		"+1 physical on hit damage",
#		"+1 elemental on hit damage",
#		"+15 range"
#	],

const base_lower_ratio : float = 0.1

var base_range_amount : float = 0
var range_effect : TowerAttributesEffect
var range_modi : FlatModifier

var base_phy_on_hit_amount : float = 0
var phy_on_hit_effect : TowerOnHitDamageAdderEffect
var phy_on_hit_modi : FlatModifier

var base_ele_on_hit_amount : float = 0
var ele_on_hit_effect : TowerOnHitDamageAdderEffect
var ele_on_hit_modi : FlatModifier

var base_major_phy_on_hit_amount : float = 0
var major_on_hit_effect : TowerOnHitDamageAdderEffect
var major_on_hit_modi : FlatModifier


func _init().(StoreOfTowerEffectsUUID.VIOLET_RB_GIVER_EFFECT):
	pass


func _make_modifications_to_tower(tower):
	if range_effect == null:
		_construct_effects()
	
	if !tower.is_connected("ingredients_limit_changed", self, "_on_tower_ing_limit_changed"):
		tower.connect("ingredients_limit_changed", self, "_on_tower_ing_limit_changed", [tower], CONNECT_PERSIST | CONNECT_DEFERRED)
		tower.connect("ingredients_absorbed_changed", self, "_on_tower_ing_absorbed_changed", [tower], CONNECT_PERSIST | CONNECT_DEFERRED)
		
		
		if range_effect != null:
			tower.add_tower_effect(range_effect)
		if phy_on_hit_effect != null:
			tower.add_tower_effect(phy_on_hit_effect)
		if ele_on_hit_effect != null:
			tower.add_tower_effect(ele_on_hit_effect)
		if major_on_hit_effect != null:
			tower.add_tower_effect(major_on_hit_effect)
		
		_compute_bonuses_to_give_to_tower(tower)


func _construct_effects():
	_construct_range_effect()
	_construct_phy_effect()
	_construct_ele_effect()
	_construct_major_effect()

func _construct_range_effect():
	range_modi = FlatModifier.new(StoreOfTowerEffectsUUID.VIOLET_RB_RANGE_EFFECT)
	range_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_modi, StoreOfTowerEffectsUUID.VIOLET_RB_RANGE_EFFECT)

func _construct_phy_effect():
	phy_on_hit_modi = FlatModifier.new(StoreOfTowerEffectsUUID.VIOLET_RB_PHY_ON_HIT_EFFECT)
	var phy_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.VIOLET_RB_PHY_ON_HIT_EFFECT, phy_on_hit_modi, DamageType.PHYSICAL)
	phy_on_hit_effect = TowerOnHitDamageAdderEffect.new(phy_on_hit, StoreOfTowerEffectsUUID.VIOLET_RB_PHY_ON_HIT_EFFECT)

func _construct_ele_effect():
	ele_on_hit_modi = FlatModifier.new(StoreOfTowerEffectsUUID.VIOLET_RB_ELE_ON_HIT_EFFECT)
	var ele_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.VIOLET_RB_ELE_ON_HIT_EFFECT, ele_on_hit_modi, DamageType.ELEMENTAL)
	ele_on_hit_effect = TowerOnHitDamageAdderEffect.new(ele_on_hit, StoreOfTowerEffectsUUID.VIOLET_RB_ELE_ON_HIT_EFFECT)

func _construct_major_effect():
	major_on_hit_modi = FlatModifier.new(StoreOfTowerEffectsUUID.VIOLET_RB_MAJOR_ON_HIT_EFFECT)
	var major_on_hit = OnHitDamage.new(StoreOfTowerEffectsUUID.VIOLET_RB_MAJOR_ON_HIT_EFFECT, major_on_hit_modi, DamageType.PURE)
	major_on_hit_effect = TowerOnHitDamageAdderEffect.new(major_on_hit, StoreOfTowerEffectsUUID.VIOLET_RB_MAJOR_ON_HIT_EFFECT)



func _on_tower_ing_limit_changed(new_limit, tower):
	_compute_bonuses_to_give_to_tower(tower)

func _on_tower_ing_absorbed_changed(tower):
	_compute_bonuses_to_give_to_tower(tower)


func _compute_bonuses_to_give_to_tower(tower):
	var limit_id_map : Dictionary = tower._ingredient_id_limit_modifier_map
	var limit_from_level_and_relic : int = 0
	
	for ing_lim_id in limit_id_map:
		if ing_lim_id == StoreOfIngredientLimitModifierID.LEVEL or ing_lim_id == StoreOfIngredientLimitModifierID.RELIC:
			limit_from_level_and_relic += limit_id_map[ing_lim_id]
	
	var limit_from_others = tower.last_calculated_ingredient_limit - limit_from_level_and_relic
	
	
	var ing_absorbed_count = tower.ingredients_absorbed.size()
	if ing_absorbed_count > tower.last_calculated_ingredient_limit:
		ing_absorbed_count = tower.last_calculated_ingredient_limit
	
	
	var ing_from_level_and_relic : int = ing_absorbed_count
	if ing_from_level_and_relic > limit_from_level_and_relic:
		ing_from_level_and_relic = limit_from_level_and_relic
	
	
	var ing_from_others : int = ing_absorbed_count - ing_from_level_and_relic
	if ing_from_others < 0:
		ing_from_others = 0
	
	_change_modi_of_effects(ing_from_level_and_relic, ing_from_others, tower)


func _change_modi_of_effects(ing_from_level_and_relic : int, ing_from_others : int, tower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_RB_RANGE_EFFECT):
		tower.add_tower_effect(range_effect)
	
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_RB_PHY_ON_HIT_EFFECT):
		tower.add_tower_effect(phy_on_hit_effect)
	
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_RB_ELE_ON_HIT_EFFECT):
		tower.add_tower_effect(ele_on_hit_effect)
	
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_RB_MAJOR_ON_HIT_EFFECT):
		tower.add_tower_effect(major_on_hit_effect)
	
	
	if range_modi != null:
		var final_amount = base_range_amount * ing_from_level_and_relic
		final_amount += base_range_amount * base_lower_ratio * ing_from_others
		
		range_modi.flat_modifier = final_amount
		
		for am in tower.all_attack_modules:
			if am != null and am.range_module != null:
				am.range_module.update_range()
	
	if phy_on_hit_modi != null:
		var final_amount = base_phy_on_hit_amount * ing_from_level_and_relic
		final_amount += base_phy_on_hit_amount * base_lower_ratio * ing_from_others
		
		phy_on_hit_modi.flat_modifier = final_amount
	
	if ele_on_hit_modi != null:
		var final_amount = base_ele_on_hit_amount * ing_from_level_and_relic
		final_amount += base_ele_on_hit_amount * base_lower_ratio * ing_from_others
		
		ele_on_hit_modi.flat_modifier = final_amount
	
	if major_on_hit_modi != null:
		var final_amount = base_major_phy_on_hit_amount * ing_from_level_and_relic
		final_amount += base_major_phy_on_hit_amount * base_lower_ratio * ing_from_others
		
		major_on_hit_modi.flat_modifier = final_amount


#

func _undo_modifications_to_tower(tower):
	if tower.is_connected("ingredients_limit_changed", self, "_on_tower_ing_limit_changed"):
		tower.disconnect("ingredients_limit_changed", self, "_on_tower_ing_limit_changed")
		tower.disconnect("ingredients_absorbed_changed", self, "_on_tower_ing_absorbed_changed")
		
		if range_effect != null:
			tower.remove_tower_effect(range_effect)
		if phy_on_hit_effect != null:
			tower.remove_tower_effect(phy_on_hit_effect)
		if ele_on_hit_effect != null:
			tower.remove_tower_effect(ele_on_hit_effect)
		if major_on_hit_effect != null:
			tower.remove_tower_effect(major_on_hit_effect)
