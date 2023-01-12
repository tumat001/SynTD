extends Control


var _slice_border_thickness : float
var _outer_border_thickness : float

var _center : Vector2
var _radius : float

var _line_angles : Array
var _line_angle_modifier : float

var color_to_use := Color(0, 0, 0)


# does not modifiy the array (arg_line_angles) so no need to duplicate it.
func set_border_properties(
		arg_slice_border_thickness, arg_outer_border_thickness,
		arg_center : Vector2, arg_radius : float,
		arg_line_angles : Array, arg_line_angle_modifier : float):
	
	
	_slice_border_thickness = arg_slice_border_thickness
	_outer_border_thickness = arg_outer_border_thickness
	
	_center = arg_center
	_radius = arg_radius
	
	_line_angles = arg_line_angles
	_line_angle_modifier = arg_line_angle_modifier
	
	update()


func _draw():
	draw_arc(_center, _radius, 0, 2 * PI, 100, color_to_use, _outer_border_thickness)
	#draw_circle_arc(_center, _radius, 0, 360, color_to_use)
	
	for angle in _line_angles:
		var initial_pos = _center
		var final_pos = _center + Vector2(0, _radius).rotated(angle + _line_angle_modifier)
		draw_line(initial_pos, final_pos, color_to_use, _slice_border_thickness)
	

#func draw_circle_arc(center, radius, angle_from, angle_to, color):
#    var nb_points = 72
#    var points_arc = PoolVector2Array()
#
#    for i in range(nb_points + 1):
#        var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
#        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
#
#    for index_point in range(nb_points):
#        draw_line(points_arc[index_point], points_arc[index_point + 1], color)
