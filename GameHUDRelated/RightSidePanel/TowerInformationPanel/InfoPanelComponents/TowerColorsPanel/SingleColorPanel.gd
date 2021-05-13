extends MarginContainer

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")


var color : int

func update_display():
	var color_icon = TowerColors.get_color_symbol_on_card(color)
	var color_name = TowerColors.get_color_name_on_card(color)
	
	$HBoxContainer/ColorIcon.texture = color_icon
	$HBoxContainer/MarginContainer/ColorName.text = color_name
