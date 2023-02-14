extends "res://MiscRelated/DialogRelated/Controls/DialogElementControls/BaseDialogElementControl.gd"


const VECTOR_UNDEFINED = Vector2(-1, -1)
const FLOAT_UNDEFINED = -9570.55

const time_taken_for_pos_change_transition : float = 0.5

#

enum TransitioningClauseIds {
	POS_X = 0,
	POS_Y = 1,
	
	MOD_A = 4,
}

var persistence_id : int



var initial_top_left_pos : Vector2 = VECTOR_UNDEFINED

var final_top_left_pos : Vector2
var final_top_left_pos_val_trans_mode : int = ValTransition.ValueIncrementMode.QUADRATIC #ValTransitionMode.QUAD



#

var val_transition__top_left_pos__x : ValTransition
var val_transition__top_left_pos__y : ValTransition

var is_transitioning_clauses : ConditionalClauses
var last_calculated_is_transitioning : bool

var transitioning_id_to_val_trans_map : Dictionary
var transitioning_id_to_is_active_map : Dictionary

##

func _ready():
	val_transition__top_left_pos__x = ValTransition.new()
	val_transition__top_left_pos__x.connect("target_val_reached", self, "_on_target_val_reached__background_ele_specific", [val_transition__top_left_pos__x, TransitioningClauseIds.POS_X], CONNECT_PERSIST)
	val_transition__top_left_pos__y = ValTransition.new()
	val_transition__top_left_pos__y.connect("target_val_reached", self, "_on_target_val_reached__background_ele_specific", [val_transition__top_left_pos__y, TransitioningClauseIds.POS_Y], CONNECT_PERSIST)
	
	
	transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_X] = val_transition__top_left_pos__x
	transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_Y] = val_transition__top_left_pos__y
	
	is_transitioning_clauses = ConditionalClauses.new()
	is_transitioning_clauses.connect("clause_inserted", self, "_on_is_transitioning_clauses_inserted", [], CONNECT_PERSIST)
	is_transitioning_clauses.connect("clause_removed", self, "_on_is_transitioning_clauses_removed", [], CONNECT_PERSIST)
	_update_last_calculated_is_transitioning()



func _on_is_transitioning_clauses_inserted(arg_clause_id):
	transitioning_id_to_is_active_map[arg_clause_id] = true
	_update_last_calculated_is_transitioning()

func _on_is_transitioning_clauses_removed(arg_clause_id):
	transitioning_id_to_is_active_map[arg_clause_id] = false
	_update_last_calculated_is_transitioning()

func _update_last_calculated_is_transitioning():
	last_calculated_is_transitioning = !is_transitioning_clauses.is_passed
	

func _on_target_val_reached__background_ele_specific(arg_val_transition, arg_transition_id):
	is_transitioning_clauses.remove_clause(arg_transition_id)


#

func _start_display():
	._start_display()
	
	if initial_top_left_pos != VECTOR_UNDEFINED:
		rect_position = initial_top_left_pos
	
	
	var final_time_taken_for_pos_change_transition = time_taken_for_pos_change_transition
	
	if !visible or modulate.a == 0:
		final_time_taken_for_pos_change_transition = 0
	
	if final_time_taken_for_pos_change_transition != 0:
		var reached_x = val_transition__top_left_pos__x.configure_self(rect_position.x, rect_position.x, final_top_left_pos.x, final_time_taken_for_pos_change_transition, ValTransition.VALUE_UNSET, final_top_left_pos_val_trans_mode)
		var reached_y = val_transition__top_left_pos__y.configure_self(rect_position.y, rect_position.y, final_top_left_pos.y, final_time_taken_for_pos_change_transition, ValTransition.VALUE_UNSET, final_top_left_pos_val_trans_mode)
		
		if !reached_x:
			is_transitioning_clauses.attempt_insert_clause(TransitioningClauseIds.POS_X)
		if !reached_y:
			is_transitioning_clauses.attempt_insert_clause(TransitioningClauseIds.POS_Y)
		
	else:
		rect_position = final_top_left_pos



func _force_finish_display():
	._force_finish_display()
	
	rect_position = final_top_left_pos



func _process(delta):
	if last_calculated_is_transitioning:
		if transitioning_id_to_is_active_map[TransitioningClauseIds.POS_X]:
			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_X]
			val_transition.delta_pass(delta)
			
			rect_position.x = val_transition.get_current_val()
		
		if transitioning_id_to_is_active_map[TransitioningClauseIds.POS_Y]:
			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_Y]
			val_transition.delta_pass(delta)
			
			rect_position.y = val_transition.get_current_val()
		

#
#const DialogSegment = preload("res://MiscRelated/DialogRelated/DataClasses/DialogSegment.gd")
#const ValTransition = preload("res://MiscRelated/ValTransitionRelated/ValTransition.gd")
#
#const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")
#
##
#
#const time_taken_for_pos_change_transition : float = 0.5
#const time_taken_for_size_change_transition : float = 0.5
#const time_taken_for_mod_a_change_transition : float = 0.25
#
#var val_transition__top_left_pos__x : ValTransition
#var val_transition__top_left_pos__y : ValTransition
#
#var val_transition__size__x : ValTransition
#var val_transition__size__y : ValTransition
#
#var val_transition__modulate_a : ValTransition
#
#
#enum TransitioningClauseIds {
#	POS_X = 0,
#	POS_Y = 1,
#
#	SIZE_X = 2,
#	SIZE_Y = 3,
#
#	MOD_A = 4,
#}
#
#var is_transitioning_clauses : ConditionalClauses
#var last_calculated_is_transitioning : bool
#
#var transitioning_id_to_val_trans_map : Dictionary
#var transitioning_id_to_is_active_map : Dictionary
#
#
#var persistence_id : int
#
##
#
#func _init():
#	val_transition__top_left_pos__x = ValTransition.new()
#	val_transition__top_left_pos__x.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__top_left_pos__x, TransitioningClauseIds.POS_X], CONNECT_PERSIST)
#	val_transition__top_left_pos__y = ValTransition.new()
#	val_transition__top_left_pos__y.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__top_left_pos__y, TransitioningClauseIds.POS_Y], CONNECT_PERSIST)
#
#	val_transition__size__x = ValTransition.new()
#	val_transition__size__x.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__size__x, TransitioningClauseIds.SIZE_X], CONNECT_PERSIST)
#	val_transition__size__y = ValTransition.new()
#	val_transition__size__y.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__size__y, TransitioningClauseIds.SIZE_Y], CONNECT_PERSIST)
#
#	val_transition__modulate_a = ValTransition.new()
#	val_transition__modulate_a.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__modulate_a, TransitioningClauseIds.MOD_A], CONNECT_PERSIST)
#
#	#
#
#
#	is_transitioning_clauses = ConditionalClauses.new()
#	is_transitioning_clauses.connect("clause_inserted", self, "_on_is_transitioning_clauses_inserted", [], CONNECT_PERSIST)
#	is_transitioning_clauses.connect("clause_removed", self, "_on_is_transitioning_clauses_removed", [], CONNECT_PERSIST)
#	_update_last_calculated_is_transitioning()
#
#	#
#	transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_X] = val_transition__top_left_pos__x
#	transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_Y] = val_transition__top_left_pos__y
#	transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_X] = val_transition__size__x
#	transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_Y] = val_transition__size__y
#	transitioning_id_to_val_trans_map[TransitioningClauseIds.MOD_A] = val_transition__modulate_a
#
#	for id in TransitioningClauseIds.values():
#		transitioning_id_to_is_active_map[id] = false
#
#
#func _on_is_transitioning_clauses_inserted(arg_clause_id):
#	transitioning_id_to_is_active_map[arg_clause_id] = true
#	_update_last_calculated_is_transitioning()
#
#func _on_is_transitioning_clauses_removed(arg_clause_id):
#	transitioning_id_to_is_active_map[arg_clause_id] = false
#	_update_last_calculated_is_transitioning()
#
#func _update_last_calculated_is_transitioning():
#	last_calculated_is_transitioning = !is_transitioning_clauses.is_passed
#
#
#func _on_target_val_reached(arg_val_transition, arg_transition_id):
#	is_transitioning_clauses.remove_clause(arg_transition_id)
#
#
###
#
#func _process(delta):
#	if last_calculated_is_transitioning:
#		if transitioning_id_to_is_active_map[TransitioningClauseIds.POS_X]:
#			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_X]
#			val_transition.delta_pass(delta)
#
#			rect_position.x = val_transition.get_current_val()
#
#		if transitioning_id_to_is_active_map[TransitioningClauseIds.POS_Y]:
#			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_Y]
#			val_transition.delta_pass(delta)
#
#			rect_position.y = val_transition.get_current_val()
#
#		if transitioning_id_to_is_active_map[TransitioningClauseIds.SIZE_X]:
#			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_X]
#			val_transition.delta_pass(delta)
#
#			#rect_min_size.x = val_transition.get_current_val()
#			rect_size.x = val_transition.get_current_val()
#
#		if transitioning_id_to_is_active_map[TransitioningClauseIds.SIZE_Y]:
#			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_Y]
#			val_transition.delta_pass(delta)
#
#			#rect_min_size.y = val_transition.get_current_val()
#			rect_size.y = val_transition.get_current_val()
#
#		if transitioning_id_to_is_active_map[TransitioningClauseIds.MOD_A]:
#			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.MOD_A]
#			val_transition.delta_pass(delta)
#
#			modulate.a = val_transition.get_current_val()
#
#
#
