extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
const LAssaut = preload("res://TowerRelated/Color_Green/L'Assaut/L'Assaut.gd")


var tower : LAssaut setget set_lassaut

onready var stat_icon = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/StatIcon
onready var stat_label = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/StatLabel

func set_lassaut(arg_tower):
	if is_instance_valid(tower):
		tower.disconnect("stack_state_changed", self, "_stack_state_changed")
	
	tower = arg_tower
	
	if is_instance_valid(tower):
		tower.connect("stack_state_changed", self, "_stack_state_changed", [], CONNECT_PERSIST)
		
		_stack_state_changed(tower.get_stack_state())

#

func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Displays the effect of the stacks."
	]
	a_tooltip.header_left_text = "Stacks"
	
	return a_tooltip


static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.L_ASSAUT

#

func _stack_state_changed(arg_state):
	var icon_to_use = tower.get_stat_icon_to_display()
	stat_icon.texture = icon_to_use
	
	var label_text_to_use = tower.get_stat_label_to_display()
	stat_label.text = label_text_to_use

