extends MarginContainer

onready var path_texture_rect = $Control/PathIcon


var black_path setget set_black_path


func set_black_path(arg_path):
	path_texture_rect.texture = arg_path.black_path_icon


