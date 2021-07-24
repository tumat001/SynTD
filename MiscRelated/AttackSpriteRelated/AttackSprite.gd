extends AnimatedSprite


export(bool) var has_lifetime : bool = true
export(float) var lifetime : float
export(bool) var frames_based_on_lifetime : bool
export(bool) var reset_frame_to_start : bool = true
export(float) var x_displacement_per_sec : float = 0
export(float) var y_displacement_per_sec : float = 0


func _init():
	z_index = ZIndexStore.PARTICLE_EFFECTS
	z_as_relative = false

func _ready():
	if frames_based_on_lifetime:
		frames.set_animation_speed("default", _calculate_fps_of_sprite_frames(frames.get_frame_count(animation)))
	
	if reset_frame_to_start:
		frame = 0



func _calculate_fps_of_sprite_frames(frame_count : int) -> int:
	return int(ceil(frame_count / lifetime))

func _process(delta):
	if has_lifetime:
		lifetime -= delta
		
		if lifetime <= 0:
			queue_free()
	
	global_position.y += y_displacement_per_sec * delta
	global_position.x += x_displacement_per_sec * delta
