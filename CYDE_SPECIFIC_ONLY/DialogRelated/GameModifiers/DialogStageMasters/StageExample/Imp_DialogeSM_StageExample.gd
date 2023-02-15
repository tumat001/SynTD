extends "res://MiscRelated/DialogRelated/StageMaster/BaseDialogStageMaster.gd"


const TestPortrait_Pic = preload("res://CYDE_SPECIFIC_ONLY/DialogRelated/Assets/TestPortraitPic_150x225.png")

var dia_seg_intro_01 : DialogSegment
var dia_seg_main_01 : DialogSegment
var dia_seg_main_03 : DialogSegment

var dia_seg_intro_02 : DialogSegment
var dia_seg_intro_03 : DialogSegment


var persistence_id_for_portrait_test : int = 1


var show_change_questions : bool = true
var remove_question_count : int = 1

func _init().(StoreOfGameModifiers.GameModiIds__CYDE_ExampleStage,
		BreakpointActivation.BEFORE_GAME_START, 
		"Cyde_StageExample_Modi"):
	
	pass

#

func _construct_dialog_segments():
	
	var plain_fragment__ingredient_effets = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredients")
	
	## VERY FIRST
	dia_seg_intro_01 = DialogSegment.new()
	var dia_seg_intro_01__descs = [
		["Welcome to ... in ... for Bchrrrrrr. |0|.", [plain_fragment__ingredient_effets]],
		"2nd line of first.",
		"Third line of first.",
		"Fourth line of first."
		]
	#var dia_seg_intro_01_02_descs = ["Welcome to ... in ... for Bchrrrrrr 02020202."]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_intro_01, dia_seg_intro_01__descs)
	#_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_intro_01, dia_seg_intro_01_02_descs)
	_configure_dia_set_to_standard_pos_and_size(dia_seg_intro_01)
	
	
	dia_seg_intro_02 = DialogSegment.new()
	configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_intro_01, dia_seg_intro_02)
	
	var dia_seg_intro_02__descs = [
		"2nd entry in list.",
		"Make a choice within the time limit.",
		""
		]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_intro_02, dia_seg_intro_02__descs) #, dia_main_panel__pos__standard, dia_main_panel__size__standard)
	_construct_and_configure_choices_for_intro_02_questions()
	_configure_dia_set_to_plate_middle_pos_and_size(dia_seg_intro_02)
	_configure_dia_seg_to_default_templated_dialog_time_bar_panel(dia_seg_intro_02, dia_time_duration__very_short, dia_time_duration__very_short, self, "_on_intro_02_timeout", null)
	
	dia_seg_intro_03 = DialogSegment.new()
	#configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_intro_02, dia_seg_intro_03)
	
	var dia_seg_intro_03__descs = [
		"2nd last entry in list.",
		["Attached flavor here: |0|", [plain_fragment__ingredient_effets]]
	]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_intro_03, dia_seg_intro_03__descs) #, dia_main_panel__pos__standard, dia_main_panel__size__standard)
	var custom_pos = dia_portrait__pos__standard_left
	custom_pos.x = 0
	_configure_dia_seg_to_default_templated_background_ele_dia_texture_image(dia_seg_intro_03, TestPortrait_Pic, dia_portrait__pos__standard_left, custom_pos, persistence_id_for_portrait_test)
	_configure_dia_set_to_standard_pos_and_size(dia_seg_intro_03)
	
	
	var dia_seg_intro_04 = DialogSegment.new()
	configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_intro_03, dia_seg_intro_04)
	
	var dia_seg_intro_04__descs = [
		"The finality last entry in list.",
	]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_intro_04, dia_seg_intro_04__descs) #, dia_main_panel__pos__standard, dia_main_panel__size__standard)
	_configure_dia_seg_to_default_templated_background_ele_dia_texture_image(dia_seg_intro_04, TestPortrait_Pic, dia_portrait__pos__standard_right, BackDialogImagePanel.VECTOR_UNDEFINED, persistence_id_for_portrait_test)
	_configure_dia_set_to_standard_pos_and_size(dia_seg_intro_04)
	
	
	#end of intro pass
	configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_intro_04, null)
	configure_dia_seg_to_call_func_on_player_click_or_enter(dia_seg_intro_04, self, "_on_end_of_dia_seg_intro_03", null)
	
	#############
	
	
	## VERY FIRST of Main
	dia_seg_main_01 = DialogSegment.new()
	var dia_seg_main_01__descs = [
		"The first of the main"
		]
	var dia_seg_main_01_02_descs = ["The second of first main"]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_main_01, dia_seg_main_01__descs)
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_main_01, dia_seg_main_01_02_descs)
	_configure_dia_set_to_standard_pos_and_size(dia_seg_main_01)
	
	
	var dia_seg_main_02 = DialogSegment.new()
	configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_main_01, dia_seg_main_02)
	
	var dia_seg_main_02__descs = [
		"The second of the main"
		]
	var dia_seg_main_02_02_descs = ["Please make an input here:"]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_main_02, dia_seg_main_02__descs)
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_main_02, dia_seg_main_02_02_descs)
	_configure_dia_seg_to_default_templated_dialog_text_input(dia_seg_main_02, "", self, "_on_input_entered__on_dia_seg_main_02")
	_configure_dia_set_to_standard_pos_and_size(dia_seg_main_02)
	
	
	#end of main pass
	configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_main_02, null)
	

###

func _construct_and_configure_choices_for_intro_02_questions():
	var choice_01 = DialogChoicesPanel.ChoiceButtonInfo.new()
	choice_01.id = 1
	choice_01.display_text = "Choice 01"
	choice_01.choice_type = DialogChoicesPanel.ChoiceButtonInfo.ChoiceType.STANDARD
	choice_01.func_source_on_click = self
	choice_01.func_name_on_click = "_on_intro_02_choice_1_clicked"
	choice_01.choice_result_type = choice_01.ChoiceResultType.CORRECT
	
	var choice_02 = DialogChoicesPanel.ChoiceButtonInfo.new()
	choice_02.id = 2
	choice_02.display_text = "Choice 02"
	choice_02.choice_type = DialogChoicesPanel.ChoiceButtonInfo.ChoiceType.STANDARD
	choice_02.func_source_on_click = self
	choice_02.func_name_on_click = "_on_intro_02_choice_2_clicked"
	choice_02.choice_result_type = choice_02.ChoiceResultType.WRONG
	
	var choice_03 = DialogChoicesPanel.ChoiceButtonInfo.new()
	choice_03.id = 3
	choice_03.display_text = "Choice 03"
	choice_03.choice_type = DialogChoicesPanel.ChoiceButtonInfo.ChoiceType.STANDARD
	choice_03.func_source_on_click = self
	choice_03.func_name_on_click = "_on_intro_02_choice_3_clicked"
	choice_03.choice_result_type = choice_03.ChoiceResultType.WRONG
	
	_configure_dia_seg_to_default_templated_dialog_choices_panel(dia_seg_intro_02, [choice_01, choice_02, choice_03], self, "_show_dialog_choices_modi_panel", "_build_dialog_choices_modi_panel_config")


func _show_dialog_choices_modi_panel():
	return true

func _build_dialog_choices_modi_panel_config():
	var config = DialogChoicesModiPanel.ModiPanelConfig.new()
	
	config.remove_false_answer_count = remove_question_count  
	config.show_change_question = show_change_questions
	
	config.func_source_for_actions = self
	config.func_name_for__change_question = "_on_dialog_choices_modi_panel__change_question"
	config.func_name_for__remove_false_answer = "_on_dialog_choices_modi_panel__removed_choices"
	
	return config


func _on_dialog_choices_modi_panel__removed_choices():
	remove_question_count = 0
	


func _on_dialog_choices_modi_panel__change_question():
	show_change_questions = false
	


##


func _on_intro_02_choice_1_clicked(arg_id, arg_button_info : DialogChoicesPanel.ChoiceButtonInfo, arg_panel : DialogChoicesPanel):
	play_dialog_segment_or_advance_or_finish_elements(dia_seg_intro_03)
	

func _on_intro_02_choice_2_clicked(arg_id, arg_button_info : DialogChoicesPanel.ChoiceButtonInfo, arg_panel : DialogChoicesPanel):
	var dia_seg_intro_02_wrong_choice = DialogSegment.new()
	var dia_seg_intro_02_wrong_choice__descs = [
		"Made the wrong choice! whoops!"
		]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_intro_02_wrong_choice, dia_seg_intro_02_wrong_choice__descs) #, dia_main_panel__pos__standard, dia_main_panel__size__standard)
	#_configure_dia_set_to_standard_pos_and_size(dia_seg_intro_02)
	_configure_dia_set_to_plate_middle_pos_and_size(dia_seg_intro_02_wrong_choice)
	
	
	#
	configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_intro_02_wrong_choice, null)
	
	
	play_dialog_segment_or_advance_or_finish_elements(dia_seg_intro_02_wrong_choice)

func _on_intro_02_choice_3_clicked(arg_id, arg_button_info : DialogChoicesPanel.ChoiceButtonInfo, arg_panel : DialogChoicesPanel):
	var dia_seg_intro_02_wrong_choice = DialogSegment.new()
	var dia_seg_intro_02_wrong_choice__descs = [
		"Made the wrong choice 02! whoopies!"
		]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_intro_02_wrong_choice, dia_seg_intro_02_wrong_choice__descs) #, dia_main_panel__pos__standard, dia_main_panel__size__standard)
	#_configure_dia_set_to_standard_pos_and_size(dia_seg_intro_02)
	_configure_dia_set_to_plate_middle_pos_and_size(dia_seg_intro_02_wrong_choice)
	
	
	#
	configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_intro_02_wrong_choice, null)
	
	play_dialog_segment_or_advance_or_finish_elements(dia_seg_intro_02_wrong_choice)



func _on_intro_02_timeout(arg_params):
	var dia_seg_intro_02_wrong_choice = DialogSegment.new()
	var dia_seg_intro_02_wrong_choice__descs = [
		"Time ran out! whoopies!"
		]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_intro_02_wrong_choice, dia_seg_intro_02_wrong_choice__descs) #, dia_main_panel__pos__standard, dia_main_panel__size__standard)
	#_configure_dia_set_to_standard_pos_and_size(dia_seg_intro_02)
	_configure_dia_set_to_plate_middle_pos_and_size(dia_seg_intro_02_wrong_choice)
	
	
	#
	configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_intro_02_wrong_choice, null)
	
	play_dialog_segment_or_advance_or_finish_elements(dia_seg_intro_02_wrong_choice)

	

#







#

func _on_end_of_dia_seg_intro_03(arg_seg, arg_params):
	listen_for_round_end_into_stage_round_id_and_call_func("02", self, "_on_end_of_stageround_xx__after_end_of_dia_seg_intro_03")

func _on_end_of_stageround_xx__after_end_of_dia_seg_intro_03(arg_stageround_id: String):
	play_dialog_segment_or_advance_or_finish_elements(dia_seg_main_01)
	


func _on_input_entered__on_dia_seg_main_02(arg_input, arg_dia_seg):
	dia_seg_main_03 = DialogSegment.new()
	var dia_seg_main_03__descs = [
		"Submitted. input: %s" % arg_input
		]
	var dia_seg_main_03_02_descs = ["It worked..."]
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_main_03, dia_seg_main_03__descs)
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(dia_seg_main_03, dia_seg_main_03_02_descs)
	_configure_dia_set_to_standard_pos_and_size(dia_seg_main_03)
	
	#
	
	configure_dia_seg_to_progress_to_next_on_player_click_or_enter(dia_seg_main_03, null)
	
	#
	
	play_dialog_segment_or_advance_or_finish_elements(dia_seg_main_03)
	


########

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	
	_construct_dialog_segments()
	play_dialog_segment_or_advance_or_finish_elements(dia_seg_intro_01)
	

