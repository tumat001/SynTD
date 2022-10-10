extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerDamageInstanceScaleBoostEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerDamageInstanceScaleBoostEffect.gd")

var _pact_source
var _bonus_dmg_effect : TowerDamageInstanceScaleBoostEffect
var _tower

func _init(arg_pact).(StoreOfTowerEffectsUUID.RED_PACT_COMBINATION_CATALOG_BONUS_DMG_EFFECT_GIVER):
	_pact_source = arg_pact


func _make_modifications_to_tower(arg_tower):
	if _pact_source != null:
		_pact_source.connect("on_bonus_dmg_amount_changed", self, "_on_source_bonus_dmg_changed", [], CONNECT_PERSIST)
	
	_tower = arg_tower
	
	if is_instance_valid(_tower):
		_construct_effect()
		_tower.add_tower_effect(_bonus_dmg_effect)

func _construct_effect():
	var amount = _pact_source._current_bonus_dmg_amount + 1
	_bonus_dmg_effect = TowerDamageInstanceScaleBoostEffect.new(TowerDamageInstanceScaleBoostEffect.DmgInstanceTypesToBoost.ANY, TowerDamageInstanceScaleBoostEffect.DmgInstanceBoostType.BASE_AND_ON_HIT_DMG_ONLY, amount, StoreOfTowerEffectsUUID.RED_PACT_COMBINATION_CATALOG_BONUS_DMG_EFFECT)


func _on_source_bonus_dmg_changed(arg_val):
	_bonus_dmg_effect.boost_scale_amount = _pact_source._current_bonus_dmg_amount + 1

##


func _undo_modifications_to_tower(arg_tower):
	if _pact_source != null:
		_pact_source.disconnect("on_bonus_dmg_amount_changed", self, "_on_source_bonus_dmg_changed")
	
	
	if is_instance_valid(_tower):
		var effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_COMBINATION_CATALOG_BONUS_DMG_EFFECT)
		
		if effect != null:
			_tower.remove_tower_effect(effect)

