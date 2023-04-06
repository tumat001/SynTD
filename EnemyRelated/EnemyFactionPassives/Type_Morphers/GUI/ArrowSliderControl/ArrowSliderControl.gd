extends Control

#

var _arrow_pic_half_width : float

#

onready var slider_panel = $SliderPanel

onready var arrow_pic = $Arrow

########

func _ready():
	update_arrow_pic_half_width()

func update_arrow_pic_half_width():
	_arrow_pic_half_width = arrow_pic.texture.get_size().x / 2
	

#

func set_slider_width(arg_width : float):
	pass
	



##

func shift_arrow_to_left(arg_left_shift : float):
	pass
	

func shift_arrow_to_right(arg_right_shift : float):
	pass
	



