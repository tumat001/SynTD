extends MarginContainer


signal value_changed(arg_val)


#onready var line_edit = $MarginContainer/LineEdit

onready var label = $MarginContainer/Label

export(bool) var only_allow_int_inputs : bool = false
#export(bool) var allow_edits : bool = true setget set_allow_edits

########

func set_value(arg_val : String):
	if only_allow_int_inputs:
		if !arg_val.is_valid_integer():
			return
	
	if is_inside_tree():
		#line_edit.text = arg_val
		label.text = arg_val
		emit_signal("value_changed", arg_val)

func get_value():
	#return line_edit.text
	return label.text


#

#func set_allow_edits(arg_val):
#	allow_edits = arg_val
#
#	if is_inside_tree():
#		line_edit.editable = allow_edits

#####

func _ready():
	#set_allow_edits(allow_edits)
	pass
