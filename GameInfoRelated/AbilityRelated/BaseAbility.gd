
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

signal ability_activated()
signal current_time_cd_changed(current_time_cd)
signal current_round_cd_changed(current_round_cd)

signal updated_is_ready_for_activation(is_ready)
signal icon_changed(icon)

signal started_time_cooldown(max_time_cd, current_time_cd)
signal started_round_cooldown(max_round_cd, current_round_cd)

signal destroying_self()

signal should_be_displaying_changed(bool_value)


enum ActivationClauses {
	ROUND_INTERMISSION_STATE = 0,
	ROUND_ONGOING_STATE = 1,
	
	TOWER_IN_BENCH = 2,
	SYNERGY_INACTIVE = 3,
}

enum CounterDecreaseClauses {
	ROUND_INTERMISSION_STATE = 0,
	ROUND_ONGOING_STATE = 1,
	
	TOWER_IN_BENCH = 2,
	SYNERGY_INACTIVE = 3,
}

enum ShouldBeDisplayingClauses {
	TOWER_IN_BENCH = 2,
	SYNERGY_INACTIVE = 3,
}


var is_timebound : bool = false
var _time_max_cooldown : float = 0
var _time_current_cooldown : float = 0 

var is_roundbound : bool = false
var _round_max_cooldown : int = 0
var _round_current_cooldown : int = 0

var activation_conditional_clauses : ConditionalClauses
var counter_decrease_clauses : ConditionalClauses
var should_be_displaying_clauses : ConditionalClauses

var icon : Texture setget set_icon

var descriptions : Array = [] setget set_descriptions

var tower : Node setget set_tower
var synergy : Node setget set_synergy

var should_be_displaying : bool setget, _get_should_be_displaying


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
	return (is_timebound and _time_current_cooldown <= 0) or (is_roundbound and _round_current_cooldown <= 0)


# Setting of cooldown

func start_time_cooldown(cooldown : float):
	if is_timebound:
		_time_max_cooldown = cooldown
		_time_current_cooldown = cooldown
		
		emit_signal("started_time_cooldown", _time_max_cooldown, _time_current_cooldown)
		emit_signal("current_time_cd_changed", _time_current_cooldown)
		emit_updated_is_ready_for_activation(0)


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
				emit_updated_is_ready_for_activation(0)


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


func set_tower(arg_tower : Node):
	if tower != null:
		if tower.is_connected("tree_exiting", self, "destroy_self"): 
			tower.disconnect("tree_exiting", self, "destroy_self")
			tower.disconnect("tower_active_in_map", self, "_tower_active_in_map")
			tower.disconnect("tower_not_in_active_map", self, "_tower_not_active_in_map")
	
	tower = arg_tower
	
	if tower != null:
		if !tower.is_connected("tree_exiting", self, "destroy_self"): 
			tower.connect("tree_exiting", self, "destroy_self", [], CONNECT_PERSIST)
			tower.connect("tower_active_in_map", self, "_tower_active_in_map", [], CONNECT_PERSIST)
			tower.connect("tower_not_in_active_map", self, "_tower_not_active_in_map", [], CONNECT_PERSIST)


func set_descriptions(arg_desc : Array):
	descriptions.clear()
	for des in arg_desc:
		descriptions.append(des)


func set_synergy(arg_synergy : Node):
	synergy = arg_synergy
	
	synergy.connect("synergy_applied", self, "_synergy_active", [], CONNECT_PERSIST)
	synergy.connect("synergy_removed", self, "_synergy_removed", [], CONNECT_PERSIST)


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

func _synergy_active():
	activation_conditional_clauses.remove_clause(ActivationClauses.SYNERGY_INACTIVE)
	counter_decrease_clauses.remove_clause(CounterDecreaseClauses.SYNERGY_INACTIVE)
	should_be_displaying_clauses.remove_clause(ShouldBeDisplayingClauses.SYNERGY_INACTIVE)

func _synergy_removed():
	activation_conditional_clauses.attempt_insert_clause(ActivationClauses.SYNERGY_INACTIVE)
	counter_decrease_clauses.attempt_insert_clause(CounterDecreaseClauses.SYNERGY_INACTIVE)
	should_be_displaying_clauses.attempt_insert_clause(ShouldBeDisplayingClauses.SYNERGY_INACTIVE)


# destroying self

func destroy_self():
	emit_signal("destroying_self")


# template

func set_properties_to_usual_tower_based():
	should_be_displaying_clauses.attempt_insert_clause(ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	activation_conditional_clauses.attempt_insert_clause(ActivationClauses.TOWER_IN_BENCH)
	counter_decrease_clauses.attempt_insert_clause(CounterDecreaseClauses.TOWER_IN_BENCH)
