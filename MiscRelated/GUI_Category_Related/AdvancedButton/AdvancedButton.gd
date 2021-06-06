extends TextureButton

signal pressed_mouse_index(button_mask)


func _on_AdvancedButton_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("pressed_type", event)
