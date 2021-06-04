extends MarginContainer

const HeatModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/HeatModule.gd")
const SingleIngredientPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/SingleIngredientPanel.gd")

enum StatDisplay {
	CURRENT,
	BASE, # MAX
}

var displaying_stat : int = StatDisplay.CURRENT
var heat_module : HeatModule setget set_heat_module

onready var effect_panel : SingleIngredientPanel
onready var stat_display_label : Label = $VBoxContainer/MarginContainer/Marginer/StatDisplayLabel


func set_heat_module(arg_heat_module):
	if heat_module != null:
		heat_module.disconnect("base_heat_effect_changed", self, "_on_module_base_effect_changed")
		heat_module.disconnect("current_heat_effect_changed", self, "_on_module_current_effect_changed")
	
	heat_module = arg_heat_module
	
	if heat_module != null:
		heat_module.connect("base_heat_effect_changed", self, "_on_module_base_effect_changed")
		heat_module.connect("current_heat_effect_changed", self, "_on_module_current_effect_changed")


# 

func _on_module_base_effect_changed():
	if displaying_stat == StatDisplay.BASE:
		effect_panel.tower_base_effect = heat_module.base_heat_effect


func _on_module_current_effect_changed():
	if displaying_stat == StatDisplay.CURRENT:
		effect_panel.tower_base_effect = heat_module.current_heat_effect


#

func _on_ToggleStatButton_pressed():
	if displaying_stat == StatDisplay.CURRENT:
		# switch to base
		displaying_stat = StatDisplay.BASE
		stat_display_label.text = "Max"
		
		_on_module_base_effect_changed()
		
	elif displaying_stat == StatDisplay.BASE:
		# switch to current
		displaying_stat = StatDisplay.CURRENT
		stat_display_label.text = "Current"
		
		_on_module_current_effect_changed()

