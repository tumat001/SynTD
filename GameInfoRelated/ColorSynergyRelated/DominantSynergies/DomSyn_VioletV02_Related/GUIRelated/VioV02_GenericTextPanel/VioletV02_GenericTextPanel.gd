extends MarginContainer



var text_to_use : String setget set_text_to_use

onready var label = $MarginContainer/Label


func _ready():
	set_text_to_use(text_to_use)


func set_text_to_use(arg_val):
	text_to_use = arg_val
	
	if is_inside_tree():
		label.text = text_to_use
