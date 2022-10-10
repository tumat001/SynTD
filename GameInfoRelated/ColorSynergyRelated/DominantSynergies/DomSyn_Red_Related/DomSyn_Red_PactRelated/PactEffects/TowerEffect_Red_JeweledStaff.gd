extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

var _pact_source
var _ap_effect : TowerAttributesEffect
var _ap_modi : FlatModifier
var _tower

func _init(arg_pact).(StoreOfTowerEffectsUUID.RED_PACT_JEWELED_STAFF_EFFECT):
	_pact_source = arg_pact
	

#

func _make_modifications_to_tower(arg_tower):
	if _pact_source != null:
		_pact_source.connect("on_current_ap_amount_changed", self, "_on_source_ap_changed", [], CONNECT_PERSIST)
	
	_tower = arg_tower
	
	if is_instance_valid(_tower):
		_construct_effect()
		_tower.add_tower_effect(_ap_effect)

func _construct_effect():
	_ap_modi = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_JEWELED_STAFF_BONUS_AP_EFFECT)
	_ap_modi.flat_modifier = _pact_source._current_ap_amount
	
	
	_ap_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, _ap_modi, StoreOfTowerEffectsUUID.RED_PACT_JEWELED_STAFF_BONUS_AP_EFFECT)
	


func _on_source_ap_changed(new_val):
	_ap_modi.flat_modifier = _pact_source._current_ap_amount
	_tower._calculate_final_ability_potency()

#

func _undo_modifications_to_tower(arg_tower):
	if _pact_source != null:
		_pact_source.disconnect("on_current_ap_amount_changed", self, "_on_source_ap_changed")
	
	
	if is_instance_valid(_tower):
		var effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_JEWELED_STAFF_BONUS_AP_EFFECT)
		
		if effect != null:
			_tower.remove_tower_effect(effect)
