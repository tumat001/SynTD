extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const Piercing_BuffParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/GreenPaths/Bloom/Piercing_Assets/Piercing_BuffParticle.tscn")


var health_effect : TowerAttributesEffect
var effect_vul_effect : TowerAttributesEffect

var _health_amount : float
var _effect_vul_scale : float



func _init(arg_health_amount : float, arg_effect_vul_scale : float).(StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_EFFECT_GIVER):
	
	_health_amount = arg_health_amount
	_effect_vul_scale = arg_effect_vul_scale

func _make_modifications_to_tower(tower):
	if health_effect == null:
		_construct_effects()
	
	tower.add_tower_effect(health_effect)
	tower.add_tower_effect(effect_vul_effect)

func _construct_effects():
	var health_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.GREEN_PATH_RESILIENCE_HEALTH_EFFECT)
	health_modi.percent_based_on = PercentType.BASE
	health_modi.percent_amount = _health_amount
	health_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_HEALTH, health_modi, StoreOfTowerEffectsUUID.GREEN_PATH_RESILIENCE_HEALTH_EFFECT)
	
	var effect_vul_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.GREEN_PATH_RESILIENCE_VUL_EFFECT)
	effect_vul_modi.percent_based_on = PercentType.BASE
	effect_vul_modi.percent_amount = _effect_vul_scale
	effect_vul_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_ENEMY_EFFECT_VULNERABILITY, effect_vul_modi, StoreOfTowerEffectsUUID.GREEN_PATH_RESILIENCE_VUL_EFFECT)
	


#

func _undo_modifications_to_tower(tower):
	_remove_effects_from_tower(tower)


func _remove_effects_from_tower(tower):
	var health_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_PATH_RESILIENCE_HEALTH_EFFECT)
	if health_effect != null:
		tower.remove_tower_effect(health_effect)
	
	var effect_vul_effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_PATH_RESILIENCE_VUL_EFFECT)
	if effect_vul_effect != null:
		tower.remove_tower_effect(effect_vul_effect)
