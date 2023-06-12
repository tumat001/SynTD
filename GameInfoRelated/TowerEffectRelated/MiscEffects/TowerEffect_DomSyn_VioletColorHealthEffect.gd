extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")


#

var _flat_health_per_ing_effect

var _attached_tower

var _health_modi : FlatModifier

var _prev_active_ing_count : int = -1

#

func _init(arg_flat_health_per_ing_effect).(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_HEALTH_EFFECT_GIVER):
	_flat_health_per_ing_effect = arg_flat_health_per_ing_effect
	

func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	_give_health_effect()
	_update_health_effect()
	
	if !tower.is_connected("ingredients_absorbed_changed", self, "_on_ingredients_absorbed_changed"):
		tower.connect("ingredients_absorbed_changed", self, "_on_ingredients_absorbed_changed", [], CONNECT_PERSIST)
	if !tower.is_connected("ingredients_limit_changed", self, "_on_ingredients_limit_changed"):
		tower.connect("ingredients_limit_changed", self, "_on_ingredients_limit_changed", [], CONNECT_PERSIST)
	if !tower.is_connected("on_ingredient_absorbed", self, "_on_ingredient_absorbed"):
		tower.connect("on_ingredient_absorbed", self, "_on_ingredient_absorbed", [], CONNECT_PERSIST)

###

func _give_health_effect():
	_health_modi = FlatModifier.new(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_HEALTH_EFFECT)
	_health_modi.flat_modifier = 0
	var health_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_HEALTH, _health_modi, StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_HEALTH_EFFECT)
	_attached_tower.add_tower_effect(health_effect)
	

func _update_health_effect():
	var active_ing_count = _attached_tower.get_amount_of_ingredients_absorbed()
	if _attached_tower.last_calculated_ingredient_limit < active_ing_count:
		active_ing_count = _attached_tower.last_calculated_ingredient_limit
	
	if _prev_active_ing_count != active_ing_count:
		_health_modi.flat_modifier = active_ing_count * _flat_health_per_ing_effect
		_attached_tower._calculate_max_health()
		
		_prev_active_ing_count = active_ing_count


func _on_ingredients_absorbed_changed():
	_update_health_effect()

func _on_ingredients_limit_changed(arg_new_limit):
	_update_health_effect()

func _on_ingredient_absorbed(arg_ing):
	#call_deferred("_apply_heal")
	_apply_heal()


func _apply_heal():
	if is_instance_valid(_attached_tower):
		pass
		# does nothing
		#_attached_tower.call_deferred("update_current_health__from_adding_health_effect", true)
		
		# heals by amount in param...
		#_attached_tower.call_deferred("heal_by_amount", _flat_health_per_ing_effect * _attached_tower.last_calculated_ingredient_limit)
		
		
		#print("heal max: %s. curr: %s. id: %s" % [_attached_tower.last_calculated_max_health, _attached_tower.current_health, _attached_tower.tower_id])
		

########

func _undo_modifications_to_tower(tower):
	if tower.is_connected("ingredients_absorbed_changed", self, "_on_ingredients_absorbed_changed"):
		tower.disconnect("ingredients_absorbed_changed", self, "_on_ingredients_absorbed_changed")
	if tower.is_connected("ingredients_limit_changed", self, "_on_ingredients_limit_changed"):
		tower.disconnect("ingredients_limit_changed", self, "_on_ingredients_limit_changed")
	if tower.is_connected("on_ingredient_absorbed", self, "_on_ingredient_absorbed"):
		tower.disconnect("on_ingredient_absorbed", self, "_on_ingredient_absorbed")
	
	
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_HEALTH_EFFECT)
	if effect != null:
		tower.remove_tower_effect(effect)


