extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerIngredientColorAcceptabilityEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerIngredientColorAcceptabilityEffect.gd")
const TowerEffect_DomSyn_VioletCMRoundCounter = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_VioletCMRoundCounter.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const ColorMasteryParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Violet_Related/MasteryParticle/ColorMasteryParticle.tscn")

const ColorMastery_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Violet_Related/OtherAssets/ColorMastery_StatusBarIcon.png")


var rounds_before_compat : int


var _tower_round_counter_effect : TowerEffect_DomSyn_VioletCMRoundCounter
var _attached_tower

#

func _init(arg_rounds_before_compat : int).(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_EFFECT_GIVER):
	rounds_before_compat = arg_rounds_before_compat


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	_get_or_construct_round_counter_effect()
	
	if !tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)



func _get_or_construct_round_counter_effect():
	if !_attached_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_ROUND_COUNTDOWN_MARKER):
		_tower_round_counter_effect = TowerEffect_DomSyn_VioletCMRoundCounter.new(rounds_before_compat)
		_attached_tower.add_tower_effect(_tower_round_counter_effect)
	else:
		_tower_round_counter_effect = _attached_tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_ROUND_COUNTDOWN_MARKER)
	

func _on_round_end():
	if !_tower_round_counter_effect.is_target_round_met():
		_tower_round_counter_effect.current_round_count += 1
		
		if _tower_round_counter_effect.is_target_round_met():
			_give_mastery_effect()
			_construct_and_show_mastery_particle()


func _give_mastery_effect():
	if !_attached_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_EFFECT):
		var tower_accepta_effect : TowerIngredientColorAcceptabilityEffect = TowerIngredientColorAcceptabilityEffect.new(TowerColors.get_all_colors(), TowerIngredientColorAcceptabilityEffect.AcceptabilityType.WHITELIST, StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_EFFECT)
		tower_accepta_effect.status_bar_icon = ColorMastery_StatusBarIcon
		
		_attached_tower.add_tower_effect(tower_accepta_effect)


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
	if tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.disconnect("on_round_end", self, "_on_round_end")


