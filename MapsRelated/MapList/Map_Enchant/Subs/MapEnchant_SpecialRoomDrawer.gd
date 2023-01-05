extends Node2D


var pos_x_left : float
var pos_x_right : float

var pos_y_start : float
var pos_y_end : float

var duration : float

export(Color) var color_to_use : Color

######

var _current_width : float

var _current_y_per_sec : float
var _current_y_target_amount : float

var _current_pos_y : float

var _floor_rect : Rect2

#const _floot_expand_delta : float = 0.02

var _is_displaying : bool

###

func _ready():
	set_process(false)
	
	#z_index = ZIndexStore.MAP_ENVIRONMENT_BELOW_PARTICLE_EFFECTS
	#z_as_relative = false

#

func start_display():
	_current_width = pos_x_right - pos_x_left
	_current_y_target_amount = (pos_y_start - pos_y_end)
	_current_y_per_sec = _current_y_target_amount / duration
	_current_pos_y = 0 #pos_y_start
	
	_is_displaying = true
	
	set_process(true)


func end_display():
	set_process(false)
	
	_is_displaying = false
	update()



func _process(delta):
	_current_pos_y += _current_y_per_sec * delta
	
	if _current_pos_y >= _current_y_target_amount:
		_current_pos_y = _current_y_target_amount
		_display_finished()
	
	_floor_rect = Rect2(pos_x_left, pos_y_start, _current_width, -_current_pos_y)
	
	update()
	

func _display_finished():
	set_process(false)
	


####

func _draw():
	if _is_displaying:
		draw_rect(_floor_rect, color_to_use, true)
	






