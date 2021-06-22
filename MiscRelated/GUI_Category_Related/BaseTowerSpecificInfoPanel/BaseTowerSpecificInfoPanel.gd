extends MarginContainer

const BaseTooltip = preload("res://GameHUDRelated/Tooltips/BaseTooltip.gd")

var about_tooltip : BaseTooltip

onready var advanced_button = $VBoxContainer/HeaderMarginer/MarginContainer2/AdvancedButton
onready var body_marginer = $VBoxContainer/BodyMarginer


func _on_AdvancedButton_pressed_mouse_event(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if about_tooltip == null:
				about_tooltip = _construct_about_tooltip()
				about_tooltip.visible = true
				about_tooltip.tooltip_owner = advanced_button
				get_tree().get_root().add_child(about_tooltip)
				about_tooltip.update_display()
				
			else:
				about_tooltip.queue_free()
				about_tooltip = null


func _construct_about_tooltip():
	pass
