extends MarginContainer #"res://MiscRelated/DialogRelated/Controls/DialogElementControls/BaseDialogElementControl.gd"


signal remove_false_answer_requested(arg_count)

#

const USE_REMAINING_HEADER_TEXT = "Uses Remaining:\n%s"

#

onready var change_question_button = $VBoxContainer/HBoxContainer/ChangeContainer/ChangeQuestionButton
onready var remove_button = $VBoxContainer/HBoxContainer/RemoveContainer/RemoveFalseAnswer

onready var uselabel_change_question = $VBoxContainer/HBoxContainer/ChangeContainer/UseLabel_Change
onready var uselabel_remove = $VBoxContainer/HBoxContainer/RemoveContainer/UseLabel_Remove


onready var change_question_container = $VBoxContainer/HBoxContainer/ChangeContainer
onready var remove_container = $VBoxContainer/HBoxContainer/RemoveContainer


#####

class ModiPanelConfig:
	#var show_change_question : bool
	
	var show_change_question_use_left: int
	var remove_false_answer_use_left: int
	
	var remove_false_answer_count : int  # 0 for no show
	
	
	#############
	
	var func_source_for_actions
	var func_name_for__change_question
	var func_param_for__change_question
	
	var func_name_for__remove_false_answer
	var func_param_for__remove_false_answer
	
	
	var show_use_labels : bool = false
	

var modi_panel_config : ModiPanelConfig

#


func _initialize():
	if modi_panel_config.show_change_question_use_left > 0:
		change_question_container.visible = true
		
		uselabel_change_question.visible = modi_panel_config.show_use_labels
		if modi_panel_config.show_use_labels:
			uselabel_change_question.text = USE_REMAINING_HEADER_TEXT % modi_panel_config.show_change_question_use_left
		
		#change_question_button.visible = true
	else:
		change_question_container.visible = false
		#change_question_button.visible = false
	
	if modi_panel_config.remove_false_answer_use_left > 0:
		var text = "Remove %s\nfalse answers." % modi_panel_config.remove_false_answer_count
		remove_button.set_text_for_text_label(text)
		remove_container.visible = true
		
		uselabel_remove.visible = modi_panel_config.show_use_labels
		if modi_panel_config.show_use_labels:
			uselabel_remove.text = USE_REMAINING_HEADER_TEXT % modi_panel_config.remove_false_answer_use_left
		#remove_button.visible = true
	else:
		remove_container.visible = false
		#remove_button.visible = false
	
	

func _update_status():
	_initialize()



func _on_ChangeQuestionButton_on_button_released_with_button_left():
	modi_panel_config.func_source_for_actions.call(modi_panel_config.func_name_for__change_question, modi_panel_config.func_param_for__change_question)
	change_question_button.is_button_enabled = false
	
	#emit_signal("change_question")


func _on_RemoveFalseAnswer_on_button_released_with_button_left():
	modi_panel_config.func_source_for_actions.call(modi_panel_config.func_name_for__remove_false_answer, modi_panel_config.func_param_for__remove_false_answer)
	remove_button.is_button_enabled = false
	
	if modi_panel_config.show_use_labels:
		uselabel_remove.text = USE_REMAINING_HEADER_TEXT % (modi_panel_config.remove_false_answer_use_left - 1)
	
	emit_signal("remove_false_answer_requested", modi_panel_config.remove_false_answer_count)
	
	

