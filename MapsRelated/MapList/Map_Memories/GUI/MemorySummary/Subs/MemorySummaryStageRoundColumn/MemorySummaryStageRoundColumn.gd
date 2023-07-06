extends MarginContainer

const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")



const BORDER_COLOR := Color(253/255.0, 210/255.0, 78/255.0)

const BORDER_MOD_A__MIN = 0.6
const BORDER_MOD_A__MAX = 1.0

const BACKGROUND_MOD_A__MIN = 0.05
const BACKGROUND_MOD_A__MAX = 0.25


const PHASE_TRANSITION_DURATION : float = 1.5
const PHASE_TRANSITION_PEAK_WAIT : float = 0.75

#

class ConstructorParams:
	
	var past_memory_type_recall_panel_constr_params
	var future_memory_type_recall_panel_constr_params
	
	
	var show_left_border : bool
	var show_right_border : bool
	
	
	var stageround_id_to_represent
	var stage_round_manager
	
	var tooltip_owner
	
	

#

var _past_memory_type_recall_panel_constr_params 
var _future_memory_type_recall_panel_constr_params


var show_left_border : bool
var show_right_border : bool

var stageround_id_to_represent : String
var stage_round_manager

var tooltip_owner

#

var _control_to_mod_a_tweener_map : Dictionary = {}


#

onready var stage_round_label = $HBoxContainer/MainContainer/ContentMarginer/MainVContainer/HeaderContainer/StageroundLabel

onready var past_memory_summary_icon_with_tooltip = $HBoxContainer/MainContainer/ContentMarginer/MainVContainer/PastContainer/PastMemorySummaryIconWithTooltip
onready var future_memory_summary_icon_with_tooltip = $HBoxContainer/MainContainer/ContentMarginer/MainVContainer/FutureContainer/FutureMemorySummaryIconWithTooltip


onready var fill_background_tex_rect = $HBoxContainer/MainContainer/Background

onready var left_border_tex_rect = $HBoxContainer/LeftBorderContainer/LeftBorder
onready var left_border_container = $HBoxContainer/LeftBorderContainer

onready var right_border_tex_rect = $HBoxContainer/RightBorderContainer/RightBorder
onready var right_border_container = $HBoxContainer/RightBorderContainer

onready var background_tex_rect = $HBoxContainer/MainContainer/Background

###########

func set_prop_based_on_constructor(arg_constructor : ConstructorParams):
	_past_memory_type_recall_panel_constr_params = arg_constructor.past_memory_type_recall_panel_constr_params
	_future_memory_type_recall_panel_constr_params = arg_constructor.future_memory_type_recall_panel_constr_params
	
	show_left_border = arg_constructor.show_left_border
	show_right_border = arg_constructor.show_right_border
	
	stageround_id_to_represent = arg_constructor.stageround_id_to_represent
	set_stage_round_manager(arg_constructor.stage_round_manager)
	
	tooltip_owner = arg_constructor.tooltip_owner
	
	if is_inside_tree():
		_update_memory_summ_icons()
		
		_update_stageround_label()
		
		past_memory_summary_icon_with_tooltip.tooltip_owner = tooltip_owner
		future_memory_summary_icon_with_tooltip.tooltip_owner = tooltip_owner
	


func _ready():
	#left_border_container.visible = false
	#right_border_container.visible = false
	
	left_border_tex_rect.visible = false
	right_border_tex_rect.visible = false
	
	left_border_tex_rect.modulate = BORDER_COLOR
	right_border_tex_rect.modulate = BORDER_COLOR
	
	background_tex_rect.visible = false
	
	#
	
	_update_memory_summ_icons()


#

func set_stage_round_manager(arg_manager):
	if stage_round_manager == null:
		stage_round_manager = arg_manager
#
#		stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
#		_update_prop_based_on_curr_stageround(stage_round_manager.current_stageround.id)
#
#
#func _on_round_end(arg_stageround):
#	var stageround_id = arg_stageround.id
#	_update_prop_based_on_curr_stageround(stageround_id)
#
#func _update_prop_based_on_curr_stageround(stageround_id):
#	var res = StageRound.compare_stage_round__param_to_second_param(stageround_id_to_represent, stageround_id)
#
#	if res == 1:
#		_make_background_fill_invisible()
#		_make_left_border_visible__and_play_tweener_transition()
#		_make_right_border_invisible()
#
#	elif res == 0:
#		_make_background_fill_visible__and_play_tweener_transition()
#		_make_left_border_invisible()
#		_make_right_border_invisible()
#
#	elif res == -1:
#		_make_background_fill_invisible()
#		_make_left_border_invisible()
#		_make_right_border_visible__and_play_tweener_transition()


func show_left_border__make_others_invis():
	_make_background_fill_invisible()
	_make_left_border_visible__and_play_tweener_transition()
	_make_right_border_invisible()
	

func show_background__make_others_invis():
	_make_background_fill_visible__and_play_tweener_transition()
	_make_left_border_invisible()
	_make_right_border_invisible()

func show_right_border__make_others_invis():
	_make_background_fill_invisible()
	_make_left_border_invisible()
	_make_right_border_visible__and_play_tweener_transition()


func show_nothing_and_make_all_invis():
	_make_background_fill_invisible()
	_make_left_border_invisible()
	_make_right_border_invisible()


#

func _make_background_fill_invisible():
	background_tex_rect.visible = false
	

func _make_background_fill_visible__and_play_tweener_transition():
	background_tex_rect.visible = true
	
	_configure_mod_a_tweener_for_control(background_tex_rect, BACKGROUND_MOD_A__MIN, BACKGROUND_MOD_A__MAX)



func _make_left_border_invisible():
	#left_border_container.visible = false
	
	left_border_tex_rect.visible = false

func _make_left_border_visible__and_play_tweener_transition():
	_make_x_border_visible__and_play_tweener_transition(left_border_tex_rect, left_border_container)



func _make_right_border_invisible():
	#right_border_container.visible = false
	
	right_border_tex_rect.visible = false

func _make_right_border_visible__and_play_tweener_transition():
	_make_x_border_visible__and_play_tweener_transition(right_border_tex_rect, right_border_container)



func _make_x_border_visible__and_play_tweener_transition(arg_control, arg_control_container):
	#arg_control_container.visible = true
	arg_control.visible = true
	
	_configure_mod_a_tweener_for_control(arg_control, BORDER_MOD_A__MIN, BORDER_MOD_A__MAX)


func _configure_mod_a_tweener_for_control(arg_control, arg_a_min, arg_a_max, arg_phase_duration = PHASE_TRANSITION_DURATION, arg_phase_peak_wait_duration = PHASE_TRANSITION_PEAK_WAIT):
	if !_control_to_mod_a_tweener_map.has(arg_control):
		
		var tweener = create_tween()
		
		arg_control.modulate.a = arg_a_min
		
		tweener.set_loops()
		tweener.tween_property(arg_control, "modulate:a", arg_a_max, arg_phase_duration)
		tweener.tween_property(arg_control, "modulate:a", arg_a_max, arg_phase_peak_wait_duration)
		tweener.tween_property(arg_control, "modulate:a", arg_a_min, arg_phase_duration)
		tweener.tween_property(arg_control, "modulate:a", arg_a_min, arg_phase_peak_wait_duration)
		
		_control_to_mod_a_tweener_map[arg_control] = tweener


####

func _update_memory_summ_icons():
	past_memory_summary_icon_with_tooltip.recall_type_panel_constr_param = _past_memory_type_recall_panel_constr_params
	future_memory_summary_icon_with_tooltip.recall_type_panel_constr_param = _future_memory_type_recall_panel_constr_params
	

func _update_stageround_label():
	var round_with_dash_as_text = StageRound.convert_stageround_id_to_stage_and_round_string_with_dash(stageround_id_to_represent)
	stage_round_label.text = round_with_dash_as_text

# INTENDED FOR OUTSIDE USE
func set_past_memory_type_recall_panel_constr_params__and_update(arg_past_memory_type_recall_panel_constr_params):
	_past_memory_type_recall_panel_constr_params = arg_past_memory_type_recall_panel_constr_params
	
	past_memory_summary_icon_with_tooltip.recall_type_panel_constr_param = _past_memory_type_recall_panel_constr_params


func set_future_memory_type_recall_panel_constr_params__and_update(arg_future_memory_type_recall_panel_constr_params):
	_future_memory_type_recall_panel_constr_params = arg_future_memory_type_recall_panel_constr_params
	
	future_memory_summary_icon_with_tooltip.recall_type_panel_constr_param = _future_memory_type_recall_panel_constr_params


##########

func get_glob_position_of_past_icon() -> Vector2:
	return past_memory_summary_icon_with_tooltip.rect_global_position

func get_glob_position_of_future_icon() -> Vector2:
	return future_memory_summary_icon_with_tooltip.rect_global_position

func get_size_of_x_icon() -> Vector2:
	return past_memory_summary_icon_with_tooltip.rect_size
