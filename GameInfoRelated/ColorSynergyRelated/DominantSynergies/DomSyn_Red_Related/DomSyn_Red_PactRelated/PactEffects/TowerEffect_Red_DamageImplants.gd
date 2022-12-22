extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

const Pact_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/DamageImplants_StatusBarIcon.png")

#

var _base_dmg_effect : TowerAttributesEffect

var _pact_parent
var _tower

func _init(arg_pact_parent).(StoreOfTowerEffectsUUID.RED_PACT_DAMAGE_IMPLANTS_EFFECT):
	_pact_parent = arg_pact_parent 

#

func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_pact_parent.is_connected("base_dmg_changed", self, "_on_pact_parent_base_dmg_changed"):
		_pact_parent.connect("base_dmg_changed", self, "_on_pact_parent_base_dmg_changed", [], CONNECT_PERSIST)
	
	_construct_effects()


func _construct_effects():
	if _base_dmg_effect == null:
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_ABILITY_PROVISIONS_AP_EFFECT)
		base_dmg_attr_mod.flat_modifier = _pact_parent._current_base_dmg_amount
		
		_base_dmg_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_DAMAGE_IMPLANTS_BASE_DMG_EFFECT)
		_base_dmg_effect.status_bar_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/DamageImplants_StatusBarIcon.png")

func _on_pact_parent_base_dmg_changed(new_val):
	_update_and_recalculate_effect_base_dmg()

func _update_and_recalculate_effect_base_dmg():
	var _current_base_dmg = _pact_parent._current_base_dmg_amount
	_base_dmg_effect.attribute_as_modifier.flat_modifier = _current_base_dmg
	
	if _tower.has_tower_effect_uuid_in_buff_map(_base_dmg_effect.effect_uuid):
		_tower.recalculate_final_base_damage()

##

func add_effects_to_tower():
	if !_tower.has_tower_effect_uuid_in_buff_map(_base_dmg_effect.effect_uuid):
		_tower.add_tower_effect(_base_dmg_effect)

func remove_effects_from_tower():
	if _tower.has_tower_effect_uuid_in_buff_map(_base_dmg_effect.effect_uuid):
		_tower.remove_tower_effect(_base_dmg_effect)

##

func _undo_modifications_to_tower(tower):
	if is_instance_valid(tower):
		remove_effects_from_tower()
	
