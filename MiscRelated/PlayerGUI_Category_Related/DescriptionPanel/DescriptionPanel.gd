extends MarginContainer

const GameSettingsManager = preload("res://GameElementsRelated/GameSettingsManager.gd")


onready var tooltip_body = $ContentContainer/TooltipBody

var descriptions : Array


func _ready():
	tooltip_body.default_font_color = Color(1, 1, 1, 1)


func update_display():
	tooltip_body.descriptions = descriptions
	
	tooltip_body.update_display()

