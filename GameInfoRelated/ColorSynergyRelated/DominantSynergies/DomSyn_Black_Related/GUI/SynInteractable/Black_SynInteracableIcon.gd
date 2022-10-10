extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButton.gd"

const BaseTooltip = preload("res://GameHUDRelated/Tooltips/BaseTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")


var about_tooltip : BaseTooltip

onready var nova_count_for_activation_panel = $NovaCountForActivationPanel
onready var nova_count_label = $NovaCountForActivationPanel/VBoxContainer/MiddleContainer/ContentMarginer/NovaCountLabel

func _ready():
	set_visibility_of_nova_counter(false)


func _on_NovaCountForActivationPanel_mouse_entered():
	_trigger_create_about_tooltip()


func _on_NovaCountForActivationPanel_mouse_exited():
	pass # Replace with function body.

#

func set_nova_counter(arg_val : int):
	nova_count_label.text = str(arg_val)

func set_visibility_of_nova_counter(arg_val : bool):
	nova_count_for_activation_panel.visible = arg_val

#


func _trigger_create_about_tooltip():
	if !is_instance_valid(about_tooltip):
		display_requested_about_tooltip(_construct_about_tooltip())
	else:
		about_tooltip.queue_free()
		about_tooltip = null
	


func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Displays the number of abilities to cast to activate the Nova."
	]
	a_tooltip.header_left_text = "Nova Activation"
	
	return a_tooltip

#
# use this only when define_tooltip_construction_in_button is false
func display_requested_about_tooltip(arg_about_tooltip : BaseTooltip):
	if is_instance_valid(arg_about_tooltip):
		about_tooltip = arg_about_tooltip
		about_tooltip.visible = true
		about_tooltip.tooltip_owner = nova_count_for_activation_panel
		get_tree().get_root().add_child(about_tooltip)
		about_tooltip.update_display()


