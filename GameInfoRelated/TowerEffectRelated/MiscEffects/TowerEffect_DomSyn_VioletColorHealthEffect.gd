extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")


#

var _flat_health_per_ing_effect

var _attached_tower

var _health_modi : FlatModifier

#

func _init(arg_flat_health_per_ing_effect).(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_HEALTH_EFFECT_GIVER):
	_flat_health_per_ing_effect = arg_flat_health_per_ing_effect
	

func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	_give_health_effect()
	_update_health_effect()
	
	if !tower.is_connected("ingredients_absorbed_changed", self, "_on_ingredients_absorbed_changed"):
		tower.connect("ingredients_absorbed_changed", self, "_on_ingredients_absorbed_changed", [], CONNECT_PERSIST)


###

func _give_health_effect():
	_health_modi = FlatModifier.new(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_HEALTH_EFFECT)
	_health_modi.flat_modifier = 0
	var health_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_HEALTH, _health_modi, StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_HEALTH_EFFECT)
	_attached_tower.add_tower_effect(health_effect)
	

func _update_health_effect():
	_health_modi.flat_modifier = _attached_tower.get_amount_of_ingredients_absorbed() * _flat_health_per_ing_effect
	_attached_tower._calculate_max_health()



func _on_ingredients_absorbed_changed():
	_update_health_effect()


########

func _undo_modifications_to_tower(tower):
	if tower.is_connected("ingredients_absorbed_changed", self, "_on_ingredients_absorbed_changed"):
		tower.disconnect("ingredients_absorbed_changed", self, "_on_ingredients_absorbed_changed")
