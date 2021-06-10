extends AnimatedSprite


export(bool) var has_lifetime : bool = true
export(float) var lifetime : float
export(bool) var frames_based_on_lifetime : bool


func _ready():
	if frames_based_on_lifetime:
		frames.set_animation_speed("default", _calculate_fps_of_sprite_frames(frames.get_frame_count(animation)))
	
	frame = 0
	z_index = ZIndexStore.PARTICLE_EFFECTS
	z_as_relative = false

func _calculate_fps_of_sprite_frames(frame_count : int) -> int:
	return int(ceil(frame_count / lifetime))

func _process(delta):
	if has_lifetime:
		lifetime -= delta
		
		if lifetime <= 0:
			queue_free()
