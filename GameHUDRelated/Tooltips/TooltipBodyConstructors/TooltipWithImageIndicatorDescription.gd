extends MarginContainer

var description : String
var img_indicator : Resource
var description_color : Color

func _init(arg_img_indicator : Resource = null, arg_description : String = "",
		arg_description_color : Color = Color.black):
	description = arg_description
	img_indicator = arg_img_indicator
	description_color = arg_description_color

func _ready():
	$ColumnContainer/ImageIndicator.texture = img_indicator
	$ColumnContainer/MarginContainer/Label.text = description
	$ColumnContainer/MarginContainer/Label.add_color_override("font_color", description_color)

func get_info_from_self_class(self_class):
	description = self_class.description
	img_indicator = self_class.img_indicator

