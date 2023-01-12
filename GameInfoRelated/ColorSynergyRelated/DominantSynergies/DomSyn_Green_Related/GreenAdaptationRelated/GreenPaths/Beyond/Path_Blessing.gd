extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

const path_name = "Blessing"
const path_descs = [
	"Color Artifact: Multiple synergies can be active at once. Synergies no longer cancel each other.",
	"Artifact is not lost when the synergy tier is not met.",
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/ColorWheel_Icon.png")

var _applied_blessing : bool = false

#

func _init(arg_tier).(path_name, path_descs, path_small_icon, arg_tier):
	pass

#

func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	if !_applied_blessing:
		_applied_blessing = true
		
		var dom_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.GREEN_PATH_COLOR_ARTIFACT_DOM_SYN_MODI_ID)
		dom_modi.flat_modifier = TowerDominantColors.synergies.size()
		
		var compo_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.GREEN_PATH_COLOR_ARTIFACT_COMPO_SYN_MODI_ID)
		compo_modi.flat_modifier = TowerCompositionColors.synergies.size()
		
		arg_game_elements.synergy_manager.add_dominant_syn_limit_modi(dom_modi)
		arg_game_elements.synergy_manager.add_composite_syn_limit_modi(compo_modi)
		arg_game_elements.synergy_manager.dont_allow_same_total_conditonal_clause.attempt_insert_clause(arg_game_elements.synergy_manager.DontAllowSameTotalsContionalClauseIds.GREEN_PATH_BLESSING)
	
	
	._apply_path_tier_to_game_elements(tier, arg_game_elements)

func _remove_path_from_game_elements(tier : int, arg_game_elements : GameElements):
	._remove_path_from_game_elements(tier, arg_game_elements)
