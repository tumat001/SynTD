extends MarginContainer


signal on_ok_pressed()
signal on_cancel_pressed()


onready var ok_button = $ContentContainer/VBoxContainer/ButtonContainer/HBoxContainer/OkButton
onready var cancel_button = $ContentContainer/VBoxContainer/ButtonContainer/HBoxContainer/CancelButton

onready var input_label = $ContentContainer/VBoxContainer/InputLabel


var captured_event : InputEventKey

func _ready():
	ok_button.set_text_for_text_label("Ok")
	cancel_button.set_text_for_text_label("Cancel")
	
	_reset_for_another_use()
	
	set_process_input(false)


func start_capture_input():
	_reset_for_another_use()
	
	set_process_input(true)

func captured_input(arg_event):
	ok_button.visible = true
	
	captured_event = arg_event
	input_label.text = captured_event.as_text()


func _reset_for_another_use():
	input_label.text = ""
	ok_button.visible = false
	captured_event = null


#

func _input(event):
	if event is InputEventKey:
		if !event.echo and event.pressed:
			if captured_event == null:
				_captured_input_event_key(event)
			else:
				if event.is_action("ui_cancel"):
					cancel_dialog()
				elif event.is_action("ui_accept"):
					do_ok_dialog()
		
		accept_event()



func _captured_input_event_key(arg_event : InputEventKey):
	captured_input(arg_event)
	



##


func _on_OkButton_on_button_released_with_button_left():
	do_ok_dialog()

func do_ok_dialog():
	emit_signal("on_ok_pressed")


func _on_CancelButton_on_button_released_with_button_left():
	cancel_dialog()

func cancel_dialog():
	emit_signal("on_cancel_pressed")

