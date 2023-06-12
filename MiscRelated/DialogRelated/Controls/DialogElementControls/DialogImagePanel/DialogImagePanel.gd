extends "res://MiscRelated/DialogRelated/Controls/DialogElementControls/BaseDialogElementControl.gd"


var image_to_use : Texture


onready var image_rect = $VBoxContainer/ImageRect

###

func _start_display():
	image_rect.texture = image_to_use

