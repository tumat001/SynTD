extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


signal movement_is_done(arg_replaced_by_new_mov)  # arg_replaced_by_new_mov is when a new forced pos mov effect is added over this one


const TIME_BASED_MOVEMENT_SPEED : float = -1.0

const default_mov_speed : float = 50.0

#

var destination_position : Vector2

var mov_speed : float

var current_movement_speed : float
var current_direction : Vector2

var snap_to_offset_at_end : bool

func _init(arg_destination_position : Vector2,
		arg_mov_speed : float,
		arg_snap_to_offset_at_end : bool,
		arg_effect_uuid : int).(EffectType.FORCED_PATH_OFFSET_MOVEMENT, arg_effect_uuid):
	
	
	destination_position = arg_destination_position
	
	mov_speed = arg_mov_speed
	current_movement_speed = mov_speed
	snap_to_offset_at_end = arg_snap_to_offset_at_end
	
	should_map_in_all_effects_map = false
	
	is_timebound = false
	
	respect_scale = false



func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	var copy = get_script().new(destination_position, mov_speed, snap_to_offset_at_end, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	copy.scale_movements(scale)
	
	return copy


func scale_movements(mov_scale : float):
	if mov_speed != TIME_BASED_MOVEMENT_SPEED:
		mov_speed *= mov_scale
	
	current_movement_speed *= mov_scale


#

func set_up_movements_and_direction(arg_origin_pos : Vector2):
	is_timebound = false
	
	current_direction = arg_origin_pos.direction_to(destination_position)
	
	var distance_to_destination : float = arg_origin_pos.distance_to(destination_position)
	_configure_current_mov_speed(distance_to_destination)


#func _get_direction_to_destination(arg_origin_pos : Vector2):
#	var angle = arg_origin_pos.angle_to(destination_position)
#
#	var base_vector : Vector2 = Vector2(1, 0)
#	base_vector.rotated(angle)
#
#	print("angle: " + str(angle))
#	print(str(arg_origin_pos) + " " + str(destination_position))
#	print("------")
#
#	return base_vector.normalized()


func _configure_current_mov_speed(arg_distance_to_destination : float):
	if mov_speed == TIME_BASED_MOVEMENT_SPEED:
		if time_in_seconds > 0:
			current_movement_speed = arg_distance_to_destination / time_in_seconds
		else:
			current_movement_speed = default_mov_speed
	
	if current_movement_speed <= 0:
		current_movement_speed = default_mov_speed

#

func get_direction_with_magnitude(delta, arg_global_pos) -> Vector2:
	var dir_mag : Vector2 = current_direction * current_movement_speed * delta
	
	dir_mag.x = _get_dir_mag_of_axis_with_surpass_adjustment(dir_mag.x, arg_global_pos.x, destination_position.x)
	dir_mag.y = _get_dir_mag_of_axis_with_surpass_adjustment(dir_mag.y, arg_global_pos.y, destination_position.y)
	
	return dir_mag


func _get_dir_mag_of_axis_with_surpass_adjustment(dir_mag_axis : float, arg_global_pos_axis : float, dest_pos_axis : float):
	var next_frame_pos_axis = dir_mag_axis + arg_global_pos_axis
	
	if dir_mag_axis > 0:
		if next_frame_pos_axis > dest_pos_axis:
			dir_mag_axis -= next_frame_pos_axis - dest_pos_axis
		
	elif dir_mag_axis < 0:
		if next_frame_pos_axis < dest_pos_axis:
			dir_mag_axis -= next_frame_pos_axis - dest_pos_axis
		
	
	return dir_mag_axis

#

func _emit_movement_is_done(arg_replaced_by_new_mov : bool):
	emit_signal("movement_is_done", arg_replaced_by_new_mov)
