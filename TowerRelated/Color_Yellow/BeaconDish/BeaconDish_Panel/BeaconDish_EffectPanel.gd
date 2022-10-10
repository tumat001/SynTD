extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

var beacon_dish setget set_beacon_dish

onready var elemental_buff_effect_panel = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/VBoxContainer/ElementalBuffPanel
onready var attk_speed_effect_panel = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/VBoxContainer/AttkSpeedBuffPanel
onready var range_effect_panel = $VBoxContainer/BodyMarginer/MarginContainer/HBoxContainer/VBoxContainer/RangeBuffPanel


#

func set_beacon_dish(arg_tower):
	if is_instance_valid(beacon_dish):
		beacon_dish.disconnect("elemental_buff_changed", self, "_update_elemental_panel")
		beacon_dish.disconnect("attk_speed_buff_changed", self, "_update_attk_speed_panel")
		beacon_dish.disconnect("range_buff_changed", self, "_update_range_panel")
	
	beacon_dish = arg_tower
	
	if is_instance_valid(beacon_dish):
		beacon_dish.connect("elemental_buff_changed", self, "_update_elemental_panel", [], CONNECT_PERSIST)
		beacon_dish.connect("attk_speed_buff_changed", self, "_update_attk_speed_panel", [], CONNECT_PERSIST)
		beacon_dish.connect("range_buff_changed", self, "_update_range_panel", [], CONNECT_PERSIST)
		
		elemental_buff_effect_panel.tower_base_effect = beacon_dish.elemental_on_hit_effect
		attk_speed_effect_panel.tower_base_effect = beacon_dish.attack_speed_effect
		range_effect_panel.tower_base_effect = beacon_dish.range_effect
		
		_update_elemental_panel()
		_update_attk_speed_panel()
		_update_range_panel()


func _update_elemental_panel():
	elemental_buff_effect_panel.update_display()

func _update_attk_speed_panel():
	attk_speed_effect_panel.update_display()

func _update_range_panel():
	range_effect_panel.update_display()


#

func _ready():
	elemental_buff_effect_panel.use_dynamic_description = true
	attk_speed_effect_panel.use_dynamic_description = true
	range_effect_panel.use_dynamic_description = true


# Override this to return a tooltip
func _construct_about_tooltip() -> BaseTooltip:
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = "Beacon Dish Effects"
	tooltip.descriptions = beacon_dish.beacon_dish_panel_about_descriptions
	
	return tooltip


#

static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.BEACON_DISH
