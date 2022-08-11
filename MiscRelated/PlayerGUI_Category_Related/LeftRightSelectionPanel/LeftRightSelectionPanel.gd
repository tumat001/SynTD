extends MarginContainer


signal on_current_index_changed(arg_index)


onready var choice_label = $HBoxContainer/MiddleContainer/ContainerPanel/ChoiceLabel

var _id_to_name_map : Dictionary = {}
var current_index : int = 0 setget set_current_index


func set_or_add_entry(arg_id : int, arg_name : String):
	_id_to_name_map[arg_id] = arg_name

func set_or_add_entries(arg_id_to_name_map : Dictionary):
	for id in arg_id_to_name_map:
		_id_to_name_map[id] = arg_id_to_name_map[id]

func clear_entries():
	_id_to_name_map.clear()
	set_current_index(0)


func set_current_index(arg_index : int, arg_emit_signal : bool = true):
	current_index = arg_index
	if !is_current_index_valid():
		current_index = 0
	
	_update_display_based_on_current_index()
	
	if arg_emit_signal:
		emit_signal("on_current_index_changed", current_index)

func set_current_index_based_on_id(arg_id, arg_emit_signal : bool = true):
	var index = _id_to_name_map.keys().find(arg_id)
	set_current_index(index, arg_emit_signal)

#

func _update_display_based_on_current_index():
	if !is_current_index_valid():
		choice_label.text = ""
	else:
		var id_at_index = get_id_at_current_index()
		choice_label.text = _id_to_name_map[id_at_index]
		

#

func is_current_index_valid() -> bool:
	return is_index_valid(current_index)

func is_index_valid(arg_index) -> bool:
	return _id_to_name_map.size() - 1 >= arg_index


func get_id_at_current_index() -> int:
	return _id_to_name_map.keys()[current_index]

#


func _on_LeftButton_button_up():
	_on_toggle_left_button_pressed()


func _on_RightButton_button_up():
	_on_toggle_right_button_pressed()



func _on_toggle_left_button_pressed():
	var index_to_be = current_index - 1
	if !is_index_valid(index_to_be):
		index_to_be = _id_to_name_map.size() - 1
	
	set_current_index(index_to_be)

func _on_toggle_right_button_pressed():
	var index_to_be = current_index + 1
	if !is_index_valid(index_to_be):
		index_to_be = 0
	
	set_current_index(index_to_be)

