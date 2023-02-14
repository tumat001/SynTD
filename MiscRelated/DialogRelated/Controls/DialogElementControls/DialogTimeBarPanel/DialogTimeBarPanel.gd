extends "res://MiscRelated/DialogRelated/Controls/DialogElementControls/BaseDialogElementControl.gd"

const TimeBar_01 = preload("res://MiscRelated/DialogRelated/Assets/DialogTimeBar/DialogTImeBar_Fill_01.png")
const TimeBar_02 = preload("res://MiscRelated/DialogRelated/Assets/DialogTimeBar/DialogTImeBar_Fill_02.png")
const TimeBar_03 = preload("res://MiscRelated/DialogRelated/Assets/DialogTimeBar/DialogTImeBar_Fill_03.png")
const TimeBar_04 = preload("res://MiscRelated/DialogRelated/Assets/DialogTimeBar/DialogTImeBar_Fill_04.png")
const TimeBar_05 = preload("res://MiscRelated/DialogRelated/Assets/DialogTimeBar/DialogTImeBar_Fill_05.png")
const TimeBar_06 = preload("res://MiscRelated/DialogRelated/Assets/DialogTimeBar/DialogTImeBar_Fill_06.png")
const TimeBar_07 = preload("res://MiscRelated/DialogRelated/Assets/DialogTimeBar/DialogTImeBar_Fill_07.png")
const TimeBar_08 = preload("res://MiscRelated/DialogRelated/Assets/DialogTimeBar/DialogTImeBar_Fill_08.png")

#

const time_threshold_for_dec_display : float = 10.0
const format_for_above_time_threshold__for_dec_display : String = "%0.0f"
const format_for_below_time_threshold__for_dec_display : String = "%0.2f"

const main_bar_id : int = 1

#

#const min_percent_val_breakpoints : Array = [
#	82.5,
#	75 ,
#	67.5,
#	50,
#	37.5,
#	25,
#	12.5,
#	0,
#]

const min_percent_val_to_timebar_texture_map : Dictionary = {
	
#	0 : TimeBar_08,
#	12.5 : TimeBar_07,
#	25 : TimeBar_06,
#	37.5 : TimeBar_05,
#	50 : TimeBar_04,
#	67.5 : TimeBar_03,
#	75 : TimeBar_02,
#	82.5 : TimeBar_01,
	
	0.875 : TimeBar_01,
	0.75 : TimeBar_02,
	0.625 : TimeBar_03,
	0.50 : TimeBar_04,
	0.375 : TimeBar_05,
	0.25 : TimeBar_06,
	0.125 : TimeBar_07,
	0 : TimeBar_08,
	
}

var starting_time : float setget set_starting_time
var current_time : float setget set_current_time


var time_timeout_func_source
var time_timeout_func_name
var time_timeout_func_params

var _is_counting_down : bool

#

onready var bar_label = $HBoxContainer/BarLabel
onready var control_progress_bar = $HBoxContainer/AdvancedControlProgressBar

#

func _ready():
	control_progress_bar.add_bar_foreground(main_bar_id, TimeBar_01)
	
	control_progress_bar.max_value = starting_time

#

func set_starting_time(arg_time):
	starting_time = arg_time
	
	if is_inside_tree():
		control_progress_bar.max_value = starting_time

func set_current_time(arg_time):
	current_time = arg_time
	
	if is_inside_tree():
		_update_display_of_time_relateds()


func _update_display_of_time_relateds():
	var format_to_use = format_for_above_time_threshold__for_dec_display
	if current_time < time_threshold_for_dec_display:
		format_to_use = format_for_below_time_threshold__for_dec_display
	
	bar_label.text = format_to_use % current_time
	
	##
	
	var ratio = current_time / starting_time
	for percent_val in min_percent_val_to_timebar_texture_map.keys():
		if ratio >= percent_val:
			control_progress_bar.set_bar_foreground_current_value(main_bar_id, current_time)
			
			var texture_to_use = min_percent_val_to_timebar_texture_map[percent_val]
			control_progress_bar.set_bar_foreground_texture(main_bar_id, texture_to_use)
			
			break

#

func _start_display():
	._start_display()
	
	_update_display_of_time_relateds()

func _force_finish_display():
	._force_finish_display()
	
	_update_display_of_time_relateds()

#

func _start_finished_preparation_and_display_of_WSC():
	_is_counting_down = true

func _WSC_changed_dialog_segment():
	_is_counting_down = false

#

func _process(delta):
	if _is_counting_down:
		set_current_time(current_time - delta)
		
		if current_time <= 0:
			_is_counting_down = false
			
			if time_timeout_func_source != null:
				time_timeout_func_source.call(time_timeout_func_name, time_timeout_func_params)

#

