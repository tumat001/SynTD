extends Control


var transition_duration : float = 1.5
var _current_transition_duration : float

var _target_slice_modulate : Color  # red
var _current_slice_modulate := Color(1, 1, 1, 1)  # red

var _current_modulate_per_sec : Color

var _angle_from : float
var _angle_to : float

var _slice_radius : float
var _slice_center : Vector2

var slice_id : int


#

func _ready():
	set_process(false)

#

func set_slice_modulate(arg_color : Color,
		arg_play_transition : bool = true,
		arg_duration : float = transition_duration):
	
	_target_slice_modulate = arg_color
	
	if arg_play_transition:
		_current_transition_duration = 0
		
		_current_slice_modulate = modulate
		_current_modulate_per_sec = Color(_target_slice_modulate.r - _current_slice_modulate.r, _target_slice_modulate.g - _current_slice_modulate.g, _target_slice_modulate.b - _current_slice_modulate.b, _target_slice_modulate.a - _current_slice_modulate.a) / transition_duration
		
		set_process(true)
	else:
		_current_transition_duration = transition_duration
		_current_slice_modulate = arg_color
		
		
		update()


func set_slice_properties__using_angle_mid(arg_center : Vector2, arg_radius : float, 
		arg_angle_mid : float, arg_angle_half_width : float):
	
	var angle_from = arg_angle_mid - arg_angle_half_width
	var angle_to = arg_angle_mid + arg_angle_half_width
	
	set_slice_properties__using_from_and_to(arg_center, arg_radius, angle_from, angle_to)


func set_slice_properties__using_from_and_to(arg_center : Vector2, arg_radius : float, 
		arg_angle_from : float, arg_angle_to : float):
	
	_slice_center = arg_center
	_slice_radius = arg_radius
	
	_angle_from = arg_angle_from
	_angle_to = arg_angle_to
	
	update()


#

func _process(delta):
	_current_slice_modulate += _current_modulate_per_sec * delta
	
	_current_transition_duration += delta
	if _current_transition_duration >= transition_duration:
		_current_slice_modulate = _target_slice_modulate
		
		set_process(false)
	
	update()

#

func _draw():
	
	#print("angle_from: %s, angle_to %s, color: %s" % [_angle_from, _angle_to, _current_slice_modulate])
	
	draw_circle_arc(_slice_center, _slice_radius, rad2deg(_angle_from), rad2deg(_angle_to), _current_slice_modulate)
	



## from godot docs
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)


