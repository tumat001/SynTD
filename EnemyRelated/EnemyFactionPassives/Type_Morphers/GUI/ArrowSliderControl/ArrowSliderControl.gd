extends Control

#

signal arrow_position_changed(arg_pos, arg_global_pos)

signal arrow_reached_final_pos(arg_pos, arg_global_pos)

#

var _arrow_pic_half_width : float

#var _arrow_mov_tweener : SceneTreeTween

var _arrow_curr_speed : float
var _arrow_accel : float
var _arrow_final_pos_x : float
var _is_arrow_sliding_right : bool

#

onready var slider_panel = $SliderPanel

onready var arrow_pic = $Arrow

########

func _ready():
	set_process(false)
	
	update_arrow_pic_half_width()

func update_arrow_pic_half_width():
	_arrow_pic_half_width = arrow_pic.texture.get_size().x / 2
	

#

func set_slider_width(arg_width : float):
	slider_panel.rect_position = Vector2(-_arrow_pic_half_width, 0)
	slider_panel.rect_size = Vector2(arg_width, _arrow_pic_half_width * 2)
	
	rect_size = Vector2(arg_width + (_arrow_pic_half_width * 2), _arrow_pic_half_width * 2)


##

func shift_arrow_to_left(arg_left_shift : float):
	var x_pos = arrow_pic.rect_position.x
	
	x_pos -= arg_left_shift
	if x_pos < 0:
		x_pos += _get_arrow_right_x_pos_limit()
	
	arrow_pic.rect_position = Vector2(x_pos, 0)
	
	emit_signal("arrow_position_changed", arrow_pic.rect_position, arrow_pic.rect_global_position)

func shift_arrow_to_right(arg_right_shift : float):
	var x_pos = arrow_pic.rect_position.x
	
	x_pos += arg_right_shift
	
	var right_x_pos_limit = _get_arrow_right_x_pos_limit()
	if x_pos > right_x_pos_limit:
		x_pos -= right_x_pos_limit
	
	arrow_pic.rect_position = Vector2(x_pos, 0)
	
	emit_signal("arrow_position_changed", arrow_pic.rect_position, arrow_pic.rect_global_position)

func _get_arrow_right_x_pos_limit():
	return rect_size.x - (_arrow_pic_half_width * 2)


func set_arrow_pos_to_center_of_slider():
	arrow_pic.rect_position = Vector2(((slider_panel.rect_position + slider_panel.rect_size) / 2).x, 0)
	
	emit_signal("arrow_position_changed", arrow_pic.rect_position, arrow_pic.rect_global_position)

func set_arrow_pos(arg_pos):
	arrow_pic.rect_position = arg_pos

#

func get_arrow_x_pos() -> float:
	return arrow_pic.rect_position.x + _arrow_pic_half_width

######

func perform_arrow_slide_with_speed_on_final_x_pos__slide_right(arg_slide_initial_speed : float, arg_final_x_pos : int, arg_full_rotation_count : int):
	var dist_from_curr_pos_to_target = abs(arrow_pic.rect_position.x - arg_final_x_pos)
	if arrow_pic.rect_position.x > arg_final_x_pos:
		dist_from_curr_pos_to_target = slider_panel.rect_size.x - dist_from_curr_pos_to_target
	
	var total_dist = dist_from_curr_pos_to_target + (slider_panel.rect_size.x * arg_full_rotation_count)
	
	####
	
	_arrow_curr_speed = arg_slide_initial_speed
	_arrow_accel = -(arg_slide_initial_speed * arg_slide_initial_speed) / (2 * total_dist)
	_arrow_final_pos_x = arg_final_x_pos
	_is_arrow_sliding_right = true
	set_process(true)

# 0 = ini^2 + 2as
# -ini^2 = 2as
# -ini^2 / 2s = a


func _process(delta):
	if _is_arrow_sliding_right:
		shift_arrow_to_right(_arrow_curr_speed)
		_arrow_curr_speed -= _arrow_accel * delta
		
		if _arrow_curr_speed <= 0:
			_arrow_curr_speed = 0
			set_arrow_pos(Vector2(_arrow_final_pos_x, 0))
			emit_signal("arrow_reached_final_pos", arrow_pic.rect_position, arrow_pic.rect_global_position)
			
			set_process(false)


