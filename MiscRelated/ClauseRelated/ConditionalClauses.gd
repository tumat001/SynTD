
signal clause_inserted(clause)
signal clause_removed(clause)


var _clauses : Array = []
var blacklisted_clauses : Array = []

var is_passed : bool

func _init():
	is_passed = true


func is_passed_clauses() -> bool:
	return _clauses.size() == 0


func attempt_insert_clause(clause, clause_emit_signal : bool = true) -> bool:
	if !blacklisted_clauses.has(clause):
		if !_clauses.has(clause):
			_clauses.append(clause)
			_update_is_passed()
			
			if clause_emit_signal:
				emit_signal("clause_inserted", clause)
		
		return true
	else:
		return false


func remove_clause(clause, clause_emit_signal : bool = true):
	_clauses.erase(clause)
	_update_is_passed()
	
	if clause_emit_signal:
		emit_signal("clause_removed", clause)


func _update_is_passed():
	is_passed = is_passed_clauses()

