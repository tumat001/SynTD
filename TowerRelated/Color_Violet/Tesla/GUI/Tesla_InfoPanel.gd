extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

var tesla setget set_tesla

onready var increase_orbit_button = $VBoxContainer/BodyMarginer/ContentMargin/VBoxContainer/HBoxContainer/IncreaseOrbitRadiusButton
onready var decrease_orbit_button = $VBoxContainer/BodyMarginer/ContentMargin/VBoxContainer/HBoxContainer/DecreaseOrbitRadiusButton
onready var toggle_orbit_dir_button = $VBoxContainer/BodyMarginer/ContentMargin/VBoxContainer/ToggleOrbitDirectionButton

# FOR INFO PANEL
func LISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.connect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")
	arg_info_panel.connect("on_tower_panel_ability_02_activate", self, "_on_tower_panel_ability_02_pressed")
	arg_info_panel.connect("on_tower_panel_ability_03_activate", self, "_on_tower_panel_ability_03_pressed")
	

func UNLISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.disconnect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")
	arg_info_panel.disconnect("on_tower_panel_ability_02_activate", self, "_on_tower_panel_ability_02_pressed")
	arg_info_panel.disconnect("on_tower_panel_ability_03_activate", self, "_on_tower_panel_ability_03_pressed")


func _on_tower_panel_ability_01_pressed():
	increase_orbit_button.attempt_activate_ability()

func _on_tower_panel_ability_02_pressed():
	decrease_orbit_button.attempt_activate_ability()

func _on_tower_panel_ability_03_pressed():
	toggle_orbit_dir_button.attempt_activate_ability()

#

func _ready():
	increase_orbit_button.hotkey = InputMap.get_action_list("game_tower_panel_ability_01")[0].as_text()
	decrease_orbit_button.hotkey = InputMap.get_action_list("game_tower_panel_ability_02")[0].as_text()
	toggle_orbit_dir_button.hotkey = InputMap.get_action_list("game_tower_panel_ability_03")[0].as_text()

##


func set_tesla(arg_tesla):
	if is_instance_valid(tesla):
		increase_orbit_button.ability = null
		decrease_orbit_button.ability = null
		toggle_orbit_dir_button.ability = null
	
	tesla = arg_tesla
	
	if is_instance_valid(tesla):
		increase_orbit_button.ability = tesla.orbit_increase_radius_ability
		decrease_orbit_button.ability = tesla.orbit_decrease_radius_ability
		toggle_orbit_dir_button.ability = tesla.orbit_change_rotation_ability


#

func _construct_about_tooltip() -> BaseTooltip:
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	a_tooltip.descriptions = [
		"This panel contains abilities that alter Tesla's orbit."
	]
	a_tooltip.header_left_text = "Orbit Configuration"
	
	return a_tooltip


static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.TESLA

