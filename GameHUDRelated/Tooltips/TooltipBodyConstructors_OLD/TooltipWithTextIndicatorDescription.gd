extends MarginContainer

var description : String
var indicator : String
var color : Color = Color(0, 0, 0, 1)

func _init(arg_indicator : String = "", arg_description : String = ""):
	description = arg_description
	indicator = arg_indicator

func _ready():
	$ColumnContainer/Indicator.text = indicator
	$ColumnContainer/Label.text = description
	
	$ColumnContainer/Indicator.set("custom_colors/font_color", color)
	$ColumnContainer/Label.set("custom_colors/font_color", color)

func get_info_from_self_class(self_class):
	description = self_class.description
	indicator = self_class.indicator
