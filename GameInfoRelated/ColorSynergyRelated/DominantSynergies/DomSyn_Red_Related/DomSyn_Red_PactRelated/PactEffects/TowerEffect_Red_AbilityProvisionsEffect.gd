extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

var ability_potency_amount : float
var attk_speed_reduc_amount : float

var _tower

var _attk_speed_reduc_effect : TowerAttributesEffect
var _ability_potency_effect : TowerAttributesEffect

func _init().(StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_EFFECT_GIVER):
	pass


func _make_modifications_to_tower(tower):
	_construct_effects()
	
	_tower = tower
	
	if !_tower.is_connected("ingredients_absorbed_changed", self, "_on_tower_absorbed_ing_changed"):
		_tower.connect("ingredients_absorbed_changed", self, "_on_tower_absorbed_ing_changed", [], CONNECT_PERSIST)
	
	_give_appropriate_effect_based_on_ings()


func _on_tower_absorbed_ing_changed():
	_give_appropriate_effect_based_on_ings()

func _give_appropriate_effect_based_on_ings():
	if _tower.get_amount_of_ingredients_absorbed() > 0:
		_remove_ap_effect_to_tower()
		_add_attk_speed_reduc_effect_to_tower()
	else:
		_add_ap_effect_to_tower()
		_remove_attk_speed_reduc_effect_to_tower()


func _add_ap_effect_to_tower():
	if !_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_AP_EFFECT):
		_tower.add_tower_effect(_ability_potency_effect)

func _remove_ap_effect_to_tower():
	var effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_AP_EFFECT)
	if effect != null:
		_tower.remove_tower_effect(effect)



func _add_attk_speed_reduc_effect_to_tower():
	if !_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_ATTK_SPEED_EFFECT):
		_tower.add_tower_effect(_attk_speed_reduc_effect)

func _remove_attk_speed_reduc_effect_to_tower():
	var effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_ATTK_SPEED_EFFECT)
	if effect != null:
		_tower.remove_tower_effect(effect)

###

func _construct_effects():
	var expl_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_ATTK_SPEED_EFFECT)
	expl_attr_mod.percent_amount = attk_speed_reduc_amount
	expl_attr_mod.percent_based_on = PercentType.BASE
	
	_attk_speed_reduc_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, expl_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_ATTK_SPEED_EFFECT)
	
	#
	
	var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_AP_EFFECT)
	base_ap_attr_mod.flat_modifier = ability_potency_amount
	
	_ability_potency_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_AP_EFFECT)
	_ability_potency_effect.status_bar_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/AbilityProvisions_StatusBarIcon.png")

#

func _undo_modifications_to_tower(tower):
	if _tower.is_connected("ingredients_absorbed_changed", self, "_on_tower_absorbed_ing_changed"):
		_tower.disconnect("ingredients_absorbed_changed", self, "_on_tower_absorbed_ing_changed")
	
	_remove_ap_effect_to_tower()
	_remove_attk_speed_reduc_effect_to_tower()



