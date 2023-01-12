extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"

const TowerDamageInstanceBoostEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerDamageInstanceScaleBoostEffect.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")



const path_name = "Deep Root"
const path_descs = [
	
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/DeepRoot_Icon.png")

const base_dmg_amount_tier_1 : float = 1.7
const base_dmg_amount_tier_2 : float = 1.5
const base_dmg_amount_tier_3 : float = 1.3
const base_dmg_amount_tier_4 : float = 1.1


var game_elements : GameElements
var dmg_instance_boost_effect : TowerDamageInstanceBoostEffect

#

func _init(arg_tier).(path_name, path_descs, path_small_icon, arg_tier):
	var interpreter_for_bonus_dmg_base = TextFragmentInterpreter.new()
	interpreter_for_bonus_dmg_base.display_body = false
	
	var ins_for_bonus_dmg_base = []
	ins_for_bonus_dmg_base.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 10, true))
	
	interpreter_for_bonus_dmg_base.array_of_instructions = ins_for_bonus_dmg_base
	
	
	var interpreter_for_bonus_dmg_per_stack = TextFragmentInterpreter.new()
	interpreter_for_bonus_dmg_per_stack.display_body = false
	
	var ins_for_bonus_dmg_per_stack = []
	ins_for_bonus_dmg_per_stack.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "", 20, true))
	
	interpreter_for_bonus_dmg_per_stack.array_of_instructions = ins_for_bonus_dmg_per_stack
	
	
	#
	
	var temp_path_descs = [
		["All Green tower's attacks deal |0|.", [interpreter_for_bonus_dmg_base]],
		["This bonus is increased by another |0| for each higher tier attained.", [interpreter_for_bonus_dmg_per_stack]]
	]
	path_descs.clear()
	for desc in temp_path_descs:
		path_descs.append(desc)
	
	

#

func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if dmg_instance_boost_effect == null:
		dmg_instance_boost_effect = TowerDamageInstanceBoostEffect.new(TowerDamageInstanceBoostEffect.DmgInstanceTypesToBoost.ANY, 
				TowerDamageInstanceBoostEffect.DmgInstanceBoostType.ALL, base_dmg_amount_tier_4, StoreOfTowerEffectsUUID.GREEN_PATH_DEEP_ROOT_DMG_BOOST)
	
	if tier == 4:
		dmg_instance_boost_effect.boost_scale_amount = base_dmg_amount_tier_4
	if tier == 3:
		dmg_instance_boost_effect.boost_scale_amount = base_dmg_amount_tier_3
	if tier == 2:
		dmg_instance_boost_effect.boost_scale_amount = base_dmg_amount_tier_2
	if tier == 1:
		dmg_instance_boost_effect.boost_scale_amount = base_dmg_amount_tier_1
	
	#
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_path"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_path", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_path", [], CONNECT_PERSIST)
	
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_path(tower)
	
	._apply_path_tier_to_game_elements(tier, arg_game_elements)


func _remove_path_from_game_elements(tier : int, arg_game_elements : GameElements):
	if tier == 1:
		dmg_instance_boost_effect.boost_scale_amount = 1
	
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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.GREEN_PATH_DEEP_ROOT_DMG_BOOST) and tower._tower_colors.has(TowerColors.GREEN):
		tower.add_tower_effect(dmg_instance_boost_effect)


func _tower_to_remove_from_path(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_PATH_DEEP_ROOT_DMG_BOOST)
	
	if effect != null:
		tower.remove_tower_effect(effect)
