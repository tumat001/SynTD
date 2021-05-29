extends MarginContainer

const EnergyBattery = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/EnergyBattery.gd")
const ControlProgressBar = preload("res://MiscRelated/ControlProgressBarRelated/ControlProgressBar.gd")


var energy_battery : EnergyBattery setget _set_energy_battery

onready var energy_display_label : Label = $VBoxContainer/HeaderMarginer/MarginContainer/EnergyDisplayLabel
onready var energy_display_bar : ControlProgressBar = $VBoxContainer/BodyMarginer/EnergyDisplayBar

func _ready():
	if energy_battery != null:
		_energy_display_updated()


func _set_energy_battery(battery):
	if battery != null:
		energy_battery = battery
		energy_battery.connect("display_output_changed", self, "_energy_display_updated")
		
		_energy_display_updated()


func _energy_display_updated():
	if energy_display_label != null:
		energy_display_label.text = energy_battery.display_output
		
		energy_display_bar.set_max_value(energy_battery.max_energy_capacity)
		energy_display_bar.set_current_value(energy_battery.current_energy_amount)
