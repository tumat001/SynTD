extends MarginContainer

var description : String
var color : Color = Color(0, 0, 0, 1)

func _init(arg_description : String = ""):
	description = arg_description


func _ready():
	
	
	$Label.set("custom_colors/font_color", color)
	$Label.text = description
	
	

func get_info_from_self_class(self_class):
	description = self_class.description
