extends Timer

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")


signal timeout_and_cleared_prevention()

var pause_conditional_clauses : ConditionalClauses
const stunned_clause : int = 10
const no_action_from_self_clause : int = 11
const prevented_clause : int = 12

var prevent_conditional_clauses : ConditionalClauses
var last_calculated_is_prevented : bool

#

var pauses_when_stunned : bool = false

#

var prevent_when_stunned : bool = true

#

var _queued_for_emiting_timeout_and_cleared_prevention : bool

#

var enemy setget set_enemy

#

func _init():
	pause_conditional_clauses = ConditionalClauses.new()
	pause_conditional_clauses.connect("clause_inserted", self, "_on_pause_conditional_clauses_clause_updated", [], CONNECT_PERSIST)
	pause_conditional_clauses.connect("clause_removed", self, "_on_pause_conditional_clauses_clause_updated", [], CONNECT_PERSIST)
	
	prevent_conditional_clauses = ConditionalClauses.new()
	prevent_conditional_clauses.connect("clause_inserted", self, "_on_prevent_conditional_clauses_clause_updated")
	prevent_conditional_clauses.connect("clause_removed", self, "_on_prevent_conditional_clauses_clause_updated")
	
	_update_last_calculated_is_prevented()
	connect("timeout", self, "_on_timeout", [], CONNECT_PERSIST)

func set_enemy(arg_enemy):
	if is_instance_valid(arg_enemy):
		if arg_enemy.is_connected("last_calculated_is_stunned_changed", self, "_on_last_calculated_is_stunned_changed"):
			arg_enemy.disconnect("last_calculated_is_stunned_changed", self, "_on_last_calculated_is_stunned_changed")
			arg_enemy.disconnect("last_calculated_no_action_from_self_changed", self, "_on_last_calculated_no_action_from_self_changed")
	
	enemy = arg_enemy
	
	if is_instance_valid(arg_enemy):
		if !enemy.is_connected("last_calculated_is_stunned_changed", self, "_on_last_calculated_is_stunned_changed"):
			enemy.connect("last_calculated_is_stunned_changed", self, "_on_last_calculated_is_stunned_changed", [], CONNECT_PERSIST)
			enemy.connect("last_calculated_no_action_from_self_changed", self, "_on_last_calculated_no_action_from_self_changed", [], CONNECT_PERSIST)
		
		_on_last_calculated_is_stunned_changed(enemy._is_stunned)
		_on_last_calculated_no_action_from_self_changed(enemy.last_calculated_no_action_from_self)


##

func _on_last_calculated_is_stunned_changed(arg_val):
	if pauses_when_stunned:
		if arg_val:
			pause_conditional_clauses.attempt_insert_clause(stunned_clause)
		else:
			pause_conditional_clauses.remove_clause(stunned_clause)
	
	if prevent_when_stunned:
		if arg_val:
			prevent_conditional_clauses.attempt_insert_clause(stunned_clause)
		else:
			prevent_conditional_clauses.remove_clause(stunned_clause)


func _on_last_calculated_no_action_from_self_changed(arg_val):
	if arg_val:
		pause_conditional_clauses.attempt_insert_clause(no_action_from_self_clause)
		prevent_conditional_clauses.attempt_insert_clause(no_action_from_self_clause)
	else:
		pause_conditional_clauses.remove_clause(no_action_from_self_clause)
		prevent_conditional_clauses.remove_clause(no_action_from_self_clause)

#########

func _on_pause_conditional_clauses_clause_updated(arg_clause_id):
	paused = !pause_conditional_clauses.is_passed



func _on_prevent_conditional_clauses_clause_updated(arg_clause_id):
	_update_last_calculated_is_prevented()
	
	if !last_calculated_is_prevented and _queued_for_emiting_timeout_and_cleared_prevention:
		_queued_for_emiting_timeout_and_cleared_prevention = false
		pause_conditional_clauses.remove_clause(prevented_clause)
		emit_signal("timeout_and_cleared_prevention")

func _update_last_calculated_is_prevented():
	last_calculated_is_prevented = !prevent_conditional_clauses.is_passed


#########

func _on_timeout():
	if last_calculated_is_prevented:
		_queued_for_emiting_timeout_and_cleared_prevention = true
		pause_conditional_clauses.attempt_insert_clause(prevented_clause)
	else:
		_queued_for_emiting_timeout_and_cleared_prevention = false
		emit_signal("timeout_and_cleared_prevention")


