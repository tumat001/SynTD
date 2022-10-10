extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

var rift_axis setget set_rift_axis

onready var rift_swap_sides_button = $VBoxContainer/BodyMarginer/ContentMarginer/HBoxContainer/RiftSwapButton

# FOR INFO PANEL
func LISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.connect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")
	#arg_info_panel.connect("on_tower_panel_ability_02_activate", self, "_on_tower_panel_ability_02_pressed")

func UNLISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.disconnect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")
	#arg_info_panel.disconnect("on_tower_panel_ability_02_activate", self, "_on_tower_panel_ability_02_pressed")


func _on_tower_panel_ability_01_pressed():
	rift_swap_sides_button.attempt_activate_ability()

#func _on_tower_panel_ability_02_pressed():
#	unassign_partner_button.attempt_activate_ability()

#

func _ready():
	rift_swap_sides_button.hotkey = InputMap.get_action_list("game_tower_panel_ability_01")[0].as_text()
	#unassign_partner_button.hotkey = InputMap.get_action_list("game_tower_panel_ability_02")[0].as_text()



#

func set_rift_axis(arg_rift_axis):
	if is_instance_valid(rift_axis):
		rift_swap_sides_button.ability = null
	
	rift_axis = arg_rift_axis
	
	if is_instance_valid(rift_axis):
		rift_swap_sides_button.ability = rift_axis.rift_swap_sides_ability

#

func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"This panel contains abilties for Rift Axis."
	]
	a_tooltip.header_left_text = "Rift Axis"
	
	return a_tooltip


static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.YELVIO_RIFT_AXIS
