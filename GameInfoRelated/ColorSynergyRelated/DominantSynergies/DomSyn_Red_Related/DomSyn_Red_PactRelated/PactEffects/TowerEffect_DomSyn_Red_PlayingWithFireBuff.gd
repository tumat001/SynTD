extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")


var base_max_attk_speed_amount : float

var attk_speed_effect : TowerAttributesEffect
var attk_speed_modifier : PercentModifier
var tower_affected

var health_manager
var pact_parent

func _init(arg_health_manager, arg_pact_parent).(StoreOfTowerEffectsUUID.RED_PACT_PLAYING_WITH_FIRE_BUFF_GIVER):
	health_manager = arg_health_manager
	pact_parent = arg_pact_parent


func _make_modifications_to_tower(tower):
	if attk_speed_effect == null:
		_construct_effect()
	
	if !health_manager.is_connected("current_health_changed", self, "_health_changed"):
		health_manager.connect("current_health_changed", self, "_health_changed", [], CONNECT_PERSIST)
	
	tower_affected = tower
	
	if !tower_affected.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_PLAYING_WITH_FIRE_BUFF):
		tower_affected.add_tower_effect(attk_speed_effect)
		_update_effect_modi()




func _construct_effect():
	attk_speed_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_PLAYING_WITH_FIRE_BUFF)
	attk_speed_modifier.percent_based_on = PercentType.BASE
	
	attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_modifier, StoreOfTowerEffectsUUID.RED_PACT_PLAYING_WITH_FIRE_BUFF)
	attk_speed_effect.is_timebound = false

func _health_changed(curr_health):
	_update_effect_modi()

func _update_effect_modi():
	var attk_speed_bonus = _calculate_attk_speed_bonus()
	attk_speed_modifier.percent_amount = attk_speed_bonus
	
	for module in tower_affected.all_attack_modules:
		if module.benefits_from_bonus_attack_speed:
			module.calculate_all_speed_related_attributes()
		
		if tower_affected.main_attack_module == module:
			tower_affected._emit_final_attack_speed_changed()


func _calculate_attk_speed_bonus():
	return pact_parent._calculate_attk_speed_bonus()

#

func _undo_modifications_to_tower(tower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_PLAYING_WITH_FIRE_BUFF)
	if effect != null:
		tower.remove_tower_effect(effect)
	
	if health_manager.is_connected("current_health_changed", self, "_health_changed"):
		health_manager.disconnect("current_health_changed", self, "_health_changed")

