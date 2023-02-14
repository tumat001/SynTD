extends Control



func add_dialog_element_to_container(arg_background_element):
	if is_instance_valid(arg_background_element):
		add_child(arg_background_element)

func remove_dialog_element_to_container(arg_background_element):
	pass
	


func is_block_advance():
	return !_is_fully_displayed()

func _is_fully_displayed():
	for child in get_children():
		if !child._is_fully_displayed():
			return false
	
	return true



func resolve_block_advance():
	_force_finish_display()

func _force_finish_display():
	for child in get_children():
		if !child._is_fully_displayed():
			child._force_finish_display()

