extends Node

const SelectionNotifPanel = preload("res://GameHUDRelated/NotificationPanel/SelectionNotifPanel/SelectionNotifPanel.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")


signal prompted_for_tower_selection(prompter, prompt_predicate_method)

signal cancelled_tower_selection()
signal tower_selection_ended()
signal tower_selected(tower)

enum SelectionMode {
	NONE = -10
	
	TOWER = 1
}

const notif_message_select_tower : String = "Select a tower"


var current_selection_mode : int = SelectionMode.NONE
var selection_notif_panel : SelectionNotifPanel

var _current_prompter
var _current_prompt_tower_checker_predicate_name : String

var _prompt_successful_method_handler : String
var _prompt_cancelled_method_handler : String


# Prompt select tower related

func prompt_select_tower(prompter, arg_prompt_successful_method_handler : String, arg_prompt_cancelled_method_handler : String, arg_prompt_tower_checker_predicate_name : String = ""):
	if current_selection_mode == SelectionMode.NONE:
		current_selection_mode = SelectionMode.TOWER
		_prompt_successful_method_handler = arg_prompt_successful_method_handler
		_prompt_cancelled_method_handler = arg_prompt_cancelled_method_handler
		
		_current_prompter = prompter
		_current_prompt_tower_checker_predicate_name = arg_prompt_tower_checker_predicate_name
		
		if is_instance_valid(_current_prompter) and _current_prompter != null:
			_current_prompter.connect("tree_exiting", self, "cancel_selection")
			
			if _current_prompter is AbstractTower:
				_current_prompter.connect("tower_not_in_active_map", self, "cancel_selection")
		
		
		emit_signal("prompted_for_tower_selection", prompter, arg_prompt_tower_checker_predicate_name)
		_show_selection_notif_panel(notif_message_select_tower)


func tower_selected_from_prompt(tower):
	emit_signal("tower_selected", tower)
	_current_prompter.call_deferred(_prompt_successful_method_handler, tower)
	
	clean_up_selection()


# General stuffs

func cancel_selection(emit_cancel_selection : bool = true):
	if emit_cancel_selection:
		emit_signal("cancelled_tower_selection")
	
	_current_prompter.call_deferred(_prompt_cancelled_method_handler)
	
	clean_up_selection()


func clean_up_selection():
	if current_selection_mode == SelectionMode.TOWER:
		current_selection_mode = SelectionMode.NONE
		
		if is_instance_valid(_current_prompter) and _current_prompter != null:
			_current_prompter.disconnect("tree_exiting", self, "cancel_selection")
			
			if _current_prompter is AbstractTower:
				_current_prompter.disconnect("tower_not_in_active_map", self, "cancel_selection")
		
		_current_prompter = null
		_prompt_cancelled_method_handler = ""
		_prompt_successful_method_handler = ""
		_current_prompt_tower_checker_predicate_name = ""
		
		emit_signal("tower_selection_ended")
		
		_hide_selection_notif_panel()


func is_current_promter_arg(arg) -> bool:
	return _current_prompter == arg


# selection notif panel related

func _show_selection_notif_panel(message : String):
	selection_notif_panel.visible = true
	selection_notif_panel.notif_label.text = message


func _hide_selection_notif_panel():
	selection_notif_panel.visible = false

# 

func is_in_tower_selection_mode() -> bool:
	return current_selection_mode == SelectionMode.TOWER


func is_in_selection_mode() -> bool:
	return current_selection_mode != SelectionMode.NONE


func can_prompt() -> bool:
	return current_selection_mode == SelectionMode.NONE
