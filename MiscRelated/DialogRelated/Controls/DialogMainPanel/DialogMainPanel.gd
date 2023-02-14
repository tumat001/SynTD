extends MarginContainer

const BaseDialogElementControl = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/BaseDialogElementControl.gd")
const DialogSegment = preload("res://MiscRelated/DialogRelated/DataClasses/DialogSegment.gd")
const ValTransition = preload("res://MiscRelated/ValTransitionRelated/ValTransition.gd")

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")


signal resolve_block_advanced_requested_status(arg_resolved)
signal request_next_base_DE_construction_ins()

#

const time_taken_for_pos_change_transition : float = 0.5
const time_taken_for_size_change_transition : float = 0.5
const time_taken_for_mod_a_change_transition : float = 0.25

var val_transition__top_left_pos__x : ValTransition
var val_transition__top_left_pos__y : ValTransition

var val_transition__size__x : ValTransition
var val_transition__size__y : ValTransition

var val_transition__modulate_a : ValTransition


enum TransitioningClauseIds {
	POS_X = 0,
	POS_Y = 1,
	
	SIZE_X = 2,
	SIZE_Y = 3,
	
	MOD_A = 4,
}

var is_transitioning_clauses : ConditionalClauses
var last_calculated_is_transitioning : bool

var transitioning_id_to_val_trans_map : Dictionary
var transitioning_id_to_is_active_map : Dictionary

#var transitioning_id_to_property_map : Dictionary = {
#	TransitioningClauseIds.POS_X : ["rect_position", "x"],
#	TransitioningClauseIds.POS_Y : ["rect_position", "y"],
#
#	TransitioningClauseIds.SIZE_X : ["rect_size", "x"],
#	TransitioningClauseIds.SIZE_Y : ["rect_size", "y"],
#
#	TransitioningClauseIds.MOD_A : ["modulate", "a"],
#}


#

var dialog_segment : DialogSegment setget set_dialog_segment

var _latest_base_dialog_ele_control : BaseDialogElementControl

#

var _all_borders : Array

onready var background = $Background
onready var left_border = $LeftBorder
onready var right_border = $RightBorder
onready var top_border = $TopBorder
onready var bottom_border = $BottomBorder

onready var content_panel = $Marginer/VBoxContainer/ContentPanel

#

func _init():
	val_transition__top_left_pos__x = ValTransition.new()
	val_transition__top_left_pos__x.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__top_left_pos__x, TransitioningClauseIds.POS_X], CONNECT_PERSIST)
	val_transition__top_left_pos__y = ValTransition.new()
	val_transition__top_left_pos__y.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__top_left_pos__y, TransitioningClauseIds.POS_Y], CONNECT_PERSIST)
	
	val_transition__size__x = ValTransition.new()
	val_transition__size__x.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__size__x, TransitioningClauseIds.SIZE_X], CONNECT_PERSIST)
	val_transition__size__y = ValTransition.new()
	val_transition__size__y.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__size__y, TransitioningClauseIds.SIZE_Y], CONNECT_PERSIST)
	
	val_transition__modulate_a = ValTransition.new()
	val_transition__modulate_a.connect("target_val_reached", self, "_on_target_val_reached", [val_transition__modulate_a, TransitioningClauseIds.MOD_A], CONNECT_PERSIST)
	
	#
	
	
	is_transitioning_clauses = ConditionalClauses.new()
	is_transitioning_clauses.connect("clause_inserted", self, "_on_is_transitioning_clauses_inserted", [], CONNECT_PERSIST)
	is_transitioning_clauses.connect("clause_removed", self, "_on_is_transitioning_clauses_removed", [], CONNECT_PERSIST)
	_update_last_calculated_is_transitioning()
	
	#
	
	transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_X] = val_transition__top_left_pos__x
	transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_Y] = val_transition__top_left_pos__y
	transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_X] = val_transition__size__x
	transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_Y] = val_transition__size__y
	transitioning_id_to_val_trans_map[TransitioningClauseIds.MOD_A] = val_transition__modulate_a
	
	for id in TransitioningClauseIds.values():
		transitioning_id_to_is_active_map[id] = false
	
	

func _ready():
	#
	
	_all_borders.append(left_border)
	_all_borders.append(right_border)
	_all_borders.append(left_border)
	_all_borders.append(bottom_border)
	
	##

#

func _on_is_transitioning_clauses_inserted(arg_clause_id):
	transitioning_id_to_is_active_map[arg_clause_id] = true
	_update_last_calculated_is_transitioning()

func _on_is_transitioning_clauses_removed(arg_clause_id):
	transitioning_id_to_is_active_map[arg_clause_id] = false
	_update_last_calculated_is_transitioning()

func _update_last_calculated_is_transitioning():
	last_calculated_is_transitioning = !is_transitioning_clauses.is_passed
	

func _on_target_val_reached(arg_val_transition, arg_transition_id):
	is_transitioning_clauses.remove_clause(arg_transition_id)


#

func set_dialog_segment(arg_segment, arg_set_to_visible : bool = true):
	if is_instance_valid(dialog_segment):
		pass
		#dialog_segment.disconnect("mouse_filter_changed", self, "_on_mouse_filter_of_dia_segment_changed")
	
	dialog_segment = arg_segment
	
	var final_time_taken_for_pos_change_transition = time_taken_for_pos_change_transition
	var final_time_taken_for_size_change_transition = time_taken_for_size_change_transition
	
	if !visible or modulate.a == 0:
		final_time_taken_for_pos_change_transition = 0
		final_time_taken_for_size_change_transition = 0
	
	if final_time_taken_for_pos_change_transition != 0:
		var reached_x = val_transition__top_left_pos__x.configure_self(rect_position.x, rect_position.x, dialog_segment.final_dialog_top_left_pos.x, final_time_taken_for_pos_change_transition, ValTransition.VALUE_UNSET, dialog_segment.final_dialog_top_left_pos_val_trans_mode)
		var reached_y = val_transition__top_left_pos__y.configure_self(rect_position.y, rect_position.y, dialog_segment.final_dialog_top_left_pos.y, final_time_taken_for_pos_change_transition, ValTransition.VALUE_UNSET, dialog_segment.final_dialog_top_left_pos_val_trans_mode)
		
		if !reached_x:
			is_transitioning_clauses.attempt_insert_clause(TransitioningClauseIds.POS_X)
		if !reached_y:
			is_transitioning_clauses.attempt_insert_clause(TransitioningClauseIds.POS_Y)
		
	else:
		rect_position = dialog_segment.final_dialog_top_left_pos
	
	if final_time_taken_for_size_change_transition != 0:
		var reached_x = val_transition__size__x.configure_self(rect_size.x, rect_size.x, dialog_segment.final_dialog_custom_size.x, final_time_taken_for_size_change_transition, ValTransition.VALUE_UNSET, dialog_segment.final_dialog_custom_size_val_trans_mode)
		var reached_y = val_transition__size__y.configure_self(rect_size.y, rect_size.y, dialog_segment.final_dialog_custom_size.y, final_time_taken_for_size_change_transition, ValTransition.VALUE_UNSET, dialog_segment.final_dialog_custom_size_val_trans_mode)
		
		if !reached_x:
			is_transitioning_clauses.attempt_insert_clause(TransitioningClauseIds.SIZE_X)
		if !reached_y:
			is_transitioning_clauses.attempt_insert_clause(TransitioningClauseIds.SIZE_Y)
	else:
		#rect_min_size = dialog_segment.final_dialog_custom_size
		rect_size = dialog_segment.final_dialog_custom_size
	
	if dialog_segment.make_dialog_main_panel_visible and (modulate.a != 1 or !visible):
		var reached_a = val_transition__modulate_a.configure_self(modulate.a, modulate.a, 1, time_taken_for_mod_a_change_transition, ValTransition.VALUE_UNSET, dialog_segment.make_dialog_main_panel_visible_val_trans_mode)
		if !reached_a:
			is_transitioning_clauses.attempt_insert_clause(TransitioningClauseIds.MOD_A)
	elif dialog_segment.make_dialog_main_panel_invis and (modulate.a != 0 or visible):
		var reached_a = val_transition__modulate_a.configure_self(modulate.a, modulate.a, 0, time_taken_for_mod_a_change_transition, ValTransition.VALUE_UNSET, dialog_segment.make_dialog_main_panel_invis_val_trans_mode)
		if !reached_a:
			is_transitioning_clauses.attempt_insert_clause(TransitioningClauseIds.MOD_A)
	
	top_border.texture = dialog_segment.top_border_texture
	bottom_border.texture = dialog_segment.bottom_border_texture
	left_border.texture = dialog_segment.left_border_texture
	right_border.texture = dialog_segment.right_border_texture
	
	if arg_set_to_visible:
		visible = true
	
	#########
	
	if is_instance_valid(dialog_segment):
		pass
	else:
		pass


func add_dialog_element_to_content_panel(arg_ele):
	if is_instance_valid(arg_ele):
		content_panel.add_child(arg_ele)

func flush_dialog_elements_in_content_panel():
	for ele in content_panel.get_children():
		ele.visible = false
		ele.queue_free()

#

func dia_seg_of_whole_screen_panel_changed():
	for child in content_panel.get_children():
		child._WSC_changed_dialog_segment()


func all_BDE_of_whole_screen_panel_diplay_finished():
	for child in content_panel.get_children():
		child._start_finished_preparation_and_display_of_WSC()

#

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
		
		if transitioning_id_to_is_active_map[TransitioningClauseIds.SIZE_X]:
			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_X]
			val_transition.delta_pass(delta)
			
			#rect_min_size.x = val_transition.get_current_val()
			rect_size.x = val_transition.get_current_val()
		
		if transitioning_id_to_is_active_map[TransitioningClauseIds.SIZE_Y]:
			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_Y]
			val_transition.delta_pass(delta)
			
			#rect_min_size.y = val_transition.get_current_val()
			rect_size.y = val_transition.get_current_val()
		
		if transitioning_id_to_is_active_map[TransitioningClauseIds.MOD_A]:
			var val_transition = transitioning_id_to_val_trans_map[TransitioningClauseIds.MOD_A]
			val_transition.delta_pass(delta)
			
			modulate.a = val_transition.get_current_val()
	
#		var ids = is_transitioning_clauses.get_all_clause_ids__of_non_composite__non_copy()
#		for id in ids:
#			var val_transition = transitioning_id_to_val_trans_map[id]
#			val_transition.delta_pass(delta)
#
#			var val_prop_name = transitioning_id_to_val_trans_map[id]
#			set()

#

func is_block_advance():
	return last_calculated_is_transitioning or !_latest_base_dialog_ele_control.last_calculated_is_fully_finished #and last_calculated_not_all_BDEs_are_shown

func resolve_block_advance():
	if last_calculated_is_transitioning:
		for val_transition in transitioning_id_to_val_trans_map.values():
			val_transition.instantly_finish_transition()
			
			if val_transition == transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_X]:
				rect_position.x = val_transition.get_current_val()
				
			elif val_transition == transitioning_id_to_val_trans_map[TransitioningClauseIds.POS_Y]:
				rect_position.y = val_transition.get_current_val()
				
			elif val_transition == transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_X]:
				rect_size.x = val_transition.get_current_val()
				
			elif val_transition == transitioning_id_to_val_trans_map[TransitioningClauseIds.SIZE_Y]:
				rect_size.y = val_transition.get_current_val()
				
			elif val_transition == transitioning_id_to_val_trans_map[TransitioningClauseIds.MOD_A]:
				modulate.a = val_transition.get_current_val()
	
	#
	
	if !_latest_base_dialog_ele_control.last_calculated_is_fully_finished:
		_latest_base_dialog_ele_control._force_finish_display()
	
	#if last_calculated_not_all_BDEs_are_shown:
	#	_latest_base_dialog_ele_control.set_mod_a_to_one__using_val_transition()
	
	call_deferred("_emit_resolve_block_advanced_requested_status")

func _emit_resolve_block_advanced_requested_status():
	emit_signal("resolve_block_advanced_requested_status", !is_block_advance())


##### DIA ELEMENTS


####### DIA SEGMENT SIGNALS

#func _on_mouse_filter_of_dia_segment_changed(_arg_filter):
#	mouse_filter = dialog_segment.mouse_filter
#


###

#func _unhandled_key_input(event : InputEventKey):
#	if !event.echo and event.pressed:
#		if event.is_action_pressed("ui_accept"):
#			emit_signal("player_enter_or_click_inputted")
#
#	accept_event()

#func _on_DialogMainPanel_gui_input(event):
#	pass # Replace with function body.




