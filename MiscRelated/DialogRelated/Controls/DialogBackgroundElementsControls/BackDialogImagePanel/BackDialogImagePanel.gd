extends "res://MiscRelated/DialogRelated/Controls/DialogBackgroundElementsControls/BaseDialogBackgroundElement.gd"



var texture_to_use : Texture setget set_texture_to_use

#

onready var texture_rect = $TextureRect


func _ready():
	texture_rect.texture = texture_to_use

func set_texture_to_use(arg_texture):
	texture_to_use = arg_texture
	
	if is_inside_tree():
		texture_rect.texture = texture_to_use
