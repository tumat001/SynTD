extends "res://MiscRelated/PlayerGUI_Category_Related/ButtonStandard/PlayerGUI_ButtonStandard.gd"

const SideBar_Highlighted = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/Assets/PlayerGUI_ButtonToggleStandard_SideBorder_Highlighted.png")


signal toggle_mode_changed(val)


var is_toggle_mode_on : bool = false setget set_is_toggle_mode_on, get_is_toggle_mode_on
var current_button_group


func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	._on_advanced_button_released_mouse_event(arg_event)
	
	set_is_toggle_mode_on(!is_toggle_mode_on)


func set_is_toggle_mode_on(arg_mode):
	is_toggle_mode_on = arg_mode
	
	if is_toggle_mode_on:
		set_border_texture(SideBar_Highlighted)
	else:
		set_border_texture(SideBorder_Normal_Texture)
	
	emit_signal("toggle_mode_changed", is_toggle_mode_on)

func get_is_toggle_mode_on():
	return is_toggle_mode_on

##

func configure_self_with_button_group(arg_group):
	if current_button_group == null or current_button_group != arg_group:
		arg_group._add_toggle_button_to_group(self)
		current_button_group = arg_group # this should be below the add button to group



