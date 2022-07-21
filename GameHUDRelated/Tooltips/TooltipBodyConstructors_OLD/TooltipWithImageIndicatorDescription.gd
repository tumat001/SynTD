extends MarginContainer

var description : String
var img_indicator : Resource
var color : Color = Color(0, 0, 0, 1)


func _init(arg_img_indicator : Resource = null, arg_description : String = ""):
	description = arg_description
	img_indicator = arg_img_indicator

func _ready():
	$ColumnContainer/ImageIndicator.texture = img_indicator
	$ColumnContainer/MarginContainer/Label.text = description


func get_info_from_self_class(self_class):
	description = self_class.description
	img_indicator = self_class.img_indicator

