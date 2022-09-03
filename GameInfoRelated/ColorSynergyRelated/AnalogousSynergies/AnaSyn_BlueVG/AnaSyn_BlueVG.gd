extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")

const AbilityManager = preload("res://GameElementsRelated/AbilityManager.gd")
const AbilityAttributesEffect = preload("res://GameInfoRelated/AbilityRelated/AbilityEffectRelated/AbilityAttributesEffect.gd")

const TowerEffect_AnaSyn_BlueVG_ApPerCastEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_AnaSyn_BlueVG_ApPerCast.gd")

var cdr_effect : AbilityAttributesEffect
var cdr_modi : PercentModifier


const tier1_cdr_amount : float = 80.0
const tier2_cdr_amount : float = 60.0
const tier3_cdr_amount : float = 40.0
const tier4_cdr_amount : float = 20.0

const tier1_ap_per_cd_cooldown_amount : float = 20.0#15.0
const tier2_ap_per_cd_cooldown_amount : float = 30.0#20.0
const tier3_ap_per_cd_cooldown_amount : float = 40.0#30.0
const tier4_ap_per_cd_cooldown_amount : float = 50.0#40.0

const ap_on_no_cooldown_amount : float = 0.05


var curr_tier : int
var game_elements : GameElements
var ability_manager : AbilityManager

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if cdr_effect == null:
		_construct_cdr_effect()
	
	if game_elements == null:
		game_elements = arg_game_elements
		ability_manager = game_elements.ability_manager
	
	curr_tier = tier
	if tier == 4:
		cdr_modi.percent_amount = tier4_cdr_amount
	elif tier == 3:
		cdr_modi.percent_amount = tier3_cdr_amount
	elif tier == 2:
		cdr_modi.percent_amount = tier2_cdr_amount
	elif tier == 1:
		cdr_modi.percent_amount = tier1_cdr_amount
	
	ability_manager.add_effect_to_all_abilities(cdr_effect)
	
	#
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _construct_cdr_effect():
	cdr_modi = PercentModifier.new(StoreOfAbilityEffectsUUID.BLUEVG_CDR)
	cdr_modi.percent_based_on = PercentType.BASE
	
	cdr_effect = AbilityAttributesEffect.new(AbilityAttributesEffect.PERCENT_ABILITY_CDR, cdr_modi, StoreOfAbilityEffectsUUID.BLUEVG_CDR)



func _remove_syn_from_game_elements(game_elements : GameElements, tier : int):
	curr_tier = -1
	ability_manager.remove_effect_to_all_abilities(cdr_effect)
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	
	._remove_syn_from_game_elements(game_elements, tier)


#

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLUE_VG_AP_PER_CAST):
		var effect = TowerEffect_AnaSyn_BlueVG_ApPerCastEffect.new(tier4_ap_per_cd_cooldown_amount, ap_on_no_cooldown_amount)
		
		if curr_tier == 1:
			effect.cd_ap_ratio = tier1_ap_per_cd_cooldown_amount
		elif curr_tier == 2:
			effect.cd_ap_ratio = tier2_ap_per_cd_cooldown_amount
		elif curr_tier == 3:
			effect.cd_ap_ratio = tier3_ap_per_cd_cooldown_amount
		elif curr_tier == 4:
			effect.cd_ap_ratio = tier4_ap_per_cd_cooldown_amount
		
		tower.add_tower_effect(effect)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.BLUE_VG_AP_PER_CAST)
	
	if effect != null:
		tower.remove_tower_effect(effect)

