extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")

const TowerDamageInstanceScaleBoostEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerDamageInstanceScaleBoostEffect.gd")


var bonus_damage_scale_per_tower = 0.1
var _current_same_tower_count : int
var _scale_multiplier : float = 1

var _current_total_bonus_damage_scale : float

var _effects_applied : bool

var _tower

var _dmg_instance_scale_effect : TowerDamageInstanceScaleBoostEffect

func _init().(StoreOfTowerEffectsUUID.ING_BOUNDED):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Bounded.png")
	_update_description()
	
	_can_be_scaled_by_yel_vio = true

func _update_description():
	var interpreter_for_bonus_dmg_per_tower = TextFragmentInterpreter.new()
	interpreter_for_bonus_dmg_per_tower.display_body = false
	
	var ins_for_bonus_dmg_per_tower = []
	ins_for_bonus_dmg_per_tower.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", (bonus_damage_scale_per_tower) * 100.0 * _current_additive_scale * _scale_multiplier, true))
	
	interpreter_for_bonus_dmg_per_tower.array_of_instructions = ins_for_bonus_dmg_per_tower
	
	#
	
	var show_bonus_desc : bool = _effects_applied
	
	
	var current_bonus_desc : String
	var interpreter_array : Array = [interpreter_for_bonus_dmg_per_tower]
	
	if show_bonus_desc:
		var interpreter_for_bonus_dmg_total = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg_total.display_body = false
		
		var ins_for_bonus_dmg_total = []
		ins_for_bonus_dmg_total.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", (_current_total_bonus_damage_scale) * 100.0 * _current_additive_scale, true))
		
		interpreter_for_bonus_dmg_total.array_of_instructions = ins_for_bonus_dmg_total
		
		#
		
		current_bonus_desc = " (Current bonus: |1|)."
		interpreter_array.append(interpreter_for_bonus_dmg_total)
	
	description = ["Gain |0| per same type of this tower found in the map (including itself).%s%s" % [current_bonus_desc, _generate_desc_for_persisting_total_additive_scaling(true)], interpreter_array]

func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_effects_applied:
		_effects_applied = true
		
		tower.tower_manager.connect("tower_transfered_to_different_type_of_placable", self, "_on_tower_transfered_to_different_type_of_placable", [], CONNECT_PERSIST | CONNECT_DEFERRED)
		tower.tower_manager.connect("tower_in_queue_free", self, "_on_tower_in_queue_free", [], CONNECT_PERSIST)
		tower.tower_manager.connect("tower_added_in_map", self, "_on_tower_added_in_map", [], CONNECT_PERSIST | CONNECT_DEFERRED)
		
		_construct_and_add_dmg_instance_scale_eff()
		_update_properties()

#

func _on_tower_transfered_to_different_type_of_placable(arg_tower, arg_placable_from, arg_placable_to):
	_update_properties()

func _on_tower_in_queue_free(tower):
	if _tower != tower:
		call_deferred("_update_properties")

func _on_tower_added_in_map(tower):
	_update_properties()

func _update_properties():
	var towers = _tower.tower_manager.get_all_in_map_towers_except_in_queue_free()
	var id_to_monitor = _tower.tower_id
	var count = 0
	
	for tower in towers:
		if tower.tower_id == id_to_monitor:
			count += 1
	
	_current_same_tower_count = count
	_current_total_bonus_damage_scale = (bonus_damage_scale_per_tower * count * _scale_multiplier)
	
	_dmg_instance_scale_effect.boost_scale_amount = _current_total_bonus_damage_scale + 1
	
	_update_description()


func _construct_and_add_dmg_instance_scale_eff():
	_dmg_instance_scale_effect = TowerDamageInstanceScaleBoostEffect.new(TowerDamageInstanceScaleBoostEffect.DmgInstanceTypesToBoost.ANY, TowerDamageInstanceScaleBoostEffect.DmgInstanceBoostType.BASE_AND_ON_HIT_DMG_ONLY, 0, StoreOfTowerEffectsUUID.ING_BOUNDED_DMG_SCALE_BOOST)
	_tower.add_tower_effect(_dmg_instance_scale_effect)

#

func _undo_modifications_to_tower(tower):
	if _effects_applied:
		_effects_applied = false
		
		tower.tower_manager.disconnect("tower_transfered_to_different_type_of_placable", self, "_on_tower_transfered_to_different_type_of_placable")
		tower.tower_manager.disconnect("tower_in_queue_free", self, "_on_tower_in_queue_free")
		tower.tower_manager.disconnect("tower_added_in_map", self, "_on_tower_added_in_map")
		
		_tower.remove_tower_effect(_dmg_instance_scale_effect)

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	
	#armor_and_toughness_pierce_amount *= _current_additive_scale
	
	_scale_multiplier = _current_additive_scale
	_current_additive_scale = 1
	
