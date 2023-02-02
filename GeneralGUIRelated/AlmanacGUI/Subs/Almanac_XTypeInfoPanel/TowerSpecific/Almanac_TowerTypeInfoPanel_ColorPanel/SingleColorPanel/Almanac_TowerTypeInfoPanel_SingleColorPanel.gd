extends MarginContainer


const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

var color_id : int


#

onready var color_icon = $HBoxContainer/ColorIcon
onready var color_name = $HBoxContainer/MarginContainer/ColorName

#

func update_display():
	color_icon.texture = TowerColors.get_color_symbol_on_card(color_id)
	color_name.text = TowerColors.get_color_name_on_card(color_id)
	
