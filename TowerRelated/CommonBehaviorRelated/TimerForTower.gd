extends Timer

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")


signal timer_stopped()


var _current_tower

#

var stop_on_round_end_instead_of_pause : bool = true

var pause_on_disabled_from_attacking : bool = true

var stop_on_no_health_instead_of_pause : bool = true
var resume_from_pause_from_no_health : bool = true

#

enum IsPausedClauseIds {
	ON_ROUND_END = 1,
	DISABLED_FROM_ATTACKING = 2,
	NO_HEALTH = 3,
	
}
var is_paused_conditional_clauses : ConditionalClauses
var last_calculated_is_paused : bool

#

func _init():
	is_paused_conditional_clauses = ConditionalClauses.new()
	is_paused_conditional_clauses.connect("clause_inserted", self, "_on_is_paused_clause_ins_or_rem", [], CONNECT_PERSIST)
	is_paused_conditional_clauses.connect("clause_removed", self, "_on_is_paused_clause_ins_or_rem", [], CONNECT_PERSIST)
	_update_last_calculated_is_paused()

func _on_is_paused_clause_ins_or_rem(_arg_clause_id):
	_update_last_calculated_is_paused()
	


func _update_last_calculated_is_paused():
	last_calculated_is_paused = !is_paused_conditional_clauses.is_passed
	
	paused = last_calculated_is_paused

#

func set_tower_and_properties(arg_tower):
	_current_tower = arg_tower
	
	_current_tower.connect("on_tower_no_health", self, "_on_tower_lost_all_health", [], CONNECT_PERSIST)
	_current_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
	_current_tower.connect("on_last_calculated_disabled_from_attacking_changed", self, "_on_last_calculated_disabled_from_attacking_changed", [], CONNECT_PERSIST)
	_current_tower.connect("on_round_start", self, "_on_round_start", [], CONNECT_PERSIST)
	_current_tower.connect("on_tower_healed_from_no_health", self, "_on_tower_healed_from_no_health", [], CONNECT_PERSIST)
	
	
	_on_last_calculated_disabled_from_attacking_changed(_current_tower.last_calculated_disabled_from_attacking)
#	if _current_tower.is_round_started:
#		_on_round_start()
#	else:
#		_on_round_end()
	

#

func _on_round_end():
	if stop_on_round_end_instead_of_pause:
		stop()
	else:
		#paused = true
		is_paused_conditional_clauses.attempt_insert_clause(IsPausedClauseIds.ON_ROUND_END)

func _on_round_start():
	if paused:
		#paused = false
		is_paused_conditional_clauses.remove_clause(IsPausedClauseIds.ON_ROUND_END)

func _on_last_calculated_disabled_from_attacking_changed(arg_val):
	if pause_on_disabled_from_attacking:
		#paused = arg_val
		if arg_val:
			is_paused_conditional_clauses.attempt_insert_clause(IsPausedClauseIds.ON_ROUND_END)
		else:
			is_paused_conditional_clauses.remove_clause(IsPausedClauseIds.ON_ROUND_END)
		
		
	
#	if arg_val:
#		stop()



func _on_tower_lost_all_health():
	if stop_on_no_health_instead_of_pause:
		stop()
	else:
		is_paused_conditional_clauses.attempt_insert_clause(IsPausedClauseIds.NO_HEALTH)

func _on_tower_healed_from_no_health():
	if resume_from_pause_from_no_health:
		is_paused_conditional_clauses.remove_clause(IsPausedClauseIds.NO_HEALTH)

#

func stop():
	.stop()
	
	emit_signal("timer_stopped")

func start(arg_time : float = 1):
	.start(arg_time)



