extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

var _pact_source
var _base_dmg_effect : TowerAttributesEffect
var _base_dmg_modi : FlatModifier
var _tower

func _init(arg_pact).(StoreOfTowerEffectsUUID.RED_PACT_JEWELED_BLADE_EFFECT):
	_pact_source = arg_pact
	

#

func _make_modifications_to_tower(arg_tower):
	if _pact_source != null:
		_pact_source.connect("on_current_base_dmg_amount_changed", self, "_on_source_base_dmg_changed", [], CONNECT_PERSIST)
	
	_tower = arg_tower
	
	if is_instance_valid(_tower):
		_construct_effect()
		_tower.add_tower_effect(_base_dmg_effect)

func _construct_effect():
	_base_dmg_modi = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_JEWELED_BLADE_BONUS_BASE_DMG_EFFECT)
	_base_dmg_modi.flat_modifier = _pact_source._current_base_dmg_amount
	
	
	_base_dmg_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS, _base_dmg_modi, StoreOfTowerEffectsUUID.RED_PACT_JEWELED_BLADE_BONUS_BASE_DMG_EFFECT)
	


func _on_source_base_dmg_changed(new_val):
	_base_dmg_modi.flat_modifier = _pact_source._current_base_dmg_amount
	_tower.recalculate_final_base_damage()

#

func _undo_modifications_to_tower(arg_tower):
	if _pact_source != null:
		_pact_source.disconnect("on_current_base_dmg_amount_changed", self, "_on_source_base_dmg_changed")
	
	
	if is_instance_valid(_tower):
		var effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_JEWELED_BLADE_BONUS_BASE_DMG_EFFECT)
		
		if effect != null:
			_tower.remove_tower_effect(effect)
