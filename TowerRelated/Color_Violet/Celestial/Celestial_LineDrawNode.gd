extends Node2D

class LineDrawParams:
	
	var source_pos : Vector2
	var dest_pos : Vector2
	
	var total_line_length : float
	
	var current_line_start_length : float setget set_current_line_start_length
	var current_line_end_length : float setget set_current_line_end_length
	
	var line_length_per_sec : float
	
	var color : Color
	
	var width : float
	
	var delta_delay_before_show : float
	
	
	var _length_from_source_to_dest_pos : float
	var _phantom_line_start_length : float
	var _line_end_dist_traversed : float
	
	####
	
	func set_current_line_start_length(arg_val):
		if arg_val > total_line_length:
			arg_val = total_line_length
		
		current_line_start_length = arg_val
	
	func set_current_line_end_length(arg_val):
		if arg_val > total_line_length:
			arg_val = total_line_length
		
		current_line_end_length = arg_val
	
	
	func configure_properties():
		_length_from_source_to_dest_pos = source_pos.distance_to(dest_pos)
	

var _all_line_draw_params : Array
var _all_line_draw_params_with_delay : Array


func _ready():
	z_index = ZIndexStore.PARTICLE_EFFECTS
	z_as_relative = false
	
	set_process(false)

######

func add_line_draw_param(arg_param : LineDrawParams):
	arg_param.configure_properties()
	
	if arg_param.delta_delay_before_show <= 0:
		_all_line_draw_params.append(arg_param)
	else:
		_all_line_draw_params_with_delay.append(arg_param)
	
	set_process(true)

func remove_line_draw_param(arg_param : LineDrawParams):
	_all_line_draw_params.erase(arg_param)
	
	if _all_line_draw_params.size() == 0 and _all_line_draw_params_with_delay.size() == 0:
		set_process(false)


func _process(delta):
	for param in _all_line_draw_params:
		var line_inc = param.line_length_per_sec * delta
		
		param.current_line_start_length += line_inc
		param._phantom_line_start_length += line_inc
		
		if param._line_end_dist_traversed >= param._length_from_source_to_dest_pos:
			remove_line_draw_param(param)
		
		if param._phantom_line_start_length >= param.total_line_length:
			param.current_line_end_length += line_inc
			param._line_end_dist_traversed += line_inc
	
	#
	
	var bucket_to_add : Array = []
	for param in _all_line_draw_params_with_delay:
		param.delta_delay_before_show -= delta
		if param.delta_delay_before_show <= 0:
			_all_line_draw_params_with_delay.erase(param)
			bucket_to_add.append(param)
	
	for param in bucket_to_add:
		add_line_draw_param(param)
	
	update()

func _draw():
	for param in _all_line_draw_params:
		var final_source_line_pos = param.source_pos.move_toward(param.dest_pos, param.current_line_end_length)
		var final_dest_line_pos = param.source_pos.move_toward(param.dest_pos, param.current_line_start_length)
		
		draw_line(final_source_line_pos - global_position, final_dest_line_pos - global_position, param.color, param.width)


