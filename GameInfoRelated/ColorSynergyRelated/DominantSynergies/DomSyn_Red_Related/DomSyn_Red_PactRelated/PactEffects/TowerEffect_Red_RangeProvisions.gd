extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

var range_amount : float
var attk_speed_reduc_amount : float

var _tower

var _attk_speed_reduc_effect : TowerAttributesEffect
var _range_effect : TowerAttributesEffect


func _init().(StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_EFFECT_GIVER):
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
		_remove_range_effect_to_tower()
		_add_attk_speed_reduc_effect_to_tower()
	else:
		_add_range_effect_to_tower()
		_remove_attk_speed_reduc_effect_to_tower()


func _add_range_effect_to_tower():
	if !_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_RANGE_EFFECT):
		_tower.add_tower_effect(_range_effect)

func _remove_range_effect_to_tower():
	var effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_RANGE_EFFECT)
	if effect != null:
		_tower.remove_tower_effect(effect)



func _add_attk_speed_reduc_effect_to_tower():
	if !_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_ATTK_SPEED_REDUC_EFFECT):
		_tower.add_tower_effect(_attk_speed_reduc_effect)

func _remove_attk_speed_reduc_effect_to_tower():
	var effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_ATTK_SPEED_REDUC_EFFECT)
	if effect != null:
		_tower.remove_tower_effect(effect)

###

func _construct_effects():
	var expl_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_ATTK_SPEED_REDUC_EFFECT)
	expl_attr_mod.percent_amount = attk_speed_reduc_amount
	expl_attr_mod.percent_based_on = PercentType.BASE
	
	_attk_speed_reduc_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, expl_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_ATTK_SPEED_REDUC_EFFECT)
	
	#
	
	var base_range_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_RANGE_EFFECT)
	base_range_mod.flat_modifier = range_amount
	
	_range_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE , base_range_mod, StoreOfTowerEffectsUUID.RED_PACT_RANGE_PROVISIONS_RANGE_EFFECT)
	_range_effect.status_bar_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/RangeProvisions_StatusBarIcon.png")

#
# TODO make the status bar icon and pact icon
func _undo_modifications_to_tower(tower):
	if _tower.is_connected("ingredients_absorbed_changed", self, "_on_tower_absorbed_ing_changed"):
		_tower.disconnect("ingredients_absorbed_changed", self, "_on_tower_absorbed_ing_changed")
	
	_remove_range_effect_to_tower()
	_remove_attk_speed_reduc_effect_to_tower()


