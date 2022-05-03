extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")


var cd_ap_ratio : float
var default_amount_on_no_cooldown : float

var ap_effect : TowerAttributesEffect

var _tower

func _init(arg_cd_ap_ratio, arg_default_amount_on_no_cooldown).(StoreOfTowerEffectsUUID.BLUE_VG_AP_PER_CAST):
	cd_ap_ratio = arg_cd_ap_ratio
	default_amount_on_no_cooldown = arg_default_amount_on_no_cooldown



func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !tower.is_connected("on_tower_ability_before_cast_start", self, "_on_tower_ability_casted"):
		tower.connect("on_tower_ability_before_cast_start", self, "_on_tower_ability_casted", [], CONNECT_PERSIST)
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
	
	_construct_ap_effect()
	
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLUE_VG_STACKING_AP_EFFECT):
		tower.add_tower_effect(ap_effect)

func _construct_ap_effect():
	if ap_effect == null:
		var modi = FlatModifier.new(StoreOfTowerEffectsUUID.BLUE_VG_STACKING_AP_EFFECT)
		modi.flat_modifier = 0
		
		ap_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, modi, StoreOfTowerEffectsUUID.BLUE_VG_STACKING_AP_EFFECT)
		ap_effect.ignore_effect_shield_effect = true
		ap_effect.is_from_enemy = false




func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_tower_ability_before_cast_start", self, "_on_tower_ability_casted"):
		tower.disconnect("on_tower_ability_before_cast_start", self, "_on_tower_ability_casted")
		tower.disconnect("on_round_end", self, "_on_round_end")
	
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.BLUE_VG_STACKING_AP_EFFECT)
	if effect != null:
		tower.remove_tower_effect(effect)

#

func _on_tower_ability_casted(cooldown, ability):
	var ap_to_gain = default_amount_on_no_cooldown
	if cooldown > 0:
		ap_to_gain = (cooldown / cd_ap_ratio) / 4
	
	ap_effect.attribute_as_modifier.flat_modifier += ap_to_gain
	
	_tower._calculate_final_ability_potency()


func _on_round_end():
	ap_effect.attribute_as_modifier.flat_modifier = 0
	
	_tower._calculate_final_ability_potency()
