extends TextureRect

signal corner_turned()


var current_target_point_local : Vector2
var current_target_point_idx : int
#var next_target_point_local : Vector2

var _is_mov_x : bool = true # if false, then mov is in y


func move_unit_distance(arg_unit_dist : float, arg_path_length : float):
	move_distance(arg_unit_dist * arg_path_length)


func move_distance(arg_dist : float):
	var diff_vec = current_target_point_local - rect_position
	var axis_dist : float
	var axis_dist_overflow : float
	
	if _is_mov_x:
		axis_dist = diff_vec.x
		if abs(axis_dist) >= abs(arg_dist):
			rect_position += Vector2(axis_dist, 0)
		else:
			axis_dist_overflow = arg_dist - axis_dist
			rect_position += Vector2(axis_dist, 0)
			rect_position -= Vector2(0, axis_dist_overflow)
			emit_signal("corner_turned")
		
	else:
		axis_dist = diff_vec.y
		if abs(axis_dist) >= abs(arg_dist):
			rect_position += Vector2(0, axis_dist)
		else:
			axis_dist_overflow = arg_dist - axis_dist
			rect_position += Vector2(0, axis_dist)
			rect_position -= Vector2(axis_dist_overflow, 0)
			emit_signal("corner_turned")


