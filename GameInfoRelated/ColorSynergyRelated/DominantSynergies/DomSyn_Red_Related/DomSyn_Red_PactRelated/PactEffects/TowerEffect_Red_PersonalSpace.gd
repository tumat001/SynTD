extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")

const PersonalSpace_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/PersonalSpace_StatusBarIcon.png")

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
	
	if !is_instance_valid(tower_detecting_range_module):
		_construct_tower_detecting_range_module()
		tower_affected.add_child(tower_detecting_range_module)
	
	if !tower_affected.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_ATTK_SPEED_EFFECT):
		tower_affected.add_tower_effect(attk_speed_effect)
		_update_effect_modi()
	
	if !tower_affected.is_connected("on_tower_toggle_showing_range", self, "_on_tower_toggle_showing_range"):
		tower_affected.connect("on_tower_toggle_showing_range", self, "_on_tower_toggle_showing_range", [], CONNECT_PERSIST)


func _construct_effect():
	attk_speed_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_ATTK_SPEED_EFFECT)
	attk_speed_modifier.percent_based_on = PercentType.BASE
	
	attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_modifier, StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_ATTK_SPEED_EFFECT)
	attk_speed_effect.is_timebound = false



func _update_effect_modi():
	var attk_speed_bonus = attk_speed_amount
	
	if tower_detecting_range_module.get_all_in_map_towers_in_range().size() > 0:
		attk_speed_bonus = 0
		tower_affected.status_bar.remove_status_icon(attk_speed_effect.effect_uuid)
	else:
		tower_affected.status_bar.add_status_icon(attk_speed_effect.effect_uuid, PersonalSpace_StatusBarIcon)
	
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
	
	tower_detecting_range_module.connect("on_tower_entered_range_while_in_map_or_entered_map_while_in_range", self, "_on_tower_entered_range_while_in_map", [], CONNECT_PERSIST)
	tower_detecting_range_module.connect("on_tower_exited_range_or_exited_map_while_in_range", self, "_on_tower_exited_range_while_in_range_or_exited_map", [], CONNECT_PERSIST)
	
	tower_detecting_range_module.can_display_circle_arc = true
	tower_detecting_range_module.circle_arc_color = color_of_personal_space_range
	

func _on_tower_entered_range_while_in_map(arg_tower):
	_update_effect_modi()

func _on_tower_exited_range_while_in_range_or_exited_map(arg_tower):
	_update_effect_modi()

#

func _on_tower_toggle_showing_range(is_showing_range):
	if is_showing_range:
		tower_detecting_range_module.show_range()
	else:
		tower_detecting_range_module.hide_range()


####

func _undo_modifications_to_tower(tower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_PERSONAL_SPACE_ATTK_SPEED_EFFECT)
	if effect != null:
		tower.remove_tower_effect(effect)
	
	#
	tower_affected.status_bar.remove_status_icon(attk_speed_effect.effect_uuid)
	
	#
	tower_detecting_range_module.queue_free()
	
	#
	
	if tower_affected.is_connected("on_tower_toggle_showing_range", self, "_on_tower_toggle_showing_range"):
		tower_affected.disconnect("on_tower_toggle_showing_range", self, "_on_tower_toggle_showing_range")


