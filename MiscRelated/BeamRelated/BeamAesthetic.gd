extends AnimatedSprite

var time_visible : float
var is_timebound : bool = false

var _current_time_visible : float


func _process(delta):
	if visible and is_timebound:
		if _current_time_visible >= time_visible:
			visible = false
			_current_time_visible = 0
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

func set_texture_as_default_anim(texture : Texture):
	var sprite_frames = SpriteFrames.new()
	
	if !sprite_frames.has_animation("default"):
		sprite_frames.add_animation("default")
	sprite_frames.add_frame("default", texture)
	
	frames = sprite_frames


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