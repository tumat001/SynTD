extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButton.gd"

signal on_request_open_green_panel()


func _on_Green_SynInteractableIcon_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		emit_signal("on_request_open_green_panel")
