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

var node_to_follow_to__override_disp_per_sec : Node2D
var node_to_follow_to__override_disp_per_sec__offset : Vector2 setget set_node_to_follow_to__override_disp_per_sec__offset

var node_to_listen_for_queue_free__turn_invis : Node2D setget set_node_to_listen_for_queue_free__turn_invis

#

func set_node_to_follow_to__override_disp_per_sec__offset(arg_vector):
	node_to_follow_to__override_disp_per_sec__offset = arg_vector
	
	if is_inside_tree() and is_instance_valid(node_to_follow_to__override_disp_per_sec):
		global_position = node_to_follow_to__override_disp_per_sec.global_position + node_to_follow_to__override_disp_per_sec__offset

#

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
	for anim_name in frames.get_animation_names():
		frames.set_animation_speed(anim_name, _calculate_fps_of_sprite_frames(frames.get_frame_count(animation)))

func _calculate_fps_of_sprite_frames(frame_count : int) -> int:
	return int(ceil(frame_count / lifetime))

#

func _process(delta):
	if has_lifetime:
		lifetime -= delta
		
		if lifetime <= 0:
			configure_self_on_reached_end_of_lifetime()
	
	if is_instance_valid(node_to_follow_to__override_disp_per_sec):
		global_position = node_to_follow_to__override_disp_per_sec.global_position + node_to_follow_to__override_disp_per_sec__offset
	else:
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


func configure_self_on_reached_end_of_lifetime():
	if queue_free_at_end_of_lifetime: 
		queue_free()
	elif turn_invisible_at_end_of_lifetime:
		if visible:
			_turn_invisible_from_lifetime_end()

func _turn_invisible_from_lifetime_end():
	visible = false
	emit_signal("turned_invisible_from_lifetime_end")




func set_lifetime(arg_val):
	lifetime = arg_val


func _on_visiblity_changed():
	if stop_process_at_invisible:
		set_process(visible)


#

func get_sprite_size() -> Vector2:
	return frames.get_frame(animation, frame).get_size()

#

func set_node_to_listen_for_queue_free__turn_invis(arg_node):
	if is_instance_valid(node_to_listen_for_queue_free__turn_invis):
		node_to_listen_for_queue_free__turn_invis.disconnect("tree_exiting", self, "_on_node_to_listen_for_queue_free__turn_invis_queued_free")
	
	node_to_listen_for_queue_free__turn_invis = arg_node
	
	if is_instance_valid(node_to_listen_for_queue_free__turn_invis):
		node_to_listen_for_queue_free__turn_invis.connect("tree_exiting", self, "_on_node_to_listen_for_queue_free__turn_invis_queued_free", [arg_node])

func _on_node_to_listen_for_queue_free__turn_invis_queued_free(arg_node):
	_turn_invisible_from_lifetime_end()


func turn_invisible_from_lifetime_end__from_outside():
	_turn_invisible_from_lifetime_end()
	
	

