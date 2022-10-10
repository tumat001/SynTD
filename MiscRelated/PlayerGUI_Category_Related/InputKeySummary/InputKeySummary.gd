extends MarginContainer

const KeyChar_BodyTexture_Highlighted = preload("res://MiscRelated/PlayerGUI_Category_Related/InputKeySummary/Assets/InputKeySummary_BodyFill_ForInputKey_Highlighted.png")
const KeyChar_BodyTexture_Normal = preload("res://MiscRelated/PlayerGUI_Category_Related/InputKeySummary/Assets/InputKeySummary_BodyFill_ForInputKey.png")
const KeyTitle_BodyTexture_Highlighted = preload("res://MiscRelated/PlayerGUI_Category_Related/InputKeySummary/Assets/InputKeySummary_BodyFill_ForTitle_Highlighted.png")
const KeyTitle_BodyTexture_Normal = preload("res://MiscRelated/PlayerGUI_Category_Related/InputKeySummary/Assets/InputKeySummary_BodyFill_ForTitle.png")

const InputKeyDialog = preload("res://MiscRelated/PlayerGUI_Category_Related/InputKeyDialog/InputKeyDialog.gd")
const InputKeyDialog_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/InputKeyDialog/InputKeyDialog.tscn")

signal on_input_dialog_shown(arg_dialog)
signal on_input_dialog_removed(arg_dialog)

signal on_button_released_with_button_left()
signal on_button_tooltip_requested()


var can_prompt_change_input_event_key_mapping : bool = false

# Used to coordinate with Pause Manager. 
var node_to_parent_for_input_key_dialog : Node
var node_to_parent__show_control_func_name : String
var node_to_parent__remove_control_func_name : String

var input_dialog : InputKeyDialog
var input_key_action_name : String setget set_action_name

onready var advanced_button_with_tooltip = $AdvancedButtonWithTooltip

onready var key_name_label = $HBoxContainer/KeyNameContainer/ContentContainer/KeyNameLabel
onready var key_name_body_background_texture_rect = $HBoxContainer/KeyNameContainer/BodyBackground

onready var key_char_label = $HBoxContainer/KeyCharContainer/ContentContainer/KeyCharLabel
onready var key_char_body_background_texture_rect = $HBoxContainer/KeyCharContainer/BodyBackground

# used by Pause manager to determine when to remove or hide
var REMOVE_WHEN_ESCAPED_BY_PAUSE_MANAGER : bool = true


func _ready():
	advanced_button_with_tooltip.connect("released_mouse_event", self, "_on_advanced_button_released_mouse_event", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("about_tooltip_construction_requested", self, "_on_advanced_button_tooltip_requested", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_entered", self, "_on_advanced_button_mouse_entered", [], CONNECT_PERSIST)
	advanced_button_with_tooltip.connect("mouse_exited", self, "_on_advanced_button_mouse_exited", [], CONNECT_PERSIST)
	
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST)


func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	if arg_event.button_index == BUTTON_LEFT:
		emit_signal("on_button_released_with_button_left")
		
		if can_prompt_change_input_event_key_mapping:
			_on_prompt_change_input_event_key_mapping()

func _on_advanced_button_tooltip_requested():
	emit_signal("on_button_tooltip_requested")

#

func _on_advanced_button_mouse_entered():
	key_name_body_background_texture_rect.texture = KeyTitle_BodyTexture_Highlighted
	key_char_body_background_texture_rect.texture = KeyChar_BodyTexture_Highlighted

func _on_advanced_button_mouse_exited():
	key_name_body_background_texture_rect.texture = KeyTitle_BodyTexture_Normal
	key_char_body_background_texture_rect.texture = KeyChar_BodyTexture_Normal

func _on_visibility_changed():
	_on_advanced_button_mouse_exited()
	
	# update
	set_action_name(input_key_action_name)



#

func give_requested_tooltip(arg_about_tooltip):
	advanced_button_with_tooltip.display_requested_about_tooltip(arg_about_tooltip)


func set_key_name_text(arg_text : String):
	key_name_label.text = arg_text


func set_action_name(arg_action_name : String):
	input_key_action_name = arg_action_name
	var input_events = InputMap.get_action_list(arg_action_name)
	
	
	var key_char : String = ""
	if input_events.size() > 0:
		key_char = input_events[0].as_text()
		
	
	key_char_label.text = key_char

func refresh():
	set_action_name(input_key_action_name)

#####

func _on_prompt_change_input_event_key_mapping():
	input_dialog = InputKeyDialog_Scene.instance()
	input_dialog.connect("on_ok_pressed", self, "_on_input_dialog_ok_pressed", [], CONNECT_ONESHOT)
	input_dialog.connect("on_cancel_pressed", self, "_on_input_dialog_cancel_pressed", [], CONNECT_ONESHOT)
	
	node_to_parent_for_input_key_dialog.call(node_to_parent__show_control_func_name, input_dialog)
	input_dialog.start_capture_input()
	
	emit_signal("on_input_dialog_shown", input_dialog)

func _on_input_dialog_ok_pressed():
	InputMap.action_erase_events(input_key_action_name)
	InputMap.action_add_event(input_key_action_name, input_dialog.captured_event)
	
	node_to_parent_for_input_key_dialog.call(node_to_parent__remove_control_func_name, input_dialog)
	
	set_action_name(input_key_action_name)
	
	# SAVE CHANGES
	GameSaveManager.save_game_controls__input_map()
	#
	
	emit_signal("on_input_dialog_removed", input_dialog)

func _if_chosen_key_collides_with_other_controls():
	var actions = InputMap.get_actions()


#

func _on_input_dialog_cancel_pressed():
	remove_input_key_dialog()

func remove_input_key_dialog():
	if is_instance_valid(input_dialog) and !input_dialog.is_queued_for_deletion():
		node_to_parent_for_input_key_dialog.call(node_to_parent__remove_control_func_name, input_dialog)



