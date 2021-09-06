extends AnimatedSprite

signal time_visible_is_over


export(float) var time_visible : float
export(bool) var is_timebound : bool = false

var _current_time_visible : float

export(bool) var queue_free_if_time_over : bool = false

func _init():
	z_as_relative = false
	z_index = ZIndexStore.PARTICLE_EFFECTS

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


# Beam Show Functionality

func update_destination_position(destination_pos : Vector2):
	if destination_pos == null:
		visible = false
	else:
		visible = true
		scale.x = _get_needed_x_scaling(destination_pos)
		rotation_degrees = _get_angle(destination_pos)
		offset.y = -(_get_current_size().y / 2)


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
	frames.set_animation_speed("default", _calculate_fps_of_sprite_frames(.get_frame_count("default")))
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
