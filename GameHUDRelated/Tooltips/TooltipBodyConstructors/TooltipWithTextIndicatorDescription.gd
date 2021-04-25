extends MarginContainer

var description : String
var description_color : Color
var indicator : String
var indicator_color : Color

func _init(arg_indicator : String = "", arg_description : String = "",
		arg_indicator_color : Color = Color.black,
		arg_description_color : Color = Color.black):
	description = arg_description
	indicator = arg_indicator
	description_color = arg_description_color
	indicator_color = arg_indicator_color

func _ready():
	$ColumnContainer/Indicator.text = indicator
	$ColumnContainer/Indicator.add_color_override("font_color", indicator_color)
	$ColumnContainer/Label.text = description
	$ColumnContainer/Label.add_color_override("font_color", description_color)

func get_info_from_self_class(self_class):
	description = self_class.description
	indicator = self_class.indicator

