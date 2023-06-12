extends "res://MiscRelated/DialogRelated/Controls/DialogElementControls/BaseDialogElementControl.gd"


const PlayerGUI_ButtonStandard = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/PlayerGUI_ButtonStandard.gd")
const PlayerGUI_ButtonStandard_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/PlayerGUI_ButtonStandard.tscn")
const PlayerGUI_ButtonToggleStandard = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/PlayerGUI_ButtonToggleStandard.gd")
const PlayerGUI_ButtonToggleStandard_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/PlayerGUI_ButtonToggleStandard.tscn")
const PlayerGUI_ButtonGroup = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/ButtonGroup.gd")

const DialogChoicesModiPanel = preload("res://MiscRelated/DialogRelated/Controls/DialogElementControls/DialogChoicesModiPanel/DialogChoicesModiPanel.gd")



signal choice_buttons_changed()

#

const time_to_reach_mod_a : float = 0.25
var _is_making_button_mod_a_changes : bool = false

var _current_button_for_mod_a_changes


class ChoiceButtonChanges:
	
	const QUEUE_STAT__ADD : int = 0
	const QUEUE_STAT__REMOVE : int = 1
	
	#
	
	var change_type : int
	var index : int
	
	var choice_button_info
	

var _queue_of_choice_button_info_changes : Array = []  # is in this format: [[arg_info, ]]
var _queue_of_buttons : Array = []
var _current_choice_button_info_changes : ChoiceButtonChanges

#

var grid_columns_count : int = 1


var func_source_for__properties
var func_name_for__is_display_dialog_choices_modi
var func_name_for__modi_panel_config

var _already_initialized_choices_modi_panel : bool = false

var player_gui__button_group : PlayerGUI_ButtonGroup

#

class ChoiceButtonInfo:
	
	signal is_disabled_changed(arg_val)
	
	var id : int
	var display_text : String
	var texture : Texture
	
	enum ChoiceType {
		STANDARD = 0
	}
	var choice_type : int = ChoiceType.STANDARD
	
	var is_button_enabled : bool = true setget set_is_button_enabled
	
	#
	var display_default_blue_background : bool = false
	var is_toggle_button : bool = true
	
	# func should expect (id, choice_button_info, choice_panel / self)
	var func_source_on_click
	var func_name_on_click
	
	
	#
	
	enum ChoiceResultType {
		NONE = 0,
		CORRECT = 1,
		WRONG = 2,
	}
	var choice_result_type : int
	
	#
	
	var associated_button
	
	#
	
	func set_is_button_enabled(arg_val):
		is_button_enabled = arg_val
		
		emit_signal("is_disabled_changed")

var _all_choice_button_info : Array

#

var val_transition_for_button_mod_a : ValTransition

#

onready var grid_container = $VBoxContainer/GridContainer
onready var dialog_choice_modi_panel = $VBoxContainer/DialogChoicesModiPanel
onready var confirm_button = $VBoxContainer/ConfirmButton

#

func _init():
	val_transition_for_button_mod_a = ValTransition.new()
	
	player_gui__button_group = PlayerGUI_ButtonGroup.new()
	player_gui__button_group.connect("toggled_on_button_changed", self, "_on_toggled_on_button_changed")
	

func _on_toggled_on_button_changed(arg_button):
	if is_inside_tree():
		if arg_button != null:
			confirm_button.set_is_button_enabled(true)
			
		else:
			confirm_button.set_is_button_enabled(false)


func _ready():
	grid_container.columns = grid_columns_count
	
	dialog_choice_modi_panel.connect("remove_false_answer_requested", self, "_on_dialog_choice_modi_panel_remove_false_answer_requested")
	
	#
	
	_construct_and_configure_buttons_based_on_properties__on_start()

func _construct_and_configure_buttons_based_on_properties__on_start():
	for button_info in _all_choice_button_info:
		if button_info.choice_type == ChoiceButtonInfo.ChoiceType.STANDARD:
			_construct_and_add_button_choice_type_standard(button_info, 1, -1, false)
			
	
	confirm_button.set_is_button_enabled(false)
	_initialize_choices_modi_panel()

func _construct_and_add_button_choice_type_standard(arg_choice_button_info : ChoiceButtonInfo, arg_modulate_a : float, arg_index : int, arg_should_always_be_disabled : bool):
	var button
	if !arg_choice_button_info.is_toggle_button:
		button = PlayerGUI_ButtonStandard_Scene.instance()
		button.connect("on_button_released_with_button_left", self, "_on_button_standard_released_with_button_left", [arg_choice_button_info], CONNECT_DEFERRED)
		
	else:
		button = PlayerGUI_ButtonToggleStandard_Scene.instance()
		button.configure_self_with_button_group(player_gui__button_group)
		_set_confirm_button_as_visible()
		button.can_be_untoggled_if_is_toggled = false
	
	button.set_modulate_a_for_body_background(0.3)
	
	#button.use_texture_defaults = false
	
	if arg_choice_button_info.display_default_blue_background:
		
		button.background_texture_normal = PlayerGUI_ButtonStandard.Background_NormalTexture
		button.background_texture_highlighted = PlayerGUI_ButtonStandard.Background_HighlightedTexture
	else:
		
		button.background_texture_normal = null
		button.background_texture_highlighted = null
		
		#button.set_body_background_normal_texture(null)
		#button.set_body_background_highlighted_texture(null)
		
	
	button.text_for_label = arg_choice_button_info.display_text
	button.button_icon = arg_choice_button_info.texture
	
	if arg_should_always_be_disabled:
		button.is_button_enabled = false
	else:
		button.is_button_enabled = arg_choice_button_info.is_button_enabled
	
	arg_choice_button_info.associated_button = button
	
	arg_choice_button_info.connect("is_disabled_changed", self, "_on_arg_choice_button_info_is_disabled_changed", [button, arg_choice_button_info])
	
	button.modulate.a = arg_modulate_a
	
	grid_container.add_child(button)
	if arg_index != -1:
		grid_container.move_child(button, arg_index)
	
	return button

func _on_arg_choice_button_info_is_disabled_changed(arg_val, arg_button, arg_info : ChoiceButtonInfo):
	arg_button.is_button_enabled = arg_val


#

func add_choice_button_info(arg_info : ChoiceButtonInfo):
	_all_choice_button_info.append(arg_info)
	
	if is_inside_tree():
		var button_changes := ChoiceButtonChanges.new()
		button_changes.change_type = ChoiceButtonChanges.QUEUE_STAT__ADD
		button_changes.index = _all_choice_button_info.size() - 1
		button_changes.choice_button_info = arg_info
		
		_add_to_queue_of_choice_button_changes(button_changes)
	
	
	emit_signal("choice_buttons_changed")

func replace_choice_button_info_at_index(arg_index, arg_replacement_info : ChoiceButtonInfo):
	var info = _all_choice_button_info[arg_index]
	
	_all_choice_button_info.remove(arg_index)
	_all_choice_button_info.insert(arg_index, arg_replacement_info)
	
	if is_inside_tree():
		var button_changes_rem := ChoiceButtonChanges.new()
		button_changes_rem.change_type = ChoiceButtonChanges.QUEUE_STAT__REMOVE
		button_changes_rem.index = arg_index
		button_changes_rem.choice_button_info = info
		_add_to_queue_of_choice_button_changes(button_changes_rem)
		
		
		var button_changes := ChoiceButtonChanges.new()
		button_changes.change_type = ChoiceButtonChanges.QUEUE_STAT__ADD
		button_changes.index = arg_index
		button_changes.choice_button_info = arg_replacement_info
		_add_to_queue_of_choice_button_changes(button_changes)
		
		
	
	emit_signal("choice_buttons_changed")

func remove_choice_button_info(arg_index):
	var info = _all_choice_button_info[arg_index]
	_all_choice_button_info.remove(arg_index)
	
	if is_inside_tree():
		var button_changes_rem := ChoiceButtonChanges.new()
		button_changes_rem.change_type = ChoiceButtonChanges.QUEUE_STAT__REMOVE
		button_changes_rem.index = arg_index
		button_changes_rem.choice_button_info = info
		_add_to_queue_of_choice_button_changes(button_changes_rem)
		
		_update_confirm_button_vis_based_on_choices_button()
	
	emit_signal("choice_buttons_changed")


func _set_confirm_button_as_visible():
	confirm_button.visible = true

func _update_confirm_button_vis_based_on_choices_button():
	for info in _all_choice_button_info:
		if info.is_toggle_button:
			confirm_button.visible = true
			return
	
	confirm_button.visible = false



#func immediate_remove_choice_button_info(arg_index):
#	pass

#

func _add_to_queue_of_choice_button_changes(arg_changes : ChoiceButtonChanges):
	_queue_of_choice_button_info_changes.append(arg_changes)
	
	var latest : ChoiceButtonChanges = _queue_of_choice_button_info_changes.front()
	var button = _construct_and_add_button_choice_type_standard(latest.choice_button_info, 0, latest.index, true)
	_queue_of_buttons.append(button)
	
	if _current_choice_button_info_changes == null:
		_process_next_choice_button_changes_in_queue(false)
		

func _process_next_choice_button_changes_in_queue(arg_instant_show : bool):
	if _queue_of_choice_button_info_changes.size() != 0:
		is_fully_finished_conditional_clauses.attempt_insert_clause(IsFullyFinishedClauseIds.CHOICES_PANEL__CHOICES_SHOWING)
		
		var latest : ChoiceButtonChanges = _queue_of_choice_button_info_changes.pop_front()
		
		if latest.change_type == latest.QUEUE_STAT__ADD:
			#var button = _construct_and_add_button_choice_type_standard(latest.choice_button_info, 0, latest.index, true)
			var button = _queue_of_buttons.pop_front()
			_start_fade_in_of_button__make_initial_mod_a_zero(button, arg_instant_show, latest.choice_button_info)
		elif latest.change_type == latest.QUEUE_STAT__REMOVE:
			_start_fade_out_of_button(latest.choice_button_info.associated_button, arg_instant_show, latest.choice_button_info)
	else:
		
		_initialize_choices_modi_panel()


func _initialize_choices_modi_panel():
	if !_already_initialized_choices_modi_panel:
		is_fully_finished_conditional_clauses.remove_clause(IsFullyFinishedClauseIds.CHOICES_PANEL__CHOICES_SHOWING)
		
		if func_source_for__properties.call(func_name_for__is_display_dialog_choices_modi):
			dialog_choice_modi_panel.modi_panel_config = func_source_for__properties.call(func_name_for__modi_panel_config)
			
			dialog_choice_modi_panel._initialize()
			dialog_choice_modi_panel.visible = true
		else:
			dialog_choice_modi_panel.visible = false

#

func _start_fade_out_of_button(arg_button, arg_instant_show : bool, arg_button_info):
	_current_button_for_mod_a_changes = arg_button
	arg_button.is_button_enabled = false
	
	var final_time = time_to_reach_mod_a
	if arg_instant_show:
		final_time = 0
	
	var reached_a = val_transition_for_mod_a.configure_self(arg_button.modulate.a, arg_button.modulate.a, 0, final_time, ValTransition.VALUE_UNSET, ValTransition.ValueIncrementMode.LINEAR)
	if !reached_a:
		val_transition_for_mod_a.connect("target_val_reached", self, "_on_target_val_reached__button_mod_a", [arg_button, arg_button_info, arg_instant_show], CONNECT_ONESHOT)
		_is_making_button_mod_a_changes = true
	else:
		#call(arg_func_name_to_call)
		_process_next_choice_button_changes_in_queue(arg_instant_show)

func _on_target_val_reached__button_mod_a(arg_button, arg_button_info, arg_instant_show):
	_is_making_button_mod_a_changes = false
	
	if arg_button.modulate.a == 1:
		arg_button.is_button_enabled = arg_button_info.is_button_enabled
	
	_process_next_choice_button_changes_in_queue(arg_instant_show)
	#if has_method(arg_func_name_to_call):
	#	call(arg_func_name_to_call)


func _start_fade_in_of_button__make_initial_mod_a_zero(arg_button, arg_instant_show : bool, arg_button_info):
	_current_button_for_mod_a_changes = arg_button
	_current_button_for_mod_a_changes.modulate.a = 0
	
	var final_time = time_to_reach_mod_a
	if arg_instant_show:
		final_time = 0
	
	var reached_a = val_transition_for_mod_a.configure_self(arg_button.modulate.a, arg_button.modulate.a, 1, final_time, ValTransition.VALUE_UNSET, ValTransition.ValueIncrementMode.LINEAR)
	if !reached_a:
		val_transition_for_mod_a.connect("target_val_reached", self, "_on_target_val_reached__button_mod_a", [arg_button, arg_button_info, arg_instant_show], CONNECT_ONESHOT)
		_is_making_button_mod_a_changes = true
	else:
		#call(arg_func_name_to_call)
		_process_next_choice_button_changes_in_queue(arg_instant_show)

#

func _process(delta):
	if _is_making_button_mod_a_changes:
		val_transition_for_mod_a.delta_pass(delta)
		_current_button_for_mod_a_changes.modulate.a = val_transition_for_button_mod_a.get_current_val()

##

func _on_button_standard_released_with_button_left(arg_choice_button_info : ChoiceButtonInfo):
	if arg_choice_button_info.func_source_on_click != null:
		arg_choice_button_info.func_source_on_click.call(arg_choice_button_info.func_name_on_click, arg_choice_button_info.id, arg_choice_button_info, self)


#########


func _start_display():
	._start_display()
	
	#_construct_and_configure_buttons_based_on_properties__on_start()
	pass

func _force_finish_display():
	._force_finish_display()
	
	_process_next_choice_button_changes_in_queue(true)

##


func _on_dialog_choice_modi_panel_remove_false_answer_requested(arg_count):
	remove_wrong_choices_count(arg_count)

func remove_wrong_choices_count(arg_count : int):
	var all_wrong_choices : Array = []
	for info in _all_choice_button_info:
		if info.choice_result_type == info.ChoiceResultType.WRONG:
			all_wrong_choices.append(info)
	
	if arg_count >= all_wrong_choices.size():
		arg_count = all_wrong_choices.size() - 1
	
	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	for i in arg_count:
		var choice = StoreOfRNG.randomly_select_one_element(all_wrong_choices, rng)
		#remove_choice_button_info(_all_choice_button_info.find(choice))
		var button = choice.associated_button
		button.is_button_enabled = false



####

func _on_ConfirmButton_on_button_released_with_button_left():
	
	var selected_button = player_gui__button_group.get_toggled_on_button()
	
	if is_instance_valid(selected_button):
		for info in _all_choice_button_info:
			if info.associated_button == selected_button:
				
				if info.func_source_on_click != null:
					info.func_source_on_click.call(info.func_name_on_click, info.id, info, self)
				
				return



