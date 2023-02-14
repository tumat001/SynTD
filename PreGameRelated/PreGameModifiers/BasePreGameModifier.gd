extends Reference


enum BreakpointActivation {
	BEFORE_SINGLETONS_INITIALIZE = 0,
	AFTER_SINGLETONS_INITIALIZE = 1,
}

var breakpoint_activation : int


func _init(arg_breakpoint_activation_id : int):
	breakpoint_activation = arg_breakpoint_activation_id

##


func _apply_pre_game_modifier():
	pass
	

