extends "res://MiscRelated/DialogRelated/Controls/DialogElementControls/BaseDialogElementControl.gd"


signal line_edit_input_entered(arg_val)

onready var text_input_title = $VBoxContainer/TextInputTitle
onready var line_edit = $VBoxContainer/LineEdit


var input_entered : bool

var text_for_input_title : String

func _ready():
	_set_text_input_title(text_for_input_title)

#

func _set_text_input_title(arg_title):
	text_input_title.text = arg_title

func _on_LineEdit_text_entered(new_text):
	emit_signal("line_edit_input_entered", new_text)

####

func _start_display():
	._start_display()

func _force_finish_display():
	._force_finish_display()

func _is_fully_displayed():
	return ._is_fully_displayed()

