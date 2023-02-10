
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const AbilityAttributesEffect = preload("res://GameInfoRelated/AbilityRelated/AbilityEffectRelated/AbilityAttributesEffect.gd")

signal ability_activated()
signal current_time_cd_changed(current_time_cd)
signal current_round_cd_changed(current_round_cd)
signal current_time_cd_reached_zero()

signal updated_is_ready_for_activation(is_ready)
signal icon_changed(icon)
signal display_name_changed(display_name)
signal descriptions_changed(descriptions)

signal started_time_cooldown(max_time_cd, current_time_cd)
signal started_round_cooldown(max_round_cd, current_round_cd)

signal destroying_self()

signal should_be_displaying_changed(bool_value)

signal auto_cast_state_changed(is_autocast_on)

signal final_ability_potency_changed()
signal final_ability_cdr_changed()


# NOT Automated. Emitted by caster
signal on_ability_before_cast_start(cooldown)
signal on_ability_after_cast_end(cooldown)


enum ActivationClauses {
	ROUND_INTERMISSION_STATE = 1000,
	ROUND_ONGOING_STATE = 1001,
	
	TOWER_IN_BENCH = 1002,
	SYNERGY_INACTIVE = 1003,
	SYNERGY_LEVEL_INSUFFICIENT = 1004,
	
	
	PASSIVE_BEHAVIOR__LA_NATURE__NO_ALIVE_LA_NATURES = 2001
}

enum CounterDecreaseClauses {
	ROUND_INTERMISSION_STATE = 1000,
	ROUND_ONGOING_STATE = 1001,
	
	TOWER_IN_BENCH = 1002,
	SYNERGY_INACTIVE = 1003,
	SYNERGY_LEVEL_INSUFFICIENT = 1004,
}

enum ShouldBeDisplayingClauses {
	TOWER_IN_BENCH = 1002,
	SYNERGY_INACTIVE = 1003,
	SYNERGY_LEVEL_INSUFFICIENT = 1004,
	
	PASSIVE_BEHAVIOR__LA_NATURE__NO_ACTIVE_LA_NATURES = 2000
}

enum AutoCastableClauses {
	CANNOT_BE_AUTOCASTED = 1004,
}

const ON_ABILITY_CAST_NO_COOLDOWN : float = -1.0
const ABILITY_MINIMUM_COOLDOWN : float = 0.1


var is_timebound : bool = false
var _time_max_cooldown : float = 0
var _time_current_cooldown : float = 0 

var is_roundbound : bool = false
var _round_max_cooldown : int = 0
var _round_current_cooldown : int = 0

var activation_conditional_clauses : ConditionalClauses
var counter_decrease_clauses : ConditionalClauses
var should_be_displaying_clauses : ConditionalClauses
var auto_castable_clauses : ConditionalClauses

var icon : Texture setget set_icon

#

var descriptions_source_func_name : String setget set_descriptions_source_func_name
var descriptions_source setget set_descriptions_source
var descriptions : Array = [] setget set_descriptions

var simple_descriptions_source_func_name : String setget set_simple_descriptions_source_func_name
var simple_descriptions_source setget set_simple_descriptions_source
var simple_descriptions : Array = [] setget set_simple_descriptions

#

var display_name : String setget set_display_name

var tower : Node setget set_tower
var synergy setget set_synergy
var red_pact setget set_red_pact

var should_be_displaying : bool setget, _get_should_be_displaying

var auto_cast_on : bool = false setget set_auto_cast_val
var auto_cast_func : String


var ignore_ability_effects_from_manager : bool = false

# Ability Power related

var base_ability_potency : float = 1
var _flat_base_ability_potency_effects : Dictionary = {}
var _percent_base_ability_potency_effects : Dictionary = {}
var last_calculated_final_ability_potency : float

var base_flat_ability_cdr : float = 0
var _flat_base_ability_cdr_effects : Dictionary = {}
var last_calculated_final_flat_ability_cdr : float

var base_percent_ability_cdr : float = 0
var _percent_base_ability_cdr_effects : Dictionary = {}
var last_calculated_final_percent_ability_cdr : float


func _init():
	activation_conditional_clauses = ConditionalClauses.new()
	activation_conditional_clauses.blacklisted_clauses.append(ActivationClauses.ROUND_ONGOING_STATE)
	activation_conditional_clauses.connect("clause_inserted", self, "emit_updated_is_ready_for_activation", [], CONNECT_PERSIST)
	activation_conditional_clauses.connect("clause_removed", self, "emit_updated_is_ready_for_activation", [], CONNECT_PERSIST)
	
	#
	
	counter_decrease_clauses = ConditionalClauses.new()
	counter_decrease_clauses.blacklisted_clauses.append(CounterDecreaseClauses.ROUND_ONGOING_STATE)
	
	#
	
	should_be_displaying_clauses = ConditionalClauses.new()
	should_be_displaying_clauses.connect("clause_inserted", self, "emit_updated_should_be_displayed", [], CONNECT_PERSIST)
	should_be_displaying_clauses.connect("clause_removed", self, "emit_updated_should_be_displayed", [], CONNECT_PERSIST)
	
	#
	
	auto_castable_clauses = ConditionalClauses.new()
	auto_castable_clauses.attempt_insert_clause(AutoCastableClauses.CANNOT_BE_AUTOCASTED)
	auto_castable_clauses.connect("clause_inserted", self, "emit_auto_cast_state_changed", [], CONNECT_PERSIST)
	auto_castable_clauses.connect("clause_removed", self, "emit_auto_cast_state_changed", [], CONNECT_PERSIST)
	
	_calculate_final_ability_potency()
	_calculate_final_flat_ability_cdr()
	_calculate_final_percent_ability_cdr()


# Activation related

func activate_ability(forced : bool = false):
	if is_ready_for_activation() or forced:
		emit_signal("ability_activated")


func is_ready_for_activation() -> bool:
	if is_time_ready_or_round_ready():
		return activation_conditional_clauses.is_passed
	else:
		return false


func is_time_ready_or_round_ready() -> bool:
	return (is_timebound and _time_current_cooldown <= 0) or (is_roundbound and _round_current_cooldown <= 0) or (!is_timebound and !is_roundbound)


# Setting of cooldown

func start_time_cooldown(arg_cooldown : float, ignore_self_cd : bool = false):
	if is_timebound:
		var cooldown = 0
		if !ignore_self_cd:
			cooldown = _get_cd_to_use(arg_cooldown)
		else:
			cooldown = arg_cooldown
		
		_time_max_cooldown = cooldown
		_time_current_cooldown = cooldown
		
		emit_signal("started_time_cooldown", _time_max_cooldown, _time_current_cooldown)
		emit_signal("current_time_cd_changed", _time_current_cooldown)
		emit_updated_is_ready_for_activation(0)


func _get_cd_to_use(cd_of_source : float) -> float:
	if cd_of_source == ON_ABILITY_CAST_NO_COOLDOWN:
		return ON_ABILITY_CAST_NO_COOLDOWN
	
	var final_cd : float = cd_of_source
	
	final_cd *= (100 - last_calculated_final_percent_ability_cdr) / 100
	final_cd -= last_calculated_final_flat_ability_cdr
	
	if final_cd < ABILITY_MINIMUM_COOLDOWN:
		final_cd = ABILITY_MINIMUM_COOLDOWN
	
	return final_cd

func get_potency_to_use(potency_of_source : float) -> float:
	return potency_of_source * last_calculated_final_ability_potency


func start_round_cooldown(cooldown : int):
	if is_roundbound:
		_round_max_cooldown = cooldown
		_round_current_cooldown = cooldown
		
		emit_signal("started_round_cooldown", _round_max_cooldown, _round_current_cooldown)
		emit_signal("current_round_cd_changed", _round_current_cooldown)
		emit_updated_is_ready_for_activation(0)


# time related

func time_decreased(delta : float):
	if is_timebound and _time_current_cooldown > 0:
		if counter_decrease_clauses.is_passed:
			
			_time_current_cooldown -= delta
			emit_signal("current_time_cd_changed", _time_current_cooldown)
			
			if _time_current_cooldown <= 0:
				emit_signal("current_time_cd_reached_zero")
				emit_updated_is_ready_for_activation(0)


func remove_all_time_cooldown():
	if is_timebound and _time_current_cooldown > 0:
		_time_current_cooldown = 0
		emit_signal("current_time_cd_changed", _time_current_cooldown)
		
		if _time_current_cooldown <= 0:
			emit_signal("current_time_cd_reached_zero")
			emit_updated_is_ready_for_activation(0)


func time_decreased_by_percent(arg_percent : float, percent_type : int):
	var amount : float = 0
	
	if percent_type == PercentType.BASE or percent_type == PercentType.MAX:
		amount = _time_max_cooldown * arg_percent / 100
	elif percent_type == PercentType.CURRENT:
		amount = _time_current_cooldown * arg_percent / 100
	elif percent_type == PercentType.MISSING:
		amount = (_time_max_cooldown - _time_current_cooldown) * arg_percent / 100
	
	time_decreased(amount)

# round related

func round_ended():
	if is_roundbound and _round_current_cooldown > 0:
		if counter_decrease_clauses.is_passed:
			_round_current_cooldown -= 1
			emit_signal("current_round_cd_changed", _round_current_cooldown)
	
	activation_conditional_clauses.remove_clause(ActivationClauses.ROUND_ONGOING_STATE, false)
	activation_conditional_clauses.attempt_insert_clause(ActivationClauses.ROUND_INTERMISSION_STATE)
	
	counter_decrease_clauses.remove_clause(CounterDecreaseClauses.ROUND_ONGOING_STATE, false)
	counter_decrease_clauses.attempt_insert_clause(CounterDecreaseClauses.ROUND_INTERMISSION_STATE)


func round_started():
	activation_conditional_clauses.attempt_insert_clause(ActivationClauses.ROUND_ONGOING_STATE, false)
	activation_conditional_clauses.remove_clause(ActivationClauses.ROUND_INTERMISSION_STATE)
	
	counter_decrease_clauses.attempt_insert_clause(CounterDecreaseClauses.ROUND_ONGOING_STATE, false)
	counter_decrease_clauses.remove_clause(CounterDecreaseClauses.ROUND_INTERMISSION_STATE)


# signals related

func emit_updated_is_ready_for_activation(clause):
	emit_signal("updated_is_ready_for_activation", is_ready_for_activation())


func emit_updated_should_be_displayed(clause):
	emit_signal("should_be_displaying_changed", should_be_displaying_clauses.is_passed)


# setters

func set_icon(arg_icon):
	icon = arg_icon
	call_deferred("emit_signal", "icon_changed", icon)

func set_descriptions(arg_desc : Array):
	descriptions.clear()
	for des in arg_desc:
		descriptions.append(des)
		
	call_deferred("emit_signal", "descriptions_changed", arg_desc)

func set_descriptions_source_func_name(arg_func_name : String):
	descriptions_source_func_name = arg_func_name

func set_descriptions_source(arg_source):
	descriptions_source = arg_source



func set_simple_descriptions(arg_desc : Array):
	simple_descriptions.clear()
	for des in arg_desc:
		simple_descriptions.append(des)
	
	call_deferred("emit_signal", "descriptions_changed", arg_desc)

func set_simple_descriptions_source_func_name(arg_func_name : String):
	simple_descriptions_source_func_name = arg_func_name

func set_simple_descriptions_source(arg_source):
	simple_descriptions_source = arg_source


func has_simple_descriptions():
	return (simple_descriptions != null and simple_descriptions.size() != 0) or simple_descriptions_source != null

#

func set_display_name(arg_name : String):
	display_name = arg_name
	call_deferred("emit_signal", "display_name_changed", arg_name)


func set_tower(arg_tower : Node):
	if is_instance_valid(tower):
		if tower.is_connected("tree_exiting", self, "destroy_self"): 
			tower.disconnect("tree_exiting", self, "destroy_self")
			tower.disconnect("tower_active_in_map", self, "_tower_active_in_map")
			tower.disconnect("tower_not_in_active_map", self, "_tower_not_active_in_map")
			activation_conditional_clauses.remove_clause(tower.disabled_from_attacking_clauses)
	
	tower = arg_tower
	
	if is_instance_valid(tower):
		if !tower.is_connected("tree_exiting", self, "destroy_self"): 
			tower.connect("tree_exiting", self, "destroy_self", [], CONNECT_PERSIST)
			tower.connect("tower_active_in_map", self, "_tower_active_in_map", [], CONNECT_PERSIST)
			tower.connect("tower_not_in_active_map", self, "_tower_not_active_in_map", [], CONNECT_PERSIST)
			activation_conditional_clauses.attempt_insert_clause(tower.disabled_from_attacking_clauses)
			
			if tower.is_current_placable_in_map():
				_tower_active_in_map()
			else:
				_tower_not_active_in_map()
			
			if tower.is_round_started:
				round_started()
			else:
				round_ended()


func set_synergy(arg_synergy):
	synergy = arg_synergy
	
	synergy.connect("synergy_applied", self, "_synergy_active", [], CONNECT_PERSIST)
	synergy.connect("synergy_removed", self, "_synergy_removed", [], CONNECT_PERSIST)


func set_red_pact(arg_pact):
	red_pact = arg_pact
	
	red_pact.connect("on_activation_requirements_met", self, "_red_pact_activation_requirements_met", [], CONNECT_PERSIST)
	red_pact.connect("on_activation_requirements_unmet", self, "_red_pact_activation_requirements_unmet", [], CONNECT_PERSIST)


# getters

func _get_should_be_displaying() -> bool:
	return should_be_displaying_clauses.is_passed


# tower related clauses

func _tower_active_in_map():
	activation_conditional_clauses.remove_clause(ActivationClauses.TOWER_IN_BENCH)
	counter_decrease_clauses.remove_clause(CounterDecreaseClauses.TOWER_IN_BENCH)
	should_be_displaying_clauses.remove_clause(ShouldBeDisplayingClauses.TOWER_IN_BENCH)

func _tower_not_active_in_map():
	activation_conditional_clauses.attempt_insert_clause(ActivationClauses.TOWER_IN_BENCH)
	counter_decrease_clauses.attempt_insert_clause(CounterDecreaseClauses.TOWER_IN_BENCH)
	should_be_displaying_clauses.attempt_insert_clause(ShouldBeDisplayingClauses.TOWER_IN_BENCH)



# synergy related clauses

func _synergy_active(tier):
	activation_conditional_clauses.remove_clause(ActivationClauses.SYNERGY_INACTIVE)
	counter_decrease_clauses.remove_clause(CounterDecreaseClauses.SYNERGY_INACTIVE)
	should_be_displaying_clauses.remove_clause(ShouldBeDisplayingClauses.SYNERGY_INACTIVE)

func _synergy_removed(tier):
	activation_conditional_clauses.attempt_insert_clause(ActivationClauses.SYNERGY_INACTIVE)
	counter_decrease_clauses.attempt_insert_clause(CounterDecreaseClauses.SYNERGY_INACTIVE)
	should_be_displaying_clauses.attempt_insert_clause(ShouldBeDisplayingClauses.SYNERGY_INACTIVE)

#

func _red_pact_activation_requirements_met(tier):
	activation_conditional_clauses.remove_clause(ActivationClauses.SYNERGY_INACTIVE)
	counter_decrease_clauses.remove_clause(CounterDecreaseClauses.SYNERGY_INACTIVE)
	should_be_displaying_clauses.remove_clause(ShouldBeDisplayingClauses.SYNERGY_INACTIVE)


func _red_pact_activation_requirements_unmet(tier):
	activation_conditional_clauses.attempt_insert_clause(ActivationClauses.SYNERGY_INACTIVE)
	counter_decrease_clauses.attempt_insert_clause(CounterDecreaseClauses.SYNERGY_INACTIVE)
	should_be_displaying_clauses.attempt_insert_clause(ShouldBeDisplayingClauses.SYNERGY_INACTIVE)



# Autocast stuffs

func set_auto_cast_val(value : bool):
	auto_cast_on = value
	emit_auto_cast_state_changed(null)


func emit_auto_cast_state_changed(clause):
	var is_passed = auto_castable_clauses.is_passed
	
	if !is_passed:
		auto_cast_on = false
		if is_connected("updated_is_ready_for_activation", self, "_on_ability_attempt_auto_cast"):
			disconnect("updated_is_ready_for_activation", self, "_on_ability_attempt_auto_cast")
		
	else:
		if auto_cast_on:
			if !is_connected("updated_is_ready_for_activation", self, "_on_ability_attempt_auto_cast"):
				connect("updated_is_ready_for_activation", self, "_on_ability_attempt_auto_cast", [], CONNECT_PERSIST)
			_on_ability_attempt_auto_cast(null)
			
		else:
			if is_connected("updated_is_ready_for_activation", self, "_on_ability_attempt_auto_cast"):
				disconnect("updated_is_ready_for_activation", self, "_on_ability_attempt_auto_cast")
	
	emit_signal("auto_cast_state_changed", auto_cast_on)


func _on_ability_attempt_auto_cast(any_var):
	if is_ready_for_activation() and auto_cast_on:
		if auto_cast_func != null:
			if is_instance_valid(tower):
				tower.call_deferred(auto_cast_func)
			
			elif synergy != null:
				synergy.call_deferred(auto_cast_func)


# destroying self

func destroy_self():
	emit_signal("destroying_self")


# template

func set_properties_to_usual_tower_based():
	should_be_displaying_clauses.attempt_insert_clause(ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	activation_conditional_clauses.attempt_insert_clause(ActivationClauses.TOWER_IN_BENCH)
	counter_decrease_clauses.attempt_insert_clause(CounterDecreaseClauses.TOWER_IN_BENCH)


func set_properties_to_usual_synergy_based():
	pass


func set_properties_to_auto_castable():
	auto_castable_clauses.remove_clause(AutoCastableClauses.CANNOT_BE_AUTOCASTED)


func set_properties_to_enemy_based():
	ignore_ability_effects_from_manager = true


#

func set_clauses_to_usual_synergy_insufficient_based():
	should_be_displaying_clauses.attempt_insert_clause(ShouldBeDisplayingClauses.SYNERGY_LEVEL_INSUFFICIENT)
	activation_conditional_clauses.attempt_insert_clause(ActivationClauses.SYNERGY_LEVEL_INSUFFICIENT)
	counter_decrease_clauses.attempt_insert_clause(CounterDecreaseClauses.SYNERGY_LEVEL_INSUFFICIENT)

func set_clauses_to_usual_synergy_sufficient_based():
	should_be_displaying_clauses.remove_clause(ShouldBeDisplayingClauses.SYNERGY_LEVEL_INSUFFICIENT)
	activation_conditional_clauses.remove_clause(ActivationClauses.SYNERGY_LEVEL_INSUFFICIENT)
	counter_decrease_clauses.remove_clause(CounterDecreaseClauses.SYNERGY_LEVEL_INSUFFICIENT)


#


func on_ability_before_cast_start(cooldown : float):
	emit_signal("on_ability_before_cast_start", cooldown)

func on_ability_after_cast_ended(cooldown : float):
	emit_signal("on_ability_after_cast_end", cooldown)



# Ability adding removing stats related

func add_ability_effect_from_manager(attr_effect : AbilityAttributesEffect):
	if !ignore_ability_effects_from_manager:
		add_ability_effect(attr_effect)

func remove_ability_effect_from_manager(attr_effect : AbilityAttributesEffect):
	if !ignore_ability_effects_from_manager:
		remove_ability_effect(attr_effect)


func add_ability_effect(attr_effect : AbilityAttributesEffect):
	if attr_effect.attribute_type == AbilityAttributesEffect.FLAT_ABILITY_POTENCY or attr_effect.attribute_type == AbilityAttributesEffect.PERCENT_ABILITY_POTENCY:
		add_ability_potency_effect(attr_effect)
	elif attr_effect.attribute_type == AbilityAttributesEffect.FLAT_ABILITY_CDR or attr_effect.attribute_type == AbilityAttributesEffect.PERCENT_ABILITY_CDR:
		add_ability_cdr_effect(attr_effect)

func remove_ability_effect(attr_effect : AbilityAttributesEffect):
	if attr_effect.attribute_type == AbilityAttributesEffect.FLAT_ABILITY_POTENCY or attr_effect.attribute_type == AbilityAttributesEffect.PERCENT_ABILITY_POTENCY:
		remove_ability_potency_effect(attr_effect.effect_uuid)
	elif attr_effect.attribute_type == AbilityAttributesEffect.FLAT_ABILITY_CDR:
		remove_flat_ability_cdr_effect(attr_effect.effect_uuid)
	elif attr_effect.attribute_type == AbilityAttributesEffect.PERCENT_ABILITY_CDR:
		remove_percent_ability_cdr_effect(attr_effect.effect_uuid)


#

func add_ability_potency_effect(attr_effect : AbilityAttributesEffect):
	if attr_effect.attribute_type == AbilityAttributesEffect.FLAT_ABILITY_POTENCY:
		_flat_base_ability_potency_effects[attr_effect.effect_uuid] = attr_effect
	elif attr_effect.attribute_type == AbilityAttributesEffect.PERCENT_ABILITY_POTENCY:
		_percent_base_ability_potency_effects[attr_effect.effect_uuid] = attr_effect
	
	_calculate_final_ability_potency()


func remove_ability_potency_effect(attr_effect_uuid : int):
	_flat_base_ability_potency_effects.erase(attr_effect_uuid)
	_percent_base_ability_potency_effects.erase(attr_effect_uuid)
	
	_calculate_final_ability_potency()


func add_ability_cdr_effect(attr_effect : AbilityAttributesEffect):
	if attr_effect.attribute_type == AbilityAttributesEffect.FLAT_ABILITY_CDR:
		_flat_base_ability_cdr_effects[attr_effect.effect_uuid] = attr_effect
		_calculate_final_flat_ability_cdr()
	elif attr_effect.attribute_type == AbilityAttributesEffect.PERCENT_ABILITY_CDR:
		_percent_base_ability_cdr_effects[attr_effect.effect_uuid] = attr_effect
		_calculate_final_percent_ability_cdr()

func remove_flat_ability_cdr_effect(attr_effect_uuid : int):
	_flat_base_ability_cdr_effects.erase(attr_effect_uuid)
	_calculate_final_flat_ability_cdr()

func remove_percent_ability_cdr_effect(attr_effect_uuid : int):
	_percent_base_ability_cdr_effects.erase(attr_effect_uuid)
	_calculate_final_percent_ability_cdr()



# Ability calculation related

func _calculate_final_ability_potency():
	var final_ap = base_ability_potency
	
	#if benefits_from_bonus_base_damage:
	var totals_bucket : Array = []
	
	for effect in _percent_base_ability_potency_effects.values():
		if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
			final_ap += effect.attribute_as_modifier.get_modification_to_value(base_ability_potency)
		else:
			totals_bucket.append(effect)
	
	for effect in _flat_base_ability_potency_effects.values():
		final_ap += effect.attribute_as_modifier.get_modification_to_value(base_ability_potency)
	
	var final_base_ap = final_ap
	for effect in totals_bucket:
		final_base_ap += effect.attribute_as_modifier.get_modification_to_value(final_base_ap)
	final_ap = final_base_ap
	
	last_calculated_final_ability_potency = final_ap
	emit_signal("final_ability_potency_changed")
	return last_calculated_final_ability_potency


func _calculate_final_flat_ability_cdr():
	var final_cdr = base_flat_ability_cdr
	
	for effect in _flat_base_ability_potency_effects.values():
		final_cdr += effect.attribute_as_modifier.get_modification_to_value(base_flat_ability_cdr)
	
	last_calculated_final_flat_ability_cdr = final_cdr
	emit_signal("final_ability_cdr_changed")
	return last_calculated_final_flat_ability_cdr



func _calculate_final_percent_ability_cdr():
	var final_percent_cdr = base_percent_ability_cdr
	
	for effect in _percent_base_ability_cdr_effects.values():
		# Intentionally does not use "get_modification_to"
		final_percent_cdr = _get_add_cdr_to_total_cdr(effect.attribute_as_modifier.percent_amount, final_percent_cdr)
	
	if final_percent_cdr > 95:
		final_percent_cdr = 95
	
	last_calculated_final_percent_ability_cdr = final_percent_cdr
	emit_signal("final_ability_cdr_changed")
	return last_calculated_final_percent_ability_cdr

func _get_add_cdr_to_total_cdr(arg_cdr, arg_total_cdr) -> float:
	var missing = 100 - arg_total_cdr
	
	return arg_total_cdr + (arg_cdr * (1 - ((100 - missing) / 100)))
