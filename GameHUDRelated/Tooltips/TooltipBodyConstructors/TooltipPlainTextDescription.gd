extends MarginContainer

var description : String

func _init(arg_description : String = ""):
	description = arg_description


func _ready():
	$Label.text = description

func get_info_from_self_class(self_class):
	description = self_class.description
