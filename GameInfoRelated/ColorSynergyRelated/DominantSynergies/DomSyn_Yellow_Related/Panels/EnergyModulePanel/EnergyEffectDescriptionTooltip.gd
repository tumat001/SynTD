extends "res://GameHUDRelated/Tooltips/BaseTooltip.gd"

const EnergyModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/EnergyModule.gd")
const TooltipBody = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipBody.gd")

var energy_module : EnergyModule

onready var tooltip_body : TooltipBody = $VBoxContainer/BodyMarginer/TooltipBody
onready var vbox : VBoxContainer = $VBoxContainer


func update_display():
	if energy_module != null:
		_update_tooltip_body(energy_module.module_effect_descriptions)
	else:
		_update_tooltip_body([])
	
	call_deferred("shrink")

func shrink():
	rect_min_size.y = 10
	rect_size.y = 10

func _update_tooltip_body(descriptions : Array):
	tooltip_body.descriptions = descriptions
	tooltip_body.update_display()
