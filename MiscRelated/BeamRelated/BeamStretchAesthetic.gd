extends Sprite

signal beam_fully_stretched()


var is_during_stretch

var _destination_pos : Vector2

var _current_scale_target : float
var _current_scale_per_sec : float

var _current_texture_size : Vector2

#

func _init():
	z_index = ZIndexStore.PARTICLE_EFFECTS
	z_as_relative = false

func _ready():
	if texture != null:
		_current_texture_size = texture.get_size()
	
	set_physics_process(false)

#

func reset():
	scale = Vector2(1, 1)
	is_during_stretch = false
	set_physics_process(false)
	rotation = 0
	offset = Vector2(0, 0)
	
	visible = false

func start_stretch(arg_destination_pos : Vector2, arg_duration : float):
	if !is_during_stretch:
		is_during_stretch = true
		_destination_pos = arg_destination_pos
		
		_current_scale_target = (global_position.distance_to(_destination_pos) / _current_texture_size.x) / 2
		_current_scale_per_sec = _current_scale_target / arg_duration
		
		offset.y = -_current_texture_size.y / 2
		
		#
		
		rotation = global_position.angle_to_point(arg_destination_pos)
		#rotation = _get_angle(arg_destination_pos)
		
		visible = true
		
		#
		
		set_physics_process(true)


func start_stretch__V2(arg_destination_pos : Vector2, arg_duration : float):
	if !is_during_stretch:
		is_during_stretch = true
		_destination_pos = arg_destination_pos + Vector2(0, _current_texture_size.y)
		
		_current_scale_target = (global_position.distance_to(_destination_pos) / _current_texture_size.x)
		_current_scale_per_sec = _current_scale_target / arg_duration
		
		#offset.y = _current_texture_size.y
		#offset.x = _current_texture_size.x / 2
		
		#
		
		#rotation = global_position.angle_to_point(arg_destination_pos)
		rotation = _get_angle(arg_destination_pos)
		
		visible = true
		
		#
		
		set_physics_process(true)



func _get_angle(destination_pos : Vector2):
	var dx = destination_pos.x - global_position.x
	var dy = destination_pos.y - global_position.y
	
	return atan2(dy, dx)


func _physics_process(delta):
	scale.x += _current_scale_per_sec * delta
	
	if scale.x >= _current_scale_target:
		scale.x = _current_scale_target
		
		is_during_stretch = false
		
		set_physics_process(false)
		emit_signal("beam_fully_stretched")


func _on_BeamStretchAesthetic_texture_changed():
	_current_texture_size = texture.get_size()
	



