extends MarginContainer


signal on_button_released_with_button_left()
signal on_button_tooltip_requested()

onready var back_button = $BackButton


func _ready():
	back_button.connect("released_mouse_event", self, "_on_advanced_button_released_mouse_event", [], CONNECT_PERSIST)
	back_button.connect("about_tooltip_construction_requested", self, "_on_advanced_button_tooltip_requested", [], CONNECT_PERSIST)
	

func _on_advanced_button_released_mouse_event(arg_event : InputEventMouseButton):
	if arg_event.button_index == BUTTON_LEFT:
		emit_signal("on_button_released_with_button_left")

func _on_advanced_button_tooltip_requested():
	emit_signal("on_button_tooltip_requested")



