extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

const ability_cast_amount_for_empower : int = 3  # note: change description if changing this
const base_ap_amount : float = 1.0

const ap_buff_duration : float = 5.0

var _ap_amount_scale : float = 1.0
var _current_ability_casted_count : int


var _tower
var _effects_applied : bool


func _init().(StoreOfTowerEffectsUUID.ING_CELESTIAL):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Celestial.png")
	_update_description()
	
	_can_be_scaled_by_yel_vio = true

func _update_description():
	var interpreter_for_ap = TextFragmentInterpreter.new()
	interpreter_for_ap.display_body = false
	
	var ins_for_ap = []
	ins_for_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", base_ap_amount * _ap_amount_scale * _current_additive_scale, false))
	
	interpreter_for_ap.array_of_instructions = ins_for_ap
	
	
	var plain_fragment__ability_cast = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "3rd ability cast")
	
	description = ["Every |0|, gain |1| for %s seconds.%s" % [ap_buff_duration, _generate_desc_for_persisting_total_additive_scaling(true)], [plain_fragment__ability_cast, interpreter_for_ap]]
	
	emit_signal("description_updated")

#####


func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_effects_applied:
		_effects_applied = true
		
		_tower.connect("on_tower_ability_before_cast_start", self, "_on_tower_ability_before_cast_start", [], CONNECT_PERSIST)

func _on_tower_ability_before_cast_start(arg_cd, arg_ability):
	_inc_current_ability_casted_count()
	


func _inc_current_ability_casted_count():
	_current_ability_casted_count += 1
	
	if _current_ability_casted_count >= ability_cast_amount_for_empower:
		_current_ability_casted_count = 0
		_construct_and_add_ap_effect()

func _construct_and_add_ap_effect():
	var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_CELESTIAL_AP_BOOST)
	base_ap_attr_mod.flat_modifier = base_ap_amount * _ap_amount_scale
	
	var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_CELESTIAL_AP_BOOST)
	attr_effect.time_in_seconds = ap_buff_duration
	attr_effect.is_timebound = true
	attr_effect.status_bar_icon = preload("res://TowerRelated/Color_Violet/Celestial/IngAssets/IngCelestialAPActive_StatusBarIcon.png")
	
	_tower.add_tower_effect(attr_effect)




func _undo_modifications_to_tower(tower):
	if _effects_applied:
		_effects_applied = false
		
		_tower.disconnect("on_tower_ability_before_cast_start", self, "_on_tower_ability_before_cast_start")

####

func _can_be_absorbed_as_an_ingredient_by_tower(arg_tower):
	return arg_tower.all_tower_abiltiies.size() > 0
	


####

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	
	#armor_and_toughness_pierce_amount *= _current_additive_scale
	
	_ap_amount_scale = _current_additive_scale
	_current_additive_scale = 1
	
