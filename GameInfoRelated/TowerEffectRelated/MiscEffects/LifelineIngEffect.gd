extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")


const base_dmg_percent_of_self_min : float = 10.0
const base_dmg_percent_of_self_max : float = 40.0

const base_dmg_ratio_max__health_threshold_for_max : float = -0.8 + 1   #the -x is the missing health component
const desc_for__missing_health_max_dmg : float = 100 - (base_dmg_ratio_max__health_threshold_for_max * 100)    # value not used other than in description


var _current_scale : float = 1.0

var _tower
var _effects_applied : bool

var base_damage_buff_effect
var current_base_dmg_percent

#

func _init().(StoreOfTowerEffectsUUID.ING_LIFELINE):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Lifeline_BaseDamageIncrease.png")
	_update_description()
	
	_can_be_scaled_by_yel_vio = true


func _update_description():
	var plain_fragment__base_dmg_percent_min = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BASE_DAMAGE, "%s%%" % (base_dmg_percent_of_self_min * _current_scale * _current_additive_scale))
	var plain_fragment__base_dmg_percent_max = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BASE_DAMAGE, "%s%% total base damage" % (base_dmg_percent_of_self_max * _current_scale * _current_additive_scale))
	
	var curr_bonus_desc = ""
	var curr_bonus_desc_interpreters = []
	if _effects_applied:
		curr_bonus_desc = " (Current bonus: |2|)"
		
		var plain_fragment__base_dmg_percent_current = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BASE_DAMAGE, "%s%% total base damage" % (current_base_dmg_percent * _current_additive_scale))
		curr_bonus_desc_interpreters.append(plain_fragment__base_dmg_percent_current)
	
	
	var final_interpreters = [plain_fragment__base_dmg_percent_min, plain_fragment__base_dmg_percent_max]
	final_interpreters.append_array(curr_bonus_desc_interpreters)
	
	description = ["Gain |0| to |1| based on the tower's missing health. Max value reached at %s%% missing health.%s%s" % [desc_for__missing_health_max_dmg, curr_bonus_desc, _generate_desc_for_persisting_total_additive_scaling(true)], final_interpreters]
	
	emit_signal("description_updated")

###########

func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_effects_applied:
		_effects_applied = true
		
		_construct_and_add_base_dmg_effect()
		_calc_and_update_current_base_dmg_percent()
		
		_tower.connect("on_max_health_changed", self, "_on_tower_max_health_changed", [], CONNECT_PERSIST)
		_tower.connect("on_current_health_changed", self, "_on_current_health_changed", [], CONNECT_PERSIST)

func _construct_and_add_base_dmg_effect():
	var base_damage_buff_mod = PercentModifier.new(StoreOfTowerEffectsUUID.LIFELINE_BASE_DMG_EFFECT)
	base_damage_buff_mod.percent_amount = 0
	base_damage_buff_mod.percent_based_on = PercentType.MAX
	
	base_damage_buff_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS, base_damage_buff_mod, StoreOfTowerEffectsUUID.LIFELINE_BASE_DMG_EFFECT)
	base_damage_buff_effect.is_timebound = false
	
	_tower.add_tower_effect(base_damage_buff_effect)
	
	return base_damage_buff_effect



func _calc_and_update_current_base_dmg_percent():
	var current_health_ratio = _tower.current_health / _tower.last_calculated_max_health
	var diff = (1 + base_dmg_ratio_max__health_threshold_for_max)  # 1 = max curr to max health ratio
	
	var diff_ratio = diff * (1 - current_health_ratio)
	if diff_ratio > 1:
		diff_ratio = 1
	
	var dmg_ratio_diff = (base_dmg_percent_of_self_max - base_dmg_percent_of_self_min)
	var dmg_ratio_ratio = (dmg_ratio_diff * diff_ratio) + base_dmg_percent_of_self_min
	
	#print("dmg ratio ratio: %s. diff_ratio : %s. curr health ratio: %s" % [dmg_ratio_ratio, diff_ratio, current_health_ratio])
	current_base_dmg_percent = dmg_ratio_ratio * _current_scale #* 100 #min(base_dmg_ratio_of_self_max, -(current_health_ratio - base_dmg_ratio_max__health_threshold_for_max) + 1)
	
	base_damage_buff_effect.attribute_as_modifier.percent_amount = current_base_dmg_percent
	
	_tower.recalculate_final_base_damage()
	
	_update_description()

##########

func _on_tower_max_health_changed(arg_val):
	_calc_and_update_current_base_dmg_percent()

func _on_current_health_changed(arg_val):
	_calc_and_update_current_base_dmg_percent()



func _undo_modifications_to_tower(tower):
	if _effects_applied:
		_effects_applied = false
		
		_tower.disconnect("on_max_health_changed", self, "_on_tower_max_health_changed")
		_tower.disconnect("on_current_health_changed", self, "_on_current_health_changed")
		
		_tower.remove_tower_effect(base_damage_buff_effect)

####

func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	
	#armor_and_toughness_pierce_amount *= _current_additive_scale
	
	_current_scale = _current_additive_scale
	_current_additive_scale = 1
	

