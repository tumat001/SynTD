extends AnimatedSprite

const NO_INTERSECTION : float = -999.0

signal time_visible_is_over()


export(float) var time_visible : float
export(bool) var is_timebound : bool = false

var _current_time_visible : float

export(bool) var queue_free_if_time_over : bool = false

var pos_of_beam_travel : Vector2

#

var is_from_tower_attack_module : bool = false
var attack_module_source

var is_blockable : bool = false
var curr_destination_pos : Vector2

var distance_x_from_destination_pos : float
var distance_y_from_destination_pos : float


var modulate_a_subtract_per_sec : float = 0

#

func _init():
	z_as_relative = false
	z_index = ZIndexStore.PARTICLE_EFFECTS

func _ready():
	pos_of_beam_travel = global_position

func _process(delta):
	if visible and is_timebound:
		if _current_time_visible >= time_visible:
			visible = false
			_current_time_visible = 0
			
			emit_signal("time_visible_is_over")
			
			if queue_free_if_time_over:
				queue_free()
		else:
			_current_time_visible += delta
		
		_update_curr_beam_travel_pos()
	
	modulate.a -= modulate_a_subtract_per_sec * delta


# blocking and beam pos related

func _update_curr_beam_travel_pos():
	if time_visible != 0:
		var ratio = _current_time_visible / time_visible
		
		pos_of_beam_travel.x = distance_x_from_destination_pos * ratio
		pos_of_beam_travel.y = distance_y_from_destination_pos * ratio


func is_beam_travel_pos_at_or_beyond_segment(arg_point : Vector2, x_width : float, y_width : float) -> bool:
	var intersection_point = _get_position_intersection_of_line_in_curve(arg_point, x_width, y_width)
	
	return global_position.distance_to(intersection_point) > global_position.distance_to(intersection_point)

func _get_position_intersection_of_line_in_curve(arg_point_origin : Vector2, x_width : float, y_width : float) -> Vector2:
	var point_origin_from = arg_point_origin + Vector2(x_width, y_width)
	var point_origin_to = arg_point_origin - Vector2(x_width, y_width)
	
	return Geometry.segment_intersects_segment_2d(point_origin_from, point_origin_to, global_position, curr_destination_pos)




# Beam Show Functionality

func update_destination_position(destination_pos : Vector2):
	if destination_pos == null:
		visible = false
	else:
		visible = true
		scale.x = _get_needed_x_scaling(destination_pos)
		
		rotation_degrees = _get_angle(destination_pos)
		offset.y = -(_get_current_size().y / 2)
	
	
	curr_destination_pos = destination_pos
	
	var diff_in_dist = global_position - curr_destination_pos
	distance_x_from_destination_pos = diff_in_dist.x
	distance_y_from_destination_pos = diff_in_dist.y

#	if curve_to_destination_pos == null:
#		curve_to_destination_pos = Curve2D.new()
#	curve_to_destination_pos.clear_points()
#	curve_to_destination_pos.add_point(global_position)
#	curve_to_destination_pos.add_point(destination_pos)


func _get_angle(destination_pos : Vector2):
	var dx = destination_pos.x - global_position.x
	var dy = destination_pos.y - global_position.y
	
	return rad2deg(atan2(dy, dx))

func _get_needed_x_scaling(destination_pos : Vector2):
	var distance_from_origin = _get_origin_distance_to(destination_pos)
	var size = _get_current_size().x
	
	return distance_from_origin / size

func _get_current_size():
	return frames.get_frame(animation, frame).get_size()

func _get_origin_distance_to(destination_pos : Vector2):
	var dx = abs(destination_pos.x - global_position.x)
	var dy = abs(destination_pos.y - global_position.y)
	
	return sqrt((dx * dx) + (dy * dy))


# setting properites

func play_only_once(value : bool):
	frames.set_animation_loop("default", value)

func set_frame_rate_based_on_lifetime():
	frames.set_animation_speed("default", _calculate_fps_of_sprite_frames(get_sprite_frames().get_frame_count("default")))
	frames.set_animation_loop("default", false)
	

func _calculate_fps_of_sprite_frames(frame_count : int) -> int:
	return int(ceil(frame_count / time_visible))

func set_texture_as_default_anim(texture : Texture):
	var sprite_frames = SpriteFrames.new()
	
	if !sprite_frames.has_animation("default"):
		sprite_frames.add_animation("default")
	sprite_frames.add_frame("default", texture)
	
	frames = sprite_frames

func set_sprite_frames(sprite_frames : SpriteFrames):
	frames = sprite_frames
	playing = true


func get_sprite_frames() -> SpriteFrames:
	return frames
