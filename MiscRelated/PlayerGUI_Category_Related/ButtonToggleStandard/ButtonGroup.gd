extends Reference


# does not need to be the player gui button toggle. Only these things are needed:
# method: "set_is_toggle_mode_on()"
# method: "get_is_toggle_mode_on()"
# signal: "toggle_mode_changed"
# 
# Classes that use this class: PlayerGUI_ButtonToggleStandard, MapCard
var _all_toggle_buttons : Array = []


#

func _add_toggle_button_to_group(arg_button):
	if !_all_toggle_buttons.has(arg_button) and arg_button.current_button_group == null:
		_all_toggle_buttons.append(arg_button)
		
		if !arg_button.is_connected("toggle_mode_changed", self, "_on_button_toggle_mode_changed"):
			arg_button.connect("toggle_mode_changed", self, "_on_button_toggle_mode_changed", [arg_button])
			arg_button.connect("tree_exiting", self, "_on_button_tree_exiting", [arg_button])


func _remove_toggle_button_from_group(arg_button):
	if _all_toggle_buttons.has(arg_button):
		_all_toggle_buttons.erase(arg_button)
		
		if arg_button.is_connected("toggle_mode_changed", self, "_on_button_toggle_mode_changed"):
			arg_button.disconnect("toggle_mode_changed", self, "_on_button_toggle_mode_changed")
			arg_button.disconnect("tree_exiting", self, "_on_button_tree_exiting")

#

func _on_button_toggle_mode_changed(arg_val, arg_button):
	if arg_val:
		for button in _all_toggle_buttons:
			if button != arg_button:
				button.set_is_toggle_mode_on(false)

func _on_button_tree_exiting(arg_button):
	_all_toggle_buttons.erase(arg_button)

#

func get_toggled_on_button():
	for button in _all_toggle_buttons:
		if button.get_is_toggle_mode_on():
			return button
	
	return null
