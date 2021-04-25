extends MarginContainer

var description : String
var description_color : Color

func _init(arg_description : String = "",
		arg_description_color : Color = Color.black):
	description = arg_description
	description_color = arg_description_color


func _ready():
	$Label.text = description
	$Label.add_color_override("font_color", description_color)

func get_info_from_self_class(self_class):
	description = self_class.description
