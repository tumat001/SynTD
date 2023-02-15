extends MarginContainer #"res://MiscRelated/DialogRelated/Controls/DialogElementControls/BaseDialogElementControl.gd"


signal remove_false_answer_requested(arg_count)

onready var change_question_button = $VBoxContainer/HBoxContainer/ChangeQuestionButton
onready var remove_button = $VBoxContainer/HBoxContainer/RemoveFalseAnswer


class ModiPanelConfig:
	var show_change_question : bool
	
	var remove_false_answer_count : int  # 0 for no show
	
	
	#############
	
	var func_source_for_actions
	var func_name_for__change_question
	var func_name_for__remove_false_answer
	

var modi_panel_config : ModiPanelConfig

#


func _initialize():
	if modi_panel_config.show_change_question:
		change_question_button.visible = true
	
	if modi_panel_config.remove_false_answer_count > 0:
		var text = "Remove %s false answers." % modi_panel_config.remove_false_answer_count
		remove_button.set_text_for_text_label(text)
		remove_button.visible = true

func _update_status():
	_initialize()



func _on_ChangeQuestionButton_on_button_released_with_button_left():
	modi_panel_config.func_source_for_actions.call(modi_panel_config.func_name_for__change_question)
	change_question_button.is_button_enabled = false
	
	#emit_signal("change_question")


func _on_RemoveFalseAnswer_on_button_released_with_button_left():
	modi_panel_config.func_source_for_actions.call(modi_panel_config.func_name_for__remove_false_answer)
	remove_button.is_button_enabled = false
	
	emit_signal("remove_false_answer_requested", modi_panel_config.remove_false_answer_count)
	
	

