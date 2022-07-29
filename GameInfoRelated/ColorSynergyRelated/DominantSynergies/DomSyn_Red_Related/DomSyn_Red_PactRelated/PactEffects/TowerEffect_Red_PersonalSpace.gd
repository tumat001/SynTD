extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")

var attk_speed_amount : float
var range_of_personal_space : float

var attk_speed_effect : TowerAttributesEffect
var attk_speed_modifier : PercentModifier
var tower_affected

var tower_detecting_range_module : TowerDetectingRangeModule

const color_of_personal_space_range : Color = Color(0.8, 0.35, 0, 0.5)


func _init().(StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_EFFECT_GIVER):
	pass


func _make_modifications_to_tower(tower):
	if attk_speed_effect == null:
		_construct_effect()
	
	tower_affected = tower
	
	if tower_detecting_range_module == null:
		_construct_tower_detecting_range_module()
		tower_affected.add_child(tower_detecting_range_module)
	
	if !tower_affected.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_ATTK_SPEED_EFFECT):
		tower_affected.add_tower_effect(attk_speed_effect)
		_update_effect_modi()


func _construct_effect():
	attk_speed_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_ATTK_SPEED_EFFECT)
	attk_speed_modifier.percent_based_on = PercentType.BASE
	
	attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_modifier, StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_ATTK_SPEED_EFFECT)
	attk_speed_effect.is_timebound = false



func _update_effect_modi():
	var attk_speed_bonus = attk_speed_amount
	#if a tower is within range
	attk_speed_modifier.percent_amount = attk_speed_bonus
	
	for module in tower_affected.all_attack_modules:
		if module.benefits_from_bonus_attack_speed:
			module.calculate_all_speed_related_attributes()
		
		if tower_affected.main_attack_module == module:
			tower_affected._emit_final_attack_speed_changed()

#

func _construct_tower_detecting_range_module():
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.detection_range = range_of_personal_space
	tower_detecting_range_module.can_display_range = false


#todo continue this. let the tower detecting range module use draw to draw the arcs (borrow from adept)
