extends Node2D

signal all_draw_params_finished()


class DrawParams:
	
	var center_pos : Vector2
	var current_radius : float
	var radius_per_sec : float
	var fill_color : Color
	
	var outline_color : Color
	var outline_width : float
	
	var _current_lifetime : float = 0
	var lifetime_of_draw : float
	var lifetime_to_start_transparency : float
	var has_lifetime : bool = true
	
	var max_radius : float = 10000
	
	#
	
	var game_elements
	
	var _is_configure_self_to_pause_and_unpause_based_on_stage_status : bool
	var _is_paused__due_to_stage_status : bool
	
	#
	
	var _outline_transparency_per_sec : float
	var _fill_transparency_per_sec : float
	
	#
	
	func configure_properties():
		if (lifetime_of_draw - lifetime_to_start_transparency) != 0:
			_outline_transparency_per_sec = outline_color.a / (lifetime_of_draw - lifetime_to_start_transparency)
			_fill_transparency_per_sec = fill_color.a / (lifetime_of_draw - lifetime_to_start_transparency)
		else:
			_outline_transparency_per_sec = outline_color.a / lifetime_of_draw
			_fill_transparency_per_sec = fill_color.a / lifetime_of_draw
		
		_current_lifetime = 0
	
	
	func configure_self_to_pause_and_unpause_based_on_stage_status(arg_game_elements):
		game_elements = arg_game_elements
		_is_configure_self_to_pause_and_unpause_based_on_stage_status = true
		
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_ended")
		game_elements.stage_round_manager.connect("round_started", self, "_on_round_started")
	
	func unconfigure_self_from_all():
		if _is_configure_self_to_pause_and_unpause_based_on_stage_status:
			_is_paused__due_to_stage_status = false
			game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_ended")
			game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_started")
	
	func _on_round_ended(arg_stageround):
		_is_paused__due_to_stage_status = true
	
	func _on_round_started(arg_stageround):
		_is_paused__due_to_stage_status = false
	
	


var _all_draw_params : Array

var pause_lifetime_of_all_draws : bool = false

#

func _ready():
	z_index = ZIndexStore.PARTICLE_EFFECTS
	z_as_relative = false
	
	set_process(false)


func add_draw_param(arg_draw_param : DrawParams):
	arg_draw_param.configure_properties()
	_all_draw_params.append(arg_draw_param)
	
	set_process(true)

func remove_draw_param(arg_draw_param : DrawParams):
	_all_draw_params.erase(arg_draw_param)
	
	arg_draw_param.unconfigure_self_from_all()
	
	if _all_draw_params.size() == 0:
		set_process(false)
		
		emit_signal("all_draw_params_finished")


func has_draw_param():
	return _all_draw_params.size() > 0
	


#

func _process(delta):
	for param in _all_draw_params:
		if (!pause_lifetime_of_all_draws or param._is_paused__due_to_stage_status) and param.has_lifetime:
			param._current_lifetime += delta
		
		param.current_radius += param.radius_per_sec * delta
		if param.current_radius > param.max_radius:
			param.current_radius = param.max_radius
		
		if param.lifetime_to_start_transparency <= param._current_lifetime:
			param.fill_color.a -= param._fill_transparency_per_sec * delta
			param.outline_color.a -= param._outline_transparency_per_sec * delta
			
		
		if param.lifetime_of_draw <= param._current_lifetime:
			remove_draw_param(param)
	
	update()

func _draw():
	for param in _all_draw_params:
		draw_circle(param.center_pos - global_position, param.current_radius, param.fill_color)
		draw_circle_arc(param.center_pos - global_position, param.current_radius, 0, 360, param.outline_color, param.outline_width)

func draw_circle_arc(center, radius, angle_from, angle_to, color, arg_width):
	var nb_points = 64
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, arg_width)
