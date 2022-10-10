extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

var variance setget set_variance

onready var lock_button = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/LockButton


# FOR INFO PANEL
func LISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.connect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")

func UNLISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.disconnect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")


func _on_tower_panel_ability_01_pressed():
	lock_button.attempt_activate_ability()

#

func _ready():
	lock_button.hotkey = InputMap.get_action_list("game_tower_panel_ability_01")[0].as_text()
	


#

func set_variance(arg_variance):
	if is_instance_valid(variance):
		lock_button.ability = null
	
	variance = arg_variance
	
	if is_instance_valid(variance):
		lock_button.ability = variance.lock_ability
		



#

func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"Contains abilities that manipulate the state of Variance."
	]
	a_tooltip.header_left_text = "State"
	
	return a_tooltip


static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.VARIANCE
