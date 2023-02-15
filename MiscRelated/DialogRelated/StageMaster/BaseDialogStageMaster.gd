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


signal current_dialog_segment_changed(arg_seg)

#

const dia_main_panel__pos__standard := Vector2(200, 280)
const dia_main_panel__size__standard := Vector2(500, 100)

const dia_main_panel__pos__plate_middle := Vector2(350, 150)
const dia_main_panel__size__plate_middle := Vector2(250, 200)



const dia_portrait__pos__standard_left := Vector2(150, 150)
const dia_portrait__pos__standard_right := Vector2(600, 150)


const dia_time_duration__very_short : float = 10.0

######

var dialog_whole_screen_panel setget set_dialog_whole_screen_panel

var _current_dialog_segment : DialogSegment

##

var _towers_placed_in_map_for_multiple_listen : Array
var _towers_bought_for_multiple_listen : Array = []

##

func _init(arg_id, arg_breakpoint, arg_name).(arg_id, arg_breakpoint, arg_name):
	pass

#

func create_dialog_whole_screen_panel_and_add_to_GE():
	var panel = DialogWholeScreenPanel_Scene.instance()
	game_elements.add_child_to_below_below_screen_effects_manager(panel)
	
	set_dialog_whole_screen_panel(panel)

func set_dialog_whole_screen_panel(arg_panel):
	dialog_whole_screen_panel = arg_panel
	
	dialog_whole_screen_panel.connect("resolve_block_advanced_requested_status", self, "_on_resolve_block_advanced_requested_status")

func play_dialog_segment_or_advance_or_finish_elements(arg_segment : DialogSegment):
	
	_current_dialog_segment = arg_segment
	dialog_whole_screen_panel.current_dialog_segment = _current_dialog_segment
	
	emit_signal("current_dialog_segment_changed", _current_dialog_segment)


#############

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	
	game_elements.connect("unhandled_input", self, "_game_elements_unhandled_input")
	game_elements.connect("unhandled_key_input", self, "_game_elements_unhandled_key_input")
	game_elements.connect("before_game_start", self, "_on_game_elements_before_game_start__base_class", [], CONNECT_ONESHOT)
	
	create_dialog_whole_screen_panel_and_add_to_GE()

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
		_current_dialog_segment.request_advance()
	

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


#func configure_dia_seg_to_previous_on_player_click_or_enter

func _on_configured_dia_seg_requested_advance_to_next_seg(arg_next_seg : DialogSegment):
	play_dialog_segment_or_advance_or_finish_elements(arg_next_seg)

func _on_configured_dia_seg_to_call_func_on_player_click_or_enter(arg_seg : DialogSegment, arg_func_source, arg_func_name, arg_func_params):
	arg_func_source.call(arg_func_name, arg_seg, arg_func_params)


########## HELPER FUNCS FOR DIALOG ELEMENTS
## 

## DESCRIPTIONS
func _configure_dia_seg_to_default_templated_dialog_with_descs_only(arg_seg : DialogSegment, arg_descs : Array):#, arg_pos : Vector2, arg_size : Vector2):
	var diag_construction_ins := DialogSegment.DialogElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_dialog_for_dia_seg"
	diag_construction_ins.func_params = [arg_seg, arg_descs] #arg_pos, arg_size]
	
	arg_seg.add_dialog_element_construction_ins(diag_construction_ins)

func _construct_default_templated_dialog_for_dia_seg(arg_params : Array):
	var dia_seg : DialogSegment = arg_params[0]
	var descs : Array = arg_params[1]
	
	var panel = DialogDescsPanel_Scene.instance()
	panel.descs = descs
	
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


# pos and sizes

func _configure_dia_set_to_standard_pos_and_size(arg_seg : DialogSegment):
	arg_seg.final_dialog_top_left_pos = dia_main_panel__pos__standard
	arg_seg.final_dialog_custom_size = dia_main_panel__size__standard

func _configure_dia_set_to_plate_middle_pos_and_size(arg_seg : DialogSegment):
	arg_seg.final_dialog_top_left_pos = dia_main_panel__pos__plate_middle
	arg_seg.final_dialog_custom_size = dia_main_panel__size__plate_middle



## BACKGROUND ELEMENT -- TEXTURE IMAGE

func _configure_dia_seg_to_default_templated_background_ele_dia_texture_image(arg_seg : DialogSegment, arg_image, arg_ending_pos, arg_starting_pos = BackDialogImagePanel.VECTOR_UNDEFINED, arg_persistence_id = DialogSegment.BackgroundElementsConstructionIns.NO_PERSISTENCE_ID):
	var diag_construction_ins := DialogSegment.BackgroundElementsConstructionIns.new()
	diag_construction_ins.func_source = self
	diag_construction_ins.func_name_for_construction = "_construct_default_templated_background_ele_dia_texture_image_for_dia_seg"
	diag_construction_ins.func_params = [arg_seg, arg_image, arg_ending_pos, arg_starting_pos]
	diag_construction_ins.persistence_id = arg_persistence_id
	
	arg_seg.add_background_element_construction_ins(diag_construction_ins)

# arg_background_element may be null, depending if an element with the given persistence_id exists
func _construct_default_templated_background_ele_dia_texture_image_for_dia_seg(arg_background_element, arg_params : Array, arg_persistence_id):
	var dia_seg : DialogSegment = arg_params[0]
	var texture : Texture = arg_params[1]
	var ending_pos : Vector2 = arg_params[2]
	var starting_pos : Vector2 = arg_params[3]
	
	if arg_background_element == null:
		arg_background_element = BackDialogImagePanel_Scene.instance()
	
	arg_background_element.persistence_id = arg_persistence_id
	arg_background_element.final_top_left_pos = ending_pos
	arg_background_element.initial_top_left_pos = starting_pos
	
	arg_background_element.texture_to_use = texture
	
	
	return arg_background_element


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

#

func create_tower_at_placable(arg_tower_id, arg_placable):
	var tower = game_elements.tower_inventory_bench.create_tower_and_add_to_scene(arg_tower_id, arg_placable)
	return tower


# expects a method that accepts a tower instance
func listen_for_tower_with_id__bought__then_call_func(arg_tower_id : int, arg_func_name : String, arg_func_source):
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added", [arg_tower_id, arg_func_name, arg_func_source])

func _on_tower_added(arg_tower_instance, arg_expected_tower_id, arg_func_name, arg_func_source):
	if arg_tower_instance.tower_id == arg_expected_tower_id:
		game_elements.tower_manager.disconnect("tower_added", self, "_on_tower_added")
		arg_func_source.call(arg_func_name, arg_tower_instance)



# expects a method that accepts an array (of tower instances)
func listen_for_towers_with_ids__bought__then_call_func(arg_tower_ids : Array, arg_func_name : String, arg_func_source):
	_towers_bought_for_multiple_listen.clear()
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added__multiple_needed", [arg_tower_ids, arg_func_name, arg_func_source])

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


