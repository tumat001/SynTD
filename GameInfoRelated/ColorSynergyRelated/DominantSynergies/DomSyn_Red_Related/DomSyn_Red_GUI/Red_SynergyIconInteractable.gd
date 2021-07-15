extends MarginContainer

signal show_syn_shop()


func _on_AdvancedButton_pressed_mouse_event(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("show_syn_shop")
