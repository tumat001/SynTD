extends MeshInstance2D

signal on_duration_over()


var is_timebounded : bool = true

var main_duration : float
var fade_in_duration : float
var fade_out_duration : float

var initial_modulate_a : float

var ins_uuid : int

var custom_z_index : int = ZIndexStore.SCREEN_EFFECTS

# curr

var _current_duration : float
var _total_duration : float
var _current_modulate_a : float

var _tint_a_fade_in_rate : float = -1
var _tint_a_fade_out_rate : float = -1

#

func configure_self_to_gradient_texture_2d(arg_size : Vector2, arg_pos : Vector2, arg_gradient_texture : GradientTexture2D):
	mesh = QuadMesh.new()
	mesh.size = arg_size
	
	position = arg_pos
	
	texture = arg_gradient_texture


##

func _ready():
	z_as_relative = false
	z_index = custom_z_index
	
	_total_duration = main_duration + fade_in_duration + fade_out_duration
	
	if fade_in_duration != 0:
		_tint_a_fade_in_rate = initial_modulate_a / fade_in_duration
	
	_calculate_fade_out_rate()
	
	
	if !is_timebounded:
		_current_modulate_a = initial_modulate_a

func _calculate_fade_out_rate():
	if fade_out_duration != 0:
		_tint_a_fade_out_rate = initial_modulate_a / fade_out_duration


func _process(delta):
	if is_timebounded:
		_current_duration += delta
		
		if _current_duration < fade_in_duration:
			_current_modulate_a += _tint_a_fade_in_rate * delta
		
		
		if _current_duration > fade_in_duration + main_duration:
			_current_modulate_a -= _tint_a_fade_out_rate * delta
		
		if _current_duration > _total_duration:
			emit_signal("on_duration_over")
			queue_free()
		
		
		modulate.a = _current_modulate_a


#

func force_fade_out(arg_fade_out_duration : float):
	fade_out_duration = arg_fade_out_duration
	
	_calculate_fade_out_rate()
	
	_total_duration = arg_fade_out_duration + 0.1  # this 0.1 is arbitrary/doesnt matter
	_current_duration = 0.1  # also does not matter
	
	is_timebounded = true



