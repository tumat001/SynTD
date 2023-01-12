extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"

#NOTE: REMOVED from the pool of selection, which means that
#the code for this is not updated to the standards used by the
#other paths. This will not work properly.


const TowerPathEffect_PierceGiverEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/OtherGreenEffects/TowerPathEffect_PierceGiverEffect.gd")

const path_name = "Shots of Piercing"
const path_descs = [
	"For each green tower: After dealing 40 damage or attacking 12 times, gain 8 armor and toughness pierce."
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/BlueOrangeFlower_Icon.png")

const damage_amount_trigger : float = 40.0
const attk_count_trigger : int = 12

const armor_pierce_amount : float = 8.0
const toughness_pierce_amount : float = 8.0

var game_elements

#

func _init(arg_tier).(path_name, path_descs, path_small_icon, arg_tier):
	pass


#


func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
	#
	
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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_EFFECT_GIVER) and tower._tower_colors.has(TowerColors.GREEN):
		var effect_giver = TowerPathEffect_PierceGiverEffect.new(damage_amount_trigger, attk_count_trigger, armor_pierce_amount, toughness_pierce_amount)
		
		tower.add_tower_effect(effect_giver)


func _tower_to_remove_from_path(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_PATH_PIERCING_EFFECT_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)
