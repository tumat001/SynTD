extends MarginContainer

const HeatModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/HeatModule.gd")

var heat_module : HeatModule setget set_heat_module

onready var heat_primary_stat_panel = $VBoxContainer/BodyPanel/VBoxContainer/HeatPrimaryStatPanel
onready var heat_bar_panel = $VBoxContainer/BodyPanel/VBoxContainer/HeatModuleBarPanel


func set_heat_module(arg_heat_module : HeatModule):
	heat_module = arg_heat_module
	
	heat_primary_stat_panel.heat_module = heat_module
	heat_bar_panel.heat_module = heat_module

func update_display():
	heat_bar_panel.update_display()
	heat_primary_stat_panel.update_display()


func _on_About_pressed():
	pass # Replace with function body.


func _on_About_mouse_exited():
	pass # Replace with function body.
