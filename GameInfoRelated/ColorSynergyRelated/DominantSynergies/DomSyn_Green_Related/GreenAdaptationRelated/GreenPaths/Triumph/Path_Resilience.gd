extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"

const TowerPathEffect_ResilienceGiverEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/OtherGreenEffects/TowerPathEffect_ResilienceGiverEffect.gd")


const green_tier_requirement_inclusive : int = 2

const path_name = "Resilience"
const path_descs = [
	"All green towers gain 150% bonus health.",
	"Enemy effects against green towers are only 20% effective."
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/ResilienceFruit_Icon.png")

const health_bonus_amount : float = 150.0
const effect_vulnerability_scale : float = -80.0

var game_elements

#

func _init(arg_tier).(path_name, path_descs, path_small_icon, arg_tier):
	pass

#

func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
	#
	
	if tier <= green_tier_requirement_inclusive:
		if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_path"):
			game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_path", [], CONNECT_PERSIST)
			game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_path", [], CONNECT_PERSIST)
		
		var all_towers = game_elements.tower_manager.get_all_active_towers()
		for tower in all_towers:
			_tower_to_benefit_from_path(tower)
	
	._apply_path_tier_to_game_elements(tier, arg_game_elements)


func _remove_path_from_game_elements(tier : int, arg_game_elements : GameElements):
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_path"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_path")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_path")
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_path(tower)
	
	._remove_path_from_game_elements(tier, arg_game_elements)

#


func _tower_to_benefit_from_path(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.GREEN_PATH_OVERCOME_EFFECT) and tower._tower_colors.has(TowerColors.GREEN):
		var effect = TowerPathEffect_ResilienceGiverEffect.new(health_bonus_amount, effect_vulnerability_scale)
		
		tower.add_tower_effect(effect)


func _tower_to_remove_from_path(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_PATH_OVERCOME_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)
