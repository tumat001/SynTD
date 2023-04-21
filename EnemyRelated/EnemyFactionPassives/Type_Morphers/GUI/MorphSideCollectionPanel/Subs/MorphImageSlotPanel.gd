extends MarginContainer


onready var image_rect = $ImageRect

func set_slot_size(arg_size : Vector2):
	rect_size = arg_size

func set_image(arg_texture : Texture):
	image_rect.texture = arg_texture

