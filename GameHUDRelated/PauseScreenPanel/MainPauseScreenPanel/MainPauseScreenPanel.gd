extends MarginContainer


const background_color : Color = Color(0, 0, 0, 0.8)


var current_showing_control : Control

onready var content_panel = $VBoxContainer/BodyContainer/ContentPanel

#

func _ready():
	visible = false


func show_control_at_content_panel(control : Control):
	if is_instance_valid(current_showing_control):
		hide_control_at_content_panel(current_showing_control, false)
	
	#
	if !content_panel.get_children().has(control):
		content_panel.add_child(control)
	
	current_showing_control = control
	control.visible = true
	visible = true
	

func hide_control_at_content_panel(control : Control, update_vis : bool = true):
	control.visible = false
	current_showing_control = null
	
	visible = false


func has_control_at_content_panel(control : Control) -> bool:
	return content_panel.get_children().has(control)

func has_control_with_script_at_content_panel(script : Reference) -> bool:
	for child in content_panel.get_children():
		if child.get_script() == script:
			return true
	
	return false

func get_control_with_script_at_content_panel(script : Reference) -> Control:
	for child in content_panel.get_children():
		if child.get_script() == script:
			return child
	
	return null

#





func _on_BackButton_on_button_released_with_button_left():
	if current_showing_control.has_method("_on_exit_panel") and current_showing_control.has_method("_is_a_dialog_visible__for_main"):
		if !current_showing_control._is_a_dialog_visible__for_main():
			current_showing_control._on_exit_panel()
