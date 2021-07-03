extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")

const AbilityManager = preload("res://GameElementsRelated/AbilityManager.gd")
const AbilityAttributesEffect = preload("res://GameInfoRelated/AbilityRelated/AbilityEffectRelated/AbilityAttributesEffect.gd")

var cdr_effect : AbilityAttributesEffect
var cdr_modi : PercentModifier

const tier3_cdr_amount : float = 35.0
const tier2_cdr_amount : float = 55.0
const tier1_cdr_amount : float = 80.0

var game_elements : GameElements
var ability_manager : AbilityManager

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if cdr_effect == null:
		_construct_cdr_effect()
	
	if game_elements == null:
		game_elements = arg_game_elements
		ability_manager = game_elements.ability_manager
	
	if tier == 3:
		cdr_modi.percent_amount = tier3_cdr_amount
	elif tier == 2:
		cdr_modi.percent_amount = tier2_cdr_amount
	elif tier == 1:
		cdr_modi.percent_amount = tier1_cdr_amount
	
	ability_manager.add_effect_to_all_abilities(cdr_effect)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)
	

func _construct_cdr_effect():
	cdr_modi = PercentModifier.new(StoreOfAbilityEffectsUUID.BLUEVG_CDR)
	cdr_modi.percent_based_on = PercentType.BASE
	
	cdr_effect = AbilityAttributesEffect.new(AbilityAttributesEffect.PERCENT_ABILITY_CDR, cdr_modi, StoreOfAbilityEffectsUUID.BLUEVG_CDR)



func _remove_syn_from_game_elements(game_elements : GameElements, tier : int):
	ability_manager.remove_effect_to_all_abilities(cdr_effect)
	
	._remove_syn_from_game_elements(game_elements, tier)
