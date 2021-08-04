extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButton.gd"

const BaseTooltip = preload("res://GameHUDRelated/Tooltips/BaseTooltip.gd")

signal about_tooltip_construction_requested()

var about_tooltip : BaseTooltip
enum _button_indexes {
	BUTTON_LEFT = BUTTON_LEFT,
	BUTTON_RIGHT = BUTTON_RIGHT
	BUTTON_MIDDLE = BUTTON_MIDDLE
}
export(_button_indexes) var about_button_index_trigger : int = BUTTON_RIGHT

# used when instancing button to scene
export(bool) var define_tooltip_construction_in_button : bool = true

func _on_AdvancedButton_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == about_button_index_trigger:
			if define_tooltip_construction_in_button:
				if about_tooltip == null:
					display_requested_about_tooltip(_construct_about_tooltip())
				else:
					about_tooltip.queue_free()
					about_tooltip = null
				
				
			else:
				if about_tooltip == null:
					emit_signal("about_tooltip_construction_requested")
				else:
					about_tooltip.queue_free()
					about_tooltip = null
			
	
	._on_AdvancedButton_gui_input(event)


func _construct_about_tooltip() -> BaseTooltip:
	return null

#
# use this only when define_tooltip_construction_in_button is false
func display_requested_about_tooltip(arg_about_tooltip : BaseTooltip):
	if arg_about_tooltip != null:
		about_tooltip = arg_about_tooltip
		about_tooltip.visible = true
		about_tooltip.tooltip_owner = self
		get_tree().get_root().add_child(about_tooltip)
		about_tooltip.update_display()