extends MarginContainer


func update_visibility_based_on_children():
	if get_child_count() == 0:
		visible = false
		return
	
	for child in get_children():
		if child.visible == true:
			visible = true
			return
	
	visible = false
