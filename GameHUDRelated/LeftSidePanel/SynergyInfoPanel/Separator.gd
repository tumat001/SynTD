extends MarginContainer

export var separator_text : String

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/SeparatorLabel.text = separator_text
