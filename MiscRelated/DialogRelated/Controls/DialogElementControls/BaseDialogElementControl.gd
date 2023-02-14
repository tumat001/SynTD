extends Control

const ValTransition = preload("res://MiscRelated/ValTransitionRelated/ValTransition.gd")

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")


signal mod_a_increase_to_target__finished()
signal mod_a_decrease_to_target__finished()

signal block_next_element_show_changed(arg_val)

signal is_fully_finished()

const time_taken_for_mod_a_change_transition : float = 0.25

#

var val_transition_for_mod_a : ValTransition
#var _is_val_for_mod_a_transitioning : bool


enum ChangeState {
	INCREASE = 0,
	DECREASE = 1,
	NONE = 2,
}
var _mod_a_change_state : int = ChangeState.NONE

var block_next_element_show : bool = false setget set_block_next_element_show


enum IsFullyFinishedClauseIds {
	MODULATE_CHANGE = 0
	
	DESCS_PANEL__TEXT_RUNNING = 10
	CHOICES_PANEL__CHOICES_SHOWING = 11
}

var is_fully_finished_conditional_clauses : ConditionalClauses
var last_calculated_is_fully_finished : bool

#

func _init():
	is_fully_finished_conditional_clauses = ConditionalClauses.new()
	is_fully_finished_conditional_clauses.connect("clause_inserted", self, "_is_fully_finished_conditional_clauses_updated", [], CONNECT_PERSIST)
	is_fully_finished_conditional_clauses.connect("clause_removed", self, "_is_fully_finished_conditional_clauses_updated", [], CONNECT_PERSIST)
	_is_fully_finished_conditional_clauses_updated(null)

func _is_fully_finished_conditional_clauses_updated(_arg_clause):
	last_calculated_is_fully_finished = is_fully_finished_conditional_clauses.is_passed
	
	if last_calculated_is_fully_finished:
		emit_signal("is_fully_finished")

#

func _ready():
	val_transition_for_mod_a = ValTransition.new()
	val_transition_for_mod_a.connect("target_val_reached", self, "_on_target_val_reached", [], CONNECT_PERSIST)


func set_block_next_element_show(arg_val):
	block_next_element_show = arg_val
	
	emit_signal("block_next_element_show_changed", arg_val)

#

func set_mod_a_to_zero():
	modulate.a = 0

func start_mod_a_increase():
	is_fully_finished_conditional_clauses.attempt_insert_clause(IsFullyFinishedClauseIds.MODULATE_CHANGE)
	
	_mod_a_change_state = ChangeState.INCREASE
	val_transition_for_mod_a.configure_self(modulate.a, modulate.a, 1, time_taken_for_mod_a_change_transition, ValTransition.VALUE_UNSET, ValTransition.ValueIncrementMode.LINEAR)

func start_mod_a_decrease():
	is_fully_finished_conditional_clauses.attempt_insert_clause(IsFullyFinishedClauseIds.MODULATE_CHANGE)
	
	_mod_a_change_state = ChangeState.DECREASE
	val_transition_for_mod_a.configure_self(modulate.a, modulate.a, 0, time_taken_for_mod_a_change_transition, ValTransition.VALUE_UNSET, ValTransition.ValueIncrementMode.LINEAR)

func set_mod_a_to_zero__using_val_transition():
	val_transition_for_mod_a.configure_self(modulate.a, modulate.a, 0, 0, ValTransition.VALUE_UNSET, ValTransition.ValueIncrementMode.LINEAR)

func set_mod_a_to_one__using_val_transition():
	val_transition_for_mod_a.configure_self(modulate.a, modulate.a, 1, 0, ValTransition.VALUE_UNSET, ValTransition.ValueIncrementMode.LINEAR)



func _on_target_val_reached():
	modulate.a = val_transition_for_mod_a.get_current_val()
	
	if _mod_a_change_state == ChangeState.INCREASE:
		_mod_a_change_state = ChangeState.NONE
		
		emit_signal("mod_a_increase_to_target__finished")
		
	elif _mod_a_change_state == ChangeState.DECREASE:
		_mod_a_change_state = ChangeState.NONE
		
		emit_signal("mod_a_decrease_to_target__finished")
	
	is_fully_finished_conditional_clauses.remove_clause(IsFullyFinishedClauseIds.MODULATE_CHANGE)
	

#

func _start_display():
	pass

func _force_finish_display():
	pass


func _is_fully_displayed():
	#return (_mod_a_change_state == ChangeState.NONE)
	return last_calculated_is_fully_finished

func _block_next_element_show():
	return block_next_element_show


#

# WSC is WholeScreenPanel
func _start_finished_preparation_and_display_of_WSC():
	pass

func _WSC_changed_dialog_segment():
	pass


#

func _process(delta):
	if _mod_a_change_state != ChangeState.NONE:
		val_transition_for_mod_a.delta_pass(delta)
		
		modulate.a = val_transition_for_mod_a.get_current_val()
	
