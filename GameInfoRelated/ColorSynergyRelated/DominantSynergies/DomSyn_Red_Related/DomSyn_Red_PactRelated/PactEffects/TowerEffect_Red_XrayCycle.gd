extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

const TowerStunEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerStunEffect.gd")


var range_bonus : float
var stun_duration : float

var _pact_parent
var _tower

var _range_effect : TowerAttributesEffect

var _current_stun_effect : TowerStunEffect

#

func _init(arg_pact_parent).(StoreOfTowerEffectsUUID.RED_PACT_XRAY_CYCLE_EFFECT):
	_pact_parent = arg_pact_parent 
	

func _make_modifications_to_tower(tower):
	_tower = tower
	
	_construct_effects()
	_connect_signals_with_pact_parent()


func _construct_effects():
	if _range_effect == null:
		var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_XRAY_CYCLE_RANGE_EFFECT)
		range_attr_mod.flat_modifier = range_bonus
		
		_range_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.RED_PACT_XRAY_CYCLE_RANGE_EFFECT)
		_range_effect.status_bar_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/XrayCycle_StatusBarIcon.png")

func _connect_signals_with_pact_parent():
	_pact_parent.connect("start_buffs", self, "_on_pact_start_buffs", [], CONNECT_PERSIST)
	_pact_parent.connect("end_buffs_and_start_debuffs", self, "_on_pact_end_buffs_and_start_debuffs", [], CONNECT_PERSIST)
	#_pact_parent.connect("end_debuffs", self, "_on_pact_end_debuffs", [], CONNECT_PERSIST)
	_pact_parent.connect("remove_buffs_and_remove_debuffs", self, "_on_pact_remove_buffs_and_remove_debuffs", [], CONNECT_PERSIST)

#

func _on_pact_start_buffs():
	_tower.add_tower_effect(_range_effect)
	_tower.set_layer_on_terrain_modi(_tower.LayerOnTerrainModiIds.DOM_SYN_RED__XRAY_CYCLE, 10000)

#

func _on_pact_end_buffs_and_start_debuffs():
	_remove_buffs()
	_apply_debuffs()

func _remove_buffs():
	if _tower.has_tower_effect_uuid_in_buff_map(_range_effect.effect_uuid):
		_tower.remove_tower_effect(_range_effect)
		_tower.remove_layer_on_terrain_modi(_tower.LayerOnTerrainModiIds.DOM_SYN_RED__XRAY_CYCLE)

func _apply_debuffs():
	if !_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_XRAY_CYCLE_STUN_EFFECT):
		_current_stun_effect = TowerStunEffect.new(stun_duration, StoreOfTowerEffectsUUID.RED_PACT_XRAY_CYCLE_STUN_EFFECT)
		_current_stun_effect.is_from_enemy = false
		
		_tower.add_tower_effect(_current_stun_effect)

func _on_pact_remove_buffs_and_remove_debuffs():
	_remove_buffs()
	_remove_debuffs()

#

#func _on_pact_end_debuffs():
#	_remove_debuffs()

func _remove_debuffs():
	if _tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_XRAY_CYCLE_STUN_EFFECT):
		_tower.remove_tower_effect(_current_stun_effect)

#


func _undo_modifications_to_tower(tower):
	if is_instance_valid(tower):
		_remove_buffs()
		_remove_debuffs()
	
