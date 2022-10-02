extends MarginContainer

const TooltipStandard = preload("res://MiscRelated/PlayerGUI_Category_Related/TooltipStandard/TooltipStandard.gd")
const TooltipStandard_Scene = preload("res://MiscRelated/PlayerGUI_Category_Related/TooltipStandard/TooltipStandard.tscn")


signal play_button_released()

onready var button = $Button
onready var label = $Label

func _ready():
	button.define_tooltip_construction_in_button = false
	button.connect("pressed", self, "_on_button_triggered")

##

func _on_button_triggered():
	emit_signal("play_button_released")



func set_is_enabled(arg_val):
	button.disabled = !arg_val


