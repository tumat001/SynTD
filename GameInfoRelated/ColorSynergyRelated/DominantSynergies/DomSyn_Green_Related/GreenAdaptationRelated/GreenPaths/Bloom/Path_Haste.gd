extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"

const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const TowerPathEffect_HasteGiverEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/OtherGreenEffects/TowerPathEffect_HasteGiverEffect.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")


const green_tier_requirement_inclusive : int = 3

const path_name = "Shots of Haste"
const path_descs = [
	
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/YellowFlower_Icon.png")


const damage_amount_trigger : float = 40.0
const attk_count_trigger : int = 12
const attk_speed_amount : float = 40.0
const attk_speed_percent_type : int = PercentType.BASE

var game_elements

#

func _init(arg_tier).(path_name, path_descs, path_small_icon, arg_tier):
	
	var interpreter_for_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_attk_speed.display_body = false
	
	var ins_for_attk_speed = []
	ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", attk_speed_amount, true))
	
	interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
	
	
	var temp_path_desc = [
		["For each green tower: After dealing 40 damage or attacking 12 times, gain |0|.", [interpreter_for_attk_speed]]
	]
	path_descs.clear()
	for desc in temp_path_desc:
		path_descs.append(desc)
	

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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.GREEN_PATH_HASTE_EFFECT_GIVER) and tower._tower_colors.has(TowerColors.GREEN):
		var effect_giver = TowerPathEffect_HasteGiverEffect.new(damage_amount_trigger, attk_count_trigger, attk_speed_amount, attk_speed_percent_type)
		
		tower.add_tower_effect(effect_giver)


func _tower_to_remove_from_path(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_PATH_HASTE_EFFECT_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)
