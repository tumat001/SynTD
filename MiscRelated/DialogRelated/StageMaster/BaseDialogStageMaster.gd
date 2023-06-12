extends "res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd"

const DialogSegment = preload("res://MiscRelated/DialogRelated/DataClasses/DialogSegment.gd")
const DialogDescsPanel = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogDescsPanel/DialogDescsPanel.gd")
const DialogDescsPanel_Scene = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogDescsPanel/DialogDescsPanel.tscn")
const DialogTextInputPanel = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogTextInputPanel/DialogTextInputPanel.gd")
const DialogTextInputPanel_Scene = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogTextInputPanel/DialogTextInputPanel.tscn")
const DialogChoicesPanel = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogChoicesPanel/DialogChoicesPanel.gd")
const DialogChoicesPanel_Scene = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogChoicesPanel/DialogChoicesPanel.tscn")
const DialogTimeBarPanel = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogTimeBarPanel/DialogTimeBarPanel.gd")
const DialogTimeBarPanel_Scene = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogTimeBarPanel/DialogTimeBarPanel.tscn")
const DialogChoicesModiPanel = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogChoicesModiPanel/DialogChoicesModiPanel.gd")
const DialogImagePanel = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogImagePanel/DialogImagePanel.gd")
const DialogImagePanel_Scene = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogImagePanel/DialogImagePanel.tscn")
const Dialog_AlmanacXTypeInfoPanel = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/Dialog_AlamancXTypeInfoPanel/Dialog_AlmanacXTypeInfoPanel.gd")
const Dialog_AlmanacXTypeInfoPanel_Scene = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/Dialog_AlamancXTypeInfoPanel/Dialog_AlmanacXTypeInfoPanel.tscn")


#const Almanac_XTypeInfoPanel = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/Almanac_XTypeInfoPanel/Almanac_XTypeInfoPanel/Almanac_XTypeInfoPanel.gd")
#const AlmanacButtonPanel = preload("res://GameHUDRelated/AlmanacButtonPanel/AlmanacButtonPanel.gd")

const BackDialogImagePanel = preload("res://MiscRelated/DialogRelated/Controls/DialogBackgroundElementsControls/BackDialogImagePanel/BackDialogImagePanel.gd")
const BackDialogImagePanel_Scene = preload("res://MiscRelated/DialogRelated/Controls/DialogBackgroundElementsControls/BackDialogImagePanel/BackDialogImagePanel.tscn")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const DialogWholeScreenPanel = preload("res://MiscRelated/DialogRelated/Controls/DialogWholeScreenPanel/DialogWholeScreenPanel.gd")
const DialogWholeScreenPanel_Scene = preload("res://MiscRelated/DialogRelated/Controls/DialogWholeScreenPanel/DialogWholeScreenPanel.tscn")

const Tutorial_WhiteArrow_Particle = preload("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/Sub/Tutorial_WhiteArrow_Particle.gd")
const Tutorial_WhiteArrow_Particle_Scene = preload("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/Sub/Tutorial_WhiteArrow_Particle.tscn")
const Tutorial_WhiteCircle_Particle = preload("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/Sub/Tutorial_WhiteCircle_Particle.gd")
const Tutorial_WhiteCircle_Particle_Scene = preload("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/Sub/Tutorial_WhiteCircle_Particle.tscn")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")


const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

###


const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")


######


signal current_dialog_segment_changed(arg_seg)

#

const dia_main_panel__pos__standard := Vector2(0, 100)
const dia_main_panel__size__standard := Vector2(500, 50)

const dia_main_panel__pos__plate_middle := Vector2(0, 0)
const dia_main_panel__size__plate_middle := Vector2(250, 200)



const dia_portrait__pos__standard_left := Vector2(150, 150)
const dia_portrait__pos__standard_right := Vector2(680, 150)


const dia_time_duration__very_short : float = 20.0
const dia_time_duration__short : float = 25.0
const dia_time_duration__medium : float = 40.0
const dia_time_duration__long : float = 60.0


const SKIP_BUTTON__DEFAULT_TEXT = "Skip"
const SKIP_BUTTON__SKIP_DIALOG_TEXT = "Skip Dialog"


const COLOR_OF__NAME_CYDE := "#029FA1"
const COLOR_OF__NAME_PLAYER := "#FEC9AA"
const COLOR_OF__NAME_ASI := "#AF62FD"

######

var dialog_whole_screen_panel setget set_dialog_whole_screen_panel

var _current_dialog_segment : DialogSegment

var world_completion_num_state : int

##

# not the only way to set towers in shop refresh. Just for convenience
var towers_offered_on_shop_refresh : Array = [
	
]
var _current_index_of_towers_offered_on_shop_refresh : int = 0

#

var _towers_placed_in_map_for_multiple_listen : Array
var _towers_bought_for_multiple_listen : Array = []
var _tower_ids_sold_for_multiple_listen : Array = []

var _nodes_to_queue_free_on_dia_seg_advance : Array = []

#

var audio_player_adv_params
var audio_player_adv_params__for_bg_music

#

var non_essential_rng : RandomNumberGenerator

#

var _default_instant_texture_transition_val : bool

#

var _tutorial_world_ids_to_make_available_when_completed : Array

var _current_map_id

#

func _init(arg_id, arg_breakpoint, arg_name, arg_map_id).(arg_id, arg_breakpoint, arg_name):
	_current_map_id = arg_map_id
	

#

func create_dialog_whole_screen_panel_and_add_to_GE():
	var panel = DialogWholeScreenPanel_Scene.instance()
	game_elements.add_child_to_below_below_screen_effects_manager(panel)
	panel.game_elements = game_elements
	
	set_dialog_whole_screen_panel(panel)

func set_dialog_whole_screen_panel(arg_panel):
	dialog_whole_screen_panel = arg_panel
	
	dialog_whole_screen_panel.connect("resolve_block_advanced_requested_status", self, "_on_resolve_block_advanced_requested_status")

func play_dialog_segment_or_advance_or_finish_elements(arg_segment : DialogSegment):
	# for arrows, circles, etc
	for node in _nodes_to_queue_free_on_dia_seg_advance:
		if is_instance_valid(node) and !node.is_queued_for_deletion():
			node.queue_free()
	_nodes_to_queue_free_on_dia_seg_advance.clear()
	
	#
	
	_current_dialog_segment = arg_segment
	dialog_whole_screen_panel.current_dialog_segment = _current_dialog_segment
	
	emit_signal("current_dialog_segment_changed", _current_dialog_segment)
	
	
	call_deferred("_deferred_update_default_instant_texture_transition_val", arg_segment == null)

func _deferred_update_default_instant_texture_transition_val(arg_new_val):
	_default_instant_texture_transition_val = arg_new_val


#############

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	game_elements.connect("unhandled_input", self, "_game_elements_unhandled_input")
	game_elements.connect("unhandled_key_input", self, "_game_elements_unhandled_key_input")
	
	game_elements.tower_manager.connect("tower_being_dragged", self, "_on_tower_being_dragged")
	game_elements.tower_manager.connect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_dragged")
	
	if breakpoint_activation != BreakpointActivation.BEFORE_GAME_START:
		game_elements.connect("before_game_start", self, "_on_game_elements_before_game_start__base_class", [], CONNECT_ONESHOT)
	else:
		_on_game_elements_before_game_start__base_class()
	
	create_dialog_whole_screen_panel_and_add_to_GE()
	
	_initialize_audio_relateds()
	

func _initialize_audio_relateds():
	audio_player_adv_params = AudioManager.construct_play_adv_params()
	audio_player_adv_params.node_source = game_elements
	
	audio_player_adv_params__for_bg_music = AudioManager.construct_play_adv_params()
	audio_player_adv_params__for_bg_music.node_source = game_elements
	audio_player_adv_params__for_bg_music.play_sound_type = AudioManager.PlayerSoundType.BACKGROUND_MUSIC

#

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	
	if is_instance_valid(dialog_whole_screen_panel):
		dialog_whole_screen_panel.queue_free()

##


func _on_game_elements_before_game_start__base_class():
	set_notif_from_attempt_placing_towers(false)

func set_notif_from_attempt_placing_towers(arg_val : bool):
	game_elements.tower_manager.can_show_player_desc_of_level_required = arg_val



func _game_elements_unhandled_input(arg_event, arg_action_taken):
	if !arg_action_taken:
		if arg_event is InputEventMouseButton:
			if arg_event.pressed and (arg_event.button_index == BUTTON_RIGHT or arg_event.button_index == BUTTON_LEFT):
				if !is_instance_valid(game_elements.tower_manager.get_tower_on_mouse_hover()):
					_player_requests_advance_to_next_dia_seg()


func _game_elements_unhandled_key_input(arg_event, arg_action_taken):
	if !arg_action_taken:
		if !arg_event.echo and arg_event.pressed:
			if game_elements.if_allow_key_inputs_due_to_conditions():
				if arg_event.is_action_pressed("ui_accept"):
					_player_requests_advance_to_next_dia_seg()


func _player_requests_advance_to_next_dia_seg():
	if _current_dialog_segment != null:
		if dialog_whole_screen_panel.is_block_advance():
			dialog_whole_screen_panel.resolve_block_advance()
		else:
			_current_dialog_segment.request_advance()
	

func _on_resolve_block_advanced_requested_status(arg_resolved):
	if arg_resolved:
		#_current_dialog_segment.request_advance()
		pass

########### DIA SEG signals

#func _on_current_dia_seg_requested_action_advance(arg_seg : DialogSegment):
#	if arg_seg.advance_mode == arg_seg.AdvanceMode.PLAYER_INPUT_IN_MAP:
#		pass
#


######### HELPER FUNCS
## CONFIGURE SIGNALS

func configure_dia_seg_to_progress_to_next_on_player_click_or_enter(arg_seg : DialogSegment, arg_next_seg : DialogSegment):
	arg_seg.connect("requested_action_advance", self, "_on_configured_dia_seg_requested_advance_to_next_seg", [arg_next_seg], CONNECT_ONESHOT)

func configure_dia_seg_to_call_func_on_player_click_or_enter(arg_seg : DialogSegment, arg_func_source, arg_func_name, arg_func_params):
	arg_seg.connect("requested_action_advance", self, "_on_configured_dia_seg_to_call_func_on_player_click_or_enter", [arg_seg, arg_func_source, arg_func_name, arg_func_params], CONNECT_ONESHOT)



class SkipAdvParams:
	
	var is_skip_button_in_main_dialog_panel : bool = true
	
	var skip_button_rect_pos__for_non_main_dialog_panel : Vector2
	var skip_button_rect_pos_origin : int = DialogSegment.RectPosOrigin.TOP_LEFT


func configure_dia_seg_to_skip_to_next_on_player_skip__based_on_checks(arg_seg : DialogSegment, arg_next_seg : DialogSegment, 
		arg_func_source_bool_check, arg_func_name_bool_check, arg_func_params_bool_check, arg_text_to_use : String = SKIP_BUTTON__DEFAULT_TEXT,
		arg_adv_params : SkipAdvParams = SkipAdvParams.new()):
	
	arg_seg.func_source_for__is_skip_exec = arg_func_source_bool_check
	arg_seg.func_name_for__is_skip_exec = arg_func_name_bool_check
	arg_seg.func_param_for__is_skip_exec = arg_func_params_bool_check
	arg_seg.connect("requested_action_skip", self, "_on_configured_dia_seg_requested_advance_to_next_seg__thru_skip", [arg_next_seg], CONNECT_ONESHOT)
	
	arg_seg.skip_button_text = arg_text_to_use
	
	##
	
	arg_seg.is_skip_button_in_main_dialog_panel = arg_adv_params.is_skip_button_in_main_dialog_panel
	arg_seg.skip_button_rect_pos__for_non_main_dialog_panel = arg_adv_params.skip_button_rect_pos__for_non_main_dialog_panel
	arg_seg.skip_button_rect_pos_origin = arg_adv_params.skip_button_rect_pos_origin

func configure_dia_seg_to_skip_to_next_on_player_skip(arg_seg : DialogSegment, arg_next_seg : DialogSegment, arg_text_to_use : String = SKIP_BUTTON__DEFAULT_TEXT,
		arg_adv_params : SkipAdvParams = SkipAdvParams.new()):
	
	arg_seg.func_source_for__is_skip_exec = self
	arg_seg.func_name_for__is_skip_exec = "_on_dia_seg_requested_action_skip__always_pass_bool_check"
	arg_seg.func_param_for__is_skip_exec = null
	arg_seg.connect("requested_action_skip", self, "_on_configured_dia_seg_requested_advance_to_next_seg__thru_skip", [arg_next_seg], CONNECT_ONESHOT)
	
	arg_seg.skip_button_text = arg_text_to_use
	
	##
	
	arg_seg.is_skip_button_in_main_dialog_panel = arg_adv_params.is_skip_button_in_main_dialog_panel
	arg_seg.skip_button_rect_pos__for_non_main_dialog_panel = arg_adv_params.skip_button_rect_pos__for_non_main_dialog_panel
	arg_seg.skip_button_rect_pos_origin = arg_adv_params.skip_button_rect_pos_origin


func configure_dia_seg_to_skip_to_next_on_player_skip__next_seg_as_func(arg_seg : DialogSegment, arg_func_source_for_next_seg, arg_func_name_for_next_seg, arg_text_to_use : String = SKIP_BUTTON__DEFAULT_TEXT,
		arg_adv_params : SkipAdvParams = SkipAdvParams.new()):
	arg_seg.func_source_for__is_skip_exec = self
	arg_seg.func_name_for__is_skip_exec = "_on_dia_seg_requested_action_skip__always_pass_bool_check"
	arg_seg.func_param_for__is_skip_exec = null
	arg_seg.connect("requested_action_skip", self, "_on_configured_dia_seg_requested_advance_to_next_seg__thru_skip__next_seg_as_func_name", [arg_func_source_for_next_seg, arg_func_name_for_next_seg], CONNECT_ONESHOT)
	
	arg_seg.skip_button_text = arg_text_to_use
	
	##
	
	arg_seg.is_skip_button_in_main_dialog_panel = arg_adv_params.is_skip_button_in_main_dialog_panel
	arg_seg.skip_button_rect_pos__for_non_main_dialog_panel = arg_adv_params.skip_button_rect_pos__for_non_main_dialog_panel
	arg_seg.skip_button_rect_pos_origin = arg_adv_params.skip_button_rect_pos_origin



func _on_dia_seg_requested_action_skip__always_pass_bool_check(arg_params):
	return true


#func configure_dia_seg_to_previous_on_player_click_or_enter

func _on_configured_dia_seg_requested_advance_to_next_seg(arg_next_seg : DialogSegment):
	play_dialog_segment_or_advance_or_finish_elements(arg_next_seg)

func _on_configured_dia_seg_to_call_func_on_player_click_or_enter(arg_seg : DialogSegment, arg_func_source, arg_func_name, arg_func_params):
	arg_func_source.call(arg_func_name, arg_seg, arg_func_params)

func _on_configured_dia_seg_requested_advance_to_next_seg__thru_skip(arg_seg : DialogSegment):
	play_dialog_segment_or_advance_or_finish_elements(arg_seg)

func _on_configured_dia_seg_requested_advance_to_next_seg__thru_skip__next_seg_as_func_name(arg_seg_func_source, arg_seg_func_name):
	#play_dialog_segment_or_advance_or_finish_elements(arg_seg_func_source.call(arg_seg_func_name))
	arg_seg_func_source.call(arg_seg_func_name)

########## HELPER FUNS FOR DIALOG ELEMENTS -- CONFIG

func _set_dialog_segment_to_block_almanac_button(arg_seg : DialogSegment, arg_clause_id_to_use : int):
	arg_seg.disable_almanac_button = true
	arg_seg.disable_almanac_button_clause_id = arg_clause_id_to_use


########## HELPER FUNCS FOR DIALOG ELEMENTS
## 

class DescriptionsAdvParams:
	var default_text_color : Color = Color("#dddddd")
	var use_dark_mode_text : bool = true
	
	var background_texture_of_segment : Texture = DialogSegment.Background_Pic_Default
	

## DESCRIPTIONS
func _configure_dia_seg_to_default_templated_dialog_with_descs_only(arg_seg : DialogSegment, arg_descs : Array,
		adv_params : DescriptionsAdvParams = DescriptionsAdvParams.new()):#, arg_pos : Vector2, arg_size : Vector2):
	var diag_construction_ins := DialogSegment.DialogElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_dialog_for_dia_seg"
	diag_construction_ins.func_params = [arg_seg, arg_descs, adv_params] #arg_pos, arg_size]
	
	#
	arg_seg.background_texture = adv_params.background_texture_of_segment
	
	arg_seg.add_dialog_element_construction_ins(diag_construction_ins)

func _construct_default_templated_dialog_for_dia_seg(arg_params : Array):
	var dia_seg : DialogSegment = arg_params[0]
	var descs : Array = arg_params[1]
	var adv_params : DescriptionsAdvParams = arg_params[2]
	
	var panel = DialogDescsPanel_Scene.instance()
	panel.descs = descs
	
	panel.default_text_color = adv_params.default_text_color
	panel.use_dark_mode_text = adv_params.use_dark_mode_text
	
	return panel

## TEXT INPUT PANEL
# input entered method should expect 2 args (input text, dia seg)
func _configure_dia_seg_to_default_templated_dialog_text_input(arg_seg : DialogSegment, arg_title_header : String, arg_func_source_when_enter, arg_func_name_when_enter):#, arg_pos : Vector2, arg_size : Vector2):
	var diag_construction_ins := DialogSegment.DialogElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_text_input_for_dia_seg"
	diag_construction_ins.func_params = [arg_seg, arg_title_header, arg_func_source_when_enter, arg_func_name_when_enter] #arg_pos, arg_size]
	
	arg_seg.add_dialog_element_construction_ins(diag_construction_ins)

func _construct_default_templated_text_input_for_dia_seg(arg_params : Array):
	var dia_seg : DialogSegment = arg_params[0]
	var title_header : String = arg_params[1]
	var func_source = arg_params[2]
	var func_name = arg_params[3]
	
	var panel = DialogTextInputPanel_Scene.instance()
	panel.text_for_input_title = title_header
	panel.connect("line_edit_input_entered", func_source, func_name, [dia_seg], CONNECT_ONESHOT)
	
	dia_seg.block_advance_conditional_clauses.attempt_insert_clause(DialogSegment.BlockAdvanceClauseIds.TEXT_INPUT_WAIT)
	
	return panel


## CHOICES PANEL
func _configure_dia_seg_to_default_templated_dialog_choices_panel(arg_seg : DialogSegment, arg_button_choices_info : Array, 
		func_source_for_properties, func_name_for_is_show_dia_modi_panel, func_name_for_dia_choices_modi):#, arg_pos : Vector2, arg_size : Vector2):
	
	var diag_construction_ins := DialogSegment.DialogElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_choices_panel_for_dia_seg"
	diag_construction_ins.func_params = [arg_seg, arg_button_choices_info, func_source_for_properties, func_name_for_is_show_dia_modi_panel, func_name_for_dia_choices_modi]
	
	arg_seg.add_dialog_element_construction_ins(diag_construction_ins)
	
	return diag_construction_ins

func _construct_default_templated_choices_panel_for_dia_seg(arg_params : Array):
	var dia_seg : DialogSegment = arg_params[0]
	var choices : Array = arg_params[1]
	var func_source_for_properties = arg_params[2]
	var func_name_for_show_dia_modi_panel = arg_params[3]
	var func_name_for_dia_modi_config = arg_params[4]
	
	
	var panel = DialogChoicesPanel_Scene.instance()
	for choice in choices:
		panel.add_choice_button_info(choice)
	
	panel.func_source_for__properties = func_source_for_properties
	panel.func_name_for__is_display_dialog_choices_modi = func_name_for_show_dia_modi_panel
	panel.func_name_for__modi_panel_config = func_name_for_dia_modi_config
	
	dia_seg.block_advance_conditional_clauses.attempt_insert_clause(DialogSegment.BlockAdvanceClauseIds.BUTTON_CHOICES_WAIT)
	
	return panel



# CHOICES PANEL -- WITH QuestionInfoForChoices
# returns [created_dia_seg, diag_cons_ins]
func _construct_dia_seg_to_default_templated__questions_from_pool(arg_seg_func_source, arg_seg_func_name, all_possible_choices_info : AllPossibleQuestionsAndChoices_AndMiscInfo, 
		func_source_for_properties, func_name_for_is_show_dia_modi_panel, func_name_for_dia_choices_modi):#, arg_pos : Vector2, arg_size : Vector2):
	
	var rand_ques_for_choices : QuestionInfoForChoicesPanel = all_possible_choices_info.get_random_question_and_choices__and_set_id_taken()
	var question_as_desc = rand_ques_for_choices.question_as_desc
	var choices_for_questions = rand_ques_for_choices.choices_for_questions
	
	var arg_seg : DialogSegment = arg_seg_func_source.call(arg_seg_func_name, [rand_ques_for_choices])
	
	
	# diag const ins FOR DESCS
	_configure_dia_seg_to_default_templated_dialog_with_descs_only(arg_seg, question_as_desc)
	
	# diag const ins FOR CHOICES
	var diag_construction_ins := DialogSegment.DialogElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_choices_panel_for_dia_seg__with_choices_as_info"
	diag_construction_ins.func_params = [arg_seg, choices_for_questions, func_source_for_properties, func_name_for_is_show_dia_modi_panel, func_name_for_dia_choices_modi]
	
	arg_seg.add_dialog_element_construction_ins(diag_construction_ins)
	
	# diag const ins FOR TIME
	if rand_ques_for_choices.has_time:
		var time = rand_ques_for_choices.time_for_question
		var timeout_func_source = rand_ques_for_choices.timeout_func_source
		var timeout_func_name = rand_ques_for_choices.timeout_func_name
		var timeout_func_params = rand_ques_for_choices.timeout_func_params
		
		_configure_dia_seg_to_default_templated_dialog_time_bar_panel(arg_seg, time, time, timeout_func_source, timeout_func_name, timeout_func_params)
		
	
	return [arg_seg, diag_construction_ins]

func _construct_default_templated_choices_panel_for_dia_seg__with_choices_as_info(arg_params : Array):
	var dia_seg : DialogSegment = arg_params[0]
	var choices_for_questions : ChoicesForQuestionsInfo = arg_params[1]
	var func_source_for_properties = arg_params[2]
	var func_name_for_show_dia_modi_panel = arg_params[3]
	var func_name_for_dia_modi_config = arg_params[4]
	
	
	var panel = DialogChoicesPanel_Scene.instance()
	for choice in choices_for_questions.get_random_list_of_choices():
		panel.add_choice_button_info(choice)
	
	panel.func_source_for__properties = func_source_for_properties
	panel.func_name_for__is_display_dialog_choices_modi = func_name_for_show_dia_modi_panel
	panel.func_name_for__modi_panel_config = func_name_for_dia_modi_config
	
	dia_seg.block_advance_conditional_clauses.attempt_insert_clause(DialogSegment.BlockAdvanceClauseIds.BUTTON_CHOICES_WAIT)
	
	return panel



##### HELPER FUNC FOR QUESTIONS/CHOICES

class AllPossibleQuestionsAndChoices_AndMiscInfo:
	
	var _next_id = 1
	
	var _id_to_question_info_for_choices_panel_map : Dictionary = {}
	var _ids_taken : Array
	
	var rng_to_use
	
	#
	
#	var func_source_for_all
#
#	var show_dialog_choices_modi_panel_func_name
#	var build_dialog_choices_modi_panel_config_func_name
#
#	var on_dialog_choices_modi_panel__removed_choices_func_name
#	var on_dialog_choices_modi_panel__change_question_func_name
	
	#
	
	func _init(arg_rng_to_use):
		rng_to_use = arg_rng_to_use
	
	##
	
	func add_question_info_for_choices_panel(arg_question_info):
		_id_to_question_info_for_choices_panel_map[_next_id] = arg_question_info
		var id = _next_id
		
		_next_id += 1
		return id
	
	
	func get_all_untaken_question_info_ids():
		var bucket = []
		for id in _id_to_question_info_for_choices_panel_map:
			if !_ids_taken.has(id):
				bucket.append(id)
		
		return bucket
	
	func get_random_question_and_choices__and_set_id_taken() -> QuestionInfoForChoicesPanel:
		var all_untaken_info_ids = get_all_untaken_question_info_ids()
		var rand_id = StoreOfRNG.randomly_select_one_element(all_untaken_info_ids, rng_to_use)
		
		_ids_taken.append(rand_id)
		return _id_to_question_info_for_choices_panel_map[rand_id]
	
	

class QuestionInfoForChoicesPanel:
	
	var question_as_desc : Array
	var choices_for_questions : ChoicesForQuestionsInfo
	
	#
	
	var time_for_question : float = 20.0 setget set_time_for_question
	var has_time : bool = true
	
	var timeout_func_source
	var timeout_func_name
	var timeout_func_params
	
	func set_time_for_question(arg_time):
		time_for_question = arg_time
		has_time = time_for_question > 0
	
	

class ChoicesForQuestionsInfo:
	
	var _wrong_choices_list : Array
	var _right_choices_list : Array
	
	var rng_to_use : RandomNumberGenerator
	var choice_count
	
	func _init(arg_rng_to_use, arg_choice_count):
		rng_to_use = arg_rng_to_use
		choice_count = arg_choice_count
	
	func add_choice(arg_choice): #: DialogChoicesPanel.ChoiceButtonInfo):
		if arg_choice.choice_result_type == arg_choice.ChoiceResultType.WRONG:
			_wrong_choices_list.append(arg_choice)
		else:
			_right_choices_list.append(arg_choice)
	
	#
	
	# by default, gives at least 1 right choice
	func get_random_list_of_choices(arg_count : int = choice_count) -> Array:
		var copy_of_wrong_choices_list = _wrong_choices_list.duplicate()
		
		var bucket = []
		for i in arg_count - 1:
			var rand_wrong_choice = StoreOfRNG.randomly_select_one_element(copy_of_wrong_choices_list, rng_to_use)
			copy_of_wrong_choices_list.erase(rand_wrong_choice)
			bucket.append(rand_wrong_choice)
		
		
		var rand_right_choice = StoreOfRNG.randomly_select_one_element(_right_choices_list, rng_to_use)
		var rand_index_of_right_choice = rng_to_use.randi_range(0, arg_count - 1)
		
		bucket.insert(rand_index_of_right_choice, rand_right_choice)
		
		
		return bucket


## TIMER PANEL

func _configure_dia_seg_to_default_templated_dialog_time_bar_panel(
			arg_seg : DialogSegment, 
			arg_starting_time : float, 
			arg_current_time : float, 
			arg_timeout_func_source, arg_timeout_func_name, arg_timeout_func_params):
	
	var diag_construction_ins := DialogSegment.DialogElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_time_bar_panel_for_dia_seg"
	diag_construction_ins.func_params = [arg_seg, arg_starting_time, arg_current_time, arg_timeout_func_source, arg_timeout_func_name, arg_timeout_func_params]
	
	arg_seg.add_dialog_element_construction_ins(diag_construction_ins)

func _construct_default_templated_time_bar_panel_for_dia_seg(arg_params : Array):
	var dia_seg : DialogSegment = arg_params[0]
	var starting_time : float = arg_params[1]
	var current_time : float = arg_params[2]
	var timeout_func_source = arg_params[3]
	var timeout_func_name = arg_params[4]
	var timeout_func_params = arg_params[5]
	
	#
	var panel = DialogTimeBarPanel_Scene.instance()
	
	panel.starting_time = starting_time
	panel.current_time = current_time
	panel.time_timeout_func_source = timeout_func_source
	panel.time_timeout_func_name = timeout_func_name
	panel.time_timeout_func_params = timeout_func_params
	
	return panel


## IMAGE PANEL

func _configure_dia_seg_to_default_templated_dialog_image_panel(
			arg_seg : DialogSegment, 
			arg_image : Texture):
	
	var diag_construction_ins := DialogSegment.DialogElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_image_panel_for_dia_seg"
	diag_construction_ins.func_params = [arg_seg, arg_image]
	
	arg_seg.add_dialog_element_construction_ins(diag_construction_ins)

func _construct_default_templated_image_panel_for_dia_seg(arg_params):
	var dia_seg : DialogSegment = arg_params[0]
	var image : Texture = arg_params[1]
	
	var panel = DialogImagePanel_Scene.instance()
	panel.image_to_use = image
	
	return panel


## Alamanc XTypeInfoPanel
# input entered method should expect 2 args (x_type_item_entry_data, x_type (type classification : int. Ex = TEXT_TIDBIT, ENEMY, TOWER))
func _configure_dia_seg_to_default_templated_dialog_almanac_x_type_info_panel(arg_seg : DialogSegment, arg_x_type_item_entry_data, arg_x_type_classification):#, arg_pos : Vector2, arg_size : Vector2):
	var diag_construction_ins := DialogSegment.DialogElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_almanac_x_type_info_panel_for_dia_seg"
	diag_construction_ins.func_params = [arg_seg, arg_x_type_item_entry_data, arg_x_type_classification] #arg_pos, arg_size]
	
	arg_seg.add_dialog_element_construction_ins(diag_construction_ins)

func _construct_default_templated_almanac_x_type_info_panel_for_dia_seg(arg_params : Array):
	var dia_seg : DialogSegment = arg_params[0]
	var x_type_item_entry_data = arg_params[1]
	var x_type_classification = arg_params[2]
	
	var panel = Dialog_AlmanacXTypeInfoPanel_Scene.instance()
	panel.x_type_item_entry_data = x_type_item_entry_data
	panel.x_type = x_type_classification
	
	dia_seg.show_dialog_main_panel_background = false
	dia_seg.show_dialog_main_panel_borders = false
	
	return panel



# pos and sizes

func _configure_dia_set_to_standard_pos_and_size(arg_seg : DialogSegment):
	arg_seg.final_dialog_top_left_pos = dia_main_panel__pos__standard
	arg_seg.final_dialog_custom_size = dia_main_panel__size__standard

func _configure_dia_set_to_plate_middle_pos_and_size(arg_seg : DialogSegment):
	arg_seg.final_dialog_top_left_pos = dia_main_panel__pos__plate_middle
	arg_seg.final_dialog_custom_size = dia_main_panel__size__plate_middle


func _configure_dia_set_to_pos_and_size(arg_seg : DialogSegment, arg_top_left_pos, arg_size):
	arg_seg.final_dialog_top_left_pos = arg_top_left_pos
	arg_seg.final_dialog_custom_size = arg_size

func _configure_dia_set_to_pos_and_size__to_instant_transition_times(arg_seg : DialogSegment):
	arg_seg.final_dialog_custom_size_val_trans_mode = DialogSegment.ValTransition.ValueIncrementMode.INSTANT
	arg_seg.final_dialog_top_left_pos_val_trans_mode = DialogSegment.ValTransition.ValueIncrementMode.INSTANT

## BACKGROUND ELEMENT -- TEXTURE IMAGE

class BackgroundElementAdvParams:
	var starting_initial_mod_a : float = 1.0
	var starting_target_mod_a : float = 1.0
	var starting_mod_a_duration : float = 0.3
	
	var ending_initial_mod_a : float = 1.0
	var ending_target_mod_a : float = 1.0
	var ending_mod_a_duration : float = 0.3
	
	var wait_for_all_background_elements_to_fade_out : bool = false
	
	var ignored_for_wait_for_all_background_elements_to_fade_out : bool = false
	
	#
	
	var fade_out_on_next_dia_seg : bool = true
	
	####
	
	var func_name_to_call_on_element_constructed : String
	
	var func_source__instant_texture_transition : Object
	var func_name__instant_texture_transition : String = "_default_func__instant_texture_transition"
	
	

func _default_func__instant_texture_transition():
	return _default_instant_texture_transition_val



func _configure_dia_seg_to_default_templated_background_ele_dia_texture_image(arg_seg : DialogSegment, arg_image, arg_ending_pos, arg_starting_pos = BackDialogImagePanel.VECTOR_UNDEFINED, 
		arg_persistence_id = DialogSegment.BackgroundElementsConstructionIns.NO_PERSISTENCE_ID,
		arg_adv_param : BackgroundElementAdvParams = BackgroundElementAdvParams.new()):
	
	arg_adv_param.func_source__instant_texture_transition = self
	
	var diag_construction_ins := DialogSegment.BackgroundElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_background_ele_dia_texture_image_for_dia_seg"
	diag_construction_ins.func_params = [arg_seg, arg_image, arg_ending_pos, arg_starting_pos, arg_adv_param]
	diag_construction_ins.persistence_id = arg_persistence_id
	
	arg_seg.add_background_element_construction_ins(diag_construction_ins)

# arg_background_element may be null, depending if an element with the given persistence_id exists
func _construct_default_templated_background_ele_dia_texture_image_for_dia_seg(arg_background_element, arg_params : Array, arg_persistence_id):
	var dia_seg : DialogSegment = arg_params[0]
	var texture : Texture = arg_params[1]
	var ending_pos : Vector2 = arg_params[2]
	var starting_pos : Vector2 = arg_params[3]
	var adv_params : BackgroundElementAdvParams = arg_params[4]
	
	if arg_background_element == null:
		arg_background_element = BackDialogImagePanel_Scene.instance()
	
	arg_background_element.persistence_id = arg_persistence_id
	arg_background_element.final_top_left_pos = ending_pos
	arg_background_element.initial_top_left_pos = starting_pos
	
	arg_background_element.instant_transition_and_ignore_tween_procedure = adv_params.func_source__instant_texture_transition.call(adv_params.func_name__instant_texture_transition)
	
	arg_background_element.texture_to_use = texture
	
	arg_background_element.starting_initial_mod_a = adv_params.starting_initial_mod_a
	arg_background_element.starting_target_mod_a = adv_params.starting_target_mod_a
	arg_background_element.starting_mod_a_duration = adv_params.starting_mod_a_duration
	
	arg_background_element.ending_initial_mod_a = adv_params.ending_initial_mod_a
	arg_background_element.ending_target_mod_a = adv_params.ending_target_mod_a
	arg_background_element.ending_mod_a_duration = adv_params.ending_mod_a_duration
	
	arg_background_element.wait_for_all_background_elements_to_fade_out = adv_params.wait_for_all_background_elements_to_fade_out
	arg_background_element.ignored_for_wait_for_all_background_elements_to_fade_out = adv_params.ignored_for_wait_for_all_background_elements_to_fade_out
	
	arg_background_element.fade_out_on_next_dia_seg = adv_params.fade_out_on_next_dia_seg
	
	##
	
	if adv_params.func_name_to_call_on_element_constructed.length() != 0:
		call(adv_params.func_name_to_call_on_element_constructed, arg_background_element)
	
	return arg_background_element



#

# func name expects 1 arg: DialogSegment
func listen_for_dia_seg_finish_display__on_whole_screen_panel(arg_expected_dia_seg, arg_func_source, arg_func_name):
	dialog_whole_screen_panel.connect("shown_all_DBE_and_finished_display", self, "_on_DWSP_shown_all_DBE_and_finished_display__for_listen", [arg_expected_dia_seg, arg_func_name, arg_func_source])

func _on_DWSP_shown_all_DBE_and_finished_display__for_listen(arg_dia_seg, arg_expected_dia_seg, arg_func_source, arg_func_name):
	if arg_dia_seg == arg_expected_dia_seg:
		dialog_whole_screen_panel.disconnect("shown_all_DBE_and_finished_display", self, "_on_DWSP_shown_all_DBE_and_finished_display__for_listen")
		arg_func_source.call(arg_func_name, arg_dia_seg)


#

func set_next_shop_towers_and_increment_counter():
	var tower_ids = towers_offered_on_shop_refresh[_current_index_of_towers_offered_on_shop_refresh]
	_current_index_of_towers_offered_on_shop_refresh += 1
	
	if tower_ids != null:
		game_elements.shop_manager.roll_towers_in_shop__specific_ids(tower_ids)




#func set_up_all_possible_questions_and_answers_as_choices_panel(arg_dia_seg, all_possible_question_and_ans_misc_info):
#	pass
#
#

#########################################
#########################################
########## GAME ELEMENTS STUFFS RELATED (Mostly imported from Tutorials) ############

func set_tower_is_draggable(arg_tower, arg_val):
	if arg_val:
		arg_tower.tower_is_draggable_clauses.remove_clause(arg_tower.TowerDraggableClauseIds.TUTORIAL_DISABLED)
	else:
		arg_tower.tower_is_draggable_clauses.attempt_insert_clause(arg_tower.TowerDraggableClauseIds.TUTORIAL_DISABLED)

func set_tower_is_sellable(arg_tower, arg_val):
	if arg_val:
		arg_tower.can_be_sold_conditonal_clauses.remove_clause(arg_tower.CanBeSoldClauses.TUTORIAL_DISABLED_CLAUSE)
	else:
		arg_tower.can_be_sold_conditonal_clauses.attempt_insert_clause(arg_tower.CanBeSoldClauses.TUTORIAL_DISABLED_CLAUSE)

func set_can_do_combination(arg_val : bool):
	if arg_val:
		game_elements.combination_manager.can_do_combination_clauses.remove_clause(game_elements.CombinationManager.CanDoCombinationClauses.TUTORIAL_DISABLE)
	else:
		game_elements.combination_manager.can_do_combination_clauses.attempt_insert_clause(game_elements.CombinationManager.CanDoCombinationClauses.TUTORIAL_DISABLE)

func add_gold_amount(arg_amount : int):
	game_elements.gold_manager.increase_gold_by(arg_amount, game_elements.GoldManager.IncreaseGoldSource.SYNERGY)

func set_player_level(arg_level : int):
	game_elements.level_manager.set_current_level(arg_level)

func set_ingredient_limit_modi(arg_amount : int):
	game_elements.tower_manager.set_ing_cap_changer(StoreOfIngredientLimitModifierID.TUTORIAL, arg_amount)

func set_can_return_to_round_panel(arg_val : bool):
	game_elements.can_return_to_round_panel = arg_val



func set_round_is_startable(arg_val : bool):
	game_elements.round_status_panel.can_start_round = arg_val
	game_elements.round_status_panel.round_speed_and_start_panel.visible = arg_val


func set_can_level_up(arg_val : bool):
	if arg_val:
		game_elements.level_manager.can_level_up_clauses.remove_clause(game_elements.LevelManager.CanLevelUpClauses.TUTORIAL_DISABLE)
	else:
		game_elements.level_manager.can_level_up_clauses.attempt_insert_clause(game_elements.LevelManager.CanLevelUpClauses.TUTORIAL_DISABLE)

func set_can_refresh_shop__panel_based(arg_val : bool):
	if arg_val:
		game_elements.panel_buy_sell_level_roll.can_refresh_shop_clauses.remove_clause(game_elements.panel_buy_sell_level_roll.CanRefreshShopClauses.TUTORIAL_DISABLE)
	else:
		game_elements.panel_buy_sell_level_roll.can_refresh_shop_clauses.attempt_insert_clause(game_elements.panel_buy_sell_level_roll.CanRefreshShopClauses.TUTORIAL_DISABLE)

func set_can_refresh_shop_at_round_end_clauses(arg_val):
	if arg_val:
		game_elements.shop_manager.can_refresh_shop_at_round_end_clauses.remove_clause(game_elements.ShopManager.CanRefreshShopAtRoundEndClauses.TUTORIAL_DISABLE)
	else:
		game_elements.shop_manager.can_refresh_shop_at_round_end_clauses.attempt_insert_clause(game_elements.ShopManager.CanRefreshShopAtRoundEndClauses.TUTORIAL_DISABLE)


func set_enabled_buy_slots(arg_array : Array): # ex: [1, 2] = the first and second buy slots (from the left) are enabled
	for i in game_elements.panel_buy_sell_level_roll.all_buy_slots.size():
		i += 1
		var buy_slot = game_elements.panel_buy_sell_level_roll.all_buy_slots[i - 1]
		var clause = game_elements.panel_buy_sell_level_roll.buy_slot_to_disabled_clauses[buy_slot]
		
		if arg_array.has(i):
			clause.remove_clause(game_elements.panel_buy_sell_level_roll.BuySlotDisabledClauses.TUTORIAL_DISABLE)
		else:
			clause.attempt_insert_clause(game_elements.panel_buy_sell_level_roll.BuySlotDisabledClauses.TUTORIAL_DISABLE)

func set_can_sell_towers(arg_val : bool):
	if arg_val:
		game_elements.sell_panel.can_sell_clauses.remove_clause(game_elements.SellPanel.CanSellClauses.TUTORIAL_DISABLE)
	else:
		game_elements.sell_panel.can_sell_clauses.attempt_insert_clause(game_elements.SellPanel.CanSellClauses.TUTORIAL_DISABLE)

func set_can_toggle_to_ingredient_mode(arg_val : bool):
	if arg_val:
		game_elements.tower_manager.can_toggle_to_ingredient_mode_clauses.remove_clause(game_elements.tower_manager.CanToggleToIngredientModeClauses.TUTORIAL_DISABLE)
	else:
		game_elements.tower_manager.can_toggle_to_ingredient_mode_clauses.attempt_insert_clause(game_elements.tower_manager.CanToggleToIngredientModeClauses.TUTORIAL_DISABLE)

func set_can_towers_swap_positions_to_another_tower(arg_val):
	if arg_val:
		game_elements.tower_manager.can_towers_swap_positions_clauses.remove_clause(game_elements.tower_manager.CanTowersSwapPositionsClauses.TUTORIAL_DISABLE)
	else:
		game_elements.tower_manager.can_towers_swap_positions_clauses.attempt_insert_clause(game_elements.tower_manager.CanTowersSwapPositionsClauses.TUTORIAL_DISABLE)

func set_bonus_ingredient_limit_amount(arg_amount : int):
	game_elements.tower_manager.set_tower_limit_id_amount(StoreOfIngredientLimitModifierID.TUTORIAL, arg_amount)

func add_shop_per_refresh_modifier(arg_modi : int):
	game_elements.shop_manager.add_towers_per_refresh_amount_modifier(game_elements.ShopManager.TowersPerShopModifiers.TUTORIAL, arg_modi)

func remove_shop_per_refresh_modifier():
	game_elements.shop_manager.remove_towers_per_refresh_amount_modifier(game_elements.ShopManager.TowersPerShopModifiers.TUTORIAL)


#

func clear_all_tower_cards_from_shop():
	game_elements.panel_buy_sell_level_roll.remove_tower_card_from_all_buy_slots()


#### Map related

func set_visiblity_of_all_placables(arg_val):
	for placable in game_elements.map_manager.base_map.all_in_map_placables:
		placable.visible = arg_val

func set_visiblity_of_placable(arg_placable, arg_val):
	arg_placable.visible = arg_val


func get_map_area_placable_with_name(arg_name):
	return game_elements.map_manager.base_map.get_placable_with_node_name(arg_name)



#

func create_tower_at_placable(arg_tower_id, arg_placable):
	var tower = game_elements.tower_inventory_bench.create_tower_and_add_to_scene(arg_tower_id, arg_placable)
	return tower


# expects a method that accepts a tower instance
func listen_for_tower_with_id__bought__then_call_func(arg_tower_id, arg_func_name : String, arg_func_source):
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added", [arg_tower_id, arg_func_name, arg_func_source])

func _on_tower_added(arg_tower_instance, arg_expected_tower_id, arg_func_name, arg_func_source):
	if arg_tower_instance.tower_id == arg_expected_tower_id:
		game_elements.tower_manager.disconnect("tower_added", self, "_on_tower_added")
		arg_func_source.call(arg_func_name, arg_tower_instance)



# expects a method that accepts an array (of tower instances)  <1 param>
func listen_for_towers_with_ids__bought__then_call_func(arg_tower_ids : Array, arg_func_name : String, arg_func_source):
	_towers_bought_for_multiple_listen.clear()
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added__multiple_needed", [arg_tower_ids.duplicate(), arg_func_name, arg_func_source])

func _on_tower_added__multiple_needed(arg_tower_instance, arg_expected_tower_ids, arg_func_name, arg_func_source):
	var tower_id = arg_tower_instance.tower_id
	
	set_tower_is_sellable(arg_tower_instance, false)
	set_tower_is_draggable(arg_tower_instance, false)
	
	if arg_expected_tower_ids.has(tower_id):
		arg_expected_tower_ids.erase(tower_id)
		_towers_bought_for_multiple_listen.append(arg_tower_instance)
	
	if arg_expected_tower_ids.size() == 0:
		game_elements.tower_manager.disconnect("tower_added", self, "_on_tower_added__multiple_needed")
		arg_func_source.call(arg_func_name, _towers_bought_for_multiple_listen.duplicate())
		_towers_bought_for_multiple_listen.clear()


# expects a method that accepts array (of tower ids)
func listen_for_towers_with_ids__sold__then_call_func(arg_tower_ids : Array, arg_func_name : String, arg_func_source):
	_tower_ids_sold_for_multiple_listen.clear()
	game_elements.tower_manager.connect("tower_being_sold", self, "_on_tower_sold__multiple_needed", [arg_tower_ids.duplicate(), arg_func_name, arg_func_source])

func _on_tower_sold__multiple_needed(arg_sellback_gold, arg_tower, arg_expected_tower_ids, arg_func_name, arg_func_source):
	var tower_id = arg_tower.tower_id
	
	if arg_expected_tower_ids.has(tower_id):
		arg_expected_tower_ids.erase(tower_id)
		_tower_ids_sold_for_multiple_listen.append(tower_id)
	
	if arg_expected_tower_ids.size() == 0:
		game_elements.tower_manager.disconnect("tower_being_sold", self, "_on_tower_sold__multiple_needed")
		arg_func_source.call(arg_func_name, _tower_ids_sold_for_multiple_listen.duplicate())
		_tower_ids_sold_for_multiple_listen.clear()


# expects a method that accepts an array (of tower instances)
func listen_for_towers_with_ids__placed_in_map__then_call_func(arg_tower_ids : Array, arg_func_name : String, arg_func_source):
	_towers_placed_in_map_for_multiple_listen.clear()
	game_elements.tower_manager.connect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_drag__multiple_needed", [arg_tower_ids, arg_func_name, arg_func_source])
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_must_be_placed_in_map")

func _on_tower_must_be_placed_in_map(arg_tower):
	set_tower_is_sellable(arg_tower, false)
	#set_tower_is_draggable(arg_tower, false)

func _on_tower_dropped_from_drag__multiple_needed(arg_tower_instance, arg_expected_tower_ids : Array, arg_func_name, arg_func_source):
	var tower_id = arg_tower_instance.tower_id
	var is_placable_in_map = arg_tower_instance.is_current_placable_in_map()
	
	if arg_expected_tower_ids.has(tower_id):
		if is_placable_in_map and !_towers_placed_in_map_for_multiple_listen.has(arg_tower_instance):
			_towers_placed_in_map_for_multiple_listen.append(arg_tower_instance)
		elif !is_placable_in_map and _towers_placed_in_map_for_multiple_listen.has(arg_tower_instance):
			_towers_placed_in_map_for_multiple_listen.erase(arg_tower_instance)
	
	if _if_tower_arr_matches_tower_id_arr(_towers_placed_in_map_for_multiple_listen, arg_expected_tower_ids):
		game_elements.tower_manager.disconnect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_drag__multiple_needed")
		game_elements.tower_manager.disconnect("tower_added", self, "_on_tower_must_be_placed_in_map")
		arg_func_source.call(arg_func_name, _towers_placed_in_map_for_multiple_listen.duplicate())
		_towers_placed_in_map_for_multiple_listen.clear()


func _if_tower_arr_matches_tower_id_arr(arg_tower_arr : Array, arg_tower_id_arr : Array):
	if arg_tower_arr.size() == arg_tower_id_arr.size():
		var copy_tower_arr = arg_tower_arr.duplicate()
		var copy_tower_id_arr = arg_tower_id_arr.duplicate()
		
		for tower_inst in copy_tower_arr:
			var tower_id = tower_inst.tower_id
			if copy_tower_id_arr.has(tower_id):
				copy_tower_arr.erase(tower_inst)
				copy_tower_id_arr.erase(tower_id)
			else:
				return false
		
		return true
	
	return false

# expects a method that accepts sellback gold (int) and tower id
func listen_for_tower_sold(arg_expected_id, arg_func_source, arg_func_name):
	game_elements.tower_manager.connect("tower_being_sold", self, "_on_tower_being_sold", [arg_expected_id, arg_func_source, arg_func_name])

func _on_tower_being_sold(arg_sellback_gold, arg_tower_sold, arg_expected_id, arg_func_source, arg_func_name):
	if arg_expected_id == -1 or arg_tower_sold.tower_id == arg_expected_id:
		game_elements.tower_manager.disconnect("tower_being_sold", self, "_on_tower_being_sold")
		arg_func_source.call(arg_func_name, arg_sellback_gold, arg_expected_id)


# expects a method that accepts sellback gold (int) and tower id
func listen_for_any_tower_sold(arg_func_source, arg_func_name):
	game_elements.tower_manager.connect("tower_being_sold", self, "_on_any_tower_being_sold", [arg_func_source, arg_func_name])

func _on_any_tower_being_sold(arg_sellback_gold, arg_tower_sold, arg_func_source, arg_func_name):
	game_elements.tower_manager.disconnect("tower_being_sold", self, "_on_any_tower_being_sold")
	arg_func_source.call(arg_func_name, arg_sellback_gold, arg_tower_sold)


# expects method that accepts no args
func listen_for_round_start__then_listen_for_round_end__call_func_for_both(arg_func_source, arg_func_name_for_start, arg_func_name_for_end):
	game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [arg_func_source, arg_func_name_for_start], CONNECT_ONESHOT)
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [arg_func_source, arg_func_name_for_end], CONNECT_ONESHOT)


func _on_round_start(arg_stageround, arg_func_source, arg_func_name_to_call):
	if arg_func_source.has_method(arg_func_name_to_call):
		arg_func_source.call(arg_func_name_to_call)

func _on_round_end(arg_stageround, arg_func_source, arg_func_name_to_call):
	if arg_func_source.has_method(arg_func_name_to_call):
		arg_func_source.call(arg_func_name_to_call)




# expects method that accepts string arg (stage round id)
func listen_for_round_end_into_stage_round_id_and_call_func(arg_expected_stageround_id : String, arg_func_source, arg_func_name):
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end__into_stageround_listen", [arg_expected_stageround_id, arg_func_source, arg_func_name])

func _on_round_end__into_stageround_listen(arg_stageround, arg_expected_stageround_id, arg_func_source, arg_func_name_to_call):
	if arg_stageround.id == arg_expected_stageround_id:
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end__into_stageround_listen")
		arg_func_source.call(arg_func_name_to_call, arg_expected_stageround_id)


# expects a method that accepts tower ids (array)
func listen_for_shop_refresh(arg_func_source, arg_func_name):
	game_elements.shop_manager.connect("shop_rolled_with_towers", self, "_on_shop_rolled_with_towers", [arg_func_source, arg_func_name])

func _on_shop_rolled_with_towers(arg_tower_ids, arg_func_source, arg_func_name):
	game_elements.shop_manager.disconnect("shop_rolled_with_towers", self, "_on_shop_rolled_with_towers")
	arg_func_source.call(arg_func_name, arg_tower_ids)


# expects a method that accepts player level
func listen_for_player_level_up(arg_expected_level : int, arg_func_source, arg_func_name):
	game_elements.level_manager.connect("on_current_level_changed", self, "_on_player_curr_level_changed", [arg_expected_level, arg_func_source, arg_func_name])

func _on_player_curr_level_changed(arg_level, arg_expected_lvl, arg_func_source, arg_func_name):
	if arg_expected_lvl == -1 or arg_level == arg_expected_lvl:
		game_elements.level_manager.disconnect("on_current_level_changed", self, "_on_player_curr_level_changed")
		arg_func_source.call(arg_func_name, arg_level)


# get values related

func get_tower_tier_odds_at_player_level(arg_tower_tier, arg_player):
	return game_elements.shop_manager.get_tower_tier_odds_at_player_level(arg_tower_tier, arg_player)


# Get nodes related     (misread this at least once......)

func get_tower_buy_card_at_buy_slot_index(arg_index):
	var buy_slot = game_elements.panel_buy_sell_level_roll.all_buy_slots[arg_index]
	return buy_slot.get_current_tower_buy_card()


func get_round_speed_button_01():
	return game_elements.round_status_panel.round_speed_and_start_panel.speed_button_01

func get_round_status_button():
	return game_elements.round_status_panel.round_speed_and_start_panel.start_button

func get_round_start_and_speed_panel():
	return game_elements.round_status_panel.round_speed_and_start_panel


func get_extra_info_button_from_tower_info_panel(): # the little "i" button that displays the tower's description
	return game_elements.tower_info_panel.tower_name_and_pic_panel.extra_info_button

func get_tower_stats_panel_from_tower_info_panel():
	return game_elements.tower_info_panel.tower_stats_panel

func get_level_up_button_from_shop_panel():
	return game_elements.panel_buy_sell_level_roll.level_up_panel

func get_reroll_button_from_shop_panel():
	return game_elements.panel_buy_sell_level_roll.reroll_panel

func get_shop_odds_panel():
	return game_elements.general_stats_panel.shop_percentage_stat_panel

func get_single_syn_displayer_with_synergy_name__from_left_panel(arg_syn_name):
	return game_elements.left_panel.get_single_syn_displayer_with_synergy_name(arg_syn_name)

func get_color_wheel_on_bottom_panel_side():
	#return game_elements.color_wheel_sprite_button
	return game_elements.color_wheel_gui

func get_tower_icon_with_tower_id__on_combination_top_panel(arg_id):
	return game_elements.combination_top_panel.get_tower_icon_with_tower_id(arg_id)

func get_more_combination_info__on_combi_top_panel():
	return game_elements.combination_top_panel.combination_more_details_button

func get_player_level_panel():
	return game_elements.general_stats_panel.level_label

func get_streak_panel():
	return game_elements.general_stats_panel.streak_panel

func get_gold_panel():
	return game_elements.general_stats_panel.gold_amount_label

func get_round_indicator_panel():
	return game_elements.right_side_panel.round_status_panel.round_info_panel_v2.round_indicator_panel

func get_rounds_count_panel():
	return game_elements.right_side_panel.round_status_panel.round_info_panel_v2.round_indicator_panel.rounds_count_container

func get_round_first_enemy_damage_container_panel():
	return game_elements.right_side_panel.round_status_panel.round_info_panel_v2.round_indicator_panel.first_enemy_damage_container


func get_player_health_bar_panel():
	return game_elements.right_side_panel.round_status_panel.round_info_panel_v2.player_health_panel


func get_ability_button_with_ability(arg_ability):
	return game_elements.right_side_panel.round_status_panel.ability_panel.get_ability_button_with_ability(arg_ability)


func get_towers_with_id(arg_id):
	var bucket = []
	for tower in game_elements.tower_manager.get_all_towers_except_in_queue_free():
		if tower.tower_id == arg_id:
			bucket.append(tower)
	
	return bucket


# INDICATORS

# returns the two arrows (or one, as specified). Returns [horizontal, vertical]
func display_white_arrows_pointed_at_node(arg_node, arg_display_for_horizontal = true, arg_display_for_vertical = true) -> Array:
	var bucket = []
	if arg_display_for_horizontal:
		var arrow = _construct_tutorial_white_arrow(arg_node, false)
		bucket.append(arrow)
	
	if arg_display_for_vertical:
		var arrow = _construct_tutorial_white_arrow(arg_node, true)
		bucket.append(arrow)
	
	return bucket

func _construct_tutorial_white_arrow(arg_node, arg_is_vertical : bool):
	var arrow = Tutorial_WhiteArrow_Particle_Scene.instance()
	arrow.node_to_point_at = arg_node
	arrow.is_vertical = arg_is_vertical
	
	#game_elements.get_tree().get_root().add_child(arrow)
	CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(arrow)
	
	_nodes_to_queue_free_on_dia_seg_advance.append(arrow)
	
	return arrow


func display_white_circle_at_node(arg_node):
	var circle = Tutorial_WhiteCircle_Particle_Scene.instance()
	circle.node_to_point_at = arg_node
	
	#game_elements.get_tree().get_root().add_child(circle)
	CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(circle)
	
	_nodes_to_queue_free_on_dia_seg_advance.append(circle)
	
	return circle


######### BITWISE STUFFS

static func flag_is_enabled(b : int, flag : int):
	return b & flag != 0

static func set_flag(b : int, flag : int):
	b = b|flag
	return b

static func unset_flag(b : int, flag : int):
	b = b & ~flag
	return b


func set_stats_tidbit_val_of_id_to_enabled(arg_tidbit_id):
	StatsManager.set_val_of_tidbit_val_map(arg_tidbit_id, 1)


##### audio related


####################


# EXPECTS a method that recieves 1 param (enemy)
func listen_for_enemy_tree_exiting(arg_enemy, arg_func_source, arg_func_name):
	arg_enemy.connect("tree_exiting", self, "_on_enemy_listen_for_tree_exiting", [arg_enemy, arg_func_source, arg_func_name])
	

func _on_enemy_listen_for_tree_exiting(arg_enemy, arg_func_source, arg_func_name):
	arg_enemy.disconnect("tree_exiting", self, "_on_enemy_listen_for_tree_exiting")
	
	arg_func_source.call(arg_func_name, arg_enemy)
	


# EXPECTS a method that receives 0 param ()
# Called after game result window is closed, and not when game result is decided.
func listen_for_game_result_window_close(arg_func_source, arg_func_name_on_win, arg_func_name_on_lose):
	game_elements.game_result_manager.connect("game_result_panel_closed", self, "_on_game_result_panel_closed", [arg_func_source, arg_func_name_on_win, arg_func_name_on_lose])
	

func _on_game_result_panel_closed(arg_func_source, arg_func_name_on_win, arg_func_name_on_lose):
	game_elements.game_result_manager.disconnect("game_result_panel_closed", self, "_on_game_result_panel_closed")
	
	if game_elements.game_result_manager.game_result == game_elements.game_result_manager.GameResult.VICTORY:
		arg_func_source.call(arg_func_name_on_win)
	elif game_elements.game_result_manager.game_result == game_elements.game_result_manager.GameResult.DEFEAT:
		arg_func_source.call(arg_func_name_on_lose)
	

# EXPECTS a method that recieves 0 param ()
func listen_for_synergies_updated(arg_func_source, arg_func_name):
	game_elements.synergy_manager.connect("synergies_updated", self, "_on_listen_synergies_updated", [arg_func_source, arg_func_name], CONNECT_DEFERRED)

func _on_listen_synergies_updated(arg_func_source, arg_func_name):
	game_elements.synergy_manager.disconnect("synergies_updated", self, "_on_listen_synergies_updated")
	
	arg_func_source.call(arg_func_name)
	


# EXPECTS a method that recieves 0 param ()
func listen_for_left_side_panel_synergies_updated(arg_func_source, arg_func_name):
	game_elements.left_panel.connect("display_updated", self, "_on_listen_left_side_panel_synergy_display_updated", [arg_func_source, arg_func_name], CONNECT_DEFERRED)

func _on_listen_left_side_panel_synergy_display_updated(arg_func_source, arg_func_name):
	game_elements.left_panel.disconnect("display_updated", self, "_on_listen_left_side_panel_synergy_display_updated")
	
	arg_func_source.call(arg_func_name)
	

###

func _record_tutorial_world_ids_to_be_available_in_map_selection_panel():
	for id in _tutorial_world_ids_to_make_available_when_completed:
		#StatsManager.unlock_map_id(id)
		pass
		#todo


############

func _on_tower_being_dragged(arg_tower):
	if is_instance_valid(dialog_whole_screen_panel):
		dialog_whole_screen_panel.start_mod_a_change__to_near_invis()
	

func _on_tower_dropped_from_dragged(arg_tower):
	if is_instance_valid(dialog_whole_screen_panel):
		dialog_whole_screen_panel.start_mod_a_change__to_visible()
	


