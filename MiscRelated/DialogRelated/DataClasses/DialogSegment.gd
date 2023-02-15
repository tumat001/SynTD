extends Reference

const Border_Pic_Default = preload("res://MiscRelated/DialogRelated/Assets/Shared/Dialog_DarkGrayBorder_ForContent_4x4.png")
const ValTransition = preload("res://MiscRelated/ValTransitionRelated/ValTransition.gd")

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")


signal requested_action_advance()
signal requested_action_previous()
signal requested_action_skip()

signal full_reset_triggered()
signal partial_reset_ignore_already_traversed_triggered()


# NOTE: THESE elements changed are made available but not supported yet..............
signal dialog_elements_changed(arg_all_dialog_elements)
signal background_elements_changed(arg_all_background_elements)
#

signal mouse_filter_changed(arg_filter)

#

const VECTOR_UNDEFINED = Vector2(-1, -1)
const FLOAT_UNDEFINED = -9570.55

#

class DialogElementsConstructionIns:
	var func_source
	var func_name_for_construction
	var func_params
	
	var element_id  # used for determining when something is constructed
	
	func build_element():
		return func_source.call(func_name_for_construction, func_params)


class BackgroundElementsConstructionIns:
	
	const NO_PERSISTENCE_ID = -1
	
	var func_source
	var func_name_for_construction  # expects method to accept: func_params, persistence_id
	var func_params
	
	var persistence_id : int = NO_PERSISTENCE_ID  # normally, things undergo modulate_a reduc (fade out) and reset. Use this if you want to reuse a certain control
	
	func build_element(arg_element):
		return func_source.call(func_name_for_construction, arg_element, func_params, persistence_id)
	
	func has_persistence_id():
		return persistence_id != NO_PERSISTENCE_ID

var _all_dialog_element_construction_inses : Array
var _all_background_element_construction_inses : Array

#

var is_previous_executable : bool = false
var is_skip_executable : bool = false

var top_border_texture : Texture = Border_Pic_Default
var left_border_texture : Texture = Border_Pic_Default 
var right_border_texture : Texture = Border_Pic_Default
var bottom_border_texture : Texture = Border_Pic_Default



#enum ValTransitionMode {
#	LINEAR = 0,
#	QUAD = 1,
#
#	INSTANT = 2,
#}

var final_dialog_top_left_pos : Vector2 = VECTOR_UNDEFINED  # must be defined
var final_dialog_top_left_pos_val_trans_mode : int = ValTransition.ValueIncrementMode.QUADRATIC #ValTransitionMode.QUAD

var final_dialog_custom_size : Vector2 = VECTOR_UNDEFINED  # must be defined
var final_dialog_custom_size_val_trans_mode : int = ValTransition.ValueIncrementMode.LINEAR #ValTransitionMode.LINEAR

var make_dialog_main_panel_invis : bool = false
var make_dialog_main_panel_invis_val_trans_mode : int = ValTransition.ValueIncrementMode.LINEAR #ValTransitionMode.LINEAR  # transition mode from invis to vis

var make_dialog_main_panel_visible : bool = true
var make_dialog_main_panel_visible_val_trans_mode : int = ValTransition.ValueIncrementMode.LINEAR #ValTransitionMode.LINEAR  # transition mode from vis to invis


enum AdvanceMode {
	CLICK_OR_ENTER = 0,
	PLAYER_INPUT_IN_MAP = 1,
	
	WAIT = 2,
}
var advance_mode : int = AdvanceMode.CLICK_OR_ENTER setget set_advance_mode


enum BlockAdvanceClauseIds {
	TEXT_INPUT_WAIT = 0,
	BUTTON_CHOICES_WAIT = 1,
}
var block_advance_conditional_clauses : ConditionalClauses
var last_calculated_block_advance : bool

# expects func name to receive dia seg as param.
var resolve_block_advance_func_source
var resolve_block_advance_func_name

#var mouse_filter : int = Control.MOUSE_FILTER_STOP setget set_mouse_filter # MAY change based on AdvanceMode


#var _time_limit : float = FLOAT_UNDEFINED
#var _time_limit_reached_func_source
#var _time_limit_reached_func_name

#

##!! NOTE FOR ALL temp_x__y. "__" should only be used once, since it is the separator between metadata and the actual var name
#
## if changing var name, change conditional in "partial_reset" as well
#var temp_curr_val__already_traversed : bool = false  # true if dialog segment is already advanced.
#var temp_default__already_traversed : bool = false

var temp_var__already_traversed : bool = false

##

func _init():
	block_advance_conditional_clauses = ConditionalClauses.new()
	block_advance_conditional_clauses.connect("clause_inserted", self, "_on_block_advance_conditional_clauses_updated", [], CONNECT_PERSIST)
	block_advance_conditional_clauses.connect("clause_removed", self, "_on_block_advance_conditional_clauses_updated", [], CONNECT_PERSIST)
	_on_block_advance_conditional_clauses_updated(null)

func _on_block_advance_conditional_clauses_updated(_arg_clause_id):
	last_calculated_block_advance = !block_advance_conditional_clauses.is_passed

#

func request_advance():
	emit_signal("requested_action_advance")

func previous():
	if is_previous_executable:
		emit_signal("requested_action_previous")

func skip():
	if is_skip_executable:
		emit_signal("requested_action_skip")


#

func full_reset():
	temp_var__already_traversed = false
	
	#temp_curr_val__already_traversed = temp_default__already_traversed
	#for var_properties in get_property_list():
	#	var var_name = var_properties["name"]
	
	emit_signal("full_reset_triggered")

func partial_reset__ignore_already_traversed():
	emit_signal("partial_reset_ignore_already_traversed_triggered")


#########

func add_dialog_element_construction_ins(arg_element_construction_ins):
	_all_dialog_element_construction_inses.append(arg_element_construction_ins)
	emit_signal("dialog_elements_changed", get_all_dialog_element_construction_inses())

func get_all_dialog_element_construction_inses():
	return _all_dialog_element_construction_inses

func is_construction_inses_sizes_above_index(arg_index):
	return _all_dialog_element_construction_inses.size() > arg_index

func add_background_element_construction_ins(arg_element):
	_all_background_element_construction_inses.append(arg_element)
	emit_signal("background_elements_changed", get_all_background_elements_construction_inses())

func get_all_background_elements_construction_inses():
	return _all_background_element_construction_inses

###

func set_all_border_textures(arg_texture : Texture):
	top_border_texture = arg_texture
	left_border_texture = arg_texture
	right_border_texture = arg_texture
	bottom_border_texture = arg_texture

func set_advance_mode(arg_mode : int):
	advance_mode = arg_mode
#
#	if advance_mode == AdvanceMode.CLICK_OR_ENTER:
#		set_mouse_filter(Control.MOUSE_FILTER_STOP)
#	elif advance_mode == AdvanceMode.PLAYER_INPUT_IN_MAP:
#		set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
#	#else:
#	#	mouse_filter = Control.MOUSE_FILTER_STOP
#
#func set_mouse_filter(arg_filter : int):
#	mouse_filter = arg_filter
#
#	emit_signal("mouse_filter_changed", mouse_filter)

###

#func configure_time_related_properties(arg_time, arg_func_source, arg_func_name):
#	_time_limit = arg_time
#	_time_limit_reached_func_source = arg_func_source
#	_time_limit_reached_func_name = arg_func_name
#
#func is_time_undefined():
#	return _time_limit == FLOAT_UNDEFINED



#

func is_block_advance():
	return last_calculated_block_advance

func immediately_resolve_block_advance():
	if resolve_block_advance_func_source != null:
		resolve_block_advance_func_source.call(resolve_block_advance_func_name, self)
	



