extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"



const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

var amalgamator setget set_amalgamator

onready var amalgam_button = $VBoxContainer/BodyMarginer/Container/AmalgamAbility


# FOR INFO PANEL
func LISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.connect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")

func UNLISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.disconnect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")


func _on_tower_panel_ability_01_pressed():
	amalgam_button.attempt_activate_ability()

#

func _ready():
	amalgam_button.hotkey = InputMap.get_action_list("game_tower_panel_ability_01")[0].as_text()
	


#

func set_amalgamator(arg_variance):
	#if is_instance_valid(amalgamator):
	amalgam_button.ability = null
	
	amalgamator = arg_variance
	
	if is_instance_valid(amalgamator):
		amalgam_button.ability = amalgamator.amalgam_ability

#

func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Contains abilities for tower convertion."
	]
	a_tooltip.header_left_text = "Black"
	
	return a_tooltip


static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.AMALGAMATOR
