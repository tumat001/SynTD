extends MarginContainer

const font_name : String = "TooltipLabelFont"

var description : String
var color : Color = Color(0, 0, 0, 1)
var font_size : int = 8

onready var label = $Label

func _init(arg_description : String = ""):
	description = arg_description


func _ready():
	label.set("custom_colors/font_color", color)
	label.text = description
	
	#var font = label.get_font("font", "")
	#font.size = font_size
	label.add_font_override("font", StoreOfFonts.get_font_with_size(StoreOfFonts.FontTypes.CONSOLA, font_size))


func get_info_from_self_class(self_class):
	description = self_class.description
