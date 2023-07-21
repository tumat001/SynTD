extends MarginContainer


signal value_changed(arg_val)

onready var label = $MarginContainer/VBoxContainer/Label
onready var h_slider = $MarginContainer/VBoxContainer/HBoxContainer/HSlider
onready var text_edit = $MarginContainer/VBoxContainer/HBoxContainer/TextEditStandard

#######

func set_label_text(arg_text):
	label.text = arg_text


func set_value(arg_val : int):
	h_slider.value = arg_val
	
	text_edit.set_value("%s" % arg_val)

func get_value():
	return h_slider.value

#


func _on_HSlider_value_changed(value):
	text_edit.set_value("%s" % value)
	
	emit_signal("value_changed", value)

#


