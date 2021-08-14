extends MarginContainer

const RelicManager = preload("res://GameElementsRelated/RelicManager.gd")
const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

var relic_manager : RelicManager setget set_relic_manager
var tower_manager setget set_tower_manager

onready var tower_limit_relic_cost_label = $VBoxContainer/TowerLimitPanel/HBoxContainer/MarginContainer2/TowerLimitRelicCostLabel
onready var ing_cap_relic_cost_label = $VBoxContainer/TowerIngCapPanel/HBoxContainer/MarginContainer2/IngCapRelicCostLabel
onready var tower_limit_button = $VBoxContainer/TowerLimitPanel/TowerLimitButton
onready var ing_cap_button = $VBoxContainer/TowerIngCapPanel/IngCapButton


#

func set_relic_manager(arg_manager : RelicManager):
	relic_manager = arg_manager
	
	relic_manager.connect("current_relic_count_changed", self, "_on_relic_amount_changed", [], CONNECT_PERSIST)
	_on_relic_amount_changed(relic_manager.current_relic_count)

func set_tower_manager(arg_manager):
	tower_manager = arg_manager
	
	tower_limit_relic_cost_label.text = str(1)
	ing_cap_relic_cost_label.text = str(1)


#

func _on_relic_amount_changed(new_amount):
	visible = (new_amount >= 1)


# Tower Limit related

func _on_TowerLimitButton_about_tooltip_construction_requested():
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = "Tower Limit Increase"
	tooltip.descriptions = [
		"Increase the number of towers you can place in the map by %s" % (str(tower_manager.tower_limit_per_relic) + ".")
	]
	tower_limit_button.display_requested_about_tooltip(tooltip)


func _on_TowerLimitButton_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		tower_manager.attempt_spend_relic_for_tower_lim_increase()



# Ing Cap related

func _on_IngCapButton_about_tooltip_construction_requested():
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = "Ingredient Limit Increase"
	tooltip.descriptions = [
		"Increase the number of ingredients a tower can absorb by %s" % (str(tower_manager.ing_cap_per_relic) + ".")
	]
	ing_cap_button.display_requested_about_tooltip(tooltip)


func _on_IngCapButton_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		tower_manager.attempt_spend_relic_for_ing_cap_increase()


