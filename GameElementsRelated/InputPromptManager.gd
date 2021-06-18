extends Node

const SelectionNotifPanel = preload("res://GameHUDRelated/NotificationPanel/SelectionNotifPanel/SelectionNotifPanel.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")

signal prompted_for_tower_selection()
signal cancelled_tower_selection()
signal tower_selected(tower)

enum SelectionMode {
	NONE = -10
	
	TOWER = 1
}

const notif_message_select_tower : String = "Select a tower"

var current_selection_mode : int = SelectionMode.NONE
var selection_notif_panel : SelectionNotifPanel

var current_prompter : Node


func prompt_select_tower(prompter : Node):
	if current_selection_mode == SelectionMode.NONE:
		current_selection_mode = SelectionMode.TOWER
		
		if current_prompter != null:
			current_prompter.connect("tree_exiting", self, "cancel_selection")
			
			if current_prompter is AbstractTower:
				current_prompter.connect("tower_not_in_active_map", self, "cancel_selection")
		
		
		emit_signal("prompted_for_tower_selection")
		
		_show_selection_notif_panel(notif_message_select_tower)


func cancel_selection(emit_cancel_selection : bool = true):
	if current_selection_mode == SelectionMode.TOWER:
		current_selection_mode = SelectionMode.NONE
		
		if current_prompter != null:
			current_prompter.disconnect("tree_exiting", self, "cancel_selection")
			
			if current_prompter is AbstractTower:
				current_prompter.disconnect("tower_not_in_active_map", self, "cancel_selection")
		
		
		if emit_cancel_selection:
			emit_signal("cancelled_tower_selection")
		
		_hide_selection_notif_panel()


func tower_selected_from_prompt(tower):
	emit_signal("tower_selected", tower)
	cancel_selection()


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


