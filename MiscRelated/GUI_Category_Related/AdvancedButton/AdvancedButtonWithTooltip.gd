extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButton.gd"

const BaseTooltip = preload("res://GameHUDRelated/Tooltips/BaseTooltip.gd")

signal about_tooltip_construction_requested()
signal on_mouse_entered()

const MOUSE_HOVER = -1001

var about_tooltip : BaseTooltip
enum _button_indexes {
	BUTTON_LEFT = BUTTON_LEFT,
	BUTTON_RIGHT = BUTTON_RIGHT
	BUTTON_MIDDLE = BUTTON_MIDDLE
	BUTTON_LEFT_OR_RIGHT = -1002
	MOUSE_HOVER = -1001
}
export(_button_indexes) var about_button_index_trigger : int = BUTTON_RIGHT

# true when extending the button and defining tooltip construction in the button
export(bool) var define_tooltip_construction_in_button : bool = true

func _on_AdvancedButton_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == about_button_index_trigger or about_button_index_trigger == _button_indexes.BUTTON_LEFT_OR_RIGHT:
			_trigger_create_about_tooltip()
	
	._on_AdvancedButton_gui_input(event)

func _on_AdvancedButtonWithTooltip_mouse_entered():
	if about_button_index_trigger == MOUSE_HOVER:
		_trigger_create_about_tooltip()
	
	emit_signal("on_mouse_entered")





func _trigger_create_about_tooltip():
	if define_tooltip_construction_in_button:
		if !is_instance_valid(about_tooltip):
			display_requested_about_tooltip(_construct_about_tooltip())
		else:
			about_tooltip.queue_free()
			about_tooltip = null
		
	else:
		if !is_instance_valid(about_tooltip):
			emit_signal("about_tooltip_construction_requested")
		else:
			about_tooltip.queue_free()
			about_tooltip = null


#

func _construct_about_tooltip() -> BaseTooltip:
	return null

#
# use this only when define_tooltip_construction_in_button is false
func display_requested_about_tooltip(arg_about_tooltip : BaseTooltip):
	if is_instance_valid(arg_about_tooltip):
		about_tooltip = arg_about_tooltip
		about_tooltip.visible = true
		about_tooltip.tooltip_owner = self
		#get_tree().get_root().add_child(about_tooltip)
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(about_tooltip)
		about_tooltip.update_display()



func _on_Button_released_mouse_event(event):
	pass # Replace with function body.
