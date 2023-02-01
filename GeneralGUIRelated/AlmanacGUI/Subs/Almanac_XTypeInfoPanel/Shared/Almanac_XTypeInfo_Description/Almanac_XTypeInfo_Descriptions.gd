extends MarginContainer


onready var desc_panel = $MarginContainer/ScrollContainer/Descs

var descriptions : Array

func update_display():
	desc_panel.descriptions = descriptions
	desc_panel.update_display()
	
