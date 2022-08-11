extends MarginContainer


const background_color : Color = Color(0, 0, 0, 0.8)


var current_showing_control : Control

onready var content_panel = $VBoxContainer/BodyContainer/ContentPanel

#

func _ready():
	visible = false


func show_control_at_content_panel(control : Control):
	if current_showing_control != null:
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



