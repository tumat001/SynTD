extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const TowerIngredientColorAcceptabilityEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerIngredientColorAcceptabilityEffect.gd")
const TowerEffect_DomSyn_VioletCMRoundCounter = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_VioletCMRoundCounter.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const ColorMasteryParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Violet_Related/MasteryParticle/ColorMasteryParticle.tscn")

const ColorMastery_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Violet_Related/OtherAssets/ColorMastery_StatusBarIcon.png")


var _tower_round_counter_effect : TowerEffect_DomSyn_VioletCMRoundCounter
var _attached_tower

#

func _init().(StoreOfTowerEffectsUUID.VIOLET_V02__COLOR_MASTERY_EFFECT_GIVER):
	pass


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	_give_mastery_effect()


func _give_mastery_effect():
	if !_attached_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_V02__COLOR_MASTERY_EFFECT):
		var tower_accepta_effect : TowerIngredientColorAcceptabilityEffect = TowerIngredientColorAcceptabilityEffect.new(TowerColors.get_all_colors(), TowerIngredientColorAcceptabilityEffect.AcceptabilityType.WHITELIST, StoreOfTowerEffectsUUID.VIOLET_V02__COLOR_MASTERY_EFFECT)
		tower_accepta_effect.status_bar_icon = ColorMastery_StatusBarIcon
		
		_attached_tower.add_tower_effect(tower_accepta_effect)
		
		_construct_and_show_mastery_particle()

func _construct_and_show_mastery_particle():
	var particle = ColorMasteryParticle_Scene.instance()
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	particle.lifetime = 1.5
	particle.lifetime_to_start_transparency = 0.3
	particle.position = _attached_tower.global_position
	particle.position.y -= 10
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)

#

func _undo_modifications_to_tower(tower):
	var effect = _attached_tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_V02__COLOR_MASTERY_EFFECT)
	if effect != null:
		_attached_tower.remove_tower_effect(effect)
	

