extends MarginContainer

var description : String
var indicator : String

func _init(arg_indicator : String = "", arg_description : String = ""):
	description = arg_description
	indicator = arg_indicator

func _ready():
	$ColumnContainer/Indicator.text = indicator
	$ColumnContainer/Label.text = description

func get_info_from_self_class(self_class):
	description = self_class.description
	indicator = self_class.indicator

