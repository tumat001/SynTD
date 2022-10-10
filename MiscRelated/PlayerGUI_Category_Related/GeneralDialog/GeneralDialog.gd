extends MarginContainer

const PlayerGUI_ButtonStandard = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/PlayerGUI_ButtonStandard.gd")
const PlayerGUI_ButtonStandard_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/PlayerGUI_ButtonStandard.tscn")

signal ok_button_released()
signal cancel_button_released()
signal yes_button_released()
signal no_button_released()


enum DialogMode {
	OK_CANCEL = 0,
	OK = 1,
	YES_NO_CANCEL = 2,
}


var _dialog_mode : int = DialogMode.OK_CANCEL

var make_self_invisible_after_selection_made : bool = true
var queue_free_after_selection_made : bool = false

#

var ok_button : PlayerGUI_ButtonStandard
var cancel_button : PlayerGUI_ButtonStandard
var yes_button : PlayerGUI_ButtonStandard
var no_button : PlayerGUI_ButtonStandard

onready var button_container = $ContentContainer/VBoxContainer/MarginContainer/ButtonHBoxContainer

onready var title_label = $ContentContainer/VBoxContainer/TitleLabel
onready var content_label = $ContentContainer/VBoxContainer/ContentLabel

#

func _ready():
	_reset_for_use()
	visible = false
	set_process_unhandled_input(false)


func _reset_for_use():
	if _dialog_mode == DialogMode.OK or _dialog_mode == DialogMode.OK_CANCEL:
		if !is_instance_valid(ok_button):
			ok_button = PlayerGUI_ButtonStandard_Scene.instance()
			ok_button.set_text_for_text_label("Ok")
			ok_button.connect("on_button_released_with_button_left", self, "_on_ok_button_released")
			button_container.add_child(ok_button)
			
		ok_button.visible = true
		
	else:
		if is_instance_valid(ok_button):
			ok_button.visible = false
	
	if _dialog_mode == DialogMode.OK_CANCEL or _dialog_mode == DialogMode.YES_NO_CANCEL:
		if !is_instance_valid(cancel_button):
			cancel_button = PlayerGUI_ButtonStandard_Scene.instance()
			cancel_button.set_text_for_text_label("Cancel")
			cancel_button.connect("on_button_released_with_button_left", self, "_on_cancel_button_released")
			button_container.add_child(cancel_button)
		
		cancel_button.visible = true
	else:
		if is_instance_valid(cancel_button):
			cancel_button.visible = false
	
	if _dialog_mode == DialogMode.YES_NO_CANCEL:
		if !is_instance_valid(yes_button):
			yes_button = PlayerGUI_ButtonStandard_Scene.instance()
			yes_button.set_text_for_text_label("Yes")
			yes_button.connect("on_button_released_with_button_left", self, "_on_yes_button_released")
			button_container.add_child(yes_button)
		
		yes_button.visible = true
		
		
		if !is_instance_valid(no_button):
			no_button = PlayerGUI_ButtonStandard_Scene.instance()
			no_button.set_text_for_text_label("No")
			no_button.connect("on_button_released_with_button_left", self, "_on_no_button_released")
			button_container.add_child(no_button)
		
		no_button.visible = true
		
	else:
		if is_instance_valid(yes_button):
			yes_button.visible = false
		
		if is_instance_valid(no_button):
			no_button.visible = false

#

func start_dialog_prompt(arg_dialog_mode : int):
	_dialog_mode = arg_dialog_mode
	visible = true
	_reset_for_use()
	
	set_process_unhandled_input(true)

#

func _on_ok_button_released():
	emit_signal("ok_button_released")
	_after_selection_is_made()

func _on_cancel_button_released():
	emit_signal("cancel_button_released")
	_after_selection_is_made()

func _on_yes_button_released():
	emit_signal("yes_button_released")
	_after_selection_is_made()

func _on_no_button_released():
	emit_signal("no_button_released")
	_after_selection_is_made()


func _after_selection_is_made():
	if make_self_invisible_after_selection_made:
		visible = false
	
	if queue_free_after_selection_made:
		queue_free()
	
	set_process_unhandled_input(false)

#

func _unhandled_input(event):
	if event is InputEventKey:
		if !event.echo and event.pressed:
			if event.is_action("ui_cancel"):
				cancel_dialog()
		
		accept_event()


func cancel_dialog():
	if _dialog_mode == DialogMode.OK_CANCEL or _dialog_mode == DialogMode.YES_NO_CANCEL:
		_on_cancel_button_released()
	elif _dialog_mode == DialogMode.OK:
		_on_ok_button_released()

#

func set_title_label_text(arg_text : String):
	title_label.text = arg_text
	
	title_label.visible = arg_text.length() != 0
	

func set_content_label_text(arg_text : String):
	content_label.text = arg_text
	
	content_label.visible = arg_text.length() != 0
