extends AnimatedSprite


signal turned_invisible_from_lifetime_end()

export(bool) var has_lifetime : bool = true
export(bool) var queue_free_at_end_of_lifetime : bool = true
export(bool) var turn_invisible_at_end_of_lifetime : bool = true
export(float) var lifetime : float setget set_lifetime
export(bool) var frames_based_on_lifetime : bool
export(bool) var reset_frame_to_start : bool = true
export(float) var x_displacement_per_sec : float = 0
export(float) var y_displacement_per_sec : float = 0

export(float) var inc_in_x_displacement_per_sec : float = 0
export(float) var inc_in_y_displacement_per_sec : float = 0

export(float) var upper_limit_x_displacement_per_sec : float = 0
export(float) var upper_limit_y_displacement_per_sec : float = 0

export(float) var lifetime_to_start_transparency : float = 0
export(float) var transparency_per_sec : float = 0

export(bool) var stop_process_at_invisible : bool = false

var texture_to_use : Texture


func _init():
	z_index = ZIndexStore.PARTICLE_EFFECTS
	z_as_relative = false

func _ready():
	if texture_to_use != null and frames == null:
		frames = SpriteFrames.new()
		frames.add_frame("default", texture_to_use)
	
	if frames_based_on_lifetime:
		set_anim_speed_based_on_lifetime()
	
	if reset_frame_to_start:
		frame = 0
	
	
	connect("visibility_changed", self, "_on_visiblity_changed")


func set_anim_speed_based_on_lifetime():
	frames.set_animation_speed("default", _calculate_fps_of_sprite_frames(frames.get_frame_count(animation)))

func _calculate_fps_of_sprite_frames(frame_count : int) -> int:
	return int(ceil(frame_count / lifetime))

#

func _process(delta):
	if has_lifetime:
		lifetime -= delta
		
		if lifetime <= 0:
			if queue_free_at_end_of_lifetime: 
				queue_free()
			elif turn_invisible_at_end_of_lifetime:
				if visible:
					visible = false
					emit_signal("turned_invisible_from_lifetime_end")
	
	
	global_position.y += y_displacement_per_sec * delta
	global_position.x += x_displacement_per_sec * delta
	
	x_displacement_per_sec += inc_in_x_displacement_per_sec * delta
	y_displacement_per_sec += inc_in_y_displacement_per_sec * delta
	
	if x_displacement_per_sec > upper_limit_x_displacement_per_sec:
		x_displacement_per_sec = upper_limit_x_displacement_per_sec
	
	if y_displacement_per_sec > upper_limit_y_displacement_per_sec:
		y_displacement_per_sec = upper_limit_y_displacement_per_sec
	
	if lifetime_to_start_transparency >= lifetime:
		modulate.a -= transparency_per_sec * delta
	


func set_lifetime(arg_val):
	lifetime = arg_val


func _on_visiblity_changed():
	if stop_process_at_invisible:
		set_process(visible)


#

func get_sprite_size() -> Vector2:
	return frames.get_frame(animation, frame).get_size()


