extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")


const path_name = "Quick Root"
const path_descs = [
	
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/QuickRoot_Icon.png")

const dmg_amount : float = 1.0
const dmg_type : int = DamageType.ELEMENTAL

var game_elements
var on_hit_damage_effect : TowerOnHitDamageAdderEffect

#

func _init(arg_tier).(path_name, path_descs, path_small_icon, arg_tier):
	
	var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
	interpreter_for_flat_on_hit.display_body = false
	
	var ins_for_flat_on_hit = []
	ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental on hit damage", dmg_amount))
	
	interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
	
	
	var temp_path_descs = [
		["All Green tower's main attacks deal bonus |0|.", [interpreter_for_flat_on_hit]]
	]
	path_descs.clear()
	for desc in temp_path_descs:
		path_descs.append(desc)
	

#

func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if on_hit_damage_effect == null:
		_construct_effect()
	
	#
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_path"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_path", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_path", [], CONNECT_PERSIST)
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_path(tower)
	
	._apply_path_tier_to_game_elements(tier, arg_game_elements)

func _construct_effect():
	var modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.GREEN_PATH_QUICK_ROOT_DMG_BOOST)
	modi.flat_modifier = dmg_amount
	
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.GREEN_PATH_QUICK_ROOT_DMG_BOOST, modi, dmg_type)
	
	on_hit_damage_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.GREEN_PATH_QUICK_ROOT_DMG_BOOST)
	on_hit_damage_effect.is_timebound = false
	on_hit_damage_effect.is_countbound = false



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
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.GREEN_PATH_QUICK_ROOT_DMG_BOOST) and tower._tower_colors.has(TowerColors.GREEN):
		tower.add_tower_effect(on_hit_damage_effect)


func _tower_to_remove_from_path(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_PATH_QUICK_ROOT_DMG_BOOST)
	
	if effect != null:
		tower.remove_tower_effect(effect)
