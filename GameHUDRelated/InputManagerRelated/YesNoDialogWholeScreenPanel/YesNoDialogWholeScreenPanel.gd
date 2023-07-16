extends Control

signal option_chosen(arg_choice)   # signal emited before calling func source & name
signal escaped_via_ESC()


var _descriptions_to_use : Array

var func_source__on_select_option
var func_name__on_select_no
var func_name__on_select_yes


onready var tooltip_body_for_desc = $MarginContainer/VBoxContainer/BodyMarginer/LabelMarginer/VBoxContainer/TooltipBody


#

func _ready():
	tooltip_body_for_desc.bbcode_align_mode = tooltip_body_for_desc.BBCodeAlignMode.CENTER
	
	set_process_input(false)

#

func set_descriptions_to_use(arg_descs : Array):
	tooltip_body_for_desc.descriptions = arg_descs
	tooltip_body_for_desc.update_display()


func _on_NoButton_on_button_released_with_button_left():
	_on_no_selected()

func _on_no_selected():
	emit_signal("option_chosen", 0)
	func_source__on_select_option.call(func_name__on_select_no)
	
	_clean_up_temp_vars()

func _on_YesButton_on_button_released_with_button_left():
	_on_yes_selected()

func _on_yes_selected():
	emit_signal("option_chosen", 1)
	func_source__on_select_option.call(func_name__on_select_yes)
	
	_clean_up_temp_vars()


# called by WHOLE_SCREEN_GUI
func control_set_to_hide_by_whole_screen_gui():
	emit_signal("escaped_via_ESC")
	

##

func _clean_up_temp_vars():
	func_source__on_select_option = null
	func_name__on_select_no = ""
	func_name__on_select_yes = ""

##


func _on_YesNoDialogWholeScreenPanel_visibility_changed():
	if visible:
		set_process_input(true)
		
	else:
		set_process_input(false)


func _input(event):
	if event is InputEventKey:
		if !event.echo and event.pressed:
			if event.is_action_pressed("ui_accept"):
				_on_yes_selected()
				accept_event()
			elif event.is_action_pressed("custom_ui_decline"):
				_on_no_selected()
				accept_event()
	


#func _unhandled_key_input(event : InputEventKey):
#	if !event.echo and event.pressed:
#		if event.is_action_pressed("ui_cancel"):
#
#			_on_exit_panel()
#
#	accept_event()
