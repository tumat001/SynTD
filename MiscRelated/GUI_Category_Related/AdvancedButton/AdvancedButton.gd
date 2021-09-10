extends TextureButton

signal pressed_mouse_event(event)
signal released_mouse_event(event)


func _on_AdvancedButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("pressed_mouse_event", event)
		else:
			emit_signal("released_mouse_event", event)
	
