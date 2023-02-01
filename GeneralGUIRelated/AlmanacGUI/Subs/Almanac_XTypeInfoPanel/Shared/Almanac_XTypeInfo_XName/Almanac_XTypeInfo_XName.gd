extends MarginContainer


var x_name : String

onready var name_label = $MarginContainer/NameLabel

func update_display():
	name_label.text = x_name
